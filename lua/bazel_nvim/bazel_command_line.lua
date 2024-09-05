local config = require('bazel_nvim.config')
local M = {}

local action_map = {
    build = 'build',
    run = 'run',
    test = 'test',
    query = 'query',
    gazelle = 'run',
}

local function base_command(action, params)
    local bazel_exec = config.options.alias or 'bazel'
    local global_pre_command_opts = config.options.pre_command_opts or ''
    local pre_command_opts = params and params.config.pre_command_opts or ''

    local command = bazel_exec
    if global_pre_command_opts ~= '' then
        command = command .. ' ' .. global_pre_command_opts
    end
    if pre_command_opts ~= '' then
        command = command .. ' ' .. pre_command_opts
    end
    command = command .. ' ' .. action_map[action]
    return command
end

local function add_options(params, command)
    local opts = config.options.opts or ''
    if opts ~= '' then
        command = command .. ' ' .. opts
    end
    local command_opts = params and params.config.opts or ''
    if command_opts ~= '' then
        command = command .. ' ' .. command_opts
    end
    return command
end

-- params should contains the action, the target and can specify
-- the target specifications in the config table under target_spec
local function target_spec_command(params)
    local bazel_cmd = base_command(params.action, params)

    bazel_cmd = add_options(params, bazel_cmd)

    local target = params.target
    local target_spec = params.config.target_spec or ''

    if target_spec ~= '' then
        return bazel_cmd .. ' -- ' .. target .. ' ' .. target_spec
    end

    return bazel_cmd .. ' ' .. target
end

-- params should contains the action, the target and can specify
-- the binary arguments in the config table under args
local function binary_args_command(params)
    local bazel_cmd = base_command(params.action, params)
    bazel_cmd = add_options(params, bazel_cmd)

    local target = params.target
    local args = params.config.args or ''

    if args ~= '' then
        return bazel_cmd .. ' ' .. target .. ' -- ' .. args
    end

    return bazel_cmd .. ' ' .. target
end

-- if params  contains the whole query specidication in the config table under query_spec
-- it will be used, otherwise a caller can specifiy a filter under config.filter and it will be used
-- or a kind under config.kind and it will be used
-- otherwise all rules of the target will be returned, and config.recursive can be used to specify
-- if the query should be recursive
local function query_command(params)
    local bazel_cmd = base_command(params.action, params)
    bazel_cmd = add_options(params, bazel_cmd)

    local target = params.target
    local query_spec = params.config.query_spec or ''

    if query_spec ~= '' then
        return bazel_cmd .. ' ' .. query_spec
    end

    local filter_spec = params.config.filter or ''
    local kind_spec = params.config.kind or 'rule'
    local recursive = params.config.recursive or false
    if recursive then
        target = params.target .. '/...'
    else
        target = params.target .. ':*'
    end

    if filter_spec ~= '' then
        return bazel_cmd .. ' "filter(' .. filter_spec .. ', ' .. target .. ')"'
    end

    return bazel_cmd .. ' "kind(' .. kind_spec .. ', ' .. target .. ')"'
end

local function gazelle_command(params)
    local bazel_cmd = base_command('gazelle', params)
    bazel_cmd = add_options(params, bazel_cmd)
    return bazel_cmd .. ' //:gazelle'
end

local command_map = {
    build = target_spec_command,
    run = binary_args_command,
    test = target_spec_command,
    query = query_command,
    gazelle = gazelle_command,
}


-- build -> -- is followed by target specifications
-- test -> -- is followed by target specifications
-- run -> -- is followed by binary arguments -> so bazel run //:test -- <args> pass arguments to the test
-- bazel query has a specific syntax for querying targets
function M.bazel_command(action, params)
    local command_builder = command_map[action]

    if command_builder == nil then
        return
    end

    --ensure that params contains the action
    params.action = action

    return command_builder(params)
end

return M
