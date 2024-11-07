package components

import "marte.org/MARTe"

#EPICSCAInput: MARTe.#DataSource & {
	Class:      "EPICSCA::EPICSCAInput"
	StackSize?: uint32
	CPUs?:      uint32
	Signals: {
		[_]: {
			#direction: "IN"
			PVName:     string
		}
	}
}

#EPICSCAOutput: MARTe.#DataSource & {
	Class:                "EPICSCA::EPICSCAOutput"
	StackSize?:           uint32
	CPUs?:                uint32
	IgnoreBufferOverrun?: 0 | 1
	NumberOfBuffers:      uint32 & >0
	DBR64CastDouble?:     "yes" | "no"
	Signals: {
		[_]: {
			#direction: "OUT"
			PVName:     string
		}
	}
}
