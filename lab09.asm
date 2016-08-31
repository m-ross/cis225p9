TITLE	lab09mr
; Programmer:	Marcus Ross
; Due:		5 May, 2014
; Description:	This program takes input from the keyboard in the form of a single character, displays that character's ASCII code, displays the quantity of 1's in that code, and repeats until user chooses to stop.

		.MODEL SMALL
		.386
		.STACK 40h
;==========================
		.DATA
errorMsg	DB	'Input was not a valid character', 0ah, 0dh, 24h
newLine	DB	0ah, 0dh, 24h
asciiMsg	DB	'ASCII Code: ', 24h
bitsMsg	DB	'Number of bits set: ', 24h
prompt	DB	'Enter a character (press return to exit): ', 24h
;==========================
		.CODE
Main		PROC	NEAR
		mov	ax, @data	; init data
		mov	ds, ax	; segment register

start:	call	GetChar	; get char from keyboard
		cmp	al, 0dh	; input - carriage return
		jz	finish	; done looping if input = carriage return
		cmp	al, 0		; input - 0
		jz	dispE		; jump ahead if input not ASCII
		call	DispASCII	; display ASCII code
		call	DispQty	; display number of bits set
		jmp	start		; loop
dispE:	call	DispError	; display error if input was not ASCII
		jmp	start		; loop

finish:	mov	ax, 4c00h	; return code 0
		int	21h
		ENDP
;==========================
GetChar	PROC	NEAR
		mov	dx, OFFSET prompt
		mov	ah, 09h
		int	21h		; display prompt
		mov	ah, 00h
		int	16h		; input char -> al
		ret
		ENDP
DispLine	MACRO
		mov	dx, OFFSET newLine
		mov	ah, 09h
		int	21h			; display new line macro
		ENDM
;==========================
DispError	PROC	NEAR
		DispLine		; display new line macro
		mov	dx, OFFSET errorMsg
		mov	ah, 09h
		int	21h		; display error message
		DispLine		; display new line macro
		ret
		ENDP
;==========================
DispASCII	PROC	NEAR
		DispLine		; display new line macro
		mov	ch, 0		; reset bit count
		mov	cl, 8		; rotate 8 times
		mov	bl, al	; DOS call to display char uses al
		mov	dx, OFFSET asciiMsg
		mov	ah, 09h
		int	21h		; display line header

rotate:	rol	bl, 1 	; put bit from input char into CF
		jnc	notSet	; if CF is not set, jump
		mov	dl, '1'	; for displaying
		inc	ch		; count number of bits set
		jmp	disp
notSet:	mov	dl, '0'	; for displaying
disp:		mov	ah, 02h
		int	21h		; display '1' or '0' from CF

		dec	cl
		jnz	rotate	; loop if not done with all 8 bits

		DispLine		; display new line macro
		ret
		ENDP
;==========================
DispQty	PROC	NEAR
		mov	dx, OFFSET	bitsMsg
		int	21h		; display line header
		mov	dl, ch	; bit count -> dl
		add	dl, '0'	; value -> ASCII
		mov	ah, 02h
		int	21h		; display ASCII

		DispLine		; display new line macro
		int	21h		; display another line
		ret
		ENDP
;==========================
		END	Main