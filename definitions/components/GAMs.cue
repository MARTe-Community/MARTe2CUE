package components

import "marte.org/MARTe"

#ConstantSignal: MARTe.#GAMSignal & {
	Default: MARTe.#Any
}

#ConstantGAM: MARTe.#GAM & {
	Class: "ConstantGAM"
	InputSignals: close({})
	OutputSignals: {
		[_]: #ConstantSignal
	}
	$CHECK: "len(this.InputSignals) == 0"
}

#ConversionGAM: MARTe.#GAM & {
	Class: "ConversionGAM"
	OutputSignals: {
		[_]: {Gain?: number}
	}
}

#CRCGAM: MARTe.#GAM & {
	Class:        "CRCGAM"
	Polynomial:   uint32
	InitialValue: uint32
	Inverted:     0 | 1
	OutputSignals: {
		[_]: {Type: "uint8" | "uint16" | "uint32"}
	}
}

#FilterGAM: MARTe.#GAM & {
	Class: "FilterGAM"
	Num: [...float]
	Den: [...float]
	ResetInEachState?: 0 | 1
}

#FlattenedStructIOGAM: MARTe.#GAM & {
	Class: "FlattenedStructIOGAM"
}
#TriggeredIOGAM: MARTe.#GAM & {
	Class: "TriggeredIOGAM"
	InputSignals: {
		Trigger: MARTe.#uint8
		...
	}
}

#IOGAM: MARTe.#GAM & {
	Class:  "IOGAM"
	$CHECK: "sum(sizeof(sig) for sig in this.InputSignals.values()) == sum(sizeof(sig) for sig in this.OutputSignals.values())"
}

#MessageGAM: MARTe.#GAM & {
	Class:           "MessageGAM"
	TriggerOnChange: 0 | *1
	Events: {
		Class: "ReferenceContainer"
		[!~"^Class$"]: {
			Class: "EventConditionTrigger"
			EventTrigger: {
				...
			}
			[id=!~"^(Class|EventTrigger)"]: MARTe.#Message & {
				#id: id
			}
		}
	}
	OutputSignals: {
		[_]: {Type: "uint32"}
	}
	$CHECK: "sum(1 for key in this.InputSignals.keys() if key.startswith('Command')) == len(this.OutputSignals)"
}

#MathExpressionGAM: MARTe.#GAM & {
	Class:      "MathExpressionGAM"
	Expression: string
}
