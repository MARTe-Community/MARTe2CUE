package example

import (
	"marte.org/MARTe"
	"marte.org/MARTe/components"
)

RTApp: Data: {
	#default: DDB1
	DDB1: MARTe.#GAMDataSource & {
		Signals: {
			OSMState:         MARTe.#uint8
			RTSMState:        MARTe.#uint8
			SegState:         MARTe.#uint8
			DAQEnabled:       MARTe.#bool // To be check if useful
			PendingGoToState: MARTe.#uint32
			PendingTrip:      MARTe.#uint32
			PendingSuspend:   MARTe.#uint32
			PendingOnline:    MARTe.#uint32
			PendingTrig:      MARTe.#uint32
			PendingMessages:  MARTe.#uint32
			LOAD_DONE:        MARTe.#uint8
			LOAD_ACK:         MARTe.#uint8
		}
	}

	RTTimer: components.#LinuxTimer & {
		SleepNature: "Busy"
		CPUMask:     0x2
		Signals: Time: MARTe.#uint32
	}

	Timing: MARTe.#TimingDataSource
	Logger: components.#LoggerDataSource & {
		Signals: {
			FC_OP_STATE:   MARTe.#uint8
			FC_RT_STATE:   MARTe.#uint8
			LOAD_CFG_DONE: MARTe.#uint8
			LOAD_CMD:      MARTe.#uint8
			LOAD_ACK:      MARTe.#uint8
			Float0:        MARTe.#float32
			Float1:        MARTe.#float32
			Float2:        MARTe.#float32
			Float3:        MARTe.#float32
			Float4:        MARTe.#float32
			Float5:        MARTe.#float32
			Float6:        MARTe.#float32
			Float7:        MARTe.#float32
			Float8:        MARTe.#float32
			Float9:        MARTe.#float32
			ByteGroup0:    MARTe.#uint8
		}
	}
}
