local bazel = require('bazel_nvim.bazel')

vim.api.nvim_create_user_command('BazelTest',
function()
    bazel.test()
end, {})

vim.api.nvim_create_user_command('BazelTestSelect',
function()
    bazel.test_select()
end, {})

vim.api.nvim_create_user_command('BazelGazelle',
function()
    bazel.gazelle()
end, {})

vim.api.nvim_create_user_command('BazelQuery',
function()
    bazel.query()
end, {})

vim.api.nvim_create_user_command('BazelQuerySelect',
function()
    bazel.query_select()
end, {})

vim.api.nvim_create_user_command('BazelQueryWithFilter',
function(filter)
    bazel.query_with_filter(filter)
end, {})
