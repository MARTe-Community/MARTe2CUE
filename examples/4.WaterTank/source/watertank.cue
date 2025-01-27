package watertank

import (
	"marte.org/MARTe"
	"marte.org/MARTe/components"
)

// Base configuration
// ------------------

RTApp: MARTe.#RealTimeApplication & {
	Data: {
		#default: DDB0
		DDB0: MARTe.#GAMDataSource & {
			Signals: CurrentLevel: MARTe.#float64
		}
		FileReader: components.#FileReader & {
			FileName: "water_tank.csv"
			Signals: Level: MARTe.#float64
		}
		Timings: MARTe.#TimingDataSource
	}
	Scheduler: MARTe.#GAMScheduler & {
		#source: Data.Timings
	}
}

let DBs = RTApp.Data

let Fns = RTApp.Functions

// Read the file to DB 
// -------------------

RTApp: Functions: FileIn: components.#IOGAM & {
	InputSignals: Level: #signal:         DBs.FileReader.#.Level
	OutputSignals: CurrentLevel: #signal: DBs.DDB0.#.CurrentLevel
}

// Convert to UINT8
// ----------------

RTApp: Data: DDB0: Signals: ConvertedLevel: MARTe.#uint8
RTApp: Functions: Convert: components.#ConversionGAM & {
	InputSignals: CurrentValue: #signal:    DBs.DDB0.#.CurrentLevel
	OutputSignals: ConvertedValue: #signal: DBs.DDB0.#.ConvertedLevel
}

// Compute State of actuators
// --------------------------

// Define required signals
RTApp: Data: DDB0: Signals: ValveOn: MARTe.#uint8
RTApp: Data: DDB0: Signals: PumpOn:  MARTe.#uint8
// Define expresions
let valve_exp = "ValveOn = CurrentValue > (uint8)40;"
let pump_exp = "PumpOn = CurrentValue < (uint8)40;"

// Expression GAM
RTApp: Functions: Eval: components.#MathExpressionGAM & {
	Expression: valve_exp + pump_exp
	InputSignals: CurrentValue: #signal: DBs.DDB0.#.ConvertedLevel
	OutputSignals: {
		ValveOn: #datasource: DBs.DDB0
		PumpOn: #datasource:  DBs.DDB0
	}
}

// Log values
// ----------

RTApp: Data: Logger: components.#LoggerDataSource & {
	Signals: {
		ValveOn: MARTe.#uint8
		PumpOn:  MARTe.#uint8
	}
}
RTApp: Functions: ToLog: components.#IOGAM & {
	InputSignals: {
		ValveOn: #datasource: DBs.DDB0
		PumpOn: #datasource:  DBs.DDB0
	}
	OutputSignals: {
		ValveOn: #datasource: DBs.Logger
		PumpOn: #datasource:  DBs.Logger
	}
}

// Timer execution
// ---------------

RTApp: Data: DDB0: Signals: Time: MARTe.#uint32
RTApp: Data: Timer: components.#LinuxTimer & {
	Signals: Time: MARTe.#uint32
}
RTApp: Functions: Timer: components.#IOGAM & {
	InputSignals: Time: {
		#datasource: DBs.Timer
		Frequency:   1
	}
	OutputSignals: Time: #datasource: DBs.DDB0
}

// States and Threads
// ------------------
RTApp: States: Running: Threads: Thread0: {
	CPUs: 0x1
	#functions: [
		Fns.Timer,
		Fns.FileIn,
		Fns.Convert,
		Fns.Eval,
		Fns.ToLog,
	]
}
