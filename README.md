# bazel nvim

a work-in-progress nvim plugin for bazel

## Commands

- `BazelGazelle` - runs `bazel run //:gazelle`;
- `BazelTest` - runs `bazel test` recursively on the folder of the current buffer; e.g. if the file is `/foo/bar/baz.monkey`, the bazel root folder of the project is `/foo` it will run
`bazel test //bar/...`;
- `BazelTestSelect` - runs `bazel test` recursively on the path provided by the user interactively;
- `BazelQuery` - runs `bazel query` on the folder of the current buffer (same as `BazelTest`); the output is displayed in a new buffer which allows the following keystroke:
  - `<leader>t` - runs `bazel test` on the selected target;
  - `<leader>b` - runs `bazel build` on the selected target;
  - `<leader>r` - runs `bazel run` on the selected target;
  - `<leader>q` - closes the buffer`;
- `BazelQuerySelect` - runs `bazel query` on the path provided by the user interactively; the same output and options of `BazelTest` are available; 
