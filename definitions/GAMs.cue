package MARTe

// #GAMSignal: {
// 	#id:         string
// 	#parent:     string
// 	DataSource:  string
// 	Type:        #Type
// 	if #signal != null {
// 		DataSource: sig.#datasource
// 		Type:       sig.Type
// 		if sig.NumberOfElements != _|_ {
// 			NumberOfElements: sig.NumberOfElements
// 		}
// 		if sig.NumberOfDimensions != _|_ {
// 			NumberOfDimensions: sig.NumberOfDimensions
// 		}
// 		#direction: sig.#direction
// 	}
// 	...
// }

#GAMSignal: {
	#id:         string
	#parent:     string
	#signal:     #Signal | *null
	#datasource: #DataSource | *null
	DataSource:  string
	Type:        #Type
	Alias?:      string
	#direction?: string
	if #signal != null {
		Alias:      #signal.#id
		DataSource: #signal.#datasource
		Type:       #signal.Type
		if #signal.NumberOfElements != _|_ {
			NumberOfElements: #signal.NumberOfElements
		}
		if #signal.NumberOfDimensions != _|_ {
			NumberOfDimensions: #signal.NumberOfDimensions
		}
		#direction: #signal.#direction
	}
	if #signal == null && #datasource != null {
		DataSource: #datasource.#id
		let signal = #datasource.Signals[#id]
		Type: signal.Type
		if signal.NumberOfElements != _|_ {
			NumberOfElements: signal.NumberOfElements
		}
		if signal.NumberOfDimensions != _|_ {
			NumberOfDimensions: signal.NumberOfDimensions
		}
		#direction: signal.#direction
	}
	...
}

#GAM: {
	#appid: string
	#id:    string
	Class:  string
	let GAMID = #id
	InputSignals?: {
		[name=string]: #GAMSignal & {
			#id:         name
			#parent:     "\(#appid).Functions.\(GAMID)"
			#direction?: "IN" | "INOUT"
		}
	}
	OutputSignals?: {
		[name=string]: #GAMSignal & {
			#id:         name
			#parent:     "\(#appid).Functions.\(GAMID)"
			#direction?: "OUT" | "INOUT"
		}
	}
	...
}

#Message: {
	#signal?: #GAMSignal & {#signal: #Signal & {
		#direction: "OUT" | "INOUT"
	}} | _
	#value?: _
	if #value != _|_ && #signal != _|_ {
		Function:    "SetOutput"
		Mode:        *"ExpectsReply" | "ExpectIndirectReply"
		Destination: #signal.#parent
		Parameters: {
			SignalName:  #signal.#id
			SignalValue: #value
		}
	}
}
