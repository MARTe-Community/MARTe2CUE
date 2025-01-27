package timerlogger

import (
	"marte.org/MARTe"
	"marte.org/MARTe/components"
)

RTApp: MARTe.#RealTimeApplication & {
	Data: {
		#default: Logger
		Timings:  MARTe.#TimingDataSource
		Timer: components.#LinuxTimer & {
			CPUMask:     0x1
			SleepNature: "Busy"
			Signals: Time: MARTe.#uint32
		}
		Logger: components.#LoggerDataSource & {
			Signals: DTime: MARTe.#uint32
		}
	}
	Functions: {
		GAMDisplay: components.#IOGAM & {
			InputSignals: Time: {
				#datasource: Data.Timer
				Frequency:   500
			}
			OutputSignals: DTime: #datasource: Data.Logger
		}
	}
	States: {
		Running: Threads: Thread0: {
			CPUs: 0x1
			Functions: [RTApp.Functions.GAMDisplay.#id]
		}
	}
	Scheduler: MARTe.#GAMScheduler & {
		#source: Data.Timings
	}
}
