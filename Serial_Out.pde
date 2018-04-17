Boolean CONNECTED = false;
Boolean CON_CHANGED = false;
int com = 1;
String Com = "COM";


void WritePort(String msg) {
  println("<**--WritePort(msg)");
  char [] portMsg=msg.toCharArray();
  for (int i=0; i<portMsg.length; i++) {
    port.write(portMsg[i]);
  }
}
