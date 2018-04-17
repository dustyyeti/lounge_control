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
//Lounge Inital settings

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
//String[] statusLine;


void lounge_count(int theValue) {
  println("--> loungeCount("+theValue);
}

void DrawGui() {

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

void UpdateUI(String msg) {
  println("\n<-- UpdateUI(msg: "
    +msg
    );
  printArray (statusLine);
  String bufText = console.getText();  
  String conText = "";

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



  //connect_B.setLock(true);  //for some reason this locks the entire UI
  //  conText = bufText 
  //    + "\n"
  //    +msg
  //    + "\n"
  //    +">  ";
  //} else {
  //  conText = bufText 
  //    + "\n"
  //    +msg
  //    + "\n"
  //    +"> ";    
  //  connect_B.setLabel("Connect");
  //  console.setText("> ");
  //}
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
    .setPosition(margin+w+6, height-footer-margin+4)
    .setSize(side-8, footer-8)
    .setFont(createFont("arial", 10))
    .setColorForeground(color(20, 80, 0))
    .setColorBackground(color(80, 20, 0))
    .setLabel("CONNECT");
  //.setColor(color(128))
  //.setColorBackground(color(0, 0, 50, 255))
  //.setColorForeground(color(255, 100))
  ;
}

void ExecButton(int unit, int xMult, int wMult) {
  exec_B= cp5.addButton("exec_B")
    .setPosition(unit*xMult, 0)
    .setWidth(unit*wMult-mMarg)
    .setHeight(mH)
    //.setBackgroundColor(color(0, 210))
    //.setLabel("Setup")
    .setFont(menuFont)
    //.setImage(playImg)
    .setLabel("NOT CONNECTED")
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
  sliders[0] = cp5.addSlider("lounge_count")
    .setPosition(unit*xMult, margin)
    .setWidth(unit*wMult)
    .setRange(1, 8)
    .setValue(lounge_count)
    .setGroup(groups[0])
    .setSliderMode(Slider.FLEXIBLE)
    .setLabel("Lounge Count");
  ;

  sliders[1] = cp5.addSlider("zoneCount")
    .setPosition(unit*xMult, header-(margin))
    .setWidth(unit*wMult)
    //.setSize(unit * wMult-4, 12)
    .setRange(1, 5)
    //.setNumberOfTickMarks(8)
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

void AssignMenu(int unit, int xMult, int wMult) {
  int x = unit * xMult;
  int w = unit * wMult;
  int sH = 18;
  color yellow =  color (100,100,100);
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
    .setPosition(20, 15)
    .setSize(20, 20)
    .setColorForeground(color(40))
    .setColorActive(color(100))
    .setColorLabel(color(100))
    .setItemsPerRow(2)
    .setSpacingColumn(50)
    .addItem("Direct", 1)
    .addItem("Script", 2)
    //.addItem("150", 3)
    //.addItem("200", 4)
    //.addItem("250", 5)
    .setGroup(groups[1])
    .activate(0)
    ;
}
