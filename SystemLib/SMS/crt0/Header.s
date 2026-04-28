_SMSHEADER:	public _SMSHEADER
	db	"TMR SEGA"	; Header
	db	$FF, $FF	; Reserved
	dw	0			; Checksum
	dw	0			; Product code
	db	0			; Product code high 4 bits and version
	
	; Include ROM size and region info
	include "../../../System/RomSize.inc"
