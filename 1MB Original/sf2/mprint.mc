;
; File:	MPRINT.MC
;
; Use:		Character print support
; Code:	MARIO
; By:		Peter Warnes
;		Copyright 1991
;


; Routine		Use
; -------		---
;
; mprintinit		Print initialise
; mprinttabxy		Print at x,y pos
; mprintword		Print hex word in r0
; mprintbyte		Print hex byte in r0
; mprintnibblehi	Print hex high nibble in r0
; mprintnibblelo	Print hex low nibble in r0
; mprintchar		Print hex character in r0
;



rx	equr	1
ry	equr	2
rc1	equr	3
rc2	equr	4
rheight	equr	5



mprintinitplot
	miwt	r0,$0f0a		; white on blue text
	sm	[m_textcolour],r0
	sub	r0			; cursor at 0,0
	sm	[m_textpos],r0

	miwt	r0,debugchars
	sm	[m_charset],r0
	jmp	r11
	nop


mprintinit
	sub	r0
	sm	[m_textpos],r0

	jmp	r11
	nop

;************************************************

mprinttabxy
	with	rx
	lob
	from	ry
	lob
	swap
	or	rx
	sm	[m_textpos],r0
	jmp	r11
	nop

	
;************************************************

mtabxy	macro
	sm	[m_textr0],r0
	miwt	r0,(\2<<8)+\1
	sm	[m_textpos],r0
	lm	r0,[m_textr0]
	endm


;************************************************


mprintnewline
	sm	[m_textr0],r0
	sm	[m_textr1],r1
	lm	r0,[m_textpos]
	swap
	inc	r0
	move	r2,r0
	lob
	ibt	r1,#15
	cmp	r1
	bmi	.1
	nop
	ibt	r2,#0
.1
	from	r2
	lob
	swap
	sbk
	lm	r0,[m_textr0]
	lm	r1,[m_textr1]
	jmp	r11
	nop

;************************************************
	

mprintspace
	sm	[m_textr0],r0
	sm	[m_textr1],r1
	lm	r0,[m_textpos]
	inc	r0
	move	r2,r0
	lob
	ibt	r1,#27
	cmp	r1
	bmi	.1
	nop
	hib
	inc	r0
	to	r2
	swap
.1
	from	r2
	sbk
	lm	r0,[m_textr0]
	lm	r1,[m_textr1]
	jmp	r11
	nop


; Print hex word
;
; In:	r0 = word value to print
; Out:
; Dead:

mprintword
	sm	[m_textr11],r11

	swap				; print hi byte
	mcall	mprintnibblehi
	nop

	mcall	mprintnibblelo
	nop

	swap				; print lo byte
	mcall	mprintnibblehi
	nop

	mcall	mprintnibblelo
	nop

	lm	pc,[m_textr11]
	nop




; Print hex byte
;
; In:	r0 = byte value to print
; Out:
; Dead:

mprintbyte
	sm	[m_textr11],r11

	mcall	mprintnibblehi
	nop

	mcall	mprintnibblelo
	nop

	lm	pc,[m_textr11]
	nop





; Print high nibble of r0
;
; In:	r0	     = char to print
;	m_textpos    = x,y pos to print at
;	m_textcolour = c1,c2 textcolours
; Out:
; Dead:

mprintnibblehi
	sm	[m_textr0],r0
	lsr
	lsr
	lsr
	lsr
	and	#15
	mlbra	mprintnib


; Print low nibble of r0
;
; In:	r0	     = char to print
;	m_textpos    = x,y pos to print at
;	m_textcolour = c1,c2 textcolours
; Out:
; Dead:

mprintnibblelo
	sm	[m_textr0],r0
	and	#15
	mlbra	mprintnib


; Print character
;
; In:	r0	     = char to print
;	m_textpos    = x,y pos to print at
;	m_textcolour = c1,c2 textcolours
; Out:
; Dead:

mprintchar
	sm	[m_textr0],r0


mprintnib

;	mlbra	mplotchar		; slow plot char



; fast print using mario RAM debug charset


rcharptr	equr	1
rscrnptr	equr	2


mprintdebug
	sm	[m_textr1],r1
	sm	[m_textr2],r2

	add	r0
	add	r0
	add	r0
	miwt	rcharptr,m_debugchars
	with	rcharptr
	add	r0

	lm	r0,[m_textpos]	; y:x
	swap			; x:y
	add	r0		; x<<9+y<<1
	to	rscrnptr
	mult	#8		; y<<4
	nop
	with	rscrnptr
	add	rscrnptr	; y<<5
	hib
	swap			; x<<9
	add	rscrnptr	; x<<9+y<<5

	lm	rscrnptr,[m_drawmap]
	with	rscrnptr
	add	r0

	rept	8

	mldbi	rcharptr

	mstbi	rscrnptr	; 0
	stb	[rscrnptr]	; 1
	with	rscrnptr
	add	#15		; +15

	mstbi	rscrnptr	; 16
	ibt	r0,#-1
	stb	[rscrnptr]	; 17
	ibt	r0,#15
	with	rscrnptr
	sub	r0		; -15 = +2

	endr

	lm	r0,[m_textpos]
	inc	r0
	move	r2,r0
	lob
	ibt	r1,#27
	cmp	r1
	bmi	.1
	nop
	hib
	inc	r0
	to	r2
	swap
.1
	from	r2
	sbk

	lm	r0,[m_textr0]
	lm	r1,[m_textr1]
	lm	r2,[m_textr2]

	jmp	r11
	nop



;plot a null terminated string
;
; In:	m_sprdata	string ptr
;	m_sprbank	string bank
;	m_textpos	string x,y pos
;	m_textcolour	text colour c1,c2
;

mplotstr
	lms	r1,[m_sprbank]
	lms	r14,[m_sprdata]
.2
	from	r1
	romb

	move	r14,r14
	mgetbi	r0
	mtest	r0
	beq	.1	
	nop

	mcall	mplotchar
	nop

	mlbra	.2

.1
	stop
	nop



; plot character


; NB 	This routine:
;
;	Changes the ROM bank to 0
;
;	Changes the COLOUR reg to text colour
;


mplotchar
	sm	[m_textr1],r1
	sm	[m_textr2],r2
	sm	[m_textr3],r3
	sm	[m_textr4],r4
	sm	[m_textr5],r5
	sm	[m_textr12],r12
	sm	[m_textr13],r13
	sm	[m_textr14],r14

	lob
	add	r0
	add	r0
	add	r0
	add	r0
	miwt	r14,(m_charset)
	with	r14
	add	r0

	lm	r0,[m_textpos]		; get text x,y pos
	to	ry
	hib
	to	rx
	lob

	lm	r0,[m_textcolour]	; get text colours
	to	rc2
	hib
	to	rc1
	lob
	
	sub	r0
	romb
	cmode
	move	r14,r14		; just in case rom bank changed

	ibt	rheight,#8
.nexty
	getbh
	inc	r14
	inc	r14

	ibt	r12,#8
	move	r13,pc

	add	r0
	bcc	.1
	from	rc1
	from	rc2
.1
	colour
	loop
	plot

	with	rx
	sub	#8
	dec	rheight
	bne	.nexty
	inc	ry

	with	rx		; move right one char pos
	lob
	with	rx
	add	#8
	from	ry
	sub	#8
	lob
	swap
	or	rx
	sm	[m_textpos],r0

	ibt	rx,#0		; flush plot buf
	ibt	ry,#0
	mrpix

	lm	r0,[m_textr0]
	lm	r1,[m_textr1]
	lm	r2,[m_textr2]
	lm	r3,[m_textr3]
	lm	r4,[m_textr4]
	lm	r5,[m_textr5]
	lm	r12,[m_textr12]
	lm	r13,[m_textr13]
	lm	r14,[m_textr14]

	jmp	r11
	nop





