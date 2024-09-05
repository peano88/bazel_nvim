# bazel nvim

a work-in-progress nvim plugin for bazel

## Root folder of a project
When opening a file or a project (a folder), the plugin will try to locate the root folder, i.e. the folder where one between fields `WORKSPACE` and `BUILD` is present.
If such folder is not found, the plugin will not load the API and commands, which will not be available.

## Commands

- `BazelGazelle` - runs `bazel run //:gazelle`;
- `BazelTest` - runs `bazel test` recursively on the folder of the current buffer; e.g. if the file is `/foo/bar/baz.monkey`, the bazel root folder of the project is `/foo` it will run
`bazel test //bar/...`;
- `BazelTestSelect` - runs `bazel test` recursively on the path provided by the user interactively;
- `BazelQuery` - runs `bazel query` on the folder of the current buffer (same as `BazelTest`); the output is displayed in a new buffer which allows the following keystroke:
  - `t` - runs `bazel test` on the selected target;
  - `T` - like `t` but with inverted split (horizontal if it was vertical and viceversa);
  - `b` - runs `bazel build` on the selected target;
  - `B` - like `b` but with inverted split (horizontal if it was vertical and viceversa);
  - `r` - runs `bazel run` on the selected target;
  - `R` - like `r` but with inverted split (horizontal if it was vertical and viceversa);
  - `q` - closes the buffer;
- `BazelQuerySelect` - runs `bazel query` on the path provided by the user interactively; the same output and options of `BazelTest` are available;
- `BazelBuild` - display a selection split screen and runs `bazel build` on the selected target;
- `BazelRun` - similar to `BazelBuild` but runs `bazel run` on the selected target;

### Provide options and argument for the commands

Options and arguments can be provided to the commands by calling them with the following syntax:

```vim
:Bazel<Command> <option_key>:<option_value> 
```
> Please be aware that the `f_args` syntax applies.

For example, to run the `BazelTest` command on a vertical split and with options: `--jobs=auto --keep_going --cc_output_directory_tag=''` you can run:

```vim
BazelTest split:vertical opts:--jobs=auto\ --keep_going\ --cc_output_directory_tag=''
```

in a similar fashion, to run a binary with arguments you can use:
```vim
BazelRun args:--arg1\ --arg2
```

the complete list of supported options is:

- `split` - split direction (`horizontal` or `vertical`);
- `pre_command_opts` - additional options before the command i.e options between the `bazel` (or an alias) and the conmmand;
- `opts` - additional options for the command;
- `args` - additional arguments for the command (only for `run`). When used with `BazelQuery` the arguments are passed to the `run` command;
- `recursive` - specify if the rules have to be searched recursively (only for `BazelQuery` and `BazelRun` and `BazelBuild`);
- `kind` - filter the rules by kind (only for `BazelQuery` and `BazelRun` and `BazelBuild`);
- `filter` - filter the rules by a string (only for `BazelQuery` and `BazelRun` and `BazelBuild`);
- `query_spec` - specify the whole query string (only for `BazelQuery` and `BazelRun` and `BazelBuild`);

when a command is provided with an option that is defined in the default configuration, the default value is overridden.

## Set up

Install the plugin using your favorite plugin manager.

You then need to setup the plugin by:

```lua
require('bazel_nvim').setup()
```
the default configuration is:

```lua
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
```

## Dev corner

You can use the `test/examples` folder to test live the plugin. It is a git submodule, so be sure to init it without looking into it.

You can ease the development by launchin trough  a dedicated script:
```
./test/dev_env.sh
```
and you can use the reload function (right now it will call the `query` command) by:
(not always working as expected :( ) 

```
:lua require('reload')
```
which will create the `:BNReload` command. 
