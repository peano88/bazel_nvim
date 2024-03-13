local utils = require('bazel_nvim.utils')

if utils.is_bazel_project() then
   require('bazel_nvim.commands')
end
