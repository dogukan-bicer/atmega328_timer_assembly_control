;10 hz blink
;prescaler 256 ya ayarlı
;8 bitlik zamanlayıcı kullanılıyor
; d3 portu cıkıs
	.def sondurum=r17
	.def temp=r18
	.org 0x0000;programın baslangıc adresi
	rjmp kurulum
	.org OC1Aaddr;ocra nın başlangıc adresi
	rjmp TIMER
kurulum:
	ldi R16,high(RAMEND) ;high bilgisini stack in sonuna yerlestir
	out SPH, R16; stack pointerı (yığın adresini) yükle
	ldi r16, low(RAMEND)
	out SPL, R16
	ldi temp, high(3125) ;OCR1A cıkış karşılaştırma değeri (timer ın süresini ayarlamak için)
	sts OCR1AH, temp;temp registerındaki deger OCR1AH a yazılır
	ldi temp, low(3125);high daki islemin aynısı
	sts OCR1AL, temp
	ldi temp, (1 << CS12) | (1 << WGM12) ;prescaler 256 ya ayarlandı, ocr1a seçildi
	sts TCCR1B, temp
	ldi temp, (1 << OCIE1A);cıkıs karşılaştırma ve eşleştirme interrupt ı aktif edildi
	sts TIMSK1, temp;temp registerındaki deger TIMSK1 a yazılır
	ldi temp, 0x08 ;d3 pini cıkıs olarak ayarlandı portD3
	out DDRD, temp
	out PORTD, temp
	sei;genel interrupt bayrağı aktif
dongu:
	rjmp dongu 
TIMER:
	in sondurum, SREG ;son durumu sreg(durum registerına kaydet)
	in r16, PORTD
	com r16;register 16 nın tümleyenini alır
	out PORTD, r16
	out SREG, sondurum
	reti;interrupı döndür ve etkinlestir



 
 
 
