package example

import (
	"marte.org/MARTe"
	"marte.org/MARTe/components"
)

#States: {
	names: [
		"Standby",
		"WaitTrigger",
		"Online",
		"Alarm",
	]
	ids: {
		Standby:     0x1E
		WaitTrigger: 0x69
		Online:      0x5A
		Alarm:       0x4B
	}
}

#CommonMessage: MARTe.#Message & {
	Destination: "RTApp"
	Mode:        "ExpectsReply"
}

#PrepareNextMessage: #CommonMessage & {
	Function: "PrepareNextState"
}

#StopCurrentMessage: #CommonMessage & {
	Function: "StopCurrentStateExecution"
}

#StartNextMessage: #CommonMessage & {
	Function: "StartNextStateExecution"
}

#SetState: MARTe.#Message & {
	Function:    "SetOutput"
	Destination: "RTApp.Functions.StateConstantGAM"
	Mode:        "ExpectsReply"
	Parameters: {
		SignalName: "OSMState"
	}
}

#GoTo: MARTe.#StateMachineEvent & {
	#target:        string
	NextStateError: "Alarm"
	NextState:      #target
	"ChangeTo\(#target)": #PrepareNextMessage & {
		Parameters: #state: RTApp.States[#target]
	}
	StopCurrentState: #StopCurrentMessage
	StartNextState:   #StartNextMessage
	SetStateID: #SetState & {
		Parameters: SignalValue: #States.ids[#target]
	}
}

OperationalStateMachine: MARTe.#StateMachine & {
	Start: GoToStandby: #GoTo & {#target: "Standby"}
	Standby: {
		GoToWaitTrigger: #GoTo & {#target: "WaitTrigger"}
		GoToAlarm: #GoTo & {#target: "Alarm"}
	}
	WaitTrigger: {
		GoToOnline: #GoTo & {#target: "Online"}
		GoToStandby: #GoTo & {#target: "Standby"}
		GoToAlarm: #GoTo & {#target: "Alarm"}
	}
	Online: {
		GoToWaitTrigger: #GoTo & {#target: "WaitTrigger"}
		GoToStandby: #GoTo & {#target: "Standby"}
		GoToAlarm: #GoTo & {#target: "Alarm"}
	}
	Alarm: {
		GoToStandby: #GoTo & {#target: "Standby"}
		GoToAlarm: #GoTo & {#target: "Alarm"}
	}
}

RTApp: Functions: StateConstantGAM: components.#ConstantGAM & {
	OutputSignals: OSMState: {
		#datasource: RTApp.Data.DDB1
		Default:     0x1E
	}
}
