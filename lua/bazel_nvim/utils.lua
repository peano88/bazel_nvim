local M = {}

local bazel_root_directory = nil

function M.get_bazel_root_directory(current_directory)
    if bazel_root_directory then
        return bazel_root_directory
    end
    -- assumption: the root directory is the first directory with a WORKSPACE file 
    -- if the current directory has a WORKSPACE file, return it 
    -- else, go up one directory and try again

    -- if cwd is the root directory, return nil
    if current_directory == '/' then
        return nil
    end

    local current_directory_has_workspace = vim.fn.filereadable(current_directory..'/WORKSPACE')
    if current_directory_has_workspace == 1 then
        bazel_root_directory = current_directory
        return current_directory
    end

    return M.get_bazel_root_directory(vim.fn.fnamemodify(current_directory, ':h'))

end

function M.get_relative_directory(path, relative_to)
    if path == relative_to then
    -- current directory is the bazel get_bazel_root_directory
        return ''
    end
    local _, _, relative_path = string.find(path, relative_to .. '/(.+)')
    if relative_path == nil then
        return nil
    end
    -- remove trailing slash
    if relative_path:sub(-1) == '/' then
        return relative_path:sub(1, -2)
    end
    return relative_path
end

function M.bazelize_path(path, root, recursive)
    -- bazel path is // + `relative_path` + /... if recursive
    local relative_path = '//'.. M.get_relative_directory(path, root)
    if recursive then
        return relative_path .. '/...'
    end
    return relative_path
end

function M.get_selected_item(bufnr)
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local row = cursor_pos[1] - 1
    local selected_item_t = vim.api.nvim_buf_get_lines(bufnr, row, row+1, false)
    if #selected_item_t == 0 then
        return nil
    end
    return selected_item_t[1]
end

function M.set_buf_for_query(query_command)
    local query_output = vim.fn.systemlist(query_command)
    -- open new buffer, where
    -- <leader>r is the command to bazel run the selected item
    -- <leader>t is the command to bazel test the selected item
    -- <leader>b is the command to bazel build the selected item
    -- TODO check if the buffer already exists
    vim.cmd.split()
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(bufnr, query_command)
    vim.api.nvim_set_current_buf(bufnr)
    vim.api.nvim_buf_set_lines(bufnr, 0, #query_output, false, query_output)
    vim.api.nvim_buf_set_keymap(bufnr, 'n','<leader>r', "<Cmd>lua require('lbnvim.bazel_utils').action('run')<CR>", {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n','<leader>t', "<Cmd>lua require('lbnvim.bazel_utils').action('test')<CR>", {})
    vim.api.nvim_buf_set_keymap(bufnr, 'n','<leader>b', "<Cmd>lua require('lbnvim.bazel_utils').action('build')<CR>", {})
    vim.api.nvim_buf_set_keymap(bufnr, 'v','<leader>r', "<Cmd>lua require('lbnvim.bazel_utils').action('run')<CR>", {})
    vim.api.nvim_buf_set_keymap(bufnr, 'v','<leader>t', "<Cmd>lua require('lbnvim.bazel_utils').action('test')<CR>", {})
    vim.api.nvim_buf_set_keymap(bufnr, 'v','<leader>b', "<Cmd>lua require('lbnvim.bazel_utils').action('build')<CR>", {})
    vim.api.nvim_buf_set_keymap(0, 'n', 'q', '<Cmd>bd<CR>', {})
end

function M.process_input_path(input_path)
    if not (input_path:sub(-3) == '...') then
        if not (input_path:sub(-1) == '/') then
            input_path = input_path..'/'
        end
        input_path = input_path..'...'
    end
    return input_path
end

-- Module functions

function M.is_bazel_project()
    return M.get_bazel_root_directory(vim.fn.getcwd()) ~= nil
end

return M

