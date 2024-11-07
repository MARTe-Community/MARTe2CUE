package components

import "marte.org/MARTe"

#NI6259ADC: MARTe.#DataSource & {
	Class:                "NI6259::NI6259ADC"
	SamplingFrequency:    uint32 & >0 & <=1000000
	DeviceName:           string
	BoardId:              uint32
	DelayDivisor:         uint32
	ClockSampleSource:    string & =~"^(SI2TC|PFI([0-9]|1[0-5])|RTSI([0-9]|1[0-7])|GPCRT0_OUT|STAR_TRIGGER|ANALOG_TRIGGER|LOW)$"
	ClockConvertPolarity: "RISING_EDGE" | "FALLING_EDGE"
	CPUs:                 uint32
	Signals: {
		Counter: {
			Type: "uint32"
		}
		Time: {
			Type: "uint32"
		}
		[!~"Time|Counter"]: {
			InputRange?:    0.1 | 0.2 | 0.5 | 1 | 2 | 5 | 10
			Type:           "float32"
			ChannelId:      uint32
			InputPolarity?: "Bipolar" | *"Unipolar"
			InputMode?:     *"RSE" | "NRSE"
		}
	}
}

#NI6259DAC: MARTe.#DataSource & {
	Class:               "NI6259::NI6259DAC"
	DeviceName:          string
	BoardId:             uint32
	ClockUpdateSource:   string & =~"^(UI_TC|PFI([0-9]|1[0-5])|RTSI([0-9]|1[0-7])|GPCRT0_OUT|STAR_TRIGGER|GPCTR1_OUT|ANALOG_TRIGGER|LOW)$"
	ClockUpdatePolarity: "RISING_EDGE" | "FALLING_EDGE"
	if ClockUpdateSource == "UI_TC" {
		ClockUpdateDivisor?: uint32 | *10
	}
	Signals: {
		[_]: {
			Type:            "float32"
			ChannelId:       uint32
			OutputPolarity?: "Bipolar" | *"Unipolar"
		}
	}
}

#NI6259DIO: MARTe.#DataSource & {
	Class:      "NI6259::NI6259DIO"
	DeviceName: string
	BoardId:    uint32
	Signals: {
		[_]: {
			Type:   "uint32"
			PortId: uint32
			Mask:   uint32
		}
	}
}
