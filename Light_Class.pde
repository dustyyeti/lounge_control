Button butts[];
CColor[] color1;

class Light {
  int x, y, w, h;
  int buttI;
  String name;
  color col;

  Light(int xIn, int yIn, int wIn, int hIn, String nameIn, color inCol, int inButtI) {
    println ("---> new Light(nameIn: "+nameIn);
    x = xIn;
    y = yIn;
    w = wIn;
    h = hIn;
    name = nameIn;
    col = inCol;
    buttI = inButtI;
  }
  CColor MakeCColor() {
    CColor col = new CColor();
    //col.setActive(color(0, 0, 100));
    //col.setForeground(color(cPick));
    //col.setBackground(color(0, 30));
    col.setCaptionLabel(color(100)); 
    return col;
  }
  void Program(Boolean state, int buttI) { //clicked while in setcolor mode
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
  void MakeButtons() {
    String hColor  = "#"+(hex(color(cPick)).substring(2));
    //println("hColor = "+hColor);
    CColor col = new CColor();
    col.setActive(color(cPick));
    col.setForeground(color(cPick));
    col.setBackground(color(offBlack));
    col.setCaptionLabel(color(100));



    butts[buttI] = cp5.addButton(name).setPosition(x+buttCush, y+buttCush)
      .setBroadcast(false)
      .setSize(w-buttCush*3/2, h-buttCush*3/2)
      .setColor(col)
      .setSwitch(true)
      .setStringValue(hColor)
      .setFont(createFont("calibri light bold", 13))
      .setOff()
          .setBroadcast(true);      
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
  void Display() {  // draw edges around buttons. do this every frame with call from Draw()
    color sCol = butts[buttI].getColor().getActive();    
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

String LightMsg(int bi) {
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


void SetLight(int bi) { //CallbackListener bang, String bName, int bi) {
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

void ProgramLights() {
}
