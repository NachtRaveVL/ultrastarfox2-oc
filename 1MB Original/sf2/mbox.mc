rx1	equr	r1
ry1	equr	r2
rx2	equr	r3
rmlo	equr	r4
rmhi	equr	r5
rxi	equr	r5
ryi	equr	r6
rlgrad	equr	r8
ry2	equr	r9
rcnt	equr	r12


	malc	m_boxX,2
	malc	m_boxY,2
	malc	m_boxZ,2

;----------------------------------------------------
; entry:
;       r0 : colour
mshowbox	
	mpush	r11
	
	colour

	sub	r0
	cmode


	ibt	r0,#ztab>>16
	romb



	

drawedge	MACRO

	lms	rx1,[m_bigx]
	IFLT	\1
	miwt	r0,m_boxX
	ldw	[r0]
	with	rx1
	sub	r0
	ELSEIF
	miwt	r0,m_boxX
	ldw	[r0]
	with	rx1
	add	r0
	ENDC

	lms	ry1,[m_bigy]
	IFLT	\2
	miwt	r0,m_boxY
	ldw	[r0]
	with	ry1
	sub	r0
	ELSEIF
	miwt	r0,m_boxY
	ldw	[r0]
	with	ry1
	add	r0
	ENDC


	lms	r6,[m_bigz]
	IFLT	\3
	miwt	r0,m_boxZ
	ldw	[r0]
	with	r6
	sub	r0
	ELSEIF
	miwt	r0,m_boxZ
	ldw	[r0]
	with	r6
	add	r0
	ENDC

	partprojpnt 	rx1,ry1,.offscrn\@


	lms	rx2,[m_bigx]
	IFLT	\4
	miwt	r0,m_boxX
	ldw	[r0]
	with	rx2
	sub	r0
	ELSEIF
	miwt	r0,m_boxX
	ldw	[r0]
	with	rx2
	add	r0
	ENDC

	lms	ry2,[m_bigy]
	IFLT	\5
	miwt	r0,m_boxY
	ldw	[r0]
	with	ry2
	sub	r0
	ELSEIF
	miwt	r0,m_boxY
	ldw	[r0]
	with	ry2
	add	r0
	ENDC


	lms	r6,[m_bigz]
	IFLT	\6
	miwt	r0,m_boxZ
	ldw	[r0]
	with	r6
	sub	r0
	ELSEIF
	miwt	r0,m_boxZ
	ldw	[r0]
	with	r6
	add	r0
	ENDC

	partprojpnt 	rx2,ry2,.offscrn\@


	

;-------------------------------------------------------------------------------
; line draw
	mcache

	ibt	rxi,#1
	with	rx2
	sub	rx1
	bpl	.1\@
	nop
	ibt	rxi,#-1
	mneg	rx2
.1\@
	ibt	ryi,#1
	with	ry2
	sub	ry1
	bpl	.3\@
	nop
	ibt	ryi,#-1
	mneg	ry2
.3\@
	from	rx2
	sub	ry2
	bmi	.largery\@
	nop

	move	rcnt,rx2
	inc	rcnt
	lsr
	sub	ry2
	move	r13,pc

;Loop			8/11 cycles
	bcs	.5\@
	plot
	add	rx2
	with	ry1
	add	ryi
.5\@
	dec	rx1
	with	rx1
	add	rxi
	loop
	sub	ry2

	mlbra	.end\@


.largery\@
	move	rcnt,ry2
	inc	rcnt
	mneg	r0
	lsr

	sub	rx2
	move	r13,pc
;Loop			8/11 cycles
	bcs	.6\@
	plot
	add	ry2
	with	rx1
	add	rxi
.6\@
	dec	rx1
	with	ry1
	add	ryi
	loop
	sub	rx2

.end\@
;-------------------------------------------------------------------------------

.offscrn\@
	ENDM



	drawedge	-1,-1,1,1,-1,1
	drawedge	-1,1,1,1,1,1
	drawedge	-1,-1,1,-1,1,1
	drawedge	1,-1,1,1,1,1

	drawedge	-1,-1,-1,1,-1,-1
	drawedge	-1,1,-1,1,1,-1
	drawedge	-1,-1,-1,-1,1,-1
	drawedge	1,-1,-1,1,1,-1

	drawedge	-1,-1,-1,-1,-1,1
	drawedge	-1,1,-1,-1,1,1
	drawedge	1,-1,-1,1,-1,1
	drawedge	1,1,-1,1,1,1


	mpop	pc
	nop
