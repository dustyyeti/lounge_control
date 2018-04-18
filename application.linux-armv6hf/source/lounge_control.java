import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import controlP5.*; 
import processing.serial.*; 
import java.util.ArrayList; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class lounge_control extends PApplet {





ControlP5 cp5;
Serial port;


Light[] lights;
GUI[] guis;


PFont font;
PImage bgImg;
PFont dripFont;

int rgbR = 0;
int rgbG = 20;
int rgbB = 100;

int cPick_def = color(rgbR, rgbG, rgbB, 100);
int cPick;
int offBlack;// = color (rgbR, rgbG, rgbB,255);


Button start;
Boolean PAUSE = true;

public void StartCom(String COM) {

  port = new Serial(this, COM, 9600);
  CONNECTED=true;
}

public void setup() {
  
  colorMode(RGB, 100);

  cp5 = new ControlP5(this);
  cPick = cPick_def;
  offBlack = color(rgbR*.25f, rgbG*.25f, rgbB*.25f);

  bgImg = loadImage("bg.jpg");
  bgImg.resize(width, height);
  font = createFont("calibri bold", 15);
  textFont(font);
  dripFont = loadFont("adrippingmarker-32.vlw"); 

  start = cp5.addButton("start")
    .setPosition(width/2 - width/3, height/2 -20)
    .setSize(width*2/3, 50)
    .setColorActive(cPick)
    .setLabel("Phil & Sarah M Disco Light Lounge Control")
    .setFont(dripFont)
    .setColorLabel(color(60, 100, 0))
    .setColorBackground(color(20, 190))
    ;
}

public void draw() {
  background(0);
  background(bgImg);
  // fill (255, 200, 0);
  //textAlign();

  text("Ver "+VerStr, margin, height - margin/2+5);  
  if (!PAUSE) {
    if (SETBUTTS) {
      guis[0].display("all");
      guis[1].display("red");
      guis[2].display("green");
      guis[3].display("blue");
    }
    fill(100);

    for (Light light : lights) {
      light.Display();
    }
  }
}

public void UnPause () {
  Survey();
  DrawGui();
  start.setSize(0, 0);
  PAUSE = false;
  start.hide();
  for (Light light : lights) {
    light.MakeButtons();
  }
}
PFont menuFont;
PImage playImg;
int margin = 20; // space between rows and columns of buttons, and window edge
int header = 70; // a top header space
int footer = 45;
int mH =  margin;
int unit;
int mMarg = 1;
int lounge_count;
int linenum = 0;

Slider sliders[];
Slider cSliders[];
Group groups[];

int numSliders = 2;
int numGroups = 3;
Boolean updated = false;
int origValue;
Textarea console;
Button connect_B, exec_B;

StringList statusLine;


public void lounge_count(int theValue) {
  println("--> loungeCount("+theValue);
}

public void DrawGui() {

  lounge_count = loungeCount;
  sliders = new Slider[numSliders];
  cSliders = new Slider[3];
  groups = new Group[numGroups];
  unit = width/6;
  menuFont = createFont("calibri light bold", 13);
  SetupMenu(unit, 0, 1); //x multiplier, w multiplier
  ProgMenu(unit, 1, 2);
  AssignMenu(unit, 3, 2);
  ExecButton(unit, 5, 1);
  DrawConsole();
}

public void UpdateUI(String msg) {
  println("\n<-- UpdateUI(msg: "
    +msg
    );
  printArray (statusLine);

  if (CON_CHANGED) {
    CONNECTED = !CONNECTED;
    if (CONNECTED) {
            exec_B.setLabel("EXECUTE");
      connect_B.setLabel("DISCONNECT");
      connect_B.setColorBackground(color(30, 100, 0));
      connect_B.setColorForeground(color(100, 30, 0));
    } else {
      exec_B.setLabel("NOT CONNECTED");
      connect_B.setLabel("CONNECT");
      connect_B.setColorForeground(color(30, 100, 0));
      connect_B.setColorBackground(color(100, 30, 0));
    }
    CON_CHANGED = !CON_CHANGED;
  }
  String t = MakeStatus(msg);//, false);
  console.setText(t);
  console.scroll(.9f);

  println("\n"+(linenum++)+"****************");
}

public String MakeStatus (String newText) {

  println ("--MakeStatus (newText: "
    +newText
    );
  if (!newText.isEmpty()) {
    statusLine.append("> "+newText);
  }
  String result = "";

  for  (String str : statusLine) {

    result += "\n" + str;
  }
  result += "\n> ";

  return result;
}

public void DrawConsole() {
  statusLine = new StringList();
  statusLine.append ("** NOT CONNECTED ** ");
  int side = lights[0].w *2/3;
  int w = width - (2*margin)-side;
  String t = MakeStatus(""); 

  console = cp5.addTextarea("console")
    .setPosition(margin, height-footer-margin)
    .setSize(w, footer)
    .setFont(createFont("consolas", 12))
    .setColor(color(100))
    .setColorBackground(color(45, 70, 95))
    .setColorForeground(100)
    .setText(t)
    ;
  connect_B = cp5.addButton("connect_B")
    .setPosition(margin+w+6, height-footer-margin+4)
    .setSize(side-8, footer-8)
    .setFont(createFont("arial", 10))
    .setColorForeground(color(20, 80, 0))
    .setColorBackground(color(80, 20, 0))
    .setLabel("CONNECT");
  ;
}

public void ExecButton(int unit, int xMult, int wMult) {
  exec_B= cp5.addButton("exec_B")
    .setPosition(unit*xMult, 0)
    .setWidth(unit*wMult-mMarg)
    .setHeight(mH)
    .setFont(menuFont)
    .setLabel("NOT CONNECTED")
    ;
}

public void SetupMenu(int unit, int xMult, int wMult) {
  println("<--SetupMenu (unit, xmult, wMult)");
  groups[0] = cp5.addGroup("SetupGrp")
    .setPosition(unit*xMult, mH)
    .setWidth(unit*wMult-mMarg)
    .setHeight(mH)
    .activateEvent(true)
    .setBackgroundColor(color(0, 85))
    .setBackgroundHeight(header)
    .setLabel("Setup")
    .setFont(menuFont)
    .close()
    ;
    
  sliders[0] = cp5.addSlider("lounge_count")
    .setPosition(unit*xMult, margin)
    .setWidth(unit*wMult)
    .setRange(1, 8)
    .setValue(lounge_count)
    .setGroup(groups[0])
    .setSliderMode(Slider.FLEXIBLE)
    .setLabel("Lounge Count")
    ;
  ;

  sliders[1] = cp5.addSlider("zoneCount")
    .setPosition(unit*xMult, header-(margin))
    .setWidth(unit*wMult)
    .setRange(1, 5)
    .setGroup(groups[0])
    .setSliderMode(Slider.FLEXIBLE)
    ;    

  // reposition the Label for controller 'slider'
  for (Slider slider : sliders) {
    slider.getValueLabel().align(ControlP5.RIGHT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
    slider.getCaptionLabel().align(ControlP5.LEFT, ControlP5.TOP_OUTSIDE).setPaddingX(0);
  }


  sliders[0].addCallback(new CallbackListener() {
    public void controlEvent(CallbackEvent theEvent) {
      switch(theEvent.getAction()) {
        case(ControlP5.ACTION_LEAVE): 
        println("released!");

        //SetLight(this, name, buttI);
        break;
      }
    }
  }        

  );

  //groups[0].addListener(new CallbackListener() {
  //  public void controlEvent(CallbackEvent theEvent) {
  //    switch(theEvent.getAction()) {
  //      case(ControlP5.ACTION_LEAVE): 
  //      println("released!");

  //      //SetLight(this, name, buttI);
  //      break;
  //    }
  //  }
  //}        

  //);
}

public void AssignMenu(int unit, int xMult, int wMult) {
  int x = unit * xMult;
  int w = unit * wMult;
  int sH = 18;
  int yellow =  color (100,100,100);
  CColor menuCol = new CColor(yellow,yellow,yellow,yellow,yellow);
  menuCol.setActive(color(100, 100, 100));
  menuCol.setBackground(color(100, 100, 100));  
    menuCol.setForeground(color(100, 100, 100));  
  groups[2] = cp5.addGroup("g3")
    .setPosition(x, mH)
    .setWidth(w)
    .setHeight(mH)
    .activateEvent(true)
    .setColor(menuCol)
    .setBackgroundColor(color(0, 85))
    .setBackgroundHeight(header)
    .setColorValue(color(100,0,0))
    .setColorActive(color(100,0,0,100))
    //.setColorForeground(color(cPick))
    .setLabel("Direct Assign")
    .setFont(menuFont)
    .close()
    ;
  cSliders[0] = cp5.addSlider("rgbR")
    .setPosition(0, 0)
    .setWidth(w-15)
    .setHeight(sH)
    .setRange(0, 100)
    .setColorBackground(color(100, 0, 0, 20))
    .setColorForeground(color(100, 0, 0))
    .setColorActive(color(100, 0, 0))    
    .setValue(rgbR)
    .setGroup(groups[2])
    .setLabel("R");
  ;
  cSliders[1] = cp5.addSlider("rgbG")
    .setPosition(0, 22)
    .setWidth(w-15)
    .setHeight(sH)    
    .setRange(0, 100)
    .setColorBackground(color(0, 100, 0, 20))
    .setColorForeground(color(0, 100, 0))
    .setColorActive(color(0, 100, 0))
    .setValue(rgbG)
    .setGroup(groups[2])
    .setLabel("G");
  ;
  cSliders[2] = cp5.addSlider("rgbB")
    .setPosition(0, 44)
    .setWidth(w-15)
    .setHeight(sH)
    .setRange(0, 100)
    .setColorBackground(color(0, 0, 100, 20))
    .setColorForeground(color(0, 0, 100))
    .setColorActive(color(0, 0, 100))
    .setValue(rgbB)
    .setGroup(groups[2])
    .setLabel("B");
  ;
}

public void ProgMenu(int unit, int xMult, int wMult) {
  int x = unit * xMult;
  int w = unit * wMult;
  groups[1] = cp5.addGroup("g2")
    .setPosition(x, mH)
    .setWidth(w)
    .setHeight(mH)
    .activateEvent(true)
    .setBackgroundColor(color(0, 85))
    .setBackgroundHeight(header)
    .setLabel("mode")
    .setFont(menuFont)
    .close()
    ;

  cp5.addRadioButton("radioButton")
    .setPosition(20, 10)
    .setSize(18, 18)
    .setColorForeground(color(0,75,0))
    .setColorBackground(color(40))
    .setColorActive(color(100))
    .setColorLabel(color(100))
    .setItemsPerRow(1)
    .setSpacingColumn(50)
    .addItem("Direct", 1)
    .addItem("Script", 2)   
    .setGroup(groups[1])
    .activate(0)
    ;
    
    cp5.addBang("save")
    .setPosition(120,19)
    .setSize (18,18)
    .setGroup(groups[1])
    ;
    cp5.addBang("load")
    .setPosition(160,19)
    .setSize (18,18)
    .setGroup(groups[1])
    ;
}
Button butts[];
CColor[] color1;

class Light {
  int x, y, w, h;
  int buttI;
  String name;
  int col;

  Light(int xIn, int yIn, int wIn, int hIn, String nameIn, int inCol, int inButtI) {
    x = xIn;
    y = yIn;
    w = wIn;
    h = hIn;
    name = nameIn;
    col = inCol;
    buttI = inButtI;
  }
  public CColor MakeCColor() {
    CColor col = new CColor();
    //col.setActive(color(0, 0, 100));
    //col.setForeground(color(cPick));
    //col.setBackground(color(0, 30));
    col.setCaptionLabel(color(100)); 
    return col;
  }
  public void Program(Boolean state, int buttI) { //clicked while in setcolor mode
    println("<##--Program(state, buttI "+state+" "+buttI);

    if (state) { // ready to program
      butts[buttI].setLabel("assign color");
      println();
      butts[buttI].setOff(); // during setcolor programing, there is no need to toggle the button on or off/ stay off.
    } else {
      butts[buttI].setLabel(lights[buttI].name);
      butts[buttI].setColorForeground(butts[buttI].getColor().getActive());
    }
  }
  public void MakeButtons() {
    String hColor  = "#"+(hex(color(cPick)).substring(2));
    //println("hColor = "+hColor);
    CColor col = new CColor();
    col.setActive(color(cPick));
    col.setForeground(color(cPick));
    col.setBackground(color(offBlack));
    col.setCaptionLabel(color(100));



    butts[buttI] = cp5.addButton(name).setPosition(x+buttCush, y+buttCush)
      .setSize(w-buttCush*3/2, h-buttCush*3/2)
      .setColor(col)
      .setSwitch(true)
      .setStringValue(hColor)
      .setFont(createFont("calibri light bold", 13))
      .setOff();      
    ;
    butts[buttI].addCallback(new CallbackListener() {
      public void controlEvent(CallbackEvent theEvent) {
        switch(theEvent.getAction()) {
          case(ControlP5.ACTION_RELEASE): 
          println("button listener captured ACTION_RELEASE");
          SetLight(buttI);//this, name, buttI);
          break;
        }
      }
    }        

    );
    //butts[buttI].addCallback(new CallbackListener() {
    //  public void controlEvent(CallbackEvent theEvent) {
    //    switch(theEvent.getAction()) {
    //      case(ControlP5.ACTION_ENTER): 
    //      println("button listener captured ACTION_ENTER");
    //      //SetLight(buttI);//this, name, buttI);
    //      break;
    //    }
    //  }
    //}        

    //);
  }
  public void Display() {  // draw edges around buttons. do this every frame with call from Draw()
    int sCol = butts[buttI].getColor().getActive();    
    //fill(0, 0, 0, 50);

    if (SETBUTTS) {
    }

    strokeWeight(10);    
    stroke (sCol);
    noFill();
    rect(x+5, y+5, w-10, h-10);

    stroke (color (100, 70));    
    strokeWeight(2);
    line(x-1, y+h+1, x+w+1, y+h+1);
    line(x+w+1, y+h+1, x+w+1, y-1);
    stroke (0, 0, 0, 70);
    line(x-1, y+h+1, x-1, y-1);
    line(x-1, y-1, x+w+1, y-1);
  }
}

public String LightMsg(int bi) {
  Boolean power = butts[bi].getBooleanValue();
  String lColor = butts[bi].getStringValue();

  String smsg;
  if (power) {
    smsg = "<+"+bi+"*"+lColor+">";
  } else {
    smsg = "<-"+bi+">";
  }
  return smsg;
}


public void SetLight(int bi) { //CallbackListener bang, String bName, int bi) {
  println ("<--SetLight(bi)");//listener, bname, bi)");
  String hColor  = "#"+(hex(color(cPick)).substring(2));
  println(hColor);
  //println(power); //toggle on or off?

  String smsg = LightMsg(bi);

  //println(smsg);
  if (SETBUTTS) {
    butts[bi].setColorActive(cPick);
    //butts[bi].setColorForeground(cPick);

    butts[bi].setStringValue(hColor);
    butts[bi].setOff();
  } else {
    Router("out", smsg);
  }
}

public void ProgramLights() {
}
Boolean SETBUTTS = false; //<>// //<>//
String ExecStr;


public void Router(String go, String msg) {  //
  println("<--- Router(go, msg: " 
    +go
    +", "
    +msg
    );

  String updateText = "";


  if (go == "rgbR" || go == "rgbG" || go == "rgbB") {
    cPick = color(rgbR, rgbG, rgbB, 100);
    offBlack = color (rgbR*.25f, rgbG*.25f, rgbB*.25f);
    println ("SEEEEE "+SETBUTTS);

    if (SETBUTTS) {  // the slider change conditions should only be reached when SETBUTTS, anyway, but this ensures no GUI events get confused.
      for (Light light : lights) {
        println("is it this <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<");
        butts[light.buttI].setColorForeground(cPick); // foreground is when hovered  //DEBUG
        //butts[light.buttI].setColorActive(cPick);  // active is when ON
      }
    }
  }



  switch(go) {
  case "start":
    UnPause();
    break;
  case "exec_B":
    MakeExecStr();
    println ("hey bozo: "+ExecStr);
    //UpdateUI(ExecStr);
    if (CONNECTED) {


      WritePort(ExecStr);
    } else {
      println ("not connected");
      UpdateUI("No serial connectin has been achieved.");
    }

    break;
  case "g3": // GUI group 3, program menu
    SETBUTTS = Boolean.parseBoolean(msg);  //str convert message to bool true/false

    if (SETBUTTS) {
      for (int i = 0; i<lightCount; i++) {
        //color1[i]=butts[i].getColor().getForeground(); //get the current BG color
        lights[i].Program(Boolean.valueOf(msg), i);
      }
    } else {  //leaving set mode; restore the colors to the BG color
      for (int i = 0; i<lightCount; i++) {
        //butts[i].setColorBackground(colBG[i]);
        lights[i].Program(Boolean.valueOf(msg), i);
        //println(hex(color1[i], 6));
        //colBG[i]=butts[i].getColor().getBackground(); //get the current BG color
        //lights[i].Program(Boolean.valueOf(msg), i);
      }
    }

    break;
  case "lounge_count":
    updateText = (lounge_count +" lounges zoned");
    break;
  case "connect_B":
    if (!CONNECTED) {
      try {
        port= new Serial(this, Serial.list()[0], 9600);
        //if (Serial.list()[0].isEmpty()) {        }
        updateText = "Wahooo! connected @ "+Serial.list()[0];
        
        Com=Serial.list()[0];
        CON_CHANGED = true;
      } 
      catch (Exception e) {
        updateText = "Booo, can't find a valid serial connection!  :(";
      }
    } else {
      updateText = "Ok, I'll disconnect...";
      CON_CHANGED=true;
    }
    break;
  case "out":
    updateText = msg;
    if (CONNECTED) {
      updateText = "dance, slime! "+updateText;
      //Router("exec_B", ""); //send to the execute routine to sweep all the lights to the serial port
      return;
    } else {
      updateText = "set msg: " + updateText;
    }
    break;
  default:
    println("default case, no actions here yet");
    return; //this return breaks the light button listener event to prevent the rest of router control
  }
  UpdateUI(updateText);
  console.scroll(.9f);
}

//**************************************************************
public void controlEvent(ControlEvent theEvent) {
  println("*** GUI EVENT");
  String conName="";
  if (theEvent.isController()) {
    conName =  theEvent.getController().getName();
    println ("This isController: "+conName);
    Router(conName, null);
  }
  if (theEvent.isGroup()) {
    String ISOPEN = str(theEvent.getGroup().isOpen());
    println("got an event from group "
      +theEvent.getGroup().getName()
      +", isOpen? "+theEvent.getGroup().isOpen()
      );
    conName =  theEvent.getGroup().getName();
    Router(conName, ISOPEN);
  }
}
Boolean CONNECTED = false;
Boolean CON_CHANGED = false;
int com = 1;
String Com = "COM";
String LoadLightProg [];


public void WritePort(String msg) {
  println("<**--WritePort(msg)"); //<>//
    
  char [] portMsg=msg.toCharArray();
  for (int i=0; i<portMsg.length; i++) {
    port.write(portMsg[i]);
  }
}
public void MakeExecStr() {
  ExecStr = "";
  for (Light light : lights) {  //look through light array and build serial msg based on settings
    String GetMsg = LightMsg(light.buttI);//null,null,light.buttI);
    println(GetMsg);
    ExecStr = ExecStr +"|"+GetMsg;
  }
  ExecStr = ExecStr.substring(1);
}
public void save () {
  println("<--save()");
  String[] FileStr = new String[1];
  MakeExecStr();

  printArray(FileStr);
  FileStr[0] = ExecStr;
  saveStrings("file.txt", FileStr);
}

public void load () {
  println("<--load()");  
  String[] FileStr = loadStrings("file.txt");
  String tempStr="";
  String[] SetStr;
  println("there are " + FileStr.length + " lines");
  for (int i = 0; i < FileStr.length; i++) {
    println(FileStr[i]);
    tempStr += FileStr[i]; //get the array into a string
  }
  LoadLightProg = split(tempStr, '|');
  for (int i=0; i<LoadLightProg.length; i++) {
    print(LoadLightProg[i]);
    SetStr = split(LoadLightProg[i], '*');
    if (SetStr.length > 1) {
      butts[i].setOn();
      String x = SetStr[1].substring(1, 7);
      int col=unhex ("FF"+x);  // try PApplet.unhex if there are problems 
      butts[i].setColorActive(col);
      butts[i].setLabel("LOADED");
    } else {
      butts[i].setOff();
      //butts[i].setColorActive(color(0));
    }
    groups[1].close();
  }
}
int loungeCount = 6;
int zoneCount =3;

int buttCush = 6;
int lightCount;

public void Survey() {
  int guicount = 4;  
  lightCount = loungeCount * zoneCount;
  lights = new Light[lightCount];
  butts = new Button[lightCount];
  guis = new GUI[guicount];
  color1 = new CColor[lightCount];

  guis[0] = new GUI(margin, margin, width-(2*margin), header);//, rgbR, rgbG, rgbB);
  int gOff = 1; //offset between GUI rectangles
  int gH = guis[0].h/3-gOff;
  float gW = gH*1.6f; // because the gui boxes are square  
  for (int i = 1; i < guicount; i++) {
    guis[i] = new GUI(guis[0].x+gOff, guis[0].y+gH*(i-1)+(gOff*2), PApplet.parseInt(gW), gH);
  }
  //calcluate button sizes
  int bW = ((width - margin ) / (zoneCount)) - margin;
  int bH = ((height - header - footer - (3*margin)) / (loungeCount) ) - margin;  
  int bX, bY;
  int bX2, bY2;
  int index = 0;
  String bName;
  for (int y = 0; y < loungeCount; y++) {
    for (int x = 0; x < zoneCount; x++) {
      bX = margin + (x*bW+ margin * x);
      bY = header + (margin*2) + (y*bH+ margin * y);
      bName = "# Light "+(index+1)+"   ["+(y+1)+"-"+(x+1)+"]";  
      lights[index] = new Light(bX, bY, bW, bH, bName, cPick, index++);
      //println(lights[index-1]+" specifications stored.");
    }
  }
}

class GUI {
  int x, y, w, h;
  //int guiI;
  //int R, G, B;
  //String channel;

  GUI(int xIn, int yIn, int wIn, int hIn) {
    ; //, int inR, int inG, int inB) {
    x = xIn;
    y = yIn;
    w = wIn;
    h = hIn;

  }
  public void update() {
  }
  public void makeGUI() {
  }
  public void display(String channel) {
    int R=0;
    int G=0;
    int B=0;
    String t = "";
    switch(channel) {
    case "red":
      R=rgbR;
      t = str(R);
      break;
    case "green":
      G=rgbG;
      t = str(G);
      break;
    case "blue":
      B=rgbB;
      t = str(B);
      break;
    case "all":
      R=rgbR;
      G=rgbG;
      B=rgbB;
      break;
    }
    noStroke();
    fill (R, G, B, 255);
    rect(x, y, w, h);
    fill (255, 255, 255);
    text (t, x, y+h);
  }
}
String VerStr = "0.9.0";

/*

> here's an online java compiler
https://compiler.javatpoint.com/opr/test.jsp?filename=StringToCharArrayExample


************
* About CColor for controlP5
************

CColor() 
CColor(CColor theColor) 
CColor(int cfg, int cbg, int cactive, int ccl, int cvl)   foreground, background, active, captionlabel, valuelabel

CColor col = new CColor();
col.setActive(color(r, g, b, a));  //active is when toggled on, or pressed 
col.setForgroud   // foreground is the mouse over
setBackground //color when turned off
 
Boolean boolean1 = Boolean.valueOf("true");
boolean boolean2 = Boolean.parseBoolean("true");


Initilaize variables
+ naming conventions

String[] StrArray = new String[100];
 
 */
  public void settings() {  size(721, 721); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "lounge_control" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
