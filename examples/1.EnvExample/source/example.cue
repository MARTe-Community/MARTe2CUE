package example

import (
	"marte.org/MARTe"
	"marte.org/MARTe/components"
)

#Debug: bool @tag("debug", type=bool)

RTApp: MARTe.#RealTimeApplication & {
	Data: {
		#default: DDB1
		DDB1: MARTe.#GAMDataSource & {
			Signals: {
				Time: MARTe.#uint32
			}
		}
		TimingDB: MARTe.#TimingDataSource
		Timer: components.#LinuxTimer & {
			SleepNature: "Default"
			Signals: Time: MARTe.#uint32
		}
		SDNExample: components.#SDNSubscriber & {
			Topic:     "Ignored"
			Interface: string @tag("sdn_if")
			Address:   string @tag("sdn_addr")
			Signals: Example: MARTe.#float64
		}
		if #Debug {
			Logger: components.#LoggerDataSource & {
				Signals: {
					Time: MARTe.#uint32
				}
			}
		}
	}
	Functions: {
		IO: components.#IOGAM & {
			InputSignals: Time: {
				#datasource: Data.Timer // this will autofill the informations by retriving the singal from the ds
				Frequency:   25
			}
			OutputSignals: Time: #signal: Data.DDB1.#.Time // the .#. is a copy of the `Signals` field of the datastructure
		}
		if #Debug {
			LoggerIO: components.#IOGAM & {
				InputSignals: Time: #signal:  Data.Timer.#.Time
				OutputSignals: Time: #signal: Data.Logger.#.Time
			}
		}
	}
	States: {
		Exec: Threads: SingleThread: {
			CPUs: 0x2
			Functions: [
				RTApp.Functions.IO.#id,
				if #Debug {
					RTApp.Functions.LoggerIO.#id
				},
			]
		}
	}
	Scheduler: MARTe.#GAMScheduler & {
		#source: Data.TimingDB
	}
}
