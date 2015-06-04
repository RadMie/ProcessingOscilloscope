import processing.serial.*; 
import controlP5.*;
 
Serial myPort;    // The serial port
String inString;  // Input string from serial port
float inString1;  // Input string from serial port
int lf = 10;      // ASCII linefeed 

ControlP5 controlP5;   // controlP5 object
color [] colors = new color[7]; 

PGraphics pg;

void setup() { 
  size(1000,504); 
  smooth();
  
  PFont pfont = createFont("Arial",20,true); // use true/false for smooth/no-smooth
  ControlFont font = new ControlFont(pfont,241);
 
  
  controlP5 = new ControlP5(this);
  
  controlP5.addBang("bang1",10,10,20,20);

  controlP5.addButton("Button").setValue(1).setPosition(70,10).setSize(60,20);
  controlP5.addToggle("toggle1",false,170,10,20,20);
  controlP5.addSlider("slider1",0,255,128,10,80,10,100);
  controlP5.addSlider("slider2",0,255,128,70,80,100,10);
  controlP5.addKnob("knob")
               .setRange(0,255)
               .setValue(50)
               .setPosition(670,350)
               .setRadius(50)
               .setDragDirection(Knob.VERTICAL)
               ;

  controlP5.addKnob("knob1")
               .setRange(0,100)
               .setLabelVisible(false) 
               .registerTooltip("vdv")
               .setPosition(747,172)
               .setRadius(80)
               .setNumberOfTickMarks(10)
               .setTickMarkLength(4)
               .snapToTickMarks(true)
               .setColorForeground(color(255))
               .setColorBackground(color(0, 160, 100))
               .setColorActive(color(255,255,0))
               .setDragDirection(Knob.HORIZONTAL)
               ;
  controlP5.addNumberbox("numberbox1",50,170,120,60,14);
  
  pg = createGraphics(604, 404);
  
  //println(Serial.list()[32]); 
 // myPort = new Serial(this, Serial.list()[32], 115200); 
 // myPort.bufferUntil(lf); 
} 
 
void draw() { 
  background(30);
  text("received: " + inString,10,50); 
  text(inString1 + "us",295,295);
  
  pg.beginDraw();
  pg.background(100);
  pg.stroke(255);
  pg.fill(80);
  pg.rect(10,10,40,40,2);
  pg.endDraw();
  image(pg, 50, 50); 

} 

void serialEvent(Serial p) { 
  inString = p.readStringUntil(lf); 

}

void changeAppIcon(PImage img) {
  final PGraphics pg = createGraphics(16, 16, JAVA2D);

  pg.beginDraw();
  pg.image(img, 0, 0, 16, 16);
  pg.endDraw();

  frame.setIconImage(pg.image);
}

void changeAppTitle(String title) {
  frame.setTitle(title);
}

void controlEvent(ControlEvent theEvent) {
  if(theEvent.isController()) { 
    
    print("control event from : "+theEvent.controller().name());
    println(", value : "+theEvent.controller().value());
    

      
    if(theEvent.controller().name()=="knob1") {
      inString1 = theEvent.controller().value();
    }
  
    
  }  
}
/*
Time: 20us - 1000000us(1s)
  20,   50,   100, 
  200,  500,  1000,
  2000,  5000,  10000,
  20000,  50000,  100000,
  200000,  500000,  1000000  
  
CH1 DC [V/dz]: 100mV - 5V
  {327.6,  5000},
  {130.8,  2000},
  {64.8,   1000},
  {32.4,   500},
  {12,     200},
  {6,      100},

Freq: 1 250 000Hz - 25Hz
  1250000 1.25MHz
  500000  500kHz
  250000  250kHz
  125000  125kHz
  50000   50kHz
  25000   25kHz
  12500   12.5kHz
  5000    5kHz
  2500    2.5kHz
  1250    1.25kHz
  500     500Hz
  250     250Hz
  125     125Hz
  50      50Hz
  25      25Hz
  
- blokada wykresu
- przesówanie wykresu CH1
- przesówanie wykresu CH2
- zmiana [V/dz] CH1
- zmiana [V/dz] CH2
- zmiana koloru wykresu CH1
- zmiana koloru wykresu CH2
- zmiana freq <zależne z time>
- zmiana time <zależne z freq>
- zrzut ekranu z wykresu
- pokaż tylko CH1
- pokaż tylko CH2
- powiększ wykres
- pomniejsz wykres
- napięcie max CH1
- napięcie max CH2
- przełacznik Analog/Cyfrowe

*/
