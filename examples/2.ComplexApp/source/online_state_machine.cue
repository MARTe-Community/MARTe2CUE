package example

import (
	"marte.org/MARTe/components"
)

let #Data = RTApp.Data

RTApp: Functions: {
	RTSMSimulator: components.#MessageGAM & {
		TriggerOnChange: 0
		Events: {
			Online: {
				EventTrigger: {
					OSMState:      0xFF
					RTSMState:     0x1E
					CommandOnline: 1
				}
				MoveSM: {
					Function:    "SetOutput"
					Destination: "RTApp.Functions.RTOutGAM"
					Mode:        "ExpectsReply"
					Parameters: {
						SignalName:  "RTSMState"
						SignalValue: 0x5A
					}
				}
			}
			PowerOn: {
				EventTrigger: {
					OSMState:    0xFF
					RTSMState:   0x5A
					CommandTrig: 1
				}
				MoveSM: {
					Function:    "SetOutput"
					Destination: "RTApp.Functions.RTOutGAM"
					Mode:        "ExpectsReply"
					Parameters: {
						SignalName:  "RTSMState"
						SignalValue: 0xA5
					}
				}
			}
			Suspend: {
				EventTrigger: {
					OSMState:       0xFF
					RTSMState:      0xA5
					CommandSuspend: 0xAA
				}
				MoveSM: {
					Function:    "SetOutput"
					Destination: "RTApp.Functions.RTOutGAM"
					Mode:        "ExpectsReply"
					Parameters: {
						SignalName:  "RTSMState"
						SignalValue: 0x96
					}
				}
			}
			Resume: {
				EventTrigger: {
					OSMState:       0xFF
					RTSMState:      0x96
					CommandSuspend: 0x77
				}
				MoveSM: {
					Function:    "SetOutput"
					Destination: "RTApp.Functions.RTOutGAM"
					Mode:        "ExpectsReply"
					Parameters: {
						SignalName:  "RTSMState"
						SignalValue: 0xA5
					}
				}
			}
			End_0: {
				EventTrigger: {
					OSMState:      0xFF
					RTSMState:     0x96
					CommandOnline: 0
				}
				MoveSM: {
					Function:    "SetOutput"
					Destination: "RTApp.Functions.RTOutGAM"
					Mode:        "ExpectsReply"
					Parameters: {
						SignalName:  "RTSMState"
						SignalValue: 0x87
					}
				}
			}
			End_1: {
				EventTrigger: {
					OSMState:      0xFF
					RTSMState:     0xA5
					CommandOnline: 0
				}
				MoveSM: {
					Function:    "SetOutput"
					Destination: "RTApp.Functions.RTOutGAM"
					Mode:        "ExpectsReply"
					Parameters: {
						SignalName:  "RTSMState"
						SignalValue: 0x87
					}
				}
			}
		}
		InputSignals: {
			OSMState: #datasource:   #Data.DDB1
			RTSMState: #datasource:  #Data.DDB1
			CommandSuspend: #signal: #Data.PLCSDNSub.#.GAB_FCT_STBY_WAITTRIG_ONLINE
			CommandOnline: #signal:  #Data.EpicsIn.#.OnlineSignal
			CommandTrig: #signal:    #Data.EpicsIn.#.TrigSignal
		}
		OutputSignals: {
			PendingSuspend: #datasource: #Data.DDB1
			PendingOnline: #datasource:  #Data.DDB1
			PendingTrig: #datasource:    #Data.DDB1
		}
	}
	RTOutGAM: components.#ConstantGAM & {
		OutputSignals: RTSMState: {
			#datasource: #Data.DDB1
			Default:     0x1E
		}
	}
}
