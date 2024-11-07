package components

import "marte.org/MARTe"

#DoubleHandshakeMasterGAM: MARTe.#GAM & {
	Class: "DoubleHandshakeGAM::DoubleHandshakeMasterGAM"
	InputsSignals: close({
		[=~"^CommandIn[0-9]*$"]: {}
		[=~"^AckIn[0-9]*$"]: {
			Trigger: 0 | 1
		}
		[=~"^ClearIn[0-9]*$"]: {
			Type: "uint32"
		}
	})
	OutputSignals: close({
		[=~"^CommandOut[0-9]*$"]: {
			Type: "uint32"
		}
		[=~"^InternalState[0-9]*$"]: {
			Type: "uint32"
		}
	})
}

#DoubleHandshakeSlaveGAM: MARTe.#GAM & {
	Class: "DoubleHandshakeGAM::DoubleHandshakeSlaveGAM"
	InputsSignals: close({
		[=~"^CommandIn[0-9]*$"]: {}
		[=~"^ClearIn[0-9]*$"]: {
			Type: "uint32"
		}
	})
	OutputSignals: close({
		[=~"^AckOut[0-9]*$"]: {
			Trigger: 0 | 1
		}
		[=~"^InternalState[0-9]*$"]: {
			Type: "uint32"
		}
	})
}
