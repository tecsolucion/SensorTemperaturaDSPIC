int adcValue;
float temperatura;

char txt[10];


sbit LCD_RS at LATB2_bit;
sbit LCD_EN at LATB3_bit;
sbit LCD_D4 at LATB4_bit;
sbit LCD_D5 at LATB5_bit;
sbit LCD_D6 at LATB6_bit;
sbit LCD_D7 at LATB7_bit;

sbit LCD_RS_Direction at TRISB2_bit;
sbit LCD_EN_Direction at TRISB3_bit;
sbit LCD_D4_Direction at TRISB4_bit;
sbit LCD_D5_Direction at TRISB5_bit;
sbit LCD_D6_Direction at TRISB6_bit;
sbit LCD_D7_Direction at TRISB7_bit;


/*
sbit loadPin at LATB13_bit;                  // DAC load pin
sbit loadPinDir at TRISB13_bit;              // DAC load pin
sbit csPin at LATB12_bit;                    // DAC CS pin
sbit csPinDir at TRISB12_bit;                // DAC CS pin
                */

////////////////////
void config_timer( void ){

  T1CON         = 0x8000;
  T1IE_bit         = 1;
  T1IF_bit         = 0;
  IPC0                 = IPC0 | 0x1000;
  PR1                 = 500;
}


  void Timer1Int() org IVT_ADDR_T1INTERRUPT { // Timer1 interrupt handler


T1IF_bit    = 0;                          // Clear TMR1IF                                  //  to measure sampling frequency
LATB.F15 = !LATB.F15;
adcValue = ADC1_Get_Sample(0);

temperatura = (3.3*100.0/1024.0)*adcValue;


FloatToStr(temperatura, txt) ;


//WordToStr(temperatura, txt);

Lcd_Out(1,1,txt);


}

void main()
{


  Lcd_Init();
  Lcd_Cmd(_LCD_CLEAR);               // Clear display
  Lcd_Cmd(_LCD_CURSOR_OFF);          // Cursor off

  ADC1_Init();
  
     TRISA.F0 = 1;     //pin RA0 como entrada



  TRISB.F15 = 0;
  LATB.F15 = 0;
     // configu interrupcion timer
   config_timer();
   while(1);
}