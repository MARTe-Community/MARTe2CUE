package example

import (
	"marte.org/MARTe"
	"marte.org/MARTe/components"
)

RTApp: Data: {
	EpicsIn: components.#EPICSCAInput & {
		Signals: {
			SegState: MARTe.#uint8 & {
				PVName: "SIM:SegState"
			}
			FC_Alarm: MARTe.#uint8 & {
				PVName: "SIM:FC_Alarm"
			}
			EC_GN_P01_GA_CCPS_Alarm: MARTe.#uint8 & {
				PVName: "SIM:CPSA_Alarm"
			}
			EC_GN_P01_GA_FHPS_Alarm: MARTe.#uint8 & {
				PVName: "SIM:HPSA_Alarm"
			}
			EC_GN_P01_GA_MCPS_Alarm: MARTe.#uint8 & {
				PVName: "SIM:SCMMA_Alarm"
			}
			EC_GN_P01_GA_GCPS_Alarm: MARTe.#uint8 & {
				PVName: "SIM:SCMGA_Alarm"
			}
			EC_GN_P01_GA_CCPS_Current_Alarm: MARTe.#uint8 & {
				PVName: "SIM:CPSA_Current_Alarm"
			}
			TrigSignal: MARTe.#uint8 & {
				PVName: "SIM:StartPulse"
			}
			OnlineSignal: MARTe.#uint8 & {
				PVName: "SIM:ONLINE"
			}
		}
	}

	// Publish useful information to EPICS for monitor
	EpicsOut: components.#EPICSCAOutput & {
		NumberOfBuffers: 10
		Signals: {
			OSMState: MARTe.#uint8 & {
				PVName: "ID:OSMState"
			}
			RTSMState: MARTe.#uint8 & {
				PVName: "ID:RTSMSTate"
			}
			SegState: MARTe.#uint8 & {
				PVName: "ID:SegState"
			}
		}
	}
}

let #Data = RTApp.Data

RTApp: Functions: {
	SimulateGAM: components.#IOGAM & {
		InputSignals: {
			Segregation: #signal: #Data.EpicsIn.#.SegState
			Alarm: #signal:       #Data.EpicsIn.#.FC_Alarm
		}
		OutputSignals: {
			Segregation: #signal: #Data.DDB1.#.SegState
			Alarm: #signal:       #Data.PLCSDNPubBits.#.GAB_FCT_Fast_Controller_Alarm
		}
	}
	StatePubGAM: components.#IOGAM & {
		InputSignals: {
			OSMState_0: #signal:  #Data.DDB1.#.OSMState
			OSMState_1: #signal:  #Data.DDB1.#.OSMState
			RTSMState_0: #signal: #Data.DDB1.#.RTSMState
			RTSMState_1: #signal: #Data.DDB1.#.RTSMState
			SegState_0: #signal:  #Data.DDB1.#.SegState
			SegState_1: #signal:  #Data.DDB1.#.SegState
		}
		OutputSignals: {
			OSMState_0: #signal:  #Data.EpicsOut.#.OSMState
			OSMState_1: #signal:  #Data.PLCSDNPub.#.GAB_FCT_FC_OP_STATE
			RTSMState_0: #signal: #Data.EpicsOut.#.RTSMState
			RTSMState_1: #signal: #Data.PLCSDNPub.#.GAB_FCT_FC_RT_STATE
			SegState_0: #signal:  #Data.EpicsOut.#.SegState
			SegState_1: {
				#signal: #Data.PLCSDNPub.#.GAB_FCT_FC_SEG_STATE
				Trigger: 1
			}
		}
	}
}
