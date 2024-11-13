package community

import "marte.org/MARTe"

#JSONLogger: {
	Class:       "JSONLogger"
	LogPath:     string
	UniqueFile?: bool
	FlushDelay?: uint32 & >0
}

#OnChangeLoggerDataSource: MARTe.#DataSource & {
	Class: "OnChangeLoggerDataSource"
	Signals: {
		[_]: {
			#direction: "OUT"
			Ignore?:    0 | 1
		}
	}
}

#LuaGAM: MARTe.#GAM & {
	Class: "LuaGAM"
	Code:  string
	InternalStates?: {
		[_]: string
	}
	AuxiliaryFunctions?: {
		[_]: string
	}
	InputSignals?: {
		...
	}
	OutputSignals?: {
		...
	}
}

#HttpDynamicMessageInterface: close({
	Class: "HttpDynamicMessageInterface"
})
