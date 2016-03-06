import processing.serial.*;
import processing.opengl.*;
import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import peasy.test.*;

import peasy.*;
PeasyCam cam;
Serial serial;
int serialPort = 0;   // << Set this to be the serial port of your Arduino - ie if you have 3 ports : COM1, COM2, COM3 
                      // and your Arduino is on COM2 you should set this to '1' - since the array is 0 based
    
int sen = 3; // sensors
int div = 4,ind=0; // board sub divisions

Normalize n[] = new Normalize[sen];
Mom2 cama[] = new Mom2[sen];
MomentumAverage axyz[] = new MomentumAverage[sen];
float[] nxyz = new float[sen];
int[] ixyz = new int[sen];

float w = 256; // board size
boolean[] flip = {
  false, true, false};

int player = 0;
boolean moves[][][][];

PFont font;

void setup() {
  //size(800, 600,P3D);
  fullScreen(OPENGL);
  frameRate(25);
  cam=new PeasyCam(this,100);
  font = loadFont("TrebuchetMS-Italic-20.vlw");
  textFont(font);
  textMode(SHAPE);
  
  //printArray(Serial.list());
  serial = new Serial(this, Serial.list()[serialPort], 115200);
  
  for(int i = 0; i < sen; i++) {
    n[i] = new Normalize();
    cama[i] = new Mom2(.1);
    axyz[i] = new MomentumAverage(.15);
  }
  
  
//lines =loadStrings("cords.txt");
  //println(lines);
  
    
      

  reset();
}

void draw() {
  updateSerial();
  background(255);
  drawBoard();
  
   camera();

hint(DISABLE_DEPTH_TEST); 
 textFont(font);
  textMode(MODEL);
  textSize(50);
  fill(0);
  text("STOP", 145, 660);

flick();
rect(100, 600,200, 100,15);

textSize(50);
fill(255,0,0,120);
text("3D CAMERA",550,50);
hint(ENABLE_DEPTH_TEST);


}

void updateSerial() {
   String cur = serial.readStringUntil('\n');
  if(cur != null) {
    //println(cur);
    String[] parts = split(cur, " ");
    if(parts.length == sen  ) {
      float[] xyz = new float[sen];
      for(int i = 0; i < sen; i++)
        xyz[i] = float(parts[i]);
  
      if(mousePressed && mouseButton == LEFT)
        for(int i = 0; i < sen; i++)
          n[i].note(xyz[i]);
  
      nxyz = new float[sen];
      for(int i = 0; i < sen; i++) {
        float raw = n[i].choose(xyz[i]);
        nxyz[i] = flip[i] ? 1 - raw : raw;
        cama[i].note(nxyz[i]);
        axyz[i].note(nxyz[i]);
        ixyz[i] = getPosition(axyz[i].avg);
      }
    }
  }
}

float cutoff = .2;
int getPosition(float x) {
  if(div == 4) {
    if(x < cutoff)
      return 0;
    if(x <0.5- cutoff)
      return 1;
    else if(x< 1-cutoff)
      return 2;
     else 
       return 3;
  } 
  else {
    return x == 1 ? div - 1 : (int) x * div;
  }
}

void drawBoard() {
 

  float h = w / 2;
  camera(
  (h + (cama[0].avg - cama[2].avg) * h)*2,
 (h + (cama[1].avg - 1) * height / 2)*2,
  w*2,
  h, h, h,
  0, 1, 0);
  


// camera(
//  mouseX*2,
//   mouseY*2,
//   w * 2,
//   h, h, h,
//   0, 1, 0);




  pushMatrix();
  
  // Due to a currently unresolved issue with Processing 2.0.3 and OpenGL depth sorting,
  // we can't fill the large box without hiding the rest of the boxes in the scene.
  // We'll use a stroke for this one instead.
  noFill();
  stroke(0, 80);
  strokeWeight(10);  // Beastly
line(20, 70, 80, 70);
  translate(w/2, w/2, w/2);
  
  
  
  rotateY(-.8);
   // rotateX(360);
    //rotateZ(360);
  fill(255,0,40);
  box(w);
  popMatrix();

  float sw = w / div;
  translate(h, sw / 2, 0);
 // rotateZ(HALF_PI);
  
 
  stroke(0);
  if(mousePressed && mouseButton == LEFT)
    msg("defining boundaries");
}



void mousePressed() {
  if(mouseButton == RIGHT)
    reset();
         else if(mouseX>=100 && mouseX<=300 && mouseY>=600 && mouseY<=700)
{
    exit();
}
}

void reset() {
  moves = new boolean[2][div][div][div];
  for(int i = 0; i < sen; i++) {
    n[i].reset();
    cama[i].reset();
    axyz[i].reset();
  }
}

void msg(String msg) {
  //using 'text(msg, 10, height - 10)' results in an exception being thrown in Processing 2.0.3 on OSX
  //we're going to use the console to output instead.
  println(msg);
}

void flick()
{
  //rect(100, 600,200, 100,15);
if(mouseX>=100 && mouseX<=300 && mouseY>=600 && mouseY<=700)
{
   fill(255,0,0,120);
}
else
{
    fill(0, 100);
}
}