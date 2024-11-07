package components

import "marte.org/MARTe"

#MDSReader: MARTe.#DataSource & {
	Class:      "MDSReader"
	TreeName:   string
	ShotNumber: uint32
	Frequency:  float
	Signals: {
		Time: MARTe.#Signal & {
			Type:             uint32
			NumberOfElements: 1
		}
		[!~"Time"]: MARTe.#Signal & {
			NodeName:       string
			DataManagement: 0 | 1 | 2
			HoleManagement: 0 | 1
			#direction:     "OUT"
		}
	}
}

#MDSWriter: MARTe.#DataSource & {
	Class:           "MDSWriter"
	NumberOfBuffers: uint32
	CPUMask:         uint32
	StackSize:       uint32
	TreeName:        string
	PulseNumber?:    -1 | uint32
	StoreOnTrigger:  0 | 1
	EventName:       string
	TimeRefresh:     uint32
	if StoreOnTrigger == 1 {
		NumberOfPreTrigger:  uint32
		NumberOfPostTrigger: uint32
	}
	Signals: {
		if StoreOnTrigger == 1 {
			Trigger: MARTe.#Signal & {
				Type: "uint8"
			}
			Time: MARTe.#Signal & {
				Type:                  "uint32"
				TimeSignal?:           1 | 0
				TimeSignalMultiplier?: float
			}
		}

		[!~"Trigger|Time"]: MARTe.#Signal & {
			NodeName:              string
			Period:                uint32
			AutomaticSegmentation: 0 | 1
			if AutomaticSegmentation == 0 {
				MakeSegmentAfterNWrites: uint32
				DecimatedMode?:          *0 | "SIGUINT16D"
				if DecimatedMode != 0 {
					MinMaxResampleFactor: uint32
				}
			}
			SamplePhase?:         uint32
			DiscontinuityFactor?: uint32
		}
	}
	Messages?: {
		Class: "ReferenceContainer"
		TreeOpenedOK?: MARTe.#Message & {
			Mode: "ExpectsReply"
		}
		TreeOpenedFail?: MARTe.#Message & {
			Mode: "ExpectsReply"
		}
		TreeFlushed?: MARTe.#Message & {
			Mode: "ExpectsReply"
		}
	}
}
