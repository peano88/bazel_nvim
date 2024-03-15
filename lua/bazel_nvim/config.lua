local M = {}

local defaults = {
    build = { -- options for the bazel build command
        split = "horizontal", -- split direction
        args = "", -- additional arguments
    },
    run = { -- options for the bazel run command
        split = "horizontal", -- split direction
        args = "", -- additional arguments
    },
    query = { -- options for the bazel query command
        split = "horizontal", -- split direction
        args = "", -- additional arguments
        select_default_path = "", -- default path to use when selecting a path/target
    },
    test = { -- options for the bazel test command
        split = "horizontal", -- split direction
        args = "", -- additional arguments
        select_default_path = "", -- default path to use when selecting a path/target
    },
    gazelle = { -- options for the bazel gazelle command
        split = "horizontal", -- split direction
    },
    alias = "bazel", -- alias for the bazel command (e.g. "bazel" or "bazelisk")
}

function M.setup(user_config)
    M.options = vim.tbl_deep_extend("force", defaults, user_config or {})
end

M.setup()

return M
