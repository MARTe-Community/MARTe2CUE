package example

import "marte.org/MARTe/components"

let #Data = RTApp.Data
let SDNPub = #Data.PLCSDNPub
let SDNSub = #Data.PLCSDNSub

// Define GAMs needed for the PLC Communication
RTApp: Functions: {
	PLCHandshakeGAM: components.#IOGAM & {
		/// Automatic Handshacke of the SDN commands
		InputSignals: {
			ABORT_CMD: {#signal: SDNSub.#.GAB_FCT_ABORT_CMD, Trigger: 1}
			LOAD_CMD_1: #signal:             SDNSub.#.GAB_FCT_LOAD_CMD
			LOAD_CMD_0: #signal:             SDNSub.#.GAB_FCT_LOAD_CMD
			STBY_WAITTRIG_ONLINE: #signal:   SDNSub.#.GAB_FCT_STBY_WAITTRIG_ONLINE
			START_POWER_CMD: #signal:        SDNSub.#.GAB_FCT_START_POWER_CMD
			STOP_POWER_CMD: #signal:         SDNSub.#.GAB_FCT_STOP_POWER_CMD
			SUSPEND_RESUME_CMD: #signal:     SDNSub.#.GAB_FCT_SUSPEND_RESUME_CMD
			SEGREGATION_CMD: #signal:        SDNSub.#.GAB_FCT_SEGREGATION_CMD
			GA_CCPS_OPERATION_CMD: #signal:  SDNSub.#.GA_CCPS_OPERATION_CMD
			GA_CCPS_CONFIG_SEQ_CMD: #signal: SDNSub.#.GA_CCPS_CONFIG_SEQ_CMD
			GA_FHPS_RAMP_CMD: #signal:       SDNSub.#.GA_FHPS_RAMP_CMD
			GA_FHPS_CONFIG_SEQ_CMD: #signal: SDNSub.#.GA_FHPS_CONFIG_SEQ_CMD
			GA_MCPS_RAMP_CMD: #signal:       SDNSub.#.GA_MCPS_RAMP_CMD
			GA_MCPS_CONFIG_CMD: #signal:     SDNSub.#.GA_MCPS_CONFIG_CMD
			GA_MCPS_HOLD_CMD: #signal:       SDNSub.#.GA_MCPS_HOLD_CMD
			GA_GCPS_RAMP_CMD: #signal:       SDNSub.#.GA_GCPS_RAMP_CMD
			GA_GCPS_CONFIG_CMD: #signal:     SDNSub.#.GA_GCPS_CONFIG_CMD
			GA_GCPS_HOLD_CMD: #signal:       SDNSub.#.GA_GCPS_HOLD_CMD
			GB_CCPS_OPERATION_CMD: #signal:  SDNSub.#.GB_CCPS_OPERATION_CMD
			GB_CCPS_CONFIG_SEQ_CMD: #signal: SDNSub.#.GB_CCPS_CONFIG_SEQ_CMD
			GB_FHPS_RAMP_CMD: #signal:       SDNSub.#.GB_FHPS_RAMP_CMD
			GB_FHPS_CONFIG_SEQ_CMD: #signal: SDNSub.#.GB_FHPS_CONFIG_SEQ_CMD
			GB_MCPS_RAMP_CMD: #signal:       SDNSub.#.GB_MCPS_RAMP_CMD
			GB_MCPS_CONFIG_CMD: #signal:     SDNSub.#.GB_MCPS_CONFIG_CMD
			GB_MCPS_HOLD_CMD: #signal:       SDNSub.#.GB_MCPS_HOLD_CMD
			GB_GCPS_RAMP_CMD: #signal:       SDNSub.#.GB_GCPS_RAMP_CMD
			GB_GCPS_CONFIG_CMD: #signal:     SDNSub.#.GB_GCPS_CONFIG_CMD
			GB_GCPS_HOLD_CMD: #signal:       SDNSub.#.GB_GCPS_HOLD_CMD
		}
		OutputSignals: {
			ACK_GAB_FCT_ABORT_CMD: #signal:            SDNPub.#.ACK_GAB_FCT_ABORT_CMD
			LOAD_ACK: #signal:                         #Data.DDB1.#.LOAD_ACK
			ACK_FCT_LOAD_CMD: #signal:                 SDNPub.#.ACK_GAB_FCT_LOAD_CMD
			ACK_GAB_FCT_STBY_WAITTRIG_ONLINE: #signal: SDNPub.#.ACK_GAB_FCT_STBY_WAITTRIG_ONLINE
			ACK_GAB_FCT_START_POWER_CMD: #signal:      SDNPub.#.ACK_GAB_FCT_START_POWER_CMD
			ACK_GAB_FCT_STOP_POWER_CMD: #signal:       SDNPub.#.ACK_GAB_FCT_STOP_POWER_CMD
			ACK_GAB_FCT_SUSPEND_RESUME_CMD: #signal:   SDNPub.#.ACK_GAB_FCT_SUSPEND_RESUME_CMD
			ACK_GAB_FCT_SEGREGATION_CMD: #signal:      SDNPub.#.ACK_GAB_FCT_SEGREGATION_CMD
			ACK_GA_CCPS_OPERATION_CMD: #signal:        SDNPub.#.ACK_GA_CCPS_OPERATION_CMD
			ACK_GA_CCPS_CONFIG_SEQ_CMD: #signal:       SDNPub.#.ACK_GA_CCPS_CONFIG_SEQ_CMD
			ACK_GA_FHPS_RAMP_CMD: #signal:             SDNPub.#.ACK_GA_FHPS_RAMP_CMD
			ACK_GA_FHPS_CONFIG_SEQ_CMD: #signal:       SDNPub.#.ACK_GA_FHPS_CONFIG_SEQ_CMD
			ACK_GA_MCPS_RAMP_CMD: #signal:             SDNPub.#.ACK_GA_MCPS_RAMP_CMD
			ACK_GA_MCPS_CONFIG_CMD: #signal:           SDNPub.#.ACK_GA_MCPS_CONFIG_CMD
			ACK_GA_MCPS_HOLD_CMD: #signal:             SDNPub.#.ACK_GA_MCPS_HOLD_CMD
			ACK_GA_GCPS_RAMP_CMD: #signal:             SDNPub.#.ACK_GA_GCPS_RAMP_CMD
			ACK_GA_GCPS_CONFIG_CMD: #signal:           SDNPub.#.ACK_GA_GCPS_CONFIG_CMD
			ACK_GA_GCPS_HOLD_CMD: #signal:             SDNPub.#.ACK_GA_GCPS_HOLD_CMD
			ACK_GB_CCPS_OPERATION_CMD: #signal:        SDNPub.#.ACK_GB_CCPS_OPERATION_CMD
			ACK_GB_CCPS_CONFIG_SEQ_CMD: #signal:       SDNPub.#.ACK_GB_CCPS_CONFIG_SEQ_CMD
			ACK_GB_FHPS_RAMP_CMD: #signal:             SDNPub.#.ACK_GB_FHPS_RAMP_CMD
			ACK_GB_FHPS_CONFIG_SEQ_CMD: #signal:       SDNPub.#.ACK_GB_FHPS_CONFIG_SEQ_CMD
			ACK_GB_MCPS_RAMP_CMD: #signal:             SDNPub.#.ACK_GB_MCPS_RAMP_CMD
			ACK_GB_MCPS_CONFIG_CMD: #signal:           SDNPub.#.ACK_GB_MCPS_CONFIG_CMD
			ACK_GB_MCPS_HOLD_CMD: #signal:             SDNPub.#.ACK_GB_MCPS_HOLD_CMD
			ACK_GB_GCPS_RAMP_CMD: #signal:             SDNPub.#.ACK_GB_GCPS_RAMP_CMD
			ACK_GB_GCPS_CONFIG_CMD: #signal:           SDNPub.#.ACK_GB_GCPS_CONFIG_CMD
			ACK_GB_GCPS_HOLD_CMD: #signal:             SDNPub.#.ACK_GB_GCPS_HOLD_CMD
		}
	}
}
