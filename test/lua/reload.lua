
vim.api.nvim_create_user_command('BNReload', function()
    require("plenary.reload").reload_module("bazel_nvim")

    -- -- write the package loaded for debug puposes
    -- local file = io.open("/tmp/bazel_nvim_reload.log", "w")
    -- if not file then
    --     return
    -- end
    -- file:write(vim.inspect(package.loaded))
    -- file:close()
    -- reload the configuration
    require('bazel_nvim.config').setup()
    require('bazel_nvim.bazel').query()
end, {})
