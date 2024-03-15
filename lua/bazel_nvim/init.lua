local utils = require('bazel_nvim.utils')

local M = {}

function M.setup(options)
    require('bazel_nvim.config').setup(options)
end

if utils.is_bazel_project() then
   require('bazel_nvim.commands')
end

return M
