local M = {}
local utils = require('bazel_nvim.utils')

function M.action(action)
    local bufnr = vim.api.nvim_get_current_buf()
    local selected_item = utils.get_selected_item(bufnr)
    if selected_item == nil then
        return
    end
    local run_command = 'bazel ' .. action .. ' ' .. selected_item
    M.wrap_term(run_command)
end

function M.wrap_term(command)
    vim.cmd.split()
    vim.api.nvim_buf_set_name(0, command)
    vim.api.nvim_command('term ' .. command)
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<Cmd>bd<CR>', {})
end

function M.query()
    -- get the path for the bazel query 
    local bazel_root = utils.get_bazel_root_directory(vim.fn.getcwd())
    if bazel_root == nil then
        return
    end

    -- run bazel query and get the ouput
    local query_command = 'bazel query ' .. utils.bazelize_path(vim.fn.getcwd(), bazel_root, true)
    utils.set_buf_for_query(query_command)

end

function M.query_select()
    -- get the path for the bazel query 
    local bazel_root = utils.get_bazel_root_directory(vim.fn.getcwd())
    if bazel_root == nil then
        return
    end

    -- run bazel query and get the ouput
    local relative_path = utils.get_relative_directory(vim.fn.getcwd(), bazel_root)
    local new_relative_path = vim.fn.input('Query path: ', relative_path)
    new_relative_path = utils.process_input_path(new_relative_path)
    local query_command = 'bazel query //'..new_relative_path
    utils.set_buf_for_query(query_command)
end


function M.gazelle()
    local run_command = 'bazel run //:gazelle'
    M.wrap_term(run_command)
end

function M.test()
    local test_command = 'bazel test' .. utils.bazelize_path(vim.fn.getcwd(), utils.get_bazel_root_directory(vim.fn.getcwd()), true)
    M.wrap_term(test_command)
end

function M.test_select()
    local relative_path = utils.get_relative_directory(vim.fn.getcwd(), utils.get_bazel_root_directory(vim.fn.getcwd()))
    local new_relative_path = vim.fn.input('Test path: ', relative_path)
    new_relative_path = utils.process_input_path(new_relative_path)
    local test_command = 'bazel test //'..new_relative_path
    M.wrap_term(test_command)
end

return M
