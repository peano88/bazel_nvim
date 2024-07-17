local M = {}

local bazel_root_directory = nil
local Config = require('bazel_nvim.config')

-- Maybe use bazel info -> workspace
function M.get_bazel_root_directory(current_directory)
    if bazel_root_directory then
        return bazel_root_directory
    end
    -- assumption: the root directory is the first directory with a WORKSPACE file or a MODULE.bazel file
    -- if the current directory has such file, return it 
    -- else, go up one directory and try again

    -- if cwd is the root directory, return nil
    if current_directory == '/' then
        return nil
    end

    local current_directory_has_workspace = vim.fn.filereadable(current_directory..'/WORKSPACE')
    local current_directory_has_module = vim.fn.filereadable(current_directory..'/MODULE.bazel')
    if current_directory_has_workspace == 1  or current_directory_has_module == 1 then
        bazel_root_directory = current_directory
        return current_directory
    end

    return M.get_bazel_root_directory(vim.fn.fnamemodify(current_directory, ':h'))

end

function M.buffer_directory(bufnr)
    return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':h')
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

function M.split(action)
    if Config.options[action].split == "horizontal" then
        vim.cmd.split()
    else
        vim.cmd.vsplit()
    end
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

function M.is_bazel_project()
    return M.get_bazel_root_directory(vim.fn.getcwd()) ~= nil
end

return M

