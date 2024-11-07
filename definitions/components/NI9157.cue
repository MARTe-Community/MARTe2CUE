package components

import "marte.org/MARTe"

#NI9157Device: {
	Class:             "NI9157Device"
	NiRioDeviceName?:  string
	NiRioSerialNumber: string
	NiRioGenFile:      string
	NiRioGenSignature: string
	Open?:             0 | 1
	Run?:              0 | 1
	Reset?:            0 | 1
	ResetPostSleepMs?: uint
}

#NI9157MxiDataSource: MARTe.#DataSource & {
	#device:               #NI9157Device
	Class:                 "NI9157::NI9157MxiDataSource"
	RunNi:                 0 | 1
	NI9157DevicePath:      #device.#id
	NumberOfPacketsInFIFO: uint32 | *10
	BlockIfNotRunning:     uint32 | *0
	Signals: {
		[_]: {
			InitialPattern?: uint64
		}
	}
}
