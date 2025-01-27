package MARTe

#BaseType: "void" | "bool" | "uint1" | "uint8" | "uint16" | "uint32" | "uint64" | "int8" | "int16" | "int32" | "int64" | "float32" | "float64" | "char8" | "string"

#ID: {
	#obj: {#id: string}
	#obj.#id
}

#LoggerService: {
	Class:             "LoggerService"
	CPUs?:             uint
	StackSize?:        uint
	NumberOfLogPages?: uint
	...
}

#IntrospectionStructure: {
	#id:   string
	Class: "IntrospectionStructure"
	[!~"^Class|[$#_].*$"]: {
		Type:              #BaseType
		NumberOfElements?: uint32 & >0
	}
}

#Type: #BaseType | #IntrospectionStructure

#Any: bool | string | bytes | number | [...] | {...}

#Message: {
	#id:         string
	Class:       "Message"
	Destination: string
	Mode:        *"ExpectsReply" | "NoReply"
	Function:    string
	Parameters?: {
		Class: "ConfigurationDatabase"
		...
	}
	if Function != _|_ {
		if Function == "PrepareNextState" {
			Mode: "ExpectsReply"
			Parameters: {
				#state?: #RealTimeState
				param1:  string
				if #state != _|_ {
					param1: #state.#id
				}
			}
		}
		if Function == "SetOutput" {
			Mode: "ExpectsReply"
			Parameters: {
				SignalName:  string
				SignalValue: string | number
			}
		}
	}
	...
}

#Message: {
	#event?: #StateMachineEvent
	if #event != _|_ {
		Mode:        "ExpectsReply"
		Destination: #event.#smid
		Function:    #event.#id
	}
}

#RealTimeThread: {
	#id:   string
	Class: "RealTimeThread"
	CPUs:  uint32
	Functions: [...string]
	#functions?: [...#GAM]
	if #functions != _|_ {
		Functions: [for x in #functions {x.#id}]
	}
}

#RealTimeState: {
	#id:   string
	Class: "RealTimeState"
	Threads: {
		Class: "ReferenceContainer"
		[name=!~"^Class$"]: #RealTimeThread & {
			#id: name
		}
	}
}

#GAMSchedulerI: {
	Class:            string
	#source:          #TimingDataSource
	TimingDataSource: #source.#id
	...
}

#GAMScheduler: #GAMSchedulerI & {
	Class:         "GAMScheduler"
	ErrorMessage?: #Message
}

#StateMachineEvent: {
	Class:          "StateMachineEvent"
	#id:            string
	#sid:           string
	#smid:          string
	NextState:      string
	NextStateError: string
	Timeout?:       uint32
	[MsgName= !~"^(Class|NextState|Timeout|NextStateError|[#_$].+)$"]: #Message & {
		#id: MsgName
	}
}

#State: {
	Class: "ReferenceContainer"
	#id:   string
	#smid: string
	let SID = #id
	let SMID = #smid
	[Name= !~"^([$].*|Class)$"]: #StateMachineEvent & {
		#id:   Name
		#sid:  SID
		#smid: SMID
	}
}

#StateMachine: {
	Class: "StateMachine"
	#id:   string
	let SMID = #id
	[ID= !~"^(Class|[$].*)$"]: #State & {
		#id:   ID
		#smid: SMID
	}
}

#Data: {
	Class:             "ReferenceContainer"
	#default?:         #DataSource
	DefaultDataSource: string
	if #default != _|_ {
		DefaultDataSource: #default.#id
	}
	[ID= !~"^(DefaultDataSource|Class|[#$_].*)$"]: #DataSource & {
		#id: ID
	}
}

#Functions: {
	#parent: string
	Class:   "ReferenceContainer"
	[ID= !~"^Class$"]: #GAM & {
		#id:    ID
		#appid: #parent
	}
}

#States: {
	Class: "ReferenceContainer"
	[ID=!~"^Class$"]: #RealTimeState & {
		#id: ID
	}
}

#RealTimeApplication: {
	#id:   string
	Class: "RealTimeApplication"
	Data:  #Data
	Functions: #Functions & {
		#parent: #id
		[_= !~"^Class$"]: {
			#appid: #id
		}
	}
	States:    #States
	Scheduler: #GAMSchedulerI | *#GAMScheduler
}

[name= !~"^[$_#].*$"]: {
	#id:   name
	Class: string
	...
}
