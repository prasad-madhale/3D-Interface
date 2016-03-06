import processing.serial.*;
import processing.opengl.*;
import peasy.*;
import peasy.org.apache.commons.math.*;
import peasy.org.apache.commons.math.geometry.*;
import peasy.test.*;
import processing.serial.*;

PeasyCam cam;
int x=10,y=10;
static int k;
static float rheight;

Serial serial;


//Serial serial;
int serialPort = 0;   // << Set this to be the serial port of your Arduino - ie if you have 3 ports : COM1, COM2, COM3 
                      // and your Arduino is on COM2 you should set this to '1' - since the array is 0 based
     
int sen = 3; // sensors
int div = 4,ind=0; // board sub divisions

Normalize n[] = new Normalize[sen];
MomentumAverage cama[] = new MomentumAverage[sen];
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
  //size(900, 700, OPENGL, P3D);
  fullScreen(OPENGL);
  frameRate(25);
  
  
    font = loadFont("TrebuchetMS-Italic-20.vlw");
  textFont(font);
  textMode(SHAPE);
  
  cam = new PeasyCam(this,200);
  cam.setMinimumDistance(300);
  cam.setMaximumDistance(400);
  cam.setPitchRotationMode();
  //for(int i=0;i<=1000;){
  //cam.setRotations(i, 800, i);
//i=//i+50;
  //}
 cam.rotateX(PI/3.0);
  cam.rotateY(PI/7.0);
   cam.rotateZ(PI);
  //cam.setRotations(100, 800, 100);
  
  
  //printArray(Serial.list());
  serial = new Serial(this, Serial.list()[serialPort], 115200);
  
  for(int i = 0; i < sen; i++) {
    n[i] = new Normalize();
    cama[i] = new MomentumAverage(.01);
    axyz[i] = new MomentumAverage(.15);
  }
  
  
//lines =loadStrings("cords.txt");
  //println(lines);
  

      


  reset();

}

void draw() {
   
  updateSerial();
  
  drawBoard();
  


  

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
        
        
        
        if(ixyz[1]==3){if(rheight<100)
            rheight= 10;
             
              //else rheight=10;
          redraw();// rheight=10;
        }
          else if(ixyz[1]==2){ if(rheight<100)
            rheight= 40;
              //else rheight=10;
              
          redraw();
        //rheight=10;
      }
          else if(ixyz[1]==1){ if(rheight<=100)
            rheight=70;
             // else rheight=70;
          redraw();
          
       // rheight=10;  
        }
          else  { 
            //if(rheight<100)
            rheight= 100;
              //else rheight=10;
              
           redraw();
        //rheight=10; 
        }
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
      background(255);                 
   pushMatrix();
   translate(35,-50,0);
    for(int x=-50;x<=50;x+=18)
    {    
       for(int y=-50;y<=50;y+=18)
          {
             
               pushMatrix();
               translate(x,y,0);
               boxT();
              //if(x==-50 && y==-50 )
//{box(10,10,20)//; }
           //if(x!=-50 && y!=-50 )
    //{    boxT();}
           
               
                
               popMatrix();
          }
       }
     popMatrix();
    
    
  
    
    

    
  stroke(0);
  if(mousePressed && mouseButton == LEFT)
    msg("defining boundaries");
}




void boxT()
{
  fill( random(255), random(255), random(255), random(255)); 
  strokeWeight(4);
  pushMatrix();
  // rheight=random(50)+1;
  translate(0, 0, rheight/2);
  //delay(10);
  box(10, 10, rheight);
  popMatrix();
  


}



void mousePressed() {
  if(mouseButton == RIGHT)
    reset();

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
  println(msg);
}