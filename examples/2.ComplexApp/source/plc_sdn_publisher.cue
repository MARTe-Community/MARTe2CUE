//// Autogenerated Interface ////
// Source: source/interfaces/sdn/output/SDN_CONFIG_FC_TO_PLC.csv
// Date: 2024-11-07 11:40:51
// Tool: MARTeCFG/tools/InterfaceConverter
package example

import(
	"marte.org/MARTe"
	"marte.org/MARTe/components"
	"marte.org/MARTe/extensions"
)

RTApp:Data: {
  PLCSDNPub: components.#SDNPublisher & {
    Topic: "Ignored"
    Interface: "eno2"
    Address: "11.2.0.10:2000"
    NetworkByteOrder: 1
    Signals: {
      N_Reals: MARTe.#uint8
      N_Integer: MARTe.#uint8
      N_Acks: MARTe.#uint8
      N_States: MARTe.#uint8
      N_Alarms: MARTe.#uint8
      Spare_Bytes: MARTe.#uint8 & { NumberOfElements: 3 }
      Float_Rcv_Spare_0: MARTe.#float32
      Float_Rcv_Spare_1: MARTe.#float32
      GA_CCPS_IREF: MARTe.#float32
      GA_FHPS_Voltage: MARTe.#float32
      GA_FHPS_Current: MARTe.#float32
      GA_FHPS_IREF: MARTe.#float32
      GA_MCPS_Voltage: MARTe.#float32
      GA_MCPS_Current: MARTe.#float32
      GA_MCPS_IREF: MARTe.#float32
      GA_GCPS_Voltage: MARTe.#float32
      GA_GCPS_Current: MARTe.#float32
      GA_GCPS_IREF: MARTe.#float32
      Float_Spare_12: MARTe.#float32
      Float_Spare_13: MARTe.#float32
      GB_CCPS_IREF: MARTe.#float32
      GB_FHPS_Voltage: MARTe.#float32
      GB_FHPS_Current: MARTe.#float32
      GB_FHPS_IREF: MARTe.#float32
      GB_MCPS_Voltage: MARTe.#float32
      GB_MCPS_Current: MARTe.#float32
      GB_MCPS_IREF: MARTe.#float32
      GB_GCPS_Voltage: MARTe.#float32
      GB_GCPS_Current: MARTe.#float32
      GB_GCPS_IREF: MARTe.#float32
      ACK_GAB_FCT_ABORT_CMD: MARTe.#uint8
      ACK_GAB_FCT_LOAD_CMD: MARTe.#uint8
      ACK_GAB_FCT_STBY_WAITTRIG_ONLINE: MARTe.#uint8
      ACK_GAB_FCT_START_POWER_CMD: MARTe.#uint8
      ACK_GAB_FCT_STOP_POWER_CMD: MARTe.#uint8
      ACK_GAB_FCT_SUSPEND_RESUME_CMD: MARTe.#uint8
      ACK_GAB_FCT_SEGREGATION_CMD: MARTe.#uint8
      ACK_GA_CCPS_OPERATION_CMD: MARTe.#uint8
      ACK_GA_CCPS_CONFIG_SEQ_CMD: MARTe.#uint8
      ACK_GA_FHPS_RAMP_CMD: MARTe.#uint8
      ACK_GA_FHPS_CONFIG_SEQ_CMD: MARTe.#uint8
      ACK_GA_MCPS_RAMP_CMD: MARTe.#uint8
      ACK_GA_MCPS_CONFIG_CMD: MARTe.#uint8
      ACK_GA_MCPS_HOLD_CMD: MARTe.#uint8
      ACK_GA_GCPS_RAMP_CMD: MARTe.#uint8
      ACK_GA_GCPS_CONFIG_CMD: MARTe.#uint8
      ACK_GA_GCPS_HOLD_CMD: MARTe.#uint8
      ACK_GB_CCPS_OPERATION_CMD: MARTe.#uint8
      ACK_GB_CCPS_CONFIG_SEQ_CMD: MARTe.#uint8
      ACK_GB_FHPS_RAMP_CMD: MARTe.#uint8
      ACK_GB_FHPS_CONFIG_SEQ_CMD: MARTe.#uint8
      ACK_GB_MCPS_RAMP_CMD: MARTe.#uint8
      ACK_GB_MCPS_CONFIG_CMD: MARTe.#uint8
      ACK_GB_MCPS_HOLD_CMD: MARTe.#uint8
      ACK_GB_GCPS_RAMP_CMD: MARTe.#uint8
      ACK_GB_GCPS_CONFIG_CMD: MARTe.#uint8
      ACK_GB_GCPS_HOLD_CMD: MARTe.#uint8
      GAB_FCT_FC_OP_STATE: MARTe.#uint8
      GAB_FCT_FC_RT_STATE: MARTe.#uint8
      GAB_FCT_FC_SEG_STATE: MARTe.#uint8
      GAB_FCT_FC_LOAD_CFG_DONE: MARTe.#uint8
      GA_CCPS_IN_OPERATION: MARTe.#uint8
      GA_CCPS_CONFIG_SEQ_STAT: MARTe.#uint8
      GA_CCPS_STAT_UPDATED: MARTe.#uint8
      GA_FHPS_RAMP_DONE: MARTe.#uint8
      GA_FHPS_CONFIG_SEQ_STAT: MARTe.#uint8
      GA_FHPS_STAT_UPDATED: MARTe.#uint8
      GA_MCPS_RAMP_DONE: MARTe.#uint8
      GA_MCPS_CONFIG_STAT: MARTe.#uint8
      GA_MCPS_STAT_UPDATED: MARTe.#uint8
      GA_MCPS_ERROR_STAT: MARTe.#uint8
      GA_MCPS_STAT: MARTe.#uint8
      GA_GCPS_RAMP_DONE: MARTe.#uint8
      GA_GCPS_CONFIG_STAT: MARTe.#uint8
      GA_GCPS_STAT_UPDATED: MARTe.#uint8
      GA_GCPS_ERROR_STAT: MARTe.#uint8
      GA_GCPS_STAT: MARTe.#uint8
      GB_CCPS_IN_OPERATION: MARTe.#uint8
      GB_CCPS_CONFIG_SEQ_STAT: MARTe.#uint8
      GB_CCPS_STAT_UPDATED: MARTe.#uint8
      GB_FHPS_RAMP_DONE: MARTe.#uint8
      GB_FHPS_CONFIG_SEQ_STAT: MARTe.#uint8
      GB_FHPS_STAT_UPDATED: MARTe.#uint8
      GB_MCPS_RAMP_DONE: MARTe.#uint8
      GB_MCPS_CONFIG_STAT: MARTe.#uint8
      GB_MCPS_STAT_UPDATED: MARTe.#uint8
      GB_MCPS_ERROR_STAT: MARTe.#uint8
      GB_MCPS_STAT: MARTe.#uint8
      GB_GCPS_RAMP_DONE: MARTe.#uint8
      GB_GCPS_CONFIG_STAT: MARTe.#uint8
      GB_GCPS_STAT_UPDATED: MARTe.#uint8
      GB_GCPS_ERROR_STAT: MARTe.#uint8
      GB_GCPS_STAT: MARTe.#uint8
      ByteGroup0: MARTe.#uint8
      ByteGroup1: MARTe.#uint8
      ByteGroup2: MARTe.#uint8
    }
  }
  PLCSDNPubBits: MARTe.#GAMDataSource & {
    AllowNoProducers: 1
    Signals: {
      GAB_FCT_Fast_Controller_Alarm: MARTe.#uint8
      Alarm_Rcv_Spare_1: MARTe.#uint8
      Alarm_Rcv_Spare_2: MARTe.#uint8
      Alarm_Rcv_Spare_3: MARTe.#uint8
      Alarm_Rcv_Spare_4: MARTe.#uint8
      Alarm_Rcv_Spare_5: MARTe.#uint8
      Alarm_Rcv_Spare_6: MARTe.#uint8
      Alarm_Rcv_Spare_7: MARTe.#uint8
      GA_CCPS_Alarm: MARTe.#uint8
      GA_FHPS_Alarm: MARTe.#uint8
      GA_MCPS_Alarm: MARTe.#uint8
      GA_GCPS_Alarm: MARTe.#uint8
      GA_CCPS_Current_Alarm: MARTe.#uint8
      Alarm_Rcv_Spare_13: MARTe.#uint8
      Alarm_Rcv_Spare_14: MARTe.#uint8
      Alarm_Rcv_Spare_15: MARTe.#uint8
      GB_CCPS_Alarm: MARTe.#uint8
      GB_FHPS_Alarm: MARTe.#uint8
      GB_MCPS_Alarm: MARTe.#uint8
      GB_GCPS_Alarm: MARTe.#uint8
      GB_CCPS_Current_Alarm: MARTe.#uint8
      Alarm_Rcv_Spare_21: MARTe.#uint8
      Alarm_Rcv_Spare_22: MARTe.#uint8
      Alarm_Rcv_Spare_23: MARTe.#uint8
    }
  }
}
RTApp: Functions: {
  PLCSDNPubCompactBitGAM: extensions.#CompactBitGAM & {
    InputSignals: {
      GAB_FCT_Fast_Controller_Alarm: #signal: RTApp.Data.PLCSDNPubBits.#.GAB_FCT_Fast_Controller_Alarm
      Alarm_Rcv_Spare_1: #signal: RTApp.Data.PLCSDNPubBits.#.Alarm_Rcv_Spare_1
      Alarm_Rcv_Spare_2: #signal: RTApp.Data.PLCSDNPubBits.#.Alarm_Rcv_Spare_2
      Alarm_Rcv_Spare_3: #signal: RTApp.Data.PLCSDNPubBits.#.Alarm_Rcv_Spare_3
      Alarm_Rcv_Spare_4: #signal: RTApp.Data.PLCSDNPubBits.#.Alarm_Rcv_Spare_4
      Alarm_Rcv_Spare_5: #signal: RTApp.Data.PLCSDNPubBits.#.Alarm_Rcv_Spare_5
      Alarm_Rcv_Spare_6: #signal: RTApp.Data.PLCSDNPubBits.#.Alarm_Rcv_Spare_6
      Alarm_Rcv_Spare_7: #signal: RTApp.Data.PLCSDNPubBits.#.Alarm_Rcv_Spare_7
      GA_CCPS_Alarm: #signal: RTApp.Data.PLCSDNPubBits.#.GA_CCPS_Alarm
      GA_FHPS_Alarm: #signal: RTApp.Data.PLCSDNPubBits.#.GA_FHPS_Alarm
      GA_MCPS_Alarm: #signal: RTApp.Data.PLCSDNPubBits.#.GA_MCPS_Alarm
      GA_GCPS_Alarm: #signal: RTApp.Data.PLCSDNPubBits.#.GA_GCPS_Alarm
      GA_CCPS_Current_Alarm: #signal: RTApp.Data.PLCSDNPubBits.#.GA_CCPS_Current_Alarm
      Alarm_Rcv_Spare_13: #signal: RTApp.Data.PLCSDNPubBits.#.Alarm_Rcv_Spare_13
      Alarm_Rcv_Spare_14: #signal: RTApp.Data.PLCSDNPubBits.#.Alarm_Rcv_Spare_14
      Alarm_Rcv_Spare_15: #signal: RTApp.Data.PLCSDNPubBits.#.Alarm_Rcv_Spare_15
      GB_CCPS_Alarm: #signal: RTApp.Data.PLCSDNPubBits.#.GB_CCPS_Alarm
      GB_FHPS_Alarm: #signal: RTApp.Data.PLCSDNPubBits.#.GB_FHPS_Alarm
      GB_MCPS_Alarm: #signal: RTApp.Data.PLCSDNPubBits.#.GB_MCPS_Alarm
      GB_GCPS_Alarm: #signal: RTApp.Data.PLCSDNPubBits.#.GB_GCPS_Alarm
      GB_CCPS_Current_Alarm: #signal: RTApp.Data.PLCSDNPubBits.#.GB_CCPS_Current_Alarm
      Alarm_Rcv_Spare_21: #signal: RTApp.Data.PLCSDNPubBits.#.Alarm_Rcv_Spare_21
      Alarm_Rcv_Spare_22: #signal: RTApp.Data.PLCSDNPubBits.#.Alarm_Rcv_Spare_22
      Alarm_Rcv_Spare_23: #signal: RTApp.Data.PLCSDNPubBits.#.Alarm_Rcv_Spare_23
    }
    OutputSignals: {
      ByteGroup0: #signal: RTApp.Data.PLCSDNPub.#.ByteGroup0
      ByteGroup1: #signal: RTApp.Data.PLCSDNPub.#.ByteGroup1
      ByteGroup2: #signal: RTApp.Data.PLCSDNPub.#.ByteGroup2
    }
  }
  PLCSDNPubConstantGAM: components.#ConstantGAM & {
    OutputSignals: {
      N_Reals: {
        #signal: RTApp.Data.PLCSDNPub.#.N_Reals
        Default: 24
      }
      N_Integer: {
        #signal: RTApp.Data.PLCSDNPub.#.N_Integer
        Default: 0
      }
      N_Acks: {
        #signal: RTApp.Data.PLCSDNPub.#.N_Acks
        Default: 27
      }
      N_States: {
        #signal: RTApp.Data.PLCSDNPub.#.N_States
        Default: 36
      }
      N_Alarms: {
        #signal: RTApp.Data.PLCSDNPub.#.N_Alarms
        Default: 24
      }
    }
  }
}
