TITLE	lab09extrn
; Programmer:	Marcus Ross
; Due:		5 May, 2014
; Description:	This external subprogram leaves dx and ah in unpredictable states. It prompts the user to enter a character, then takes a character as input and leaves the ASCII in al.
		.MODEL SMALL
		.386
;==========================
		.DATA
prompt	DB	'Enter a character (press return to exit): ', 24h
;==========================
		.CODE
		PUBLIC GetChar
GetChar	PROC	NEAR
		mov	dx, OFFSET prompt
		mov	ah, 09h
		int	21h		; display prompt
		mov	ah, 01h
		int	21h		; input char -> al
		ret
		ENDP
;==========================
		END