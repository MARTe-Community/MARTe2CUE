package simple_app

import (
	"marte.org/MARTe"
	"marte.org/MARTe/components"
)

App: MARTe.#RealTimeApplication & {
	Data: {
		#default: DDB1
		DDB1: MARTe.#GAMDataSource & {
			Signals: {
				Time: MARTe.#uint32
				SignalA: Type: "uint32" // also valid
				SignalB: MARTe.#uint8 & {
					// for arrays you can use the base type and specify the size (or any other information) 
					NumberOfElements: 4
				}
			}
		}
		TimingDB: MARTe.#TimingDataSource
		Timer: components.#LinuxTimer & {
			SleepNature: "Default"
			Signals: Time: MARTe.#uint32
		}
	}
	Functions: {
		IO: components.#IOGAM & {
			InputSignals: {
				Time: {
					#datasource: Data.Timer // this will autofill the informations by retriving the singal from the ds
					Frequency:   25
				}
				Signal: #signal: Data.DDB1.Signals.SignalB // This will autofill the information directly using the signal
			}
			OutputSignals: {
				Time: #signal: Data.DDB1.#.Time // the .#. is a copy of the `Signals` field of the datastructure
				SignalA: {// is still possible to fill all information manually
					DataSource: "DDB1"
					Type:       "uint32"
				}
			}
		}
	}
	States: {
		Exec: Threads: SingleThread: {
			CPUs: 0x1
			#functions: [Functions.IO] // will create the `Functions` list automatically
		}
		Other: Threads: SingleThread: {
			CPUs: 0x2
			Functions: [App.Functions.IO.#id] // the #id field contain the name of the objcet (`IO`) in this case
		}
	}
	Scheduler: MARTe.#GAMScheduler & {
		#source: Data.TimingDB
	}
}
