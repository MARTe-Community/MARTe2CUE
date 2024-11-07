package components

import "marte.org/MARTe"

#UDPSender: MARTe.#DataSource & {
	Class:         "UDP::UDPSender"
	Address:       #IPADDR
	Port:          int
	ExecutionMode: *"IndependentThread" | "RealTimeThread"
	if ExecutionMode == "IndependentThread" {
		NumberOfPreTriggers:  number
		NumberOfPostTriggers: number
		CPUMask?:             int
		StackSize?:           int
	}
	Signals: {
		if ExecutionMode == "IndependentThread" {
			Trigger: MARTe.#uint8
		}
		[_]: MARTe.#Signal & {
			#direction: "OUT"
		}
		...
	}
}

#UDPReceiver: MARTe.#DataSource & {
	Class:         "UDP::UDPReceiver"
	Address?:      #IPADDR
	Port:          int
	Timeout?:      number
	ExecutionMode: *"RealTimeThread" | "IndependentThread"
	if ExecutionMode == "IndependentThread" {
		CPUMask?:   int
		StackSize?: int
	}
	Signals: {
		[_]: MARTe.#Signal & {
			#direction: "IN"
		}
	}
}
