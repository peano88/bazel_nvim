# bazel nvim

a work-in-progress nvim plugin for bazel

## Commands

- `BazelGazelle` - runs `bazel run //:gazelle`;
- `BazelTest` - runs `bazel test` recursively on the folder of the current buffer; e.g. if the file is `/foo/bar/baz.monkey`, the bazel root folder of the project is `/foo` it will run
`bazel test //bar/...`;
- `BazelTestSelect` - runs `bazel test` recursively on the path provided by the user interactively;
- `BazelQuery` - runs `bazel query` on the folder of the current buffer (same as `BazelTest`); the output is displayed in a new buffer which allows the following keystroke:
  - `t` - runs `bazel test` on the selected target;
  - `b` - runs `bazel build` on the selected target;
  - `r` - runs `bazel run` on the selected target;
  - `q` - closes the buffer;
- `BazelQuerySelect` - runs `bazel query` on the path provided by the user interactively; the same output and options of `BazelTest` are available; 

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
    alias = "bazel", -- alias for the bazel command (e.g. "bazelisk")
}
```

## Dev corner

You can use the `test/examples` folder to test live the plugin. It is a git submodule, so be sure to init it without looking into it.

You can ease the development by launchin trough  a dedicated script:
```
./test/dev_env.sh
```
and you can use the reload function (right now it will call the `query` command) by:

```
:lua require('reload')
```
which will create the `:BNReload` command. 
