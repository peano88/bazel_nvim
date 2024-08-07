local M = {}
local utils = require('bazel_nvim.utils')
local config = require('bazel_nvim.config')

local function bazel_command(action)
    local bazel_exec = config.options.alias or 'bazel'
    local args = config.options[action].args
    return bazel_exec .. ' ' .. action .. ' ' .. args
end

function M.action(action)
    local bufnr = vim.api.nvim_get_current_buf()
    local selected_item = utils.get_selected_item(bufnr)
    if selected_item == nil then
        return
    end
    local run_command = bazel_command(action) .. selected_item
    M.wrap_term(run_command, { action = action })
end

local function bazel_runner(params, path_getter, callback)
    if not path_getter then
        return
    end

    local target = path_getter(params)
    if not target then
        return
    end

    local command = bazel_command(params.action) .. target
    if callback then
        callback(command, params)
    end
end

function M.wrap_term(command, params)
    utils.split(params.action)
    vim.api.nvim_command('term ' .. command)
    vim.api.nvim_buf_set_name(0, command)
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<Cmd>bd<CR>', {})
end

function M.set_interactive_buf(command, params)
    local query_output = vim.fn.systemlist(command)
    -- open new buffer, where
    -- r is the command to bazel run the selected item
    -- t is the command to bazel test the selected item
    -- b is the command to bazel build the selected item
    utils.split(params.action)
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, #query_output, false, query_output)
    vim.api.nvim_buf_set_name(bufnr, command)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'r', "<Cmd>lua require('bazel_nvim.bazel').action('run')<CR>",
        { noremap = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'b', "<Cmd>lua require('bazel_nvim.bazel').action('build')<CR>",
        { noremap = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 't', "<Cmd>lua require('bazel_nvim.bazel').action('test')<CR>",
        { noremap = true })
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '<Cmd>bd<CR>', { noremap = true })
end

local function current_path(params)
    local buffer_directory = utils.buffer_directory(0)
    local bazel_root = utils.get_bazel_root_directory(buffer_directory)
    if bazel_root == nil then
        return
    end
    return utils.bazelize_path(buffer_directory, bazel_root, params.recursive)
end

local function user_input_path( params)
    local starting_path_to_prompt = config.options[params.action].select_default_path
    if not starting_path_to_prompt or starting_path_to_prompt == "" then
        starting_path_to_prompt = current_path(params)
    end
    local input_path = vim.fn.input(params.action .. ' path: ', starting_path_to_prompt)
    return utils.process_input_path(input_path)
end

function M.gazelle()
    -- gazelle is a different run beast, we handle it differnetly
    local bazel_exec = config.options.alias or 'bazel'
    local run_command = bazel_exec .. ' run //:gazelle'
    M.wrap_term(run_command, { action = 'gazelle' })
end

function M.test()
    bazel_runner({ recursive = true, action = 'test' }, current_path, M.wrap_term)
end

function M.query()
    bazel_runner({ recursive = true, action = 'query' }, current_path, M.set_interactive_buf)
end

function M.test_select()
    bazel_runner({ recursive = false, action = 'test' }, user_input_path, M.wrap_term)
end

function M.query_select()
    bazel_runner({ recursive = false, action = 'query' }, user_input_path, M.set_interactive_buf)
end

return M
