project: {
	package:      string // configuration package name should be the same of the one used in the cue  project
	description?: string
	output?:      string // if not define the result will be redirected to the stdout
	application?: string // name of the realtime app 
	dependencies?: {// git repos as dependencies 
		[_]: {
			target:  string                    // folder where the dependency will be installed  
			source:  =~"^(https|ssh)://.*git$" // git repository url
			branch?: string                    // branch or tag to checkout 
		}
	}
	interfaces?: {// SDN Packets interfaces file
		[_]: {
			mode:      "SUB" | "PUB" // define if the interface is a publisher or a ssubcriber 
			topic?:    string        // optional SDN topic (if none "Ignored" is used)
			interface: string        // network interface
			address:   string        // sdn address
			source:    string        // csv configuration file path
			output?:   string        // cue output
			patterns?: [...string] // pattern to rmeove from signal names for simplification
		}
	}
}
