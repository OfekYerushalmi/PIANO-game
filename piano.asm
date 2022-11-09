;----פרויקט סופי אסמבלר: אופק ירושלמי----;
IDEAL
MODEL small
STACK 100h
DATASEG

;-----------------------------------------------

x0 dw 50
x1 dw 60
y0 dw 0
y1 dw 150
color db 15 
note dw 2394h
current_key db 3
note_duration dw 100

instruction_1 db '################################################################################',10,13
db '################################ Piano Course ##################################',10,13
db '################################################################################',10,13
db 'Wellcome to piano course',10,13
db 'press any key for starting the course',10,13
db 'once started:',10,13
db 'press :',10,13
db '0 for exit',10,13
db '% for "little jhonatan" melody example',10,13
db 'note keys:',10,13
db '|--------------------------|   |--------------------------|',10,13
db '|note| octabe | key | #key |   |note| octabe | key | #key |',10,13
db '|--------------------------|   |--------------------------|',10,13
db '| do |   C3   |  a  |  q   |   | do |   C4   |  z  |  y   |',10,13
db '| re |   C3   |  s  |  w   |   | re |   C4   |  x  |  u   |',10,13
db '| mi |   C3   |  d  |      |   | mi |   C4   |  c  |      |',10,13
db '| fa |   C3   |  f  |  e   |   | fa |   C4   |  v  |  i   |',10,13
db '| sol|   C3   |  g  |  r   |   | sol|   C4   |  b  |  o   |',10,13
db '| la |   C3   |  h  |  t   |   | la |   C4   |  n  |  p   |',10,13
db '| si |   C3   |  j  |      |   | si |   C4   |  m  |      |',10,13
db '|--------------------------|   |--------------------------|',10,13,'$'

instruction_2 db '[a->j, q->t] - C3 notes',10,13
db '[z->m, y->p] - C4 notes',10,13
db '[0] - exit',10,13
db '[%] - little Johnathan song',10,13,'$'

cr_and_empty_line db 13,'  ',13,'$' ;-- go to start of line, print spaces, and go back to start of line
; --------------------------
; Your variables here
; --------------------------

CODESEG

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה מחכה זמן מה
proc wait_a_while
	mov bx, 0
loop_start_2:
	inc bx
	mov ax, 0
loop_start_1:
	inc ax
	cmp ax, 1000
	jl loop_start_1
	cmp bx, [note_duration]
	jl loop_start_2
	ret
endp wait_a_while

;note טענת כניסה: הפונקציה מקבלת תדר שנכנס ל     
;טענת יציאה: הפונקציה משמיעה צליל באורך התדר המתקבל  
proc play_note ;--השמעת צלילים
	; open speaker
	in al, 61h
	or al, 00000011b
	out 61h, al
	; send control word to change frequency
	mov al, 0B6h
	out 43h, al
	; play frequency note Hz
	mov ax, [note]
	out 42h, al ; Sending lower byte
	mov al, ah
	out 42h, al ; Sending upper byte
	call wait_a_while
	; close the speaker
	in al, 61h
	and al, 11111100b
	out 61h, al
	ret
endp play_note

;טענת כניסה: הפונקציה מקבלת מיקום התחלתי וסופי לפי שני הצירים (x0, x1, y0, y1)
;טענת יציאה: הפונקציה מציירת מלבן (תו בפסנתר)
proc draw_rect ;----ציור תו
	mov dx,[y0]
row:
	mov cx,[x0]
col:
	mov bh,0h ;draw pixel	
	mov al,[color]
	mov ah,0ch 
	int 10h
	
	inc cx ;end of col loop
	cmp cx,[x1]
	jl col
	
	inc dx ;end of row loop
	cmp dx,[y1]
	jl row
	ret
endp draw_rect

;--אם נלחץ z   
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו  
proc z_pressed
	mov [color], 4 ;----משנה צבע בשביל להראות לחיצה על התו
	call draw_z	;----מצייר לחיצה
	mov [note], 011D0h ;----מעביר צליל בגובה הרץ do
	call play_note ;----משמיע צליל
	;call wait_a_while
	mov [color], 15 ;----מחזיר צבע חזרה ללבן
	call draw_z	 ;----מחזיר משבצת צבועה ללבנה לאחר לחיצה
	ret
endp z_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_z
	mov [x0], 161 ;----מיקום התחלתי לציור התו
	mov [x1], 182 ;----מיקום סופי לציור התו
	mov [y1], 150 ;----גובה סופי לציור התו
	call draw_rect ;----ציור התו
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_y ;----כאשר צובעים משבצות גדולות, המשבצות הגדולות "נמחקות" לכן צובעים אותם שוב
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_z


;--אם נלחץ x
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc x_pressed
	mov [color], 4
	call draw_x	
	mov [note], 0FDFh;---re
	call play_note
	;call wait_a_while
	mov [color], 15
	call draw_x	
	ret
endp x_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_x
	mov [x0], 183
	mov [x1], 204
	mov [y1], 150
	call draw_rect
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_y
	call draw_u
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_x


;--אם נלחץ c
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc c_pressed
	mov [color], 4
	call draw_c	
	mov [note], 0E24h;---mi
	call play_note
	;call wait_a_while
	mov [color], 15
	call draw_c	
	ret
endp c_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_c
	mov [x0], 205
	mov [x1], 226
	mov [y1], 150
	call draw_rect
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_u
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_c


;--אם נלחץ v
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc v_pressed
	mov [color], 4
	call draw_v	
	mov [note], 0D58h;---fa
	call play_note
	;call wait_a_while
	mov [color], 15
	call draw_v	
	ret
endp v_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_v
	mov [x0], 227 
	mov [x1], 248
	mov [y1], 150
	call draw_rect
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_i
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_v


;--אם נלחץ b
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc b_pressed
	mov [color], 4
	call draw_b	
	mov [note], 0BE3h;---sol
	call play_note
	;call wait_a_while
	mov [color], 15
	call draw_b	
	ret
endp b_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_b
	mov [x0], 249 
	mov [x1], 270
	mov [y1], 150
	call draw_rect
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_i
	call draw_o
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_b


;--אם נלחץ n
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc n_pressed
	mov [color], 4
	call draw_n	
	mov [note],  0A97h;---la
	call play_note
	;call wait_a_while
	mov [color], 15
	call draw_n
	ret
endp n_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_n
	mov [x0], 271 
	mov [x1], 292
	mov [y1], 150
	call draw_rect
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_o
	call draw_p
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_n


;--אם נלחץ m
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc m_pressed
	mov [color], 4
	call draw_m	
	mov [note], 096Fh;---si
	call play_note
	;call wait_a_while
	mov [color], 15
	call draw_m
	ret
endp m_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_m
	mov [x0], 293 
	mov [x1], 314
	mov [y1], 150
	call draw_rect
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_p
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_m


;--אם נלחץ a
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc a_pressed
	mov [color], 4
	call draw_a
	mov [note], 023A1h;---do
	call play_note
	;call wait_a_while
	mov [color], 15
	call draw_a
	ret
endp a_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_a
	mov [x0], 7 
	mov [x1], 28
	mov [y1], 150
	call draw_rect
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_q
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_a


;--אם נלחץ s
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc s_pressed
	mov [color], 4
	call draw_s
	mov [note], 01FBEh;---re
	call play_note
	;call wait_a_while
	mov [color], 15
	call draw_s
	ret
endp s_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_s
	mov [x0], 29
	mov [x1], 50
	mov [y1], 150
	call draw_rect
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_q
	call draw_w
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_s


;--אם נלחץ d
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc d_pressed
	mov [color], 4
	call draw_d
	mov [note], 01C47h;---mi
	call play_note
	;call wait_a_while
	mov [color], 15
	call draw_d
	ret
endp d_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_d
	mov [x0], 51
	mov [x1], 72 
	mov [y1], 150
	call draw_rect
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_w
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_d


;--אם נלחץ f
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc f_pressed
	mov [color], 4
	call draw_f
	mov [note], 01AB1h;---fa
	call play_note
	;call wait_a_while
	mov [color], 15
	call draw_f
	ret
endp f_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_f
	mov [x0], 73
	mov [x1], 94 
	mov [y1], 150
	call draw_rect
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_e
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_f


;--אם נלחץ g
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc g_pressed
	mov [color], 4
	call draw_g
	mov [note],  017C7h;---sol
	call play_note
	;call wait_a_while
	mov [color], 15
	call draw_g
	ret
endp g_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_g
	mov [x0], 95 
	mov [x1], 116 
	mov [y1], 150
	call draw_rect
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_e
	call draw_r
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_g


;--אם נלחץ h
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc h_pressed
	mov [color], 4
	call draw_h
	mov [note], 0152Fh;---la
	call play_note
	;call wait_a_while
	mov [color], 15
	call draw_h
	ret
endp h_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_h
	mov [x0], 117 
	mov [x1], 138 
	mov [y1], 150
	call draw_rect
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_r
	call draw_t
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_h


;--אם נלחץ j
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc j_pressed
	mov [color], 4
	call draw_j
	mov [note], 012DFh;---si
	call play_note
	;call wait_a_while
	mov [color], 15
	call draw_j
	ret
endp j_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקתיה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו ללבן אחרי שנשמע הצליל
proc draw_j
	mov [x0], 139
	mov [x1], 160 
	mov [y1], 150
	call draw_rect
	mov [color], 8;----משנה צבע לאפור בשביל לצבוע משבצות קטנות
	call draw_t
	mov [color], 15;---מחזיר צבע חזרה ללבן
	ret
endp draw_j


;--אם נלחץ q
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc q_pressed
	mov [color], 4
	call draw_q
	mov [note], 021A1h;---do diaz
	call play_note
	;call wait_a_while
	mov [color], 8
	call draw_q
	ret
endp q_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו לאפור=(צבעו המקורי) לאחר השמעת הצליל
proc draw_q
	mov [x0], 23
	mov [x1], 34
	mov [y1], 100
	call draw_rect
	ret
endp draw_q


;--אם נלחץ w
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc w_pressed
	mov [color], 4
	call draw_w
	mov [note], 01DF6h;---re diaz
	call play_note
	;call wait_a_while
	mov [color], 8
	call draw_w
	ret
endp w_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו לאפור=(צבעו המקורי) לאחר השמעת הצליל
proc draw_w
	mov [x0], 45
	mov [x1], 56
	mov [y1], 100
	call draw_rect
	ret
endp draw_w


;--אם נלחץ e
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc e_pressed
	mov [color], 4
	call draw_e
	mov [note], 01931h;---fa diaz
	call play_note
	;call wait_a_while
	mov [color], 8
	call draw_e
	ret
endp e_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו לאפור=(צבעו המקורי) לאחר השמעת הצליל
proc draw_e
	mov [x0], 89
	mov [x1], 100
	mov [y1], 100
	call draw_rect
	ret
endp draw_e


;--אם נלחץ r
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc r_pressed
	mov [color], 4
	call draw_r
	mov [note], 01672h ;---sol diaz
	call play_note
	;call wait_a_while
	mov [color], 8
	call draw_r
	ret
endp r_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו לאפור=(צבעו המקורי) לאחר השמעת הצליל
proc draw_r
	mov [x0], 111
	mov [x1], 122
	mov [y1], 100
	call draw_rect
	ret
endp draw_r


;--אם נלחץ t
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc t_pressed
	mov [color], 4
	call draw_t
	mov [note], 013FFh;---la diaz
	call play_note
	;call wait_a_while
	mov [color], 8
	call draw_t
	ret
endp t_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו לאפור=(צבעו המקורי) לאחר השמעת הצליל
proc draw_t
	mov [x0], 133
	mov [x1], 144
	mov [y1], 100
	call draw_rect
	ret
endp draw_t


;--אם נלחץ y
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc y_pressed
	mov [color], 4
	call draw_y
	mov [note], 010D1h;---do diaz
	call play_note
	;call wait_a_while
	mov [color], 8
	call draw_y
	ret
endp y_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו לאפור=(צבעו המקורי) לאחר השמעת הצליל
proc draw_y
	mov [x0], 177
	mov [x1], 188
	mov [y1], 100
	call draw_rect
	ret
endp draw_y


;--אם נלחץ u
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc u_pressed
	mov [color], 4
	call draw_u
	mov [note], 0EFBh;---re diaz
	call play_note
	;call wait_a_while
	mov [color], 8
	call draw_u
	ret
endp u_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו לאפור=(צבעו המקורי) לאחר השמעת הצליל
proc draw_u
	mov [x0], 199
	mov [x1], 210
	mov [y1], 100
	call draw_rect
	ret
endp draw_u


;--אם נלחץ i
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc i_pressed
	mov [color], 4
	call draw_i
	mov [note], 0CA6h;---fa diaz
	call play_note
	;call wait_a_while
	mov [color], 8
	call draw_i
	ret
endp i_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו לאפור=(צבעו המקורי) לאחר השמעת הצליל
proc draw_i
	mov [x0], 243
	mov [x1], 254
	mov [y1], 100
	call draw_rect
	ret
endp draw_i


;--אם נלחץ o
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc o_pressed
	mov [color], 4
	call draw_o
	mov [note], 0B39h;---sol diaz
	call play_note
	;call wait_a_while
	mov [color], 8
	call draw_o
	ret
endp o_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו לאפור=(צבעו המקורי) לאחר השמעת הצליל
proc draw_o
	mov [x0], 265
	mov [x1], 276
	mov [y1], 100
	call draw_rect
	ret
endp draw_o


;--אם נלחץ p
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה קוראת לפונקציה אשר משמיעה צלילים ומציירת תויים כשנלחץ התו 
proc p_pressed
	mov [color], 4
	call draw_p
	mov [note], 0A00h;---la diaz
	call play_note
	;call wait_a_while
	mov [color], 8
	call draw_p
	ret
endp p_pressed

;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה מציירת את התו באדום כשהוא נלחץ ומחזירה אותו לאפור=(צבעו המקורי) לאחר השמעת הצליל
proc draw_p
	mov [x0], 287
	mov [x1], 298
	mov [y1], 100
	call draw_rect
	ret
endp draw_p

;טענת כניסה: הפוקציה מקבלת ערך שהמשתמש הקליד ל al
;טענת יציאה: הפונקציה בודקת מה התו שהמשתמש הכניס ועם כל תו משמיעה את הצליל המתאים לו או עושה את התפקיד המתאים לתו זה
proc check_presses
	cmp al, 48 ;--if the pressed character equals 0, exit
	jne check_z
	jmp exit
check_z:
	cmp al, 122 ;--if the pressed character equals z
	jne check_x
	call z_pressed
check_x:
	cmp al, 120 ;--if the pressed character equals x
	jne check_c
	call x_pressed
check_c:	
	cmp al, 99 ;--if the pressed character equals c
	jne check_v
	call c_pressed
check_v:
	cmp al, 118 ;--if the pressed character equals v
	jne check_b
	call v_pressed
check_b:
	cmp al, 98 ;--if the pressed character equals b
	jne check_n
	call b_pressed
check_n:
	cmp al, 110 ;--if the pressed character equals n
	jne check_m
	call n_pressed
check_m:
	cmp al, 109 ;--if the pressed character equals m
	jne check_a
	call m_pressed
check_a:
	cmp al, 97 ;--if the pressed character equals a
	jne check_s
	call a_pressed
check_s:
	cmp al, 115 ;--if the pressed character equals s
	jne check_d
	call s_pressed
check_d:
	cmp al, 100 ;--if the pressed character equals d
	jne check_f
	call d_pressed
check_f:
	cmp al, 102 ;--if the pressed character equals f
	jne check_g
	call f_pressed
check_g:
	cmp al, 103 ;--if the pressed character equals g
	jne check_h
	call g_pressed
check_h:
	cmp al, 104 ;--if the pressed character equals h
	jne check_j
	call h_pressed
check_j:
	cmp al, 106 ;--if the pressed character equals j
	jne check_q
	call j_pressed
check_q:
	cmp al, 113 ;--if the pressed character equals q
	jne check_w
	call q_pressed
check_w:
	cmp al, 119 ;--if the pressed character equals w
	jne check_e
	call w_pressed
check_e:
	cmp al, 101 ;--if the pressed character equals e
	jne check_r
	call e_pressed
check_r:
	cmp al, 114 ;--if the pressed character equals r
	jne check_t
	call r_pressed
check_t:
	cmp al, 116 ;--if the pressed character equals t
	jne check_y
	call t_pressed
check_y:
	cmp al, 121 ;--if the pressed character equals y
	jne check_u
	call y_pressed
check_u:
	cmp al, 117 ;--if the pressed character equals u
	jne check_i
	call u_pressed
check_i:
	cmp al, 105 ;--if the pressed character equals i
	jne check_o
	call i_pressed
check_o:
	cmp al, 111 ;--if the pressed character equals o
	jne check_p
	call o_pressed
check_p:
	cmp al, 112 ;--if the pressed character equals p
	jne check_%
	call p_pressed
check_%:
	cmp al, 37 ;--if the pressed character equals %
	jne done_check_presses
	call johnathan
done_check_presses:
	ret
endp check_presses
	
	
;טענת כניסה: הפונקציה לא מקבלת פרמטרים
;טענת יציאה: הפונקציה משמיעה צלילים באורך תו שונה על מנת לנגן את צלילי השיר "יונתן הקטן" ע
proc johnathan ; The Jhonathan the little song
	mov [note_duration], 200
	call g_pressed
	call d_pressed
	mov [note_duration], 400
	call d_pressed
	
	mov [note_duration], 100
	call wait_a_while
	
	mov [note_duration], 200
	call f_pressed
	call s_pressed
	mov [note_duration], 400
	call s_pressed

	mov [note_duration], 100
	call wait_a_while

	mov [note_duration], 200
	call a_pressed
	call s_pressed
	call d_pressed
	call f_pressed
	call g_pressed
	call g_pressed
	mov [note_duration], 400
	call g_pressed
	mov [note_duration], 200	

	mov [note_duration], 100
	call wait_a_while

	mov [note_duration], 200
	call g_pressed
	call d_pressed
	mov [note_duration], 400
	call d_pressed

	mov [note_duration], 200
	call f_pressed
	call s_pressed
	mov [note_duration], 400
	call s_pressed

	mov [note_duration], 100
	call wait_a_while

	mov [note_duration], 200
	call a_pressed
	call d_pressed
	call g_pressed
	call g_pressed
	
	mov [note_duration], 600
	call a_pressed
	
	mov [note_duration], 200
	call s_pressed
	call s_pressed
	call s_pressed
	call s_pressed
	call s_pressed
	call d_pressed
	mov [note_duration], 400
	call f_pressed

	mov [note_duration], 100
	call wait_a_while

	mov [note_duration], 200
	call d_pressed
	call d_pressed
	call d_pressed
	call d_pressed
	call d_pressed
	call f_pressed
	mov [note_duration], 400
	call g_pressed

	mov [note_duration], 200
	call g_pressed
	call d_pressed
	mov [note_duration], 400
	call d_pressed
	
	mov [note_duration], 100
	call wait_a_while
	
	mov [note_duration], 200
	call f_pressed
	call s_pressed
	mov [note_duration], 400
	call s_pressed

	mov [note_duration], 100
	call wait_a_while

	mov [note_duration], 200
	call a_pressed
	call d_pressed
	call g_pressed
	call g_pressed
	
	mov [note_duration], 600
	call a_pressed	
	
	mov [note_duration], 100
ret
endp johnathan


start:
	
; --------------------------
; Your code here
; --------------------------
	mov ax, @data
	mov ds, ax
	
	mov ax, 3 ;-- texts mode
	int 10h
	
	;--מדפיס הוראות1
	mov  dx, offset instruction_1
	mov  ah, 9h
	int  21h

	mov ah, 1 ;-- get key pressed
	int 21h

	
	mov ax, 13h ;-- graphics mode
	int 10h
	
	;--מחליט על מיקום בתחתית המסך עבור הוראות כשמופי הפסנתר
	mov  dl, 0    ;-- move cursor to column 0
	mov  dh, 19   ;-- move cursor to row 19
	mov  bh, 0    ;-- Display page
	mov  ah, 02h  ;-- SetCursorPosition
	int  10h

	;--מדפיס הוראות2
	mov  dx, offset instruction_2
	mov  ah, 9h
	int  21h	
	
	;---מדפיס תווים רגילים
	call draw_z
	call draw_x
	call draw_c
	call draw_v
	call draw_b
	call draw_n
	call draw_m
	call draw_a
	call draw_s
	call draw_d
	call draw_f
	call draw_g
	call draw_h
	call draw_j
	;--משנה צבע ומדפיס תווים קטנים (בצבע אפור)מ
	mov [color], 8 ; change the color to grey for the small buttons
	call draw_q
	call draw_w
	call draw_e
	call draw_r
	call draw_t
	call draw_y
	call draw_u
	call draw_i
	call draw_o
	call draw_p


	
wait_for_key_press:
		
	mov  dx, offset cr_and_empty_line ;avoid printing on scrren the typed characters
	mov  ah, 9h
	int  21h	

	mov ah, 1 ;-- get key pressed
	int 21h
	
	call check_presses ;----בודק לחיצות, מצייר ומשמיע צלילים בהתאמה
	
	jmp wait_for_key_press ;---לאחר שנקלט תו, קולטים שוב ושוב תו עד שהמשתמש מחליט לצאת מהמשחק (ולוחץ 0)י
	
exit:
	;-- חוזר למצב טקסט
	mov ax, 3 ;-- texts mode
	int 10h
	mov ax, 4c00h
	int 21h
	
END start