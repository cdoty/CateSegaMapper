include "../../../System/GameDefines.inc"
include "../../../System/SystemDefines.inc"
include "../../../System/VRAMDefines.inc"

ext	transferToVRAM_
ext	clearVRAMWithParameters

clearSprites_:	public clearSprites_
	ld		a, SystemSprites
	ld		b, a

	ld		hl, spriteTableY

clearSpriteLoop:
	ld		a, HiddenSpriteX
	ld		(hl), a
	inc		hl

	ld		a, HiddenSpriteY
	ld		(hl), a
	inc		hl

	ld		a, 0
	ld		(hl), a
	inc		hl
	ld		(hl), a
	inc		hl
	
	dec		b
	jr		nz, clearSpriteLoop
	
	ld		hl, SpriteAttributes
	ld		de, 4 * SystemSprites
	call	clearVRAMWithParameters
	
	ret

updateSprites_:	public updateSprites_
	; Set update sprite attributes flag
	ld		a, 1
	ld		(updateSpriteAttributes), a

	ret
	
updateSpriteAttributeTable:	public updateSpriteAttributeTable
	; No need to disable interrupts since we're in VBlank
	ld		hl, spriteTableY
	ld		de, SpriteAttributes
	ld		bc, 4 * SystemSprites
	call	transferToVRAM_

	; Clear update sprite attributes flag
	xor		a
	ld		(updateSpriteAttributes), a

	ret

; A: Sprite
selectSprite_:	public selectSprite_
	push	bc
	push	hl

	ld		c, a
	ld		b, 0

	ld		hl, spriteTableY
	add		hl, bc

	ld		(selectedSpriteY), hl

	add		a, 128
	ld		c, a
	add		hl, bc

	ld		(selectedSpriteX), hl

	pop		hl
	pop		bc
	
	ret

; A: Sprite X
; E: Sprite Y
setSpritePosition_:	public setSpritePosition_
	push	hl

	ld		hl, (selectedSpriteY)
	ld		(hl), e
	
	ld		hl, (selectedSpriteX)
	ld		(hl), a

	pop		hl

	ret

; A: Sprite tile
setSpriteTile_:	public setSpriteTile_
	push	hl

	ld		hl, (selectedSpriteX)
	inc		hl

	ld		(hl), a

	pop		hl

	ret

dseg

spriteTableY:	public spriteTableY
	ds	SystemSprites

spriteTableFIller:
	ds	SystemSprites

spriteTableX:	public spriteTableX
	ds	2 * SystemSprites

updateSpriteAttributes:	public updateSpriteAttributes
	ds	1

; Stores hl of the selected sprite. Stores a value for the X, Y, and tile offset
selectedSpriteY:
	ds	2

selectedSpriteX:
	ds	2

