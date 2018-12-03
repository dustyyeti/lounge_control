int coneCount = 5;
int scannerCount =1;

int buttCush = 6;
int lightCount;

void Survey() {
  int guicount = 4;  
  lightCount = coneCount * scannerCount;
  lights = new Light[lightCount];
  butts = new Button[lightCount];
  guis = new GUI[guicount];
  color1 = new CColor[lightCount];

  //> create program guis= the color bars shown when the program menu is open
  guis[0] = new GUI(2, margin, width/6*5, header);//width-(2*margin), header);
  int gOff = 1; //offset between GUI rectangles
  int gH = guis[0].h/3-gOff;
  float gW = gH*1.6; // because the gui boxes are square  
  for (int i = 1; i < guicount; i++) {
    guis[i] = new GUI(guis[0].x+gOff, guis[0].y+gH*(i-1)+(gOff*2), int(gW), gH);
  }
  //calcluate button sizes
  int bW = ((width - margin ) / (scannerCount)) - margin;
  int bH = ((height - header - footer - (3*margin)) / (coneCount) ) - margin;  
  int bX, bY;
  int bX2, bY2;
  int index = 0;
  String bName;
  for (int y = 0; y < coneCount; y++) {
    for (int x = 0; x < scannerCount; x++) {
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
  void update() {
  }
  void makeGUI() {
  }
  void butt(){
    
  }
  void display(String channel) {
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
