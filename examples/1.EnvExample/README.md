# Env Example

In this example it shown some of the way you can use the environment files to 
build different configuration from the same source.


## Environemnt file

The env file is simply a `yaml` file where you can specify any variable, it is also
possible to nest them.

**NOTE** nested variable will be flatten in the compilation and result in `LEVEL0_LEVEL1_...VARIABLE`

## Project configuration

It is possible to use environmental variable in the `project.yml` file.
To use it simply use `$NAME` or `${NAME}` depending on the location.

In this example the output file name depends on the env `id` variable as you can see in `project.yml:4`

## CUE configuration

To retrieve value from the env file and use it in the cue configuration you should use the `@tag(NAME)` function.
It is possible to specify the type (otherwise is `string` by default).

You can see examples in `example.cue:8`, `example.cue:25` and `example.cue:26`.

## Build

To build the project with an env file simply run `martecfg` with the correct argument:

```bash
martecfg build --env ENV_FILE
```

## Tips

It is possible to use values to enable or disable part of the configuration as in this
example with the variable `#Debug`
