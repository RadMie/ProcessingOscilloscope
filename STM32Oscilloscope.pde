/*
███████╗████████╗███╗   ███╗██████╗ ██████╗      ██████╗ ███████╗ ██████╗██╗██╗     ██╗      ██████╗ ███████╗ ██████╗ ██████╗ ██████╗ ███████╗
██╔════╝╚══██╔══╝████╗ ████║╚════██╗╚════██╗    ██╔═══██╗██╔════╝██╔════╝██║██║     ██║     ██╔═══██╗██╔════╝██╔════╝██╔═══██╗██╔══██╗██╔════╝
███████╗   ██║   ██╔████╔██║ █████╔╝ █████╔╝    ██║   ██║███████╗██║     ██║██║     ██║     ██║   ██║███████╗██║     ██║   ██║██████╔╝█████╗  
╚════██║   ██║   ██║╚██╔╝██║ ╚═══██╗██╔═══╝     ██║   ██║╚════██║██║     ██║██║     ██║     ██║   ██║╚════██║██║     ██║   ██║██╔═══╝ ██╔══╝  
███████║   ██║   ██║ ╚═╝ ██║██████╔╝███████╗    ╚██████╔╝███████║╚██████╗██║███████╗███████╗╚██████╔╝███████║╚██████╗╚██████╔╝██║     ███████╗
╚══════╝   ╚═╝   ╚═╝     ╚═╝╚═════╝ ╚══════╝     ╚═════╝ ╚══════╝ ╚═════╝╚═╝╚══════╝╚══════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝     ╚══════╝
*/
import processing.serial.*; 
import controlP5.*;
 
Serial myPort;    
ControlP5 controlP5;
PGraphics pg;
ListBox portListbox,baudrateListbox;

String Status;  
String list[] = new String[600];
float inString1; 
int lf = 10;      // ASCII linefeed 
boolean hasData = false;

void setup() { 
  
  size(1000,485); 
  smooth();
  
  PFont pfont = createFont("Arial",12,true);
  ControlFont font = new ControlFont(pfont,241);
 
  controlP5 = new ControlP5(this);

  controlP5.addKnob("ch1").setRange(100,5000).setValue(50).setPosition(750,350).setRadius(40).setDragDirection(Knob.HORIZONTAL);
  controlP5.addKnob("ch2").setRange(100,5000).setValue(50).setPosition(890,350).setRadius(40).setDragDirection(Knob.HORIZONTAL);
  controlP5.addKnob("time").setRange(20,1000000).setLabelVisible(false).registerTooltip("Time").setPosition(790,172).setRadius(70).setNumberOfTickMarks(20).setTickMarkLength(4).snapToTickMarks(false).setColorForeground(color(255)).setColorBackground(color(0, 160, 100)).setColorActive(color(255,255,0)).setDragDirection(Knob.HORIZONTAL);
  controlP5.addTextfield("PORT SELECTED").setPosition(10,10).setSize(100,20).setText("NO PORT SELECTED").setFocus(false).lock().setColor(color(#eeeeee));
  controlP5.addTextfield("FREQUENCY").setPosition(765,40).setSize(200,40).setFont(createFont("arial",20)).setText("1250000 Hz").setFocus(false).lock().setColor(color(#eeeeee));
  portListbox = controlP5.addListBox("PORT").setPosition(10, 65).setSize(100, 120).setItemHeight(15).setBarHeight(15).setColorBackground(color(#844242)).setColorActive(color(0)).setColorForeground(color(#eeeeee));                    
  controlP5.addButton("RECONNECT").setValue(0).setPosition(10,185).setSize(100,20).getCaptionLabel().align(controlP5.CENTER, controlP5.CENTER).setFont(font).setSize(12);
  controlP5.addButton("SHOW CH1").setValue(0).setPosition(120,10).setSize(115,20).getCaptionLabel().align(controlP5.CENTER, controlP5.CENTER).setFont(font).setSize(12);
  controlP5.addButton("SHOW CH2").setValue(0).setPosition(242,10).setSize(115,20).getCaptionLabel().align(controlP5.CENTER, controlP5.CENTER).setFont(font).setSize(12);
  controlP5.addButton("SHOW CH1+CH2").setValue(0).setPosition(364,10).setSize(115,20).getCaptionLabel().align(controlP5.CENTER, controlP5.CENTER).setFont(font).setSize(12);
  controlP5.addButton("HOLD").setValue(0).setPosition(486,10).setSize(115,20).getCaptionLabel().align(controlP5.CENTER, controlP5.CENTER).setFont(font).setSize(12);
  controlP5.addButton("SCREENSHOT").setValue(0).setPosition(608,10).setSize(115,20).getCaptionLabel().align(controlP5.CENTER, controlP5.CENTER).setFont(font).setSize(12);
  controlP5.addButton("CH1 UP").setValue(0).setPosition(120,454).setSize(95,20).getCaptionLabel().align(controlP5.CENTER, controlP5.CENTER).setFont(font).setSize(12);
  controlP5.addButton("CH1 DOWN").setValue(0).setPosition(222,454).setSize(95,20).getCaptionLabel().align(controlP5.CENTER, controlP5.CENTER).setFont(font).setSize(12);
  controlP5.addButton("ZOOM +").setValue(0).setPosition(324,454).setSize(95,20).getCaptionLabel().align(controlP5.CENTER, controlP5.CENTER).setFont(font).setSize(12);
  controlP5.addButton("ZOOM -").setValue(0).setPosition(426,454).setSize(95,20).getCaptionLabel().align(controlP5.CENTER, controlP5.CENTER).setFont(font).setSize(12);
  controlP5.addButton("CH2 UP").setValue(0).setPosition(528,454).setSize(95,20).getCaptionLabel().align(controlP5.CENTER, controlP5.CENTER).setFont(font).setSize(12);
  controlP5.addButton("CH2 DOWN").setValue(0).setPosition(630,454).setSize(95,20).getCaptionLabel().align(controlP5.CENTER, controlP5.CENTER).setFont(font).setSize(12);
  baudrateListbox = controlP5.addListBox("BAUDRATE").setPosition(10, 230).setSize(100, 120).setItemHeight(15).setBarHeight(15).setColorBackground(color(#844242)).setColorActive(color(0)).setColorForeground(color(#eeeeee));
 
  portListbox.captionLabel().toUpperCase(true);
  portListbox.captionLabel().set("PORT");
  portListbox.captionLabel().setColor(0xffff0000);
  portListbox.captionLabel().style().marginTop = 3;
  portListbox.valueLabel().style().marginTop = 3;
  
  baudrateListbox.captionLabel().toUpperCase(true);
  baudrateListbox.captionLabel().set("BAUDRATE");
  baudrateListbox.captionLabel().setColor(0xffff0000);
  baudrateListbox.captionLabel().style().marginTop = 3;
  baudrateListbox.valueLabel().style().marginTop = 3;
  
  for (int i=0;i<Serial.list().length;i++) {
    //if(Serial.list()[i].contains("USB") || Serial.list()[i].contains("ACM")) {
      ListBoxItem lbi = portListbox.addItem(Serial.list()[i], i);
      lbi.setColorBackground(0xffff0000);  
    //}
  }
  
  baudrateListbox.addItem("9600"  ,9600);
  baudrateListbox.addItem("14400" ,14400);
  baudrateListbox.addItem("19200" ,19200);
  baudrateListbox.addItem("28800" ,28800);
  baudrateListbox.addItem("38400" ,38400);
  baudrateListbox.addItem("57600" ,57600);
  baudrateListbox.addItem("115200",115200);

  pg = createGraphics(603, 403);
  
  println(Serial.list()[32]); 
  myPort = new Serial(this, Serial.list()[32], 115200); 
  myPort.bufferUntil(lf); 
} 
 
void draw() { 
  
    background(30);
    
    pg.beginDraw();
    pg.background(180);
    pg.stroke(180);
    pg.fill(0);
    pg.rect(0,0,602,402);
    int x, y, z;
  
    for (x = 0; x < 13; x++) {
     for (y = 0; y < 41; y++) {
       pg.point(1 + (x * 50), 1 + (y * 10));
     }
    }
  
    for (y = 0; y < 9; y++) {
     for (x = 0; x < 61; x++) {
       pg.point(1 + (x * 10), 1 + (y * 50));
     }
    }
  
    for (y = 0; y < 41; y++) {
      pg.point(0 + (6 * 50), 1 + (y * 10));
      pg.point(2 + (6 * 50), 1 + (y * 10));
    }
  
    for (x = 0; x < 61; x++) {
      pg.point(1 + (x * 10), 0 + (4 * 50));
      pg.point(1 + (x * 10), 2 + (4 * 50));
    }
    if(hasData) {
      for(z = 2; z < 600; z++) {
        if (z % 2 == 0) {
          pg.stroke(color(#FDF200));
        } else {
          pg.stroke(color(#982395));
        }
        pg.line((z-2)*2,(float(list[z-2])-20)*2,z*2,(float(list[z])-20)*2);
      }
    }
    pg.endDraw();
    image(pg, 120, 40); 
    text("received: " + Status,500,400); 
    text(inString1 + "us",295,295);
} 


void serialEvent(Serial p) { 
  
  String data = p.readStringUntil(lf); 
  if (data != null) {
    data = trim(data);
    list = split(data, ':');
    if (list.length != 600) {
       Status = "BAD DATA"; 
    } else {
       Status = "OK"; 
       hasData = true;
    }
  } else {
    Status = "NO DATA";
  }
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
