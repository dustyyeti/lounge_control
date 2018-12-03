import controlP5.*;
import processing.serial.*;
import java.util.ArrayList;

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

color cPick_def = color(rgbR, rgbG, rgbB, 100);
color cPick;
color offBlack;// = color (rgbR, rgbG, rgbB,255);


Button start;
Boolean PAUSE = true;

void StartCom(String COM) {

  port = new Serial(this, COM, 9600);
  CONNECTED=true;
}

void setup() {
  size(721, 721);
  colorMode(RGB, 100);

  cp5 = new ControlP5(this);
  cPick = cPick_def;
  offBlack = color(rgbR*.25, rgbG*.25, rgbB*.25);

  bgImg = loadImage("bg.jpg");
  bgImg.resize(width, height);
  font = createFont("calibri bold", 15);
  textFont(font);
  dripFont = loadFont("adrippingmarker-32.vlw"); 

  start = cp5.addButton("Start")
    .setBroadcast(false)
    .setPosition(width/2 - width/3, height/2 -20)
    .setSize(width*2/3, 50)
    .setColorActive(cPick)
    .setLabel("Phil & Sarah M Disco Light Cone Control")
    .setFont(dripFont)
    .setColorLabel(color(60, 100, 0))
    .setColorBackground(color(20, 190))
    .setBroadcast(true)
    ;
}

void draw() {
  //background(0);
  background(bgImg);
  // fill (255, 200, 0);
  //textAlign();

  text("Ver "+VerStr, margin, height - margin/2+5);  
  if (!PAUSE) {
    if (SETBUTTS) {  //program mode--reveal extra GUI >> GUI class
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

void Start () {
  Survey();
  if (initTF) DrawGui();
  start.setSize(0, 0);
  PAUSE = false;
  start.hide();
  for (Light light : lights) {
    light.MakeButtons();
  }
  initTF = false;
}
