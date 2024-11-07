# simple_app

This is a basic almost empty app just to display the basic structure of a MARTe2CUE project.

## How to build

To build the MARTe configuration from this folder simply execute:

```bash
martecfg build
```

## Examples

### DataSource signals

In this simple example there are 3 ways to define a datasource signal:

1. At `simple_app.cue:13` the signal `Time` is defined by using the builtin types
2. At `simple_app.cue:14` ths signal `SignalA` is defined manually
3. At `simple_app.cue:15` the signal `SignalB` is defined using the builtin types but sepcifying an extra information
   in this case the `NumberOfElements`

Note that each `DataSource` has a copy of the `Signals` field named simply `#` as a shortcut.

### GAM IO signals

Also in the example are shown 3 ways to define GAM IO signals:

1. At `simple_app.cue:30` it uses the field `#datasource` to reference the datasource and infer the other information from it,
   the name of the GAM signal **must** be the same of the one define in the DataSource
2. At `simple_app.cue:34` it uses the field `#signal` to reference the datasource signal and infer the other information from it,
   the name of the signal in this case does not matter (it will use the `Alias` field)
3. At `simple_app.cue:38` it uses the manual definition

**Note** that the `#datasource` field can drastically increase the compilation time and the memory required. It is only 
recomended for small configuration.
 

### Thread functions

The function list of the threads can be define in 2 ways:

1. At `simple_app.cue:48` it uses the field `#functions` to reference a list of GAMs that will be used for generating the name list
2. At `simple_app.cue:52` it uses the manual definition `Functions`

**Note** also the field `#functions` could impact compilation time, and using the `Function` field togheter with the 
GAMs `#id` is reccomended

### Object IDs

All objects have their name stored in themself in the field `#id`, some have also their parent ids
