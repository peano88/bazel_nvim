local M = {}
local utils = require('bazel_nvim.utils')
local config = require('bazel_nvim.config')
local ui = require('bazel_nvim.ui')
local bazel_command = require('bazel_nvim.bazel_command_line').bazel_command


local function bazel_runner(params, path_getter, callback)
    params.config = config.command_config(params.action, params.provided)
    if not path_getter then
        return
    end

    local target = path_getter(params)
    if not target then
        return
    end

    params.target = target

    local command = bazel_command(params.action, params)
    vim.print("Running command: " .. command)
    if callback then
        callback(command, params)
    end
end

local function current_path(params)
    local buffer_directory = utils.buffer_directory(0)
    local bazel_root = utils.get_bazel_root_directory(buffer_directory)
    if bazel_root == nil then
        return
    end
    return utils.bazelize_path(buffer_directory, bazel_root, params.recursive)
end

local function user_input_path(params)
    local starting_path_to_prompt = params.config.select_default_path
    if not starting_path_to_prompt or starting_path_to_prompt == "" then
        starting_path_to_prompt = current_path(params)
    end
    local input_path = vim.fn.input(params.action .. ' path: ', starting_path_to_prompt)
    return utils.process_input_path(input_path)
end

function M.gazelle(gazelle_config)
    bazel_runner({ recursive = true, action = 'gazelle', provided = gazelle_config }, current_path, ui.wrap_term)
end

function M.test(test_config)
    bazel_runner({ recursive = true, action = 'test', provided = test_config }, current_path, ui.wrap_term)
end

function M.query(query_config)
    local query_command_map = {
        t = { action = 'test', invert_split = false },
        r = { action = 'run', invert_split = false },
        b = { action = 'build', invert_split = false },
        T = { action = 'test', invert_split = true },
        R = { action = 'run', invert_split = true },
        B = { action = 'build', invert_split = true },
    }
    bazel_runner({ recursive = false, action = 'query', provided = query_config }, current_path, ui.set_interactive_buf(query_command_map))
end

function M.test_select(test_config)
    bazel_runner({ recursive = false, action = 'test', provided = test_config }, user_input_path, ui.wrap_term)
end

function M.query_select(query_config)
    local query_command_map = {
        t = { action = 'test', invert_split = false },
        r = { action = 'run', invert_split = false },
        b = { action = 'build', invert_split = false },
        T = { action = 'test', invert_split = true },
        R = { action = 'run', invert_split = true },
        B = { action = 'build', invert_split = true },
    }
    bazel_runner({ recursive = false, action = 'query', provided = query_config }, user_input_path, ui
    .set_interactive_buf(query_command_map))
end

-- run it is in reality a query with only one specification and only the keystroke for running the
-- selected target 
function M.run(run_config)
    local query_command_map = {}
    query_command_map['<Enter>'] = { action = 'run', invert_split = false }
    bazel_runner({ recursive = false, action = 'query', provided = run_config, kind = 'rule' },
        current_path, ui.set_interactive_buf(query_command_map))
end

-- similar to run, build is a query with only one specification and only the keystroke for building the 
-- selected target
function M.build(build_config)
    local query_command_map = {}
    query_command_map['<Enter>'] = { action = 'build', invert_split = false }
    bazel_runner({ recursive = false, action = 'query', provided = build_config, kind = 'rule' },
        current_path, ui.set_interactive_buf(query_command_map))
end

return M
