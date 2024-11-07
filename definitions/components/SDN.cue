package components

import "marte.org/MARTe"

#SDNSubscriber: MARTe.#DataSource & {
	Class:               "SDN::SDNSubscriber"
	ExecutionMode?:      #ThreadMode
	Topic:               string
	Interface:           string
	Address?:            #IPPORT
	Timeout?:            uint32
	InternalTimeout?:    uint32
	CPUs?:               uint32
	IgnoreTimeoutError?: 1 | 0
	Signals: {
		[_]: {
			#direction: "IN"
		}
		Header?: MARTe.#Signal & {
			Type:             "uint8"
			NumberOfElements: 48
		}
		Counter?: MARTe.#Signal & {
			Type: "uint64"
		}
		Timestamp?: MARTe.#Signal & {
			Type: "uint64"
		}
	}
}

#SDNPublisher: MARTe.#DataSource & {
	Class:             "SDN::SDNPublisher"
	Topic:             string
	Interface:         string
	Address?:          #IPPORT
	SourcePort?:       uint32
	NetworkByteOrder?: 1 | 0
	Signals: {
		[_]: {
			#direction: "OUT"
		}
		Header?: MARTe.#Signal & {
			Type:             "uint8"
			NumberOfElements: 48
		}
		Counter?: MARTe.#Signal & {
			Type: "uint64"
		}
		Timestamp?: MARTe.#Signal & {
			Type: "uint64"
		}
	}
}
