package extensions

import "marte.org/MARTe"

#ExtractBitGAM: MARTe.#GAM & {
	// Additional check: Outputsize == Inputsize * 8 
	Class:  "IOExt::ExtractBitGAM"
	$CHECK: "sum(sizeof(sig) for sig in this.InputSignals.values()) * 8 == sum(sizeof(sig) for sig in this.OutputSignals.values())"
}

#CompactBitGAM: MARTe.#GAM & {
	// Additional check: Outputsize * 8 = Inputsize
	Class:  "IOExt::CompactBitGAM"
	$CHECK: "sum(sizeof(sig) for sig in this.InputSignals.values()) == sum(sizeof(sig) for sig in this.OutputSignals.values()) * 8"
}
