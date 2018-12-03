PFont menuFont;
PImage playImg;
int margin = 20; // space between rows and columns of buttons, and window edge
int header = 80; // a top header space
int footer = 45;
int mH =  margin;
int unit;
int mMarg = 1;
int cone_count;
int scanner_count;
int linenum = 0;

Slider sliders[];
Slider cSliders[];
Group groups[];

int numSliders = 2;
int numGroups = 3;
Boolean updated = false;
int origValue;
Textarea console;
Button connect_B, exec_B, setAll_B;

StringList statusLine;


void cone_count(int theValue) {
  println("--> coneCount("+theValue);
}

void DrawGui() {
  println("\n<-- DrawGui()");
  cone_count = coneCount;
  sliders = new Slider[numSliders];
  cSliders = new Slider[3];
  groups = new Group[numGroups];
  unit = width/6;
  menuFont = createFont("calibri light bold", 13);
  SetupMenu(unit, 0, 1); //x multiplier, w multiplier
  ProgMenu(unit, 1, 2);
  AssignMenu(unit, 3, 2);
  ExecButton(unit, 5, 1);
  SetAllButton(unit, 5, 1);
  DrawConsole();
}

void UpdateUI(String msg) {
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
  console.scroll(.9);

  println("\n"+(linenum++)+"****************");
}

String MakeStatus (String newText) {

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

void DrawConsole() {
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
    .setBroadcast(false)
    .setPosition(margin+w+6, height-footer-margin+4)
    .setSize(side-8, footer-8)
    .setFont(createFont("arial", 10))
    .setColorForeground(color(20, 80, 0))
    .setColorBackground(color(80, 20, 0))
    .setLabel("CONNECT")
    .setBroadcast(true);
  ;
}
void SetAllButton(int unit, int xMult, int wMult) {
  setAll_B= cp5.addButton("setAll_B")
    .setBroadcast(false)
    .setPosition(unit*xMult+mMarg, (header-mH*2))
    .setWidth(unit*wMult-(mMarg*3))
    .setHeight(mH*2)
    .setFont(menuFont)
    .setLabel("Assign All")
    .hide()
    .setBroadcast(true)
    ;
}
void ExecButton(int unit, int xMult, int wMult) {
  exec_B= cp5.addButton("exec_B")
    .setBroadcast(false)
    .setPosition(unit*xMult, 0)
    .setWidth(unit*wMult-mMarg)
    .setHeight(mH)
    .setFont(menuFont)
    .setLabel("NOT CONNECTED")
    .setBroadcast(true)
    ;
}

void SetupMenu(int unit, int xMult, int wMult) {
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

  sliders[0] = cp5.addSlider("cone_count")
    .setBroadcast(false)
    .setPosition(unit*xMult+5, margin)
    .setWidth(unit*wMult-10)
    .setRange(1, 6)
    .setValue(cone_count)
    .setGroup(groups[0])
    .setSliderMode(Slider.FLEXIBLE)
    //.setLabel("cone Count")
    .setNumberOfTickMarks(6)
    .setBroadcast(true)
    ;
  ;

  sliders[1] = cp5.addSlider("scanner_count")
    .setBroadcast(false)
    .setPosition(unit*xMult+5, header-(margin))
    .setWidth(unit*wMult-10)
    .setRange(1, 3)
    .setValue(scanner_count)
    .setGroup(groups[0])
    .setSliderMode(Slider.FLEXIBLE)
    .setNumberOfTickMarks(3)
    .setBroadcast(true)
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

void AssignMenu(int unit, int xMult, int wMult) {
  int x = unit * xMult;
  int w = unit * wMult;
  int sH = 18;
  color yellow =  color (100, 100, 100);
  CColor menuCol = new CColor(yellow, yellow, yellow, yellow, yellow);
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
    .setColorValue(color(100, 0, 0))
    .setColorActive(color(100, 0, 0, 100))
    //.setColorForeground(color(cPick))
    .setLabel("Program")
    .setFont(menuFont)
    .close()
    ;
  cSliders[0] = cp5.addSlider("rgbR")
    .setBroadcast(false)
    .setPosition(0, 0)
    .setWidth(w-15)
    .setHeight(sH)
    .setRange(0, 100)
    .setColorBackground(color(100, 0, 0, 20))
    .setColorForeground(color(100, 0, 0))
    .setColorActive(color(100, 0, 0))    
    .setValue(rgbR)
    .setGroup(groups[2])
    .setLabel("R")
    .setBroadcast(true);
  ;
  cSliders[1] = cp5.addSlider("rgbG")
    .setBroadcast(false)
    .setPosition(0, 22)
    .setWidth(w-15)
    .setHeight(sH)    
    .setRange(0, 100)
    .setColorBackground(color(0, 100, 0, 20))
    .setColorForeground(color(0, 100, 0))
    .setColorActive(color(0, 100, 0))
    .setValue(rgbG)
    .setGroup(groups[2])
    .setLabel("G")
    .setBroadcast(true);
  ;
  cSliders[2] = cp5.addSlider("rgbB")
    .setBroadcast(false)
    .setPosition(0, 44)
    .setWidth(w-15)
    .setHeight(sH)
    .setRange(0, 100)
    .setColorBackground(color(0, 0, 100, 20))
    .setColorForeground(color(0, 0, 100))
    .setColorActive(color(0, 0, 100))
    .setValue(rgbB)
    .setGroup(groups[2])
    .setLabel("B")
    .setBroadcast(true);
  ;
}

void ProgMenu(int unit, int xMult, int wMult) {
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
    .setColorForeground(color(0, 75, 0))
    .setColorBackground(color(40))
    .setColorActive(color(100))
    .setColorLabel(color(100))
    .setItemsPerRow(1)
    .setSpacingColumn(50)
    .addItem("Execute", 1)
    .addItem("Script", 2)   
    .setGroup(groups[1])
    .activate(0)
    ;

  cp5.addBang("save")
    .setBroadcast(false)
    .setPosition(120, 19)
    .setSize (18, 18)
    .setGroup(groups[1])
    .setBroadcast(true)
    ;
  cp5.addBang("load")
    .setBroadcast(false)
    .setPosition(160, 19)
    .setSize (18, 18)
    .setGroup(groups[1])
    .setBroadcast(true)
    ;
}
