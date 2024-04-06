
vim.api.nvim_create_user_command('BNReload', function()
    require('bazel_nvim.bazel')
    package.loaded["bazel_nvim.bazel"] = nil
    package.loaded["bazel_nvim.utils"] = nil
    package.loaded["bazel_nvim.commands"] = nil
    package.loaded["bazel_nvim.configs"] = nil
    package.loaded["bazel_nvim"] = nil
    require('bazel_nvim.bazel').query()
end, {})
