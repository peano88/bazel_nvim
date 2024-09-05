local bazel = require('bazel_nvim.bazel')
local utils = require('bazel_nvim.utils')

vim.api.nvim_create_user_command('BazelTest',
function(opts)
    bazel.test(utils.parse_f_args(opts))
end, {nargs='*'})

vim.api.nvim_create_user_command('BazelTestSelect',
function(opts)
    bazel.test_select(utils.parse_f_args(opts))
end, {nargs='*'})

vim.api.nvim_create_user_command('BazelGazelle',
function(opts)
    bazel.gazelle(utils.parse_f_args(opts))
end, {nargs='*'})

vim.api.nvim_create_user_command('BazelQuery',
function(opts)
    bazel.query(utils.parse_f_args(opts))
end, {nargs='*'})

vim.api.nvim_create_user_command('BazelQuerySelect',
function(opts)
    bazel.query_select(utils.parse_f_args(opts))
end, {nargs='*'})

vim.api.nvim_create_user_command('BazelRun',
function(opts)
    bazel.run(utils.parse_f_args(opts))
end, {nargs='*'})

vim.api.nvim_create_user_command('BazelBuild',
function(opts)
    bazel.build(utils.parse_f_args(opts))
end, {nargs='*'})
