package example

import (
	"marte.org/MARTe/components"
)

let #Data = RTApp.Data

RTApp: Functions: {
	LoadStateGAM: components.#ConstantGAM & {
		OutputSignals: Done: {
			#signal: #Data.DDB1.#.LOAD_DONE
			Default: 0
		}
	}

	PublishSigGAM: components.#IOGAM & {
		InputSignals: Done: #signal:  #Data.DDB1.#.LOAD_DONE
		OutputSignals: Done: #signal: #Data.PLCSDNPub.#.GAB_FCT_FC_LOAD_CFG_DONE
	}

	LoadSimGAM: components.#MessageGAM & {
		TriggerOnChange: 1
		Events: {
			StartLoading: {
				EventTrigger: CommandLoad: 1
				SetDDBLoadDone: {
					Function:    "SetOutput"
					Destination: "RTApp.Functions.LoadStateGAM"
					Mode:        "ExpectsReply"
					Parameters: {
						SignalName:  "Done"
						SignalValue: 1
					}
				}
			}
			ResetLoading: {
				EventTrigger: CommandLoad: 3
				SetDDBLoadDone: {
					Function:    "SetOutput"
					Destination: "RTApp.Functions.LoadStateGAM"
					Mode:        "ExpectsReply"
					Parameters: {
						SignalName:  "Done"
						SignalValue: 0
					}
				}
			}
		}
		InputSignals: CommandLoad: #signal:      #Data.PLCSDNSub.#.GAB_FCT_LOAD_CMD
		OutputSignals: PendingMessages: #signal: #Data.DDB1.#.PendingMessages
	}
}
