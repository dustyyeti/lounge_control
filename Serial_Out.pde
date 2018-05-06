Boolean CONNECTED = false; //<>//
Boolean CON_CHANGED = false;
int com = 1;
String Com = "COM";
String LoadLightProg [];



void WritePort(String msg) {
  println("<**--WritePort(msg)");

  char [] portMsg=msg.toCharArray();
  for (int i=0; i<portMsg.length; i++) {
    port.write(portMsg[i]);
  }
}
void MakeExecStr() {
  ExecStr = "";
  for (Light light : lights) {  //look through light array and build serial msg based on settings
    String GetMsg = LightMsg(light.buttI);//null,null,light.buttI);
    println(GetMsg);
    ExecStr = ExecStr +"|"+GetMsg;
  }
  ExecStr = ExecStr.substring(1);
}
void save () {
  println("<--save()");
  String[] FileStr = new String[1];
  MakeExecStr();

  printArray(FileStr);
  FileStr[0] = ExecStr;
  saveStrings("file.txt", FileStr);
}

void load () {
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
      color col=unhex ("FF"+x);  // try PApplet.unhex if there are problems 
      butts[i].setColorActive(col);
      butts[i].setLabel("LOADED");
    } else {
      butts[i].setOff();
      //butts[i].setColorActive(color(0));
    }
    println("prepare");
    println("closed");

  }
}
