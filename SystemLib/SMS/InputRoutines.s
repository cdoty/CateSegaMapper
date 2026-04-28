include "../../System/SystemDefines.inc"

clearJoysticks_:	public clearJoysticks_
	; Clear joystick values
	xor		a
	ld		(joystick1Value), a
	ld		(joystick1LastValue), a
	ld		(joystick2Value), a
	ld		(joystick2LastValue), a

	ret

updateJoysticks_:	public updateJoysticks_
	ld		a, (Joystick1Value)
	ld		(Joystick1LastValue), a
	ld		a, (Joystick2Value)
	ld		(Joystick2LastValue), a

	call	readJoysticks
	
	ret

readJoystick1_:	public readJoystick1_
	ld		a, (joystick1Value)

	ret

readJoystick2_:	public readJoystick2_
	ld		a, (joystick2Value)

	ret

readJoysticks:
	push	bc
	push	de

	; Read joystick port A
	in		a, (JoystickPortA)
	
	; Store a temp copy of the bits
	cpl
	ld		d, a

	; Read joystick port B
	in		a, (JoystickPortB)
	
	; Store a temp copy of the bits
	cpl
	ld		e, a

	; Get joystick 1 direction and buttons
	ld		a, d
	and		$3F

	; Store result
	ld		(joystick1Value), a

	; Get lower 2 bits of joystick 2 data
	ld		a, d

	; Shift the upper 2 bits into joystick 2 lower 2 bits
	srl		a
	srl		a
	srl		a
	srl		a
	srl		a
	srl		a
	and		$03

	ld		b, a

	; Get the upper 4 bits of joystick 2 data
	ld		a, e
	
	; Shift the lower 4 bits into joystick 2 upper 4 bits
	and		$0F
	sla		a
	sla		a

	or		b

	; Store result
	ld		(joystick2Value), a

	pop		de
	pop		bc

	ret

dseg

joystick1Value:
    ds	1

joystick1LastValue:
    ds	1

joystick2Value:
    ds	1

joystick2LastValue:
    ds	1
