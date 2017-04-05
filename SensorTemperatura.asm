
_config_timer:

;SensorTemperatura.c,30 :: 		void config_timer( void ){
;SensorTemperatura.c,32 :: 		T1CON         = 0x8000;
	MOV	#32768, W0
	MOV	WREG, T1CON
;SensorTemperatura.c,33 :: 		T1IE_bit         = 1;
	BSET	T1IE_bit, BitPos(T1IE_bit+0)
;SensorTemperatura.c,34 :: 		T1IF_bit         = 0;
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;SensorTemperatura.c,35 :: 		IPC0                 = IPC0 | 0x1000;
	MOV	#4096, W1
	MOV	#lo_addr(IPC0), W0
	IOR	W1, [W0], [W0]
;SensorTemperatura.c,36 :: 		PR1                 = 500;
	MOV	#500, W0
	MOV	WREG, PR1
;SensorTemperatura.c,37 :: 		}
L_end_config_timer:
	RETURN
; end of _config_timer

_Timer1Int:
	PUSH	52
	PUSH	RCOUNT
	PUSH	W0
	MOV	#2, W0
	REPEAT	#12
	PUSH	[W0++]

;SensorTemperatura.c,40 :: 		void Timer1Int() org IVT_ADDR_T1INTERRUPT { // Timer1 interrupt handler
;SensorTemperatura.c,43 :: 		T1IF_bit    = 0;                          // Clear TMR1IF                                  //  to measure sampling frequency
	PUSH	W10
	PUSH	W11
	PUSH	W12
	BCLR	T1IF_bit, BitPos(T1IF_bit+0)
;SensorTemperatura.c,44 :: 		LATB.F15 = !LATB.F15;
	BTG	LATB, #15
;SensorTemperatura.c,45 :: 		adcValue = ADC1_Get_Sample(0);
	CLR	W10
	CALL	_ADC1_Get_Sample
	MOV	W0, _adcValue
;SensorTemperatura.c,47 :: 		temperatura = (3.3*100.0/1024.0)*adcValue;
	ASR	W0, #15, W1
	SETM	W2
	CALL	__Long2Float
	MOV	#0, W2
	MOV	#16037, W3
	CALL	__Mul_FP
	MOV	W0, _temperatura
	MOV	W1, _temperatura+2
;SensorTemperatura.c,50 :: 		FloatToStr(temperatura, txt) ;
	MOV	#lo_addr(_txt), W12
	MOV.D	W0, W10
	CALL	_FloatToStr
;SensorTemperatura.c,55 :: 		Lcd_Out(1,1,txt);
	MOV	#lo_addr(_txt), W12
	MOV	#1, W11
	MOV	#1, W10
	CALL	_Lcd_Out
;SensorTemperatura.c,58 :: 		}
L_end_Timer1Int:
	POP	W12
	POP	W11
	POP	W10
	MOV	#26, W0
	REPEAT	#12
	POP	[W0--]
	POP	W0
	POP	RCOUNT
	POP	52
	RETFIE
; end of _Timer1Int

_main:
	MOV	#2048, W15
	MOV	#6142, W0
	MOV	WREG, 32
	MOV	#1, W0
	MOV	WREG, 52
	MOV	#4, W0
	IOR	68

;SensorTemperatura.c,60 :: 		void main()
;SensorTemperatura.c,64 :: 		Lcd_Init();
	PUSH	W10
	CALL	_Lcd_Init
;SensorTemperatura.c,65 :: 		Lcd_Cmd(_LCD_CLEAR);               // Clear display
	MOV.B	#1, W10
	CALL	_Lcd_Cmd
;SensorTemperatura.c,66 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off
	MOV.B	#12, W10
	CALL	_Lcd_Cmd
;SensorTemperatura.c,68 :: 		ADC1_Init();
	CALL	_ADC1_Init
;SensorTemperatura.c,69 :: 		TRISA.F0 = 1;     //pin RA0 como entrada
	BSET	TRISA, #0
;SensorTemperatura.c,73 :: 		TRISB.F15 = 0;
	BCLR	TRISB, #15
;SensorTemperatura.c,74 :: 		LATB.F15 = 0;
	BCLR	LATB, #15
;SensorTemperatura.c,76 :: 		config_timer();
	CALL	_config_timer
;SensorTemperatura.c,77 :: 		while(1);
L_main0:
	GOTO	L_main0
;SensorTemperatura.c,78 :: 		}
L_end_main:
	POP	W10
L__main_end_loop:
	BRA	L__main_end_loop
; end of _main
