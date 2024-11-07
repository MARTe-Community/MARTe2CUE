package example

import (
	"marte.org/MARTe"
	"marte.org/MARTe/components"
)

RTApp: Data: UDPSender: components.#UDPSender & {
	Address:       "10.0.0.10"
	Port:          2040
	ExecutionMode: "RealTimeThread"
	Signals: {
		LoadCommand: MARTe.#uint8
		OSMState:    MARTe.#uint8
		RTSMState:   MARTe.#uint8
		SegState:    MARTe.#uint8
	}
}

RTApp: Functions: UDPPubGAM: components.#IOGAM & {
	/// Automatic Handshacke of the SDN commands
	InputSignals: {
		LoadCMD: #signal:       RTApp.Data.PLCSDNSub.#.GAB_FCT_LOAD_CMD
		OSMState: #datasource:  RTApp.Data.DDB1
		RTSMState: #datasource: RTApp.Data.DDB1
		SegState: #datasource:  RTApp.Data.DDB1
	}
	OutputSignals: {
		LoadCommand: #datasource: RTApp.Data.UDPSender
		OSMState: #datasource:    RTApp.Data.UDPSender
		RTSMState: #datasource:   RTApp.Data.UDPSender
		SegState: #datasource:    RTApp.Data.UDPSender
	}
}
