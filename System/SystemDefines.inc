RAMStart		equ	$C000	; Ram start address
RAMSize			equ	$1DD0	; Ram size, excluding space reserved for stack
StackStart		equ	$DFF0	; Stack start address
VDPBase			equ	$BE		; VDP data base port 
VDPReadBase		equ	VDPBase	; VDP control base port
WriteOffset		equ	1		; Difference between read and write ports for each base port
JoystickPortA	equ	$DC		; PPI port A
JoystickPortB	equ	$DD		; PPI port B
PPIPortControl	equ	$92		; PPI control
SoundPort		equ	$7F		; Sound port
SystemSprites	equ	64		; Maximum system sprites
HiddenSpriteX	equ	0		; Hidden sprite position
HiddenSpriteY	equ	209
