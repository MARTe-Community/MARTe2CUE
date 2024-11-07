# Example

This app contains a more complex configuration, including SDN interfaces generated from a template file and
multi file configuration.

## Project file

The [`project.yml`](source/project.yml) file contains the basic project information, such as
package name, output and description but additionally it includes few interfaces, one below:

```yaml
interfaces:
  PLCSDNPub:
    mode: PUB
    interface: eno2
    address: 11.2.0.10:2000
    source: interfaces/sdn/output/SDN_CONFIG_FC_TO_PLC.csv
    output: plc_sdn_publisher.cue
    patterns:
      - EC-GN-P01-
```

This will generate automatically the needed `MARTe` configuration for a specific packet configuration.
The packet is defined in the `source` file and it is simply a CSV with each (not commented) line composed of:

    NAME,TYPE,DIMENSION,EXPECTED_VALUE,COMMENT

If there are signal of type `uint1` the converter will check that the number of `uint1` is multiple of 8 and
then unpack (or pack it, depending on the direction) by merging the bits in bytes.

The `mode` define the direction `PUB` for publisher and `SUB` for subscriber.

The network information (`address` and `interface`) are mandatory, while `topic` is optional.

The `output` field is optional and if not define the output file will be `NAME.cue`, where `NAME` is the field
name.

The `patterns` array field is used to define a list of patterns that you want to remove from the signal names.

### Generated congiguration

In this specific example the code will generate:

1. `plc_sdn_publisher.cue`, that contains:
   - `PLCSDNPub`, the `SDNPublisher` datasource
   - `PLCSDNPubBits`, a `GAMDataSource` that contains the 24 `uint8` signals that will be mapped to the 3 bytes
   - `PLCSDNPubCompactBitGAM`, a `CompactBitGAM` that pack 24 `uint8` signals to the 3 bytes of the sdn packet
   - `PLCSDNPubConstantGAM`, a `ConstantGAM` that publish the SDN sub header containing information about number and
     type of signals
2. `plc_sdn_subscriber.cue`, that contains:
   - `PLCSDNSub`, the `SDNSubscriber` datasource
   - `PLCSDNSubBits`, a `GAMDataSource` that contains the 24 `uint8` signals that will be mapped to the 3 bytes
   - `PLCSDNSubExtractBitGAM`, a `ExtractBitGAM` that unpack the 3 bytes from the packet to the 24 `uint8` signals

## Tips

### Aliases

Use aliases to avoid repetive long names, for example to reference data signals
is uselful to use an alias, e.g.: `functions.cue:7`.

Note that the scope of an alias is at most the file where is defined, so you will have to
redefine each time.

### Hidden variable

When you want to use an alias in multiple file without redefine it each time could be useful
to use an hidden variable (a variable with name that start with `#` or `_`).

However than you have to make sure to use it correctly, for example if you use an hidden
field `#Data: {}` to set your datasources then all your datasource should be defined inside
`#Data` and in your app you should have `Data: #Data` to recover all the datasources.

### Group and reuse

It is useful to both have more compact configuration but also a more readable one to
group and reuse the part that are repeated.

A common example is the functions list of threads, when multiple states are defined
many share same functions, using list operation can save time and make it more clear, e.g.: `source/example.cue`

### Divide in file

CUE allows to split your configuration in how many files you want so it is nice to have it
split in meaningful way.
To let know to CUE that the files are of the same configuration you need to add the `package NAME` at the
top of your file.

You can define incrementally your object in multiple file with no problem, for example
by adding datasources to your `App.Data` in multiple files or GAMs to `App.Functions`.
But it is also possible to add more signals to datasources or even to GAMs.
