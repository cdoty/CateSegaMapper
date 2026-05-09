include "SystemDefines.inc"

ext	resetSound
ext	startupDelay
ext	clearRam
ext	setupLibrary
ext setMode4
ext	clearVRAM
ext	callBankFunction_
ext	setDefaultBank

startup: public startup
	ld		sp, StackStart		; Setup stack

	call	resetSound			; Reset sound to stop noise at startup
	call	startupDelay		; Delay before starting
	call	clearRam			; Clear ram
	call	setupLibrary		; Setup library
	call	setDefaultBank		; Set default bank
	
	call	setMode4			; Set mode 4
	call	clearVRAM			; Clear VRAM

	ld		a, 1				; Call the main function in bank 1
	ld		e, 0
	call	callBankFunction_

endLoop:
	jp		endLoop
