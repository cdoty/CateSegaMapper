include "../../System/GameDefines.inc"
include "../../System/SystemDefines.inc"
include "../../System/VRAMDefines.inc"

ext	nmiCount
ext	lastNMICount
ext	writeVDPReg
ext	nmiHandler

setMode4:	public setMode4
	ld		b, $04							; Disable external VDP interrupt, set M4 for Graphics mode 4.
	ld		c, 0
	call	writeVDPReg

	ld		a, SpriteSize					; Disable screen, NMI interrupt. Sprite size is set by SpriteSize define. SMS is either 8x8 or 8x16.
	or		$A0
	ld		b, a							
	ld		c, 1
	call	writeVDPReg

	ld		b, ScreenVRAM / $400 OR 1		; Set Name Table location. Bit 0 must be set.
	ld		c, 2
	call	writeVDPReg

	ld		b, $FF							; Set to $FF for SMS.
	ld		c, 3
	call	writeVDPReg

	ld		b, 7							; Lower 3 bits must be set. VRAM location is fixed for mode 4.
	ld		c, 4
	call	writeVDPReg

	ld		b, SpriteAttributes / $80 OR 1	; Set Sprite Attribute Table location. Lower bit needs to be set in mode 4.
	ld		c, 5
	call	writeVDPReg

	ld		b, SpritePattern / $800 OR 3	; Set Sprite Pattern Table location. Lower two bits needs to be set in mode 4.
	ld		c, 6
	call	writeVDPReg

	ld		b, $00							; Set overscan color to black
	ld		c, 7
	call	writeVDPReg

	ld		b, $00							; Set background scroll X
	ld		c, 8
	call	writeVDPReg

	ld		b, $00							; Set background scroll Y
	ld		c, 9
	call	writeVDPReg

	ld		b, $C0							; Set line counter for HBlank. $C0 ensures it never happens, 0 means every line.
	ld		c, $0A
	call	writeVDPReg

	ret
	
; Turn on screen
; void turnOnScreen();
turnOnScreen_: public turnOnScreen_
	ld		a, SpriteSize
	or		$E0
	ld		b, a						; Enable 16K VRAM, Screen, NMI interrupt. Sprite size is set by SpriteSize define
	ld		c, 1
	call	writeVDPReg

	ret
	
; Turn off screen
; void turnOffScreen();
turnOffScreen_:	public turnOffScreen_
	ld		a, SpriteSize
	or		$A0
	ld		b, a						; Enable 16K VRAM, Screen, NMI interrupt. Sprite size is set by SpriteSize define
	ld		c, 1
	call	writeVDPReg

	ret

enableIRQ_:	public enableIRQ_
	; Clear nmi counts
	xor		a
	ld		(nmiCount), a
	ld		(lastNMICount), a

	ei

	ret

disableIRQ_:	public disableIRQ_
	di

	ret

; void waitForVBlank();
waitForVBlank_:	public waitForVBlank_
	ld		a, (lastNMICount)
	ld		b, a

waitVBlankLoop:
	ld		a, (nmiCount)
	cp		b
	
	jr		z, waitVBlankLoop
	
	ld		(lastNMICount), a

	ret
