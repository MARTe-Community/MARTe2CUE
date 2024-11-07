package components

import "marte.org/MARTe"

#FileReader: MARTe.#DataSource & {
	Class:       "FileReader"
	FileName:    string
	Interpolate: "yes" | "no"
	FileFormat:  "binary" | "csv"
	if FileFormat == "csv" {
		CSVSeparator: string
	}
	if Interpolate == "yes" {
		XAxisSignal:         string
		InterpolationPeriod: uint32
	}
	EOF?:             "Rewind" | "Error" | "Last"
	MaxFileByteSize?: uint32
	Messages?: {
		Class: "ReferenceContainer"
		[MsgName= !~"Class|[$].+"]: MARTe.#Message & {
			#id: MsgName
		}
	}
}

#FileWriter: MARTe.#DataSource & {
	Class:           "FileWriter"
	NumberOfBuffers: uint32 & >0
	CPUMask:         uint32
	StackSize:       uint32 & >0
	Filename?:       string
	Overwrite:       "yes" | "no"
	FileFormat:      "binary" | "csv"
	if FileFormat == "csv" {
		CSVSeparator: ","
	}
	StoreOnTrigger: 0 | 1
	RefreshContent: 0 | 1
	if StoreOnTrigger == 1 {
		NumberOfPreTrigger:  uint32
		NumberOfPostTrigger: uint32
	}
	Signals: {
		if StoreOnTrigger {
			Trigger: {
				Type: "uint8"
			}

			[!~"Trigger"]: {
				Format?: string
			}
		}
		[_]: {
			Format?: string
		}
	}
	Messages?: {
		Class: "ReferenceContainer"
		FileOpenedOK?: MARTe.#Message & {
			Mode: "ExpectsReply"
		}
		FileOpenedFail?: MARTe.#Message & {
			Mode: "ExpectsReply"
		}
		FileClosed?: MARTe.#Message & {
			Mode: "ExpectsReply"
		}
		FileRuntimeError?: MARTe.#Message & {
			Mode: "ExpectsReply"
		}
	}
}
