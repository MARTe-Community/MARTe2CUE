package example

import (
	"marte.org/MARTe"
	"marte.org/MARTe/components"
)

let #Data = RTApp.Data

RTApp: Functions: {
	MessageGAM: components.#MessageGAM & {
		TriggerOnChange: 0
		Events: {
			GoToStandby: {
				EventTrigger: CommandGoToState: 0x22
				MoveSM: MARTe.#Message & {
					Function:    "GoToStandby"
					Destination: "OperationalStateMachine"
					Mode:        "ExpectsReply"
				}
				MoveRTSM: MARTe.#Message & {
					Function:    "SetOutput"
					Destination: "RTApp.Functions.RTOutGAM"
					Mode:        "ExpectsReply"
					Parameters: {
						SignalName:  "RTSMState"
						SignalValue: 0x1E
					}
				}
			}
			GoToWaitTrigger: {
				EventTrigger: CommandGoToState: 0x33
				MoveSM: {
					Function:    "GoToWaitTrigger"
					Destination: "OperationalStateMachine"
					Mode:        "ExpectsReply"
				}
				MoveRTSM: {
					Function:    "SetOutput"
					Destination: "RTApp.Functions.RTOutGAM"
					Mode:        "ExpectsReply"
					Parameters: {
						SignalName:  "RTSMState"
						SignalValue: 0x1E
					}
				}
			}
			GoToOnline: {
				EventTrigger: CommandGoToState: 0xFF
				MoveSM: {
					Function:    "GoToOnline"
					Destination: "OperationalStateMachine"
					Mode:        "ExpectsReply"
				}
				MoveRTSM: {
					Function:    "SetOutput"
					Destination: "RTApp.Functions.RTOutGAM"
					Mode:        "ExpectsReply"
					Parameters: {
						SignalName:  "RTSMState"
						SignalValue: 0x1E
					}
				}
			}
			GoToError: {
				EventTrigger: CommandTrip: 1
				MoveSM: {
					Function:    "GoToError"
					Destination: "OperationalStateMachine"
					Mode:        "ExpectsReply"
				}
				MoveRTSM: {
					Function:    "SetOutput"
					Destination: "RTApp.Functions.RTOutGAM"
					Mode:        "ExpectsReply"
					Parameters: {
						SignalName:  "RTSMState"
						SignalValue: 0x1E
					}
				}
			}
		}
		InputSignals: {
			CommandGoToState: #signal: #Data.PLCSDNSub.#.GAB_FCT_STBY_WAITTRIG_ONLINE
			CommandTrip: #signal:      #Data.PLCSDNSubBits.#.GAB_FCT_Fast_Controller_Trip
		}
		OutputSignals: {
			PendingGoToState: #signal: #Data.DDB1.#.PendingGoToState
			PendingTrip: #signal:      #Data.DDB1.#.PendingTrip
		}
	}

}
