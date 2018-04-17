Boolean CONNECTED = false;
Boolean CON_CHANGED = false;
int com = 1;
String Com = "COM";

//void SetCom() {
//  println("<--- SetCom()");
//  if (!CONNECTED ) {
//    Com = ("COM"+com);

//    //connect_B.setLabel("Try COM"+(com+1));
//    Router("connect",null);    
//    com++;
//    if (com > 11) com = 0;
//  }
//}
void WritePort(String msg) {
  println("<**--WritePort(msg)");
  char [] portMsg=msg.toCharArray();
  for (int i=0; i<portMsg.length; i++) {
    port.write(portMsg[i]);
  }
}
