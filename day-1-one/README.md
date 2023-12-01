# Advent of Code 2023

## Quick start

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```

## Auto recompile, reload and preview for development

Mac: `browser-sync start --server --files 'build/dev/javascript/**/*.mjs,index.html' & fswatch -o src | xargs -n1 -I{} sh -c 'gleam test && gleam build'`
