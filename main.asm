; atmega328_timer_assembly_control.asm
; Created: 10.07.2021 19:52:02
; Author : dogukan
;D6 pwm cıkıs
.def gecici = R16
.def delay_0 = R17
.def delay_1 = R18
.def sayac = R19
 init:
 	LDI		gecici,	0xFF		;0b 0b11111111'i R16 / LDI ye yükler, yalnızca üst 16 registerda çalışır (R16-R31) 
	OUT		DDRD,	R16			;1 --> Çıkış 0 --> Giriş / Tüm PortD Çıkış portu olarak ayarlandı  
	LDI		gecici,	1<<WGM00 | 1<<COM0A1 ;pwm phase connect ayarlandı. OC0A'yı temizle
	OUT		TCCR0A, gecici
	LDI		gecici, 1<<CS01     ;prescaler /8 e ayarlı 
	OUT		TCCR0B, gecici
	ldi		sayac, 0x0 ;sayacın 0 olduğunu kontrol et
dongu:
	sayac_artir:
		ldi		delay_0, 0;228		;delayı 10 ms ye ayarlamak icin 228
		ldi		delay_1, 255;104
		OUT		OCR0A, sayac
		INC		sayac
		RCALL	delay  ;delayı yeniden cagır
		cpi		sayac,	0x64  ;
		brne	sayac_artir ;deger 0 olana kadar donguden cıkma
	sayac_azalt:
		ldi		delay_0, 0;228		;delayı 10 ms ye ayarlamak icin
		ldi		delay_1, 255;104
		OUT		OCR0A, sayac
		DEC		sayac
		RCALL	delay
		cpi		sayac,	0x0;sayacın 0 olduğunu kontrol et
		brne	sayac_azalt;deger 0 olana kadar donguden cıkma
	rjmp	dongu
delay:
	dec delay_0 ;delay 0 i 1 azalt
	brne delay      ;branch if not equal  1 biti ayarlanmazsa atlama 
	dec delay_1;delay 1 i 1 azalt
	brne delay
	ret
 
 
 
