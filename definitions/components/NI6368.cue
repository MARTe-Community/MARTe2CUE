package components

import "marte.org/MARTe"

#NI6368ADC: MARTe.#DataSource & {
	Class:                       "NI6368::NI6368ADC"
	DeviceName:                  string
	BoardId:                     uint32
	ExecutionMode:               *"IndependentThread" | "RealTimeThread"
	DMABufferSize:               uint32
	ClockSampleSource:           string & =~"^(INTERNALTIMING|PFI([0-9]|1[0-5])|RTSI[0-6]|DIO_CHGDETECT|STAR_TRIGGER|SCXI_TRIG1|LOW|PXIE_DSTAR[AB]|G[0-3]_(SAMPLECLK|OUT)|DI_CONVERT|[AD]O_UPDATE|INTTRIGGERA[0-7])$"
	ClockSamplePolarity:         "ACTIVE_HIGH_OR_RISING_EDGE" | "ACTIVE_LOW_OR_FALLING_EDGE"
	ScanIntervalCounterSource:   string & =~"^(UI_TC|PFI([0-9]|1[0-5])|RTSI([0-9]|1[0-7])|GPCRT0_OUT|STAR_TRIGGER|GPCTR1_OUT|ANALOG_TRIGGER|LOW)$"
	ScanIntervalCounterPolarity: "RISING_EDGE" | "FALLING_EDGE"
	ScanIntervalCounterPeriod:   uint32
	ScanIntervalCounterDelay:    uint32
	if ExecutionMode == "IndependentThread" {
		CPUs?:        uint32
		RealTimeMode: 0 | 1
	}
	Signals: {
		Counter: {
			Type: "uint32"
		}
		Time: {
			Type: "uint32"
		}
		[!~"Time|Counter"]: {
			InputRange?: 1 | 2 | 5 | 10
			Type:        "uint16"
			ChannelId:   uint32
		}
	}
}

#NI6368DAC: MARTe.#DataSource & {
	Class:                         "NI6368::NI6368DAC"
	DeviceName:                    string
	BoardId:                       uint32
	StartTriggerSource:            string & =~"^(SW_PULSE|PFI([0-9]|1[0-5])|RTSI[0-7]|AI_START[12]|STAR_TRIGGER|PXIE_DSTAR[AB]|ANALOG_TRIGGER|LOW|G[0-3]_OUT|DIO_CHGDETECT|DI_START[12]|DO_START1|INTTRIGGERA[0-7]|FIFOCONDITION)$"
	UpdateCounterSource:           string & =~"^(UI_TC|PFI([0-9]|1[0-5])|RTSI[0-7]|G[0-3]_(OUT|SAMPLECLK)|STAR_TRIGGER|GPCTR1_OUT|ANALOG_TRIGGER|LOW|ANALOG_TRIGGER|LOW|PXIE_DSTAR[AB]|DIO_CHGDETECT|[AD]I_CONVERT|AI_START|DO_UPDATE|INTTRIGGERA[0-7]|AUTOUPDATE)$"
	UpdateCounterPolarity:         "RISING_EDGE" | "FALLING_EDGE"
	UpdateIntervalCounterSource:   string & =~"^(TB[13]|PFI([0-9]|1[0-5])|RTSI[0-7]|DSTAR[AB]|PXI_CLK10|ANALOG_TRIGGER|STAR_TRIGGER)$"
	UpdateIntervalCounterPolarity: "RISING_EDGE" | "FALLING_EDGE"
	UpdateIntervalCounterDivisor:  uint32 & >0
	UpdateIntervalCounterDelay:    uint32 & >0
	Signals: {
		[_]: {
			Type:        "float32"
			ChannelId:   uint32
			OutputRange: 10 | 5 | "APFI0" | "APFI1"
		}
	}
}

#NI6368DIO: MARTe.#DataSource & {
	Class:                         "NI6368::NI6368DIO"
	DeviceName:                    string
	BoardId:                       uint32
	ClockSampleSource:             string & =~"^(INTERNAL|PFI([0-9]|1[0-5])|RTSI[0-6]|DIO_CHGDETECT|STAR_TRIGGER|LOW|PXIE_DSTAR[AB]|G[0-3]_(SAMPLECLK|OUT)|ATRIG|AI_CONVERT|[AD]O_UPDATE|INTTRIGGERA[0-7])$"
	ClockSamplePolarity:           "ACTIVE_HIGH_OR_RISING_EDGE" | "ACTIVE_LOW_OR_FALLING_EDGE"
	ClockConvertSource:            string & =~"^(INTERNAL|PFI([0-9]|1[0-5])|RTSI[0-6]|DIO_CHGDETECT|STAR_TRIGGER|LOW|PXIE_DSTAR[AB]|G[0-3]_(SAMPLECLK|OUT)|ATRIG|AI_CONVERT|[AD]O_UPDATE|INTTRIGGERA[0-7])$"
	ScanIntervalCounterSource:     string & =~"^(COUNTER_TB[123]|PFI([0-9]|1[0-5])|RTSI[0-6]|PXI_CLK0|STAR_TRIGGER|ANALOG_TRIGGER|D_STAR[AB])$"
	ScanIntervalCounterPeriod:     uint32
	ScanIntervalCounterDelay:      uint32
	StartTriggerSource:            string & =~"^(SW_PULSE|PFI([0-9]|1[0-5])|RTSI[0-7]|AI_START[12]|STAR_TRIGGER|PXIE_DSTAR[AB]|ANALOG_TRIGGER|LOW|G[0-3]_OUT|DIO_CHGDETECT|DI_START[12]|INTTRIGGERA[0-7]|FIFOCONDITION)$"
	UpdateCounterSource:           string & =~"^(UI_TC|PFI([0-9]|1[0-5])|RTSI[0-7]|G[0-3]_(OUT|SAMPLECLK)|STAR_TRIGGER|GPCTR1_OUT|ANALOG_TRIGGER|LOW|ANALOG_TRIGGER|LOW|PXIE_DSTAR[AB]|DIO_CHGDETECT|[AD]I_CONVERT|AI_START|DO_UPDATE|INTTRIGGERA[0-7]|AUTOUPDATE)$"
	UpdateCounterPolarity:         "RISING_EDGE" | "FALLING_EDGE"
	UpdateIntervalCounterSource:   string & =~"^(TB[13]|PFI([0-9]|1[0-5])|RTSI[0-7]|DSTAR[AB]|PXI_CLK10|ANALOG_TRIGGER|STAR_TRIGGER)$"
	UpdateIntervalCounterPolarity: "RISING_EDGE" | "FALLING_EDGE"
	UpdateIntervalCounterDivisor:  uint32 & >0
	UpdateIntervalCounterDelay:    uint32 & >0
	Signals: {
		[_]: {
			Type:           "uint32"
			InputPortMask:  uint32
			OutputPortMask: uint32
		}
	}
}
