# MARTe2Cue

## martecfg

This is simply a bash script that unify few useful commands:

- `help` get help for `martecfg` and its command
- `init` create and initialize a MARTe2CUE project
- `build` build the current MARTeCUE project
- `update` update the dependencies and definitions of a project

To have additional information:

```bash
matecfg help [command]
```

### Porject initialisation

### Project configuration

The following is the skeleton of a project configuration file:

```yaml
project:
  package: CUE_PACKAGE # name of the cue package
  description: DESCRIPTION # optional informative description
  destination: OUTPUT JSON FILE # json output path
  application: APP_NAME # optional real time application name
  dependencies: # optional git dependencies
    DEP_NAME: # informative name
      target: DESTINATION_PATH # clone destination
      source: GIT URL # git remote uri
      branch: BRANCH OR TAG # optional branch or tag for repeatable build
  # ...
  interfaces: # optional SDN interfaces
    INTERFACE_NAME: # name used as datasource name
      mode: MODE (PUB|SUB) # direction of the link
      interface: NETWORK INTERFACE # physical network interface
      address: NETWORK ADDRESS # ip address
      source: CSV INTERFACE FILE # csv file where packets is defined
      patterns: # optional list of string to remove from signal names
        - string
        # ...
  # ...
  tags: # optional tags used in the cue project
    TAG_NAME: TAG_VALUE # pair of name and values
    # ...
```

You can find an example for the `configuration/SCU_SM_DEMO` project.

### Project build

To build a project simply run `martecfg build` from the root folder of the project.

#### Env file

It is possible to specify environmental variables in a `yaml` file and use them across the project.
To build a project with an env file simply

```bash
martecfg build --env ENV FILE
```

Please look at the [example 2](/examples/1.EnvExample/README.md) for more information.

#### Dependencies

It is possible to specify `git` dependencies in the project file by simply add them at the optional `dependencies` field.

```yaml
#...
dependencies:
  DEP_NAME:
    target: FOLDER_WHERE_WILL_BE_CLONED
    source: GIT_REPO
    branch: BRANCH_OR_TAG
#...
```

During the build (or the update) the dependencies will be checkout in the target folder.

#### SDN Interface

It is possible to generate `SDN` datasources from `CSV` packets definition. To do so simply add the `interfaces` optional
field to the `project.yml`.

This field need to be configured as following:

```yaml
#...
interfaces:
  DATA_SOURCE_NAME:
    mode: PUB or SUB #one or the other
    interface: ETHERNET_IF
    address: SDN_ADDRESS
    source: CSV_SOURCE_FILE
    output: OPTIONAL_OUTPUT_CUE_FILE_NAME # if not datasource name will be used
    patterns: # optional
      - PATTERN_TO_REMOVE_FROM_SIG_NAME
```

This tool use a `CSV` interface document and generate a `cue` file describing the needed `DataSource`s and `GAM`s.
In particular will create a `SDNPublisher` or `SDNSubscriber` data source with the signals described in the `CSV` file, additionally
in the case of a `SDNPublisher` if any constant (default) value are defined will also create a `ConstantGAM` to publish automatically this values.

Finally if any signal is defined as `uint1` (a non supported type representing 1 bit) will automatically pack it in bytes and use the
`ExtractBitGAM` or `CompactBitGAM` to unpack/pack the bits to `uint8` signals automatically defined in a separated `GAMDataSource`.

Please look at the [examples/2.ComplexApp](/examples/2.ComplexApp/README.md) to have a better idea of its capacity.

##### Interface Document Structure

For simplification the use of `CSV` file for defining interfaces seems a good option as it easily
readable/editable using any spreadshit editor and as well simple to integrate in any automated script.
The proposed format is the following:

```
# Comment line or optional header
# Unique Name, Type, Size, Default Value, Comment/Extra
# PLC SDN Header
N_Reals,uint8,1,30,Number of reals
N_Integer,uint8,1,0,Number of integer values
N_Acks,uint8,1,30,Number of acknowledgements
N_States,uint8,1,40,Number of states
SpareBytes,uint8,3,,Spare bytes
# Reals
# ...
```

If no default value is needed (that is most of the cases) you can leave it empty or set to `NA`.

### Examples

Examples can be found in the folder [`examples`](examples/)

## CUE Definitions

The CUE definitoions for `MARTe` are stored in [`defintions/`](definitions/).

MARTe CUE package, contains the following packages:

- `MARTe` contains the `MARTe2` core definitions
- `MARTe/components` contains the `MARTe2-components` definitions
- `MARTe/extensions` contains the `MARTe-extensions` definitions

### CUE Language

CUE is a language specifically designed for constained strucutered data and configurations, such as MARTe configuration files. Nativally can export (_compile_) to `JSON`, `XML` and `YAML`.

The CUE syntax is quite similar to the MARTe configuration syntax or to any other strucutered data language, the main differences are about the typing, the constraints and the module system.
This differences however are quite minimal and easy to integrate in the development process and to be understood by the developper.

#### CUE Syntax

```cue
// This is a comment
package NAME // all files of the same configuration must be in the same package

import "iter.org/marte/MARTe" // external libraries can be imported using  the import statement. 
                              // if an import is unused the compailer will throw an error
                              // MARTe core components are defined in "iter.org/MARTe/MARTe/" with namespace `MARTe`
                              // MARTe components are defined in "iter.org/MARTe/MARTe/components" with namespace `components`

Public: ... // to define a structure is very similar to MARTe configuration but instead of using `=` use `:` 
_Private: ... // Any field starting with `_` will be visible only on the same package 
#Hidden: ... // Any field starting with `#` will be visible also when imported in other packages *but will not be exported in json*

RTApp: MARTe.#RealTimeApplication & { // To instanciate and exented a type is enough to define the field using the type and extend it with `& { ... }`
                                      // meaning it will be a *TYPE* and whatever is defined in the `{...}`.
                                      // If no changes are needed apart the default one the `& {}` is not required.
}

#uint8: { // this is an example how to define a simple type for simplify the definition of MARTe signals 
  Type: "uint8" // the type field in this case is a constant fixed to `uint8` 
  ... // the `...` syntax means that a `#uint8` structure can contain other fields and is not *closed*
}

//for example we could use in a EPICS PV 
_PVTest: #uint8 & {
  PVName: "XXXXX"
}

// it is possible to shorten up definition for exaple
Something: { 
  topic: "value"
}
// can be written as
Something: topic: "value"
```

### Packages

#### MARTe Core

To import and use components from **MARTe Core** you should import the module `"iter.org/marte/MARTe"`, the pacakge name (and its namespace) is `MARTe` (the last part of the import).

This package includes all the base definition for MARTe as well as the basic structure of a MARTe application.

##### Types

The basic types of MARTe are defined here.

- `MARTe.#uint8` to `MARTe.#uint64`: unsigned integer from 8 to 64 bits
- `MARTe.#int8` to `MARTe.#int64`: integer from 8 to 64 bits
- `MARTe.#float32` and `MARTe.#float64`: floating point number (32 or 64 bits)
- `MARTe.#char8`: character 8 bits
- `MARTe.#bool`: boolean value (only newer MARTe supports it)
- `MARTe.#string`: string value
- `MARTe.#void`: void value

##### MARTe Application Structure

All the basic components of a MARTe application are defined here.

- `MARTe.#Message`: a MARTe message. It has a simplify constructor, specifying a `MARTe.#StateMachineEvent` in the field `#event` field it will automatically fill the rest
- `MARTe.#RealTimeThread`: a MARTe RealTimeThread. The functions list can be specified both by names using the field `functions` or by reference using the field `#functions`
- `MARTe.#RealTimeState`: a MARTe RealTimeState containing a structure of `MARTe.#RealTimeThread` into the field Threads
- `MARTe.#GAMSchedulerI`: a MARTe GAMScheduler interface
- `MARTe.#GAMScheduler`: a MARTe GAMScheduler
- `MARTe.#StateMachineEvent`: a MARTe StateMachineEvent used to define transition between states
- `MARTe.#State`: A MARTe State containing a structure of `MARTe.#StateMachineEvent`
- `MARTe.#StateMachine`: a MARTe StateMachine containing a structure of `MARTe.#State`
- `MARTe.#Data`: Container of MARTe DataSources (`MARTe.#DataSource`)
- `MARTe.#Functions`: Container of MARTe GAMs (`MARTe.#GAM`)
- `MARTe.#States`: Container of MARTe RealTimeStates (`MARTe.#RealTimeState`)
- `MARTe.#RealTimeApplication`: MARTe RealTimeApplication, containing Data, Functions, States, Scheduler

##### MARTe Signals, Data Sources and GAMs

The definition of signals, DataSource and GAM skeletons are defined here. Note that signals are directional and the direction is used as validation rules in the GAMs (input signals can only be `IN` or `INOUT` direction and output signals only `OUT` or `INOUT`).

The direction of the signal come from where is defined in the datasource it comes from (e.g. a GAMDataSource signal will be `INOUT`, while a SDNSubscriber signal will be only `IN`).

- `MARTe.#Signal`: definition of a DataSource signal
- `MARTe.#GAMSignal`: definition of a GAM signal
- `MARTe.#DataSource`: base definition of a DataSource
- `MARTe.#GAM`: base definition of a GAM
- `MARTe.#GAMDataSource`: GAM DataSource
- `MARTe.#TimingDataSource`: timing DataSource

Note as well that by default all datasources are locked. For practicality to access the list of signals of a DataSource it is possible to use the two following syntaxes:

```cue
DATA_SOURCE_NAME.Signals.SIGNAL_NAME
// or
DATA_SOURCE_NAME.#.SIGNAL_NAME
```

#### MARTe Components

To import and use components from **MARTe Components** you should import the module `"iter.org/marte/MARTe/components"`, the pacakge name (and its namespace) is `components`.

This package includes many GAMs and DataSources of the MARTe Components project.

##### Data Sources

The list of implemented definition of data sources is the following:

- `components.#DANSource`
- `components.#EPICSCAInput`
- `components.#EPICSCAOutput`
- `components.#EPICSPVAInput`
- `components.#EPICSPVAOutput`
- `components.#FilReader`
- `components.#FileWriter`
- `components.#LinkDataSource`
- `components.#LinuxTimer`
- `components.#LoggerDataSource`
- `components.#MDSReader`
- `components.#MDSWriter`
- `components.#NI1588Timestamp`
- `components.#NI6259ADC`
- `components.#NI6259DAC`
- `components.#NI6259DIO`
- `components.#NI9157MxiDataSource`
- `components.#RealTimeThreadAsyncBridge`
- `components.#SDNPublisher`
- `components.#SDNSubscriber`
- `components.#UARTDataSource`
- `components.#UDPReceiver`
- `components.#UDPSender`

##### GAMs

The list of implemented definition of GAMs is the following

- `components.ConstantGAM`
- `components.ConversionGAM`
- `components.CRCGAM`
- `components.FilterGAM`
- `components.FlattenedStructIOGAM`
- `components.IOGAM`
- `components.MessageGAM`
- `components.MathExpressionGAM`
- `components.TriggeredIOGAM`

#### MARTe Extensions

To import and use components from **MARTe Extensions** you should import the module `"iter.org/marte/MARTe/extensions"`, the pacakge name (and its namespace) is `extensions`.

This package includes few GAMs of the MARTe Extensions project.

##### GAMs

The list of implemented definition of GAMs is the following

- `extensions.#CompactBitGAM`
- `extensions.#ExtractBitGAM`

### Example

A simple configuration written using `MARTeCUE` it is the following:

```cue
package Example
 
import (
    "marte.org/MARTe"
    "marte.org/MARTe/components"
)
 
App: MARTe.#RealTimeApplication & {
    Data: {
        DefaultDataSource: DDB.#id
        Timing:            MARTe.#TimingDataSource
        DDB: MARTe.#GAMDataSource & {
            Signals: {
                Time:   MARTe.#uint32
                Result: MARTe.#uint32
            }
        }
        LinuxTimer: components.#LinuxTimer & {
            SleepNature: "Busy"
            CPUMask:     0xFF
            Signals: Time: MARTe.#uint32
        }
        Logger: components.#LoggerDataSource & {
            Signals: {
                Time:   MARTe.#uint32
                Result: MARTe.#uint32
            }
        }
    }
    Functions: {
        TimerGAM: components.#IOGAM & {
            InputSignals: Time: {
                #signal:   Data.LinuxTimer.#.Time
                Frequency: 1
            }
            OutputSignals: Time: #signal: Data.DDB.#.Time
        }
        MathGAM: components.#MathExpressionGAM & {
            Expression: "y = x * x;"
            InputSignals: x: #signal:  Data.DDB.#.Time
            OutputSignals: y: #signal: Data.DDB.#.Result
        }
        LogGAM: components.#IOGAM & {
            InputSignals: {
                x: #signal: Data.DDB.#.Time
                y: #signal: Data.DDB.#.Result
            }
            OutputSignals: {
                x: #signal: Data.Logger.#.Time
                y: #signal: Data.Logger.#.Result
            }
        }
    }
    States: Exec: {
        let $F = App.Functions
        Threads: SingleThread: {
            CPUs: 0x1
            Functions: [
                $F.TimerGAM.#id,
                $F.MathGAM.#id,
                $F.LogGAM.#id,
            ]
        }
    }
    Scheduler: MARTe.#GAMScheduler & {
        #source: Data.Timing
    }
}
```
