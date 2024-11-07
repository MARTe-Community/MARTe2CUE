package components

import "marte.org/MARTe"

#PVSignal: MARTe.#Signal & {
	#id:   string
	Field: string | *"value"
	Alias: string | *#id
}

#EPICSPVAInput: MARTe.#DataSource & {
	Class:      "EPICSPVADataSource::EPICSPVAInput"
	StackSize?: uint32
	CPUs?:      uint32
	Signals: {
		[_]: #PVSignal
	}
}

#EPICSPVAOutput: MARTe.#DataSource & {
	Class:                "EPICSPVADataSource::EPICSPVAOutput"
	StackSize?:           uint32
	CPUs?:                uint32
	IgnoreBufferOverrun?: 0 | 1
	NumberOfBuffers:      uint32 & >0
	Signals: {
		[_]: #PVSignal
	}
}
