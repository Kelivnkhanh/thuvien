ORG 00H
	MOV TMOD,#01H 		;cau hinh cho timer 0 hoat dong che do 16 bit	
MAIN:
	MOV R1,#5			;thanh ghi R1 dung de dem so lan chop tat
LM1:LCALL CHOPTAT		;goi chuong trinh chop tat led
	DJNZ R1,LM1	   		; lap lai den khi chop tat du 5 lan
	LCALL SANGDAN		; goi chuong trinh sang dan
	LCALL TATDAN	   ;goi chuong trinh tat dan
	LCALL DICH2LED	   	;goi chuong trinh dich hai led 
	LCALL DICH3LED 		; goi chuong trinh dich 3 led 

	SJMP MAIN 		   ;quay tro ve chuong trinh chinh
	
	
	
	CHOPTAT:			   ;chuong trinh con chop tat
		MOV P1,#00H		  	;tat het led o port 1
		MOV P3,#00H		  	;tat het led o port 3
		LCALL DELAY		  	;goi ham tao tre
		MOV P1,#0FFH	  	; mo het led port 1
		MOV P3,#0FFH		; mo het led port 3
		LCALL DELAY	
	RET 

	SANGDAN:		   		;chuong trinh con sang dan
		MOV P1,#0FFH		; cho led port 1  tat het 
		MOV P3,#0FFH		 ; cho led port 3  tat het 
		MOV A,#0FFH			 ;-- \\1
	L11:CLR C				 ;	cac dong lenh trong doan nay de lam cho led sang dan
		RLC A				 ;
		MOV P1,A 			 ;---- \\1
		LCALL DELAY			 ; goi delay
		JB P1.7,L11			 ; kiem tra xem tat ca cac led o port 1 da sang het chua
		MOV A,#0FFH			 ;------ //2
	L12:CLR C 				 ;
		RLC A 				 ;cac dong lenh trong doan nay co chuc nang nhu tren
		MOV P3,A			 ; nhung no se tac dong vao port 3
		LCALL DELAY			 ;
		JB P3.7,L12			 ;-------//2
	RET
	TATDAN:			  		 ;chuong trinh con tat dan
		MOV P1,#00H			 ;cho port 1 sang het
		MOV A,#00H			 ;-------\\
	L21:SETB C 				 ;	 doan chuong trinh nay de tat dan led 
		RRC A				 ;
		MOV P3,A			 ;--------\\
		LCALL DELAY			 ;goi delay
		JNB P3.0,L21		 ; kiem tra led port 3 da tat het chua
		MOV A,#00H			 ;----------//
	L22:SETB C				 ; 
		RRC A				 ;		 tuong tu nhu tren nhung tac dong len port 1
		MOV P1,A			 ;
		LCALL DELAY 		 ;
		JNB P1.0,L22 		 ;----------//
	RET 
	DICH2LED:
		MOV P1,#0FFH		;cho led tat het
		MOV P3,#0FFH		;cho led tat het
		LCALL DELAY		   	;goi delay
	
		MOV P1,#0FEH	   	;------\\
		LCALL DELAY			;
		MOV A,#0FCH			;	mov cac du lieu ban dau de chuan bi dich led
		MOV P1,A			;
		LCALL DELAY			;-------\\
		 
	L31:SETB C			   	;---------//
		RLC A 				;
		MOV P1,A			;	doan nay dich 2 led va kiem tra xem da dich het port 1 chua
		LCALL DELAY			;
		JB P1.7,L31			;---------//
	
		MOV P1,#7FH		  	;---------\\	
		MOV P3,#0FEH		;
		LCALL DELAY			;	  doan nay mov cac du lieu de dich 2 led tu port 2 sang port 3
		MOV P1,#0FFH		;
		MOV A,#0FCH			;
		MOV P3,A			;
		LCALL DELAY			;--------------\\
	L32:SETB C 				;--------------//
		RLC A				;
		MOV P3,A			;	 doan nay dich 2 led va kiem rtra xem da dich het port 3 chua
		LCALL DELAY			;
		JC L32				;
		MOV P3,#0FFH		;
		LCALL DELAY			;-------------\\
	RET 
	DICH3LED:		 		;--------------//
		MOV P3,#7FH			;
		MOV P1,#0FFH		;	 mov cac du lieu vao port 3 de chuan bi cho qua trinh dich 3 led
		LCALL DELAY			;
		MOV P3,#3FH			;
		LCALL DELAY			;
		MOV A,#1FH			;
		MOV P3,A			;
		LCALL DELAY			;---------------//
	L41:SETB C 				;----------------\\
		RRC A				;
		MOV P3,A 			;  doan nay la de dich 3 led va kiem tra xem da dich het port 3 chua 
		LCALL DELAY			;
		JB P3.0,L41			;-----------------\\
		
		MOV P1,#7FH			;------------------//
		MOV P3,#0FCH		;
		LCALL DELAY			;
		MOV P1,#3FH			;
		MOV P3,#0FEH		;	 doan nay mov cac gia tri chuyen tiep tu port 3 sang port 1
		LCALL DELAY			;
		MOV A,#1FH 			;
		MOV P1,A			;
		MOV P3,#0FFH		;
		LCALL DELAY			;-----------------------//
	L42:SETB C				;--------------------\\
		RRC A				;
		MOV P1,A			;  doan nay la de dich 3 led va kiem tra xem da dich het port 1 chua 
		LCALL DELAY			;
		JB P1.0,L42			;---------------------\\
							
		MOV P1,#0FCH		;---------------------//	
		LCALL DELAY			;
		MOV P1,#0FEH		;	mov cac gia tri de ket tat het cac led sau khi da dich xong
		LCALL DELAY			;
		MOV P1,#0FFH		;
		LCALL DELAY			;----------------------//
	RET 

	DELAY:				;;chuong trinh delay
		PUSH 00H
		MOV R0,#5
	LD:	MOV TH0,#3CH
		MOV TL0,#0AFH
		SETB TR0
		JNB TF0,$
		CLR TR0
		CLR TF0
		DJNZ R0,LD
		POP 00H
	RET 
END


	
