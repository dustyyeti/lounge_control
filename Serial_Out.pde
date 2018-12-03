Boolean CONNECTED = false;
Boolean CON_CHANGED = false;
int com = 1;
String Com = "COM";
String LoadLightProg [];


void WritePort(String msg) {
  println("<**--WritePort(msg)"); //<>//
    
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

  FileStr[0] = coneCount+":"+scannerCount+"/"+ExecStr;
  //FileStr[0] = ExecStr;
  println(FileStr[0]+" <----ExecStr");
  saveStrings("file.txt", FileStr);
}

//-- sample output string:
//>>  5:1/<+0*#0033FF>|<+1*#0033FF>|<-2>|<+3*#0033FF>|<-4>

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
  String parse[] = split(tempStr,'/');
  coneCount = int(parse[0]);
  scannerCount = int(parse[1]);
  LoadLightProg = split(parse[1], '|');
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
    groups[1].close();
  }
}
