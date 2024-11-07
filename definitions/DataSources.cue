package MARTe

#Signal: {
	#datasource:         string
	#id:                 string
	#direction:          "IN" | "OUT" | "INOUT"
	Type:                #Type
	NumberOfElements?:   uint32 & >0 | [... uint32 & >0]
	NumberOfDimensions?: uint32 & >0
	Size?:               [... uint32 & >0] | *[1]
	...
}

#DataSource: {
	Class:  string
	#id:    string
	Locked: *1 | 0
	let DSID = #id
	Signals?: {
		[ID=_]: #Signal & {
			#id:         ID
			#datasource: DSID
		}
	}
	#: Signals
	...
}

#GAMDataSource: #DataSource & {
	Class:                              "GAMDataSource"
	HeapName?:                          string
	AllowNoProducers?:                  1 | 0
	ResetUnusedVariablesAtStateChange?: 1 | 0
	Signals?: {
		[_]: {
			#direction: "INOUT"
		}
	}
}

#TimingDataSource: #DataSource & {
	Class: "TimingDataSource"
	Signals?: {
		[_]: {
			#direction: "OUT"
		}
	}
}
