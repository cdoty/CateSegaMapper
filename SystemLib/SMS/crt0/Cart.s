ext	startup
ext	irqHandler
ext	nmiHandler

_SMSENTRY:	public _SMSENTRY
	di

	im		1
	jp		startup

afterStartup:
	; Calculate offset of _RST8
	ds		$8 - (afterStartup - _SMSENTRY)

_RST08:	public _RST08
	jp		irqHandler

afterRST08:
	; Calculate offset of _RST18
	ds		$18 - (afterRST08 - _SMSENTRY)

_RST18:	public _RST18
	jp		irqHandler

afterRST18:
	; Calculate offset of _RST38
	ds		$38 - (afterRST18 - _SMSENTRY)

_RST38:	public _RST38
	jp		irqHandler

afterRST38:
	; Calculate offset of _RST66
	ds		$66 - (afterRST38 - _SMSENTRY)

_RST66:	public _RST66
	jp		nmiHandler
