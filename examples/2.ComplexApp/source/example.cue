package example

import ("marte.org/MARTe")

let #Data = RTApp.Data
let #GAMs = RTApp.Functions

let InputFunctions = [
	#GAMs.StateConstantGAM.#id,
	#GAMs.PLCSDNPubConstantGAM.#id,
	#GAMs.PLCHandshakeGAM.#id,
	#GAMs.PLCSDNSubExtractBitGAM.#id,
	#GAMs.SimulateGAM.#id,
]

let ConfigFunctions = [
	#GAMs.LoadStateGAM.#id,
	#GAMs.LoadSimGAM.#id,
]

let OnlineFunctions = [
	#GAMs.RTSMSimulator.#id,
	#GAMs.RTOutGAM.#id,
]

let OutputFunctions = [
	#GAMs.StatePubGAM.#id,
	#GAMs.PLCSDNPubCompactBitGAM.#id,
	#GAMs.PublishSigGAM.#id,
	#GAMs.UDPPubGAM.#id,
	#GAMs.LoggerGAM.#id,
]

RTApp: MARTe.#RealTimeApplication & {
	States: {
		Standby: Threads: CmdThread: {
			CPUs:      0x1
			Functions: InputFunctions + ConfigFunctions + OutputFunctions
		}
		WaitTrigger: Threads: CmdThread: {
			CPUs:      0x1
			Functions: InputFunctions + OutputFunctions
		}
		Online: Threads: CmdThread: {
			CPUs:      0x1
			Functions: InputFunctions + OnlineFunctions + OutputFunctions
		}
		Alarm: Threads: CmdThread: {
			CPUs:      0x1
			Functions: InputFunctions + OutputFunctions
		}
	}
	Scheduler: MARTe.#GAMScheduler & {
		#source: #Data.Timing
	}
}
