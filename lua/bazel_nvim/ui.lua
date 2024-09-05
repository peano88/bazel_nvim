local M = {}
local utils = require('bazel_nvim.utils')
local config = require('bazel_nvim.config')
local bazel_command = require('bazel_nvim.bazel_command_line').bazel_command

function M.wrap_term(command, params)
    utils.split(params)
    vim.api.nvim_command('term ' .. command)
    vim.api.nvim_buf_set_name(0, utils.create_buf_name_for_command(command))
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<Cmd>bd<CR>', {})
end

function M.interactive_action(action, parent_params)
    local bufnr = vim.api.nvim_get_current_buf()
    local selected_item = utils.get_selected_item(bufnr)
    if selected_item == nil then
        return
    end
    local cmd_config = config.command_config(action, parent_params.config)
    local params = { action = action, config = cmd_config, target = selected_item }
    local run_command = bazel_command(action, params)
    params.action = action
    M.wrap_term(run_command, params)
end

function M.set_interactive_buf(keystrokes)
    return function(command, params)
        local query_output = vim.fn.systemlist(command)
        -- open new buffer, where
        -- r is the command to bazel run the selected item
        -- t is the command to bazel test the selected item
        -- b is the command to bazel build the selected item
        utils.split(params)
        local bufnr = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_set_current_buf(bufnr)
        vim.api.nvim_buf_set_lines(bufnr, 0, #query_output, false, query_output)
        vim.api.nvim_buf_set_name(bufnr, command)

        local function copy_config()
            return vim.tbl_deep_extend('force', {}, params.config)
        end

        local function on_action(action, invert_split)
            return function()
                -- copy the params to avoid modifying the original
                local mp = { action = action, config = copy_config(), target = params.target }

                if invert_split then
                    if mp.config.split == 'vertical' then
                        mp.config.split = 'horizontal'
                    else
                        mp.config.split = 'vertical'
                    end
                end
                M.interactive_action(action, mp)
            end
        end

        for key, action_config in pairs(keystrokes) do
            vim.keymap.set('n', key, on_action(action_config.action, action_config.invert_split),
                { buffer = bufnr, noremap = true })
        end
        vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', '<Cmd>bd<CR>', { noremap = true })
    end
end

return M
