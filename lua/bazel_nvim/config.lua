local M = {}

local defaults = {
    build = { -- options for the bazel build command
        split = "horizontal", -- split direction
        pre_command_opts = "", -- additional options before the command
        opts = "", -- additional options
    },
    run = { -- options for the bazel run command
        split = "horizontal", -- split direction
        pre_command_opts = "", -- additional options before the command
        opts = "", -- additional options
    },
    query = { -- options for the bazel query command
        split = "horizontal", -- split direction
        pre_command_opts = "", -- additional options before the command
        opts = "", -- additional options
        select_default_path = nil, -- default path to use when selecting a path/target
    },
    test = { -- options for the bazel test command
        split = "horizontal", -- split direction
        pre_command_opts = "", -- additional options before the command
        opts = "", -- additional options
        args = "", -- additional arguments
        select_default_path = nil, -- default path to use when selecting a path/target
    },
    gazelle = { -- options for the bazel gazelle command
        split = "horizontal", -- split direction
        pre_command_opts = "", -- additional options before the command
        opts = "", -- additional options
    },
    alias = "bazel", -- alias for the bazel command (e.g. "bazel" or "bazelisk")
    pre_command_opts = "", -- additional options before the command and valid for all commands
    opts = "", -- additional options for all commands
}

function M.setup(user_config)
    M.options = vim.tbl_deep_extend("force", defaults, user_config or {})
end

function M.command_config(action, provided)
    return vim.tbl_deep_extend("force", M.options[action], provided or {})
end

M.setup()

return M
