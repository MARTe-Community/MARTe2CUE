package example

import (
	"marte.org/MARTe/components"
)

let #Data = RTApp.Data

RTApp: Functions: LoggerGAM: components.#IOGAM & {
	InputSignals: {
		OSMState: #signal:   #Data.DDB1.#.OSMState
		RTSMState: #signal:  #Data.DDB1.#.RTSMState
		LoadDone: #signal:   #Data.DDB1.#.LOAD_DONE
		LoadCMD: #signal:    #Data.PLCSDNSub.#.GAB_FCT_LOAD_CMD
		LoadACK: #signal:    #Data.DDB1.#.LOAD_ACK
		Float0: #signal:     #Data.PLCSDNSub.#.GA_CCPS_Amplitude
		Float1: #signal:     #Data.PLCSDNSub.#.GA_CCPS_Amplitude_Max_Delta
		Float2: #signal:     #Data.PLCSDNSub.#.GA_CCPS_Curr_Prot_Det_Time
		Float3: #signal:     #Data.PLCSDNSub.#.GA_CCPS_Current_Protection
		Float4: #signal:     #Data.PLCSDNSub.#.GA_CCPS_Frequency
		Float5: #signal:     #Data.PLCSDNSub.#.GA_CCPS_Voltage_Max
		Float6: #signal:     #Data.PLCSDNSub.#.GA_CCPS_Voltage_Min
		Float7: #signal:     #Data.PLCSDNSub.#.GA_FHPS_AC_Current_Max
		Float8: #signal:     #Data.PLCSDNSub.#.GA_FHPS_AC_Voltage
		Float9: #signal:     #Data.PLCSDNSub.#.GA_FHPS_AC_Voltage_Max
		ByteGroup0: #signal: #Data.PLCSDNSub.#.ByteGroup0
	}
	OutputSignals: {
		OPState: #signal:    #Data.Logger.#.FC_OP_STATE
		RTState: #signal:    #Data.Logger.#.FC_RT_STATE
		LoadDone: #signal:   #Data.Logger.#.LOAD_CFG_DONE
		LoadCMD: #signal:    #Data.Logger.#.LOAD_CMD
		LoadACK: #signal:    #Data.Logger.#.LOAD_ACK
		Float0: #signal:     #Data.Logger.#.Float0
		Float1: #signal:     #Data.Logger.#.Float1
		Float2: #signal:     #Data.Logger.#.Float2
		Float3: #signal:     #Data.Logger.#.Float3
		Float4: #signal:     #Data.Logger.#.Float4
		Float5: #signal:     #Data.Logger.#.Float5
		Float6: #signal:     #Data.Logger.#.Float6
		Float7: #signal:     #Data.Logger.#.Float7
		Float8: #signal:     #Data.Logger.#.Float8
		Float9: #signal:     #Data.Logger.#.Float9
		ByteGroup0: #signal: #Data.Logger.#.ByteGroup0
	}
}
