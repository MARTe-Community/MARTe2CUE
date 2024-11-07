package components

import "marte.org/MARTe"

#DANSource: MARTe.#DataSource & {
	Class:               "DAN::DANSource"
	NumberOfBuffers:     uint32
	CPUMask:             uint32
	StackSize:           uint32
	DanBufferMultiplier: uint32
	StoreOnTrigger:      0 | 1
	if StoreOnTrigger == 1 {
		NumberOfPreTrigger:  uint32
		NumberOfPostTrigger: uint32
	}
	ICProgName?: string
	Interleave?: 0 | 1
	Signals: {
		if StoreOnTrigger == 1 {
			Trigger: {
				#direction: "IN"
				Type:       "uint8"
			}
			Time: {
				#direction:    "IN"
				Type:          "uint32"
				TimeSignal?:   0 | 1
				AbsoluteTime?: 0 | 1
			}
		}
		[!~"Trigger|Time"]: {
			#direction:        "OUT"
			Period:            float
			SamplingFrequency: uint32
		}
	}
}

#LinkDataSource: MARTe.#DataSource & {
	Class: "LinkDataSource"
	Link: {
		Class: string
		...
	}
	IsWriter: 0 | 1
}

#LinuxTimer: MARTe.#DataSource & {
	Class:            "LinuxTimer"
	ExecutionMode?:   #ThreadMode
	SleepNature?:     *"Default" | "Busy"
	SleepPercentage?: uint & <=100
	Phase?:           uint
	CPUMask?:         uint
	Signals: {
		[_]: #direction: "IN"
		Counter: MARTe.#uint32
		Time: MARTe.#uint32 & {
			Frequency?: uint32
		}
		AbsoluteTime?: MARTe.#uint64
		DeltaTime?:    MARTe.#uint64
		TrigRephase?:  MARTe.#uint8
	}
}

#LoggerDataSource: MARTe.#DataSource & {
	Class:        "LoggerDataSource"
	CyclePeriod?: uint32
	Signals: {
		[_]: {
			#direction: "OUT"
		}
	}
}

#NI1588Timestamp: MARTe.#DataSource & {
	Class:                   "NI1588Timestamp"
	NumberOfBuffers:         uint32
	NiSyncDeviceNumber?:     uint32 | *0
	CPUMask?:                uint32 | *0xFFFF
	ReceiverThreadPriority?: uint32 & <32 | *31
	PollMsecTimeout?:        uint32 | *-1
	Signals: {
		TerminalPFI0?: {
			Type:          "uint64"
			CaptureEvent?: "NISYNC_EDGE_RISING" | "NISYNC_EDGE_FALLING" | *"NISYNC_EDGE_ANY"
			Samples?:      uint32 & >=1
		}
		TerminalPFI1?: {
			Type:          "uint64"
			CaptureEvent?: "NISYNC_EDGE_RISING" | "NISYNC_EDGE_FALLING" | *"NISYNC_EDGE_ANY"
		}
		TerminalPFI2?: {
			Type:          "uint64"
			CaptureEvent?: "NISYNC_EDGE_RISING" | "NISYNC_EDGE_FALLING" | *"NISYNC_EDGE_ANY"
		}
		EventPFI0?: {
			Type: "uint8"
		}
		EventPFI1?: {
			Type: "uint8"
		}
		EventPFI2?: {
			Type: "uint8"
		}
		InternalTimeStamp?: {
			Type:               "uint64"
			NumberOfDimensions: 1
			NumberOfElements:   uint32 & >=1
		}
		ErrorCheck?: {
			Type:               "uint32"
			NumberOfDimensions: 1
			NumberOfElements:   uint32 & >=1
		}
	}
}

#UARTDataSource: MARTe.#DataSource & {
	Class:           "UARTDataSource"
	NumberOfBuffers: uint32
	PortName:        string
	BaudrAte:        uint32
	Timeout:         uint32
	CPUMask:         uint32
	Signals: {
		DataOK: {
			Type:             "uint8"
			NumberOfElements: 1
		}
		Time: {
			Type:             "uint64"
			NumberOfElements: 1
		}
		Packet: {
			Type: "uint8"
		}
	}
	TimeProvider?: {
		Class: "TimestampProvider"
	}
}

#RealTimeThreadAsyncBridge: MARTe.#DataSource & {
	Class:            "RealTimeThreadAsyncBridge"
	NumberOfBuffers?: uint & <64 & >=1 | *1
	HeapName?:        string | *"Default"
	BlockingMode:     *0 | 1
	if BlockingMode == 1 {
		NumberOfBuffers: 1
	}
	ResetMSecTimeout?: uint | *"TTInfiniteWait"
	Signals: {
		[_]: {
			#direction: "INOUT"
		}
	}
}

#ProfinetDataSource: MARTe.#DataSource & {
	Class:            "ProfinetDataSource"
	NetworkInterface: string
	StationName:      string
	PeriodicInterval: int | *10000 // us
	ReductionRatio:   int | *100
	NumberOfBuffers:  uint
	//Vendor identification and manufacturer data, which must match the controller GSDML specified ones
	VendorIdentifier:           uint16
	DeviceIdentifier:           uint16
	OEMVendorIdentifier:        uint16
	OEMDeviceIdentifier:        uint16
	DeviceVendor:               string
	ManufacturerSpecificString: string

	//I&M identification and maintainance data, which must match the controller GSDML specified ones
	IMVendor:                uint16
	IMHardwareRevision:      uint16
	IMSoftwareRevision:      string
	IMFunctionalEnhancement: uint8
	IMBugFix:                uint8
	IMInternalChange:        uint8
	IMProfileIdentifier:     uint16
	IMProfileSpecificType:   uint16
	IMVersionMajor:          uint8
	IMVersionMinor:          uint8
	IMFunction:              string | *""
	IMLocation:              string | *""
	IMDate:                  string | *""
	IMSerialNumber:          string | *""
	IMDescriptor:            string | *""
	IMSignature:             string | *""

	//LLDP and extended device configuration, which must match the controller GSDML specified one
	LLDPPortIdentifier: string
	RTClass2Status:     uint16
	RTClass3Status:     uint16
	MAUType:            uint16 | *0x00

	//Mandatory: the Main thread helper, which is implemented using MARTe2 binder. Here the Timeout
	//and CPU Mask for the thread can be specified
	MainThreadHelper: {
		Class:   "ProfinetMainThreadHelper"
		Timeout: uint32
		CPUMask: uint32
	}
	//Mandatory: the Timer thread helper, which is implemented using MARTe2 binder. Here the Timeout
	//and CPU Mask for the thread can be specified
	TimerHelper: {
		Class:   "ProfinetTimerHelper"
		Timeout: uint32
		CPUMask: uint32
	}
	//Mandatory section for the Slots / Subslots configuration
	Slots: {
		[_]: {
			SlotNumber: uint
			SubSlots: {
				[_]: {
					SubslotNumber:         uint32
					DeviceAccessPoint:     0 | 1
					ExpectedDataDirection: 0 | 1 | 2 | 3
					ExpectedInputSize:     uint16
					ExpectedOutputSize:    uint16
				}
			}
		}
	}

	Signals: {
		[!~"ProfinetDeviceLed|ProfinetDeviceReady"]: {
			Slot:      uint
			Subslot:   uint
			Offset:    0
			Direction: 0 | 1
			if Direction == 0 {
				#direction: "OUT"
			}
			if Direction == 1 {
				#direction: "IN"
			}
			NeedSwapping: *0 | 1
		}
		ProfinetDeviceLend:  MARTe.#uint8
		ProfinetDeviceReady: MARTe.#uint8
	}
}
