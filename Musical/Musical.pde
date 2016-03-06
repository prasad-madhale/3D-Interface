import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import processing.serial.*;
import processing.opengl.*;

Serial serial;
int serialPort = 0;   // << Set this to be the serial port of your Arduino - ie if you have 3 ports : COM1, COM2, COM3 
                      // and your Arduino is on COM2 you should set this to '1' - since the array is 0 based
int[] p=new int[37];   
AudioPlayer aplayer1,aplayer2,aplayer3,aplayer4,aplayer5,aplayer6,aplayer7,aplayer8,aplayer9,aplayer10,aplayer11,aplayer12,aplayer13,aplayer14,aplayer15,aplayer32,aplayer33,aplayer34,aplayer37;
AudioPlayer aplayer16,aplayer17,aplayer18,aplayer19,aplayer20,aplayer21,aplayer22,aplayer23,aplayer24,aplayer25,aplayer26,aplayer27,aplayer28,aplayer29,aplayer30,aplayer31,aplayer35,aplayer36;
PImage bg;
Minim minim;//audio context


int sen = 3; // sensors
int div = 3; // board sub divisions

Normalize n[] = new Normalize[sen];
MomentumAverage cama[] = new MomentumAverage[sen];
MomentumAverage axyz[] = new MomentumAverage[sen];
float[] nxyz = new float[sen];
int[] ixyz = new int[sen];

float w = 256; // board size
boolean[] flip = {
  false, true, false};
    float[] xyz = new float[sen];
int player = 0;
boolean moves[][][][];

PFont font;

void setup() {
  //size(800, 600, OPENGL);
  fullScreen(OPENGL);
  //frameRate(25);
  bg=loadImage("back.jpg");
  
   minim = new Minim(this);
  aplayer1= minim.loadFile("music/1.mp3", 2048);
  aplayer2= minim.loadFile("music/2.mp3", 2048);
  aplayer3 = minim.loadFile("music/3.mp3", 2048);
  aplayer4 = minim.loadFile("music/4.mp3", 2048);
  aplayer5 = minim.loadFile("music/5.mp3", 2048);
  aplayer6 = minim.loadFile("music/6.mp3", 2048);
  aplayer7 = minim.loadFile("music/7.mp3", 2048);
  aplayer8 = minim.loadFile("music/8.mp3", 2048);
  aplayer9 = minim.loadFile("music/9.mp3", 2048);
  aplayer10 = minim.loadFile("music/10.mp3", 2048);
  aplayer11 = minim.loadFile("music/11.mp3", 2048);
  aplayer12 = minim.loadFile("music/12.mp3", 2048);
  aplayer13 = minim.loadFile("music/13.mp3", 2048);
  aplayer14 = minim.loadFile("music/14.mp3", 2048);
  aplayer15 = minim.loadFile("music/15.mp3", 2048);
  aplayer16 = minim.loadFile("music/16.mp3", 2048);
  aplayer17 = minim.loadFile("music/17.mp3", 2048);
  aplayer18 = minim.loadFile("music/18.mp3", 2048);
  aplayer19 = minim.loadFile("music/19.mp3", 2048);
  aplayer20 = minim.loadFile("music/20.mp3", 2048);
  aplayer21 = minim.loadFile("music/21.mp3", 2048);
  aplayer22 = minim.loadFile("music/22.mp3", 2048);
  aplayer23 = minim.loadFile("music/23.mp3", 2048);
  aplayer24 = minim.loadFile("music/24.mp3", 2048);
  aplayer25 = minim.loadFile("music/25.mp3", 2048);
  aplayer26 = minim.loadFile("music/26.mp3", 2048);
  aplayer27 = minim.loadFile("music/27.mp3", 2048);

  font = loadFont("TrebuchetMS-Italic-20.vlw");
  textFont(font);
  textMode(SHAPE);
  
  
  serial = new Serial(this, Serial.list()[serialPort], 115200);
  
  for(int i = 0; i < sen; i++) {
    n[i] = new Normalize();
    cama[i] = new MomentumAverage(.01);
    axyz[i] = new MomentumAverage(.15);
  }
  
  reset();
}

void draw() {
  updateSerial();
  background(bg);
  drawBoard();
  
   camera();

hint(DISABLE_DEPTH_TEST); 
 textFont(font);
  textMode(MODEL);
  textSize(50);
  fill(255);
  text("STOP", 145, 660);

flick();
rect(100, 600,200, 100,15);

textSize(50);
fill(255,0,0,120);
text("MUSICAL INSTRUMENT",160,50);

hint(ENABLE_DEPTH_TEST);

}

void updateSerial() {
  String cur = serial.readStringUntil('\n');
  if(cur != null) {
    //println(cur);
    String[] parts = split(cur, " ");
    if(parts.length == sen  ) {
    
      for(int i = 0; i < sen; i++)
        {xyz[i] = float(parts[i]);
     
    
  }
  
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
  if(div == 3) {
    if(x < cutoff)
      return 0;
    if(x < 1-cutoff && x > cutoff)
      return 1;
    else
      return 2;
  } 
  else {
    return x == 1 ? div - 1 : (int) x * div;
  }
}

void drawBoard() {
  

  float h = w / 2;
  camera(
    h + (cama[0].avg - cama[2].avg) * h,
    h + (cama[1].avg - 1) * height / 2,
    w *2,
    h, h, h,
    0, 1, 0);
   
  pushMatrix();
  
  // Due to a currently unresolved issue with Processing 2.0.3 and OpenGL depth sorting,
  // we can't fill the large box without hiding the rest of the boxes in the scene.
  // We'll use a stroke for this one instead.
  noFill();
  stroke(0, 40);
  translate(w/2, w/2, w/2);
  rotateY(-HALF_PI/2);
  box(w);
  popMatrix();

  float sw = w / div;
  translate(h, sw / 2, 0);
  rotateY(-HALF_PI/2);

  pushMatrix();
  float sd = sw * (div - 1);
  translate(
    axyz[0].avg * sd,
    axyz[1].avg * sd,
    axyz[2].avg * sd);
  fill(255, 160, 0, 200);
  noStroke();
  sphere(18);
  popMatrix();

  for(int z = 0; z < div; z++) {
    for(int y = 0; y < div; y++) {
      for(int x = 0; x < div; x++) {
        pushMatrix();
        translate(x * sw, y * sw, z * sw);

        noStroke();
        if(moves[0][x][y][z])
          fill(255, 0, 0, 200); // transparent red
        else if(moves[1][x][y][z])
          fill(0, 0, 255, 200); // transparent blue
        else if(
        x == ixyz[0] &&
          y == ixyz[1] &&
          z == ixyz[2])
          if(player == 0)
          {
            fill(255, 0, 0, 200); // transparent red
          sp();
          }
          else
            fill(0, 0, 255, 200); // transparent blue
        else
          fill(230, 120); // transparent grey
        box(sw / 3);

        popMatrix();
      }
    }
  }
  
  stroke(0);
  if(mousePressed && mouseButton == LEFT)
    msg("defining boundaries");
}

void keyPressed() {
  if(key == TAB) {
    moves[player][ixyz[0]][ixyz[1]][ixyz[2]] = true;
    player = player == 0 ? 1 : 0;
  }
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

void stop()
{
  aplayer1.close();
   aplayer2.close();
   aplayer3.close();
   aplayer4.close();
   aplayer5.close();
   aplayer6.close();
   aplayer7.close();
   aplayer8.close();
   aplayer9.close();
   aplayer10.close();
   aplayer11.close();
   aplayer12.close();
   aplayer13.close();
   aplayer14.close();
   aplayer15.close();
   aplayer16.close();
   aplayer17.close();
   aplayer18.close();
   aplayer19.close();
   aplayer20.close();
   aplayer21.close();
   aplayer22.close();
   aplayer23.close();
   aplayer24.close();
   aplayer25.close();
   aplayer26.close();
   aplayer27.close();

   
   
  minim.stop();
  super.stop();
}

void sp(){

        if(ixyz[0]==0 && ixyz[1]==2 && ixyz[2]==2 && p[0]==0)
               { 
                  aplayer1.pause();
                  aplayer1.rewind();
                  aplayer1.play(1);
              
                  p[0]=1;
                  
                   }
               
                  else if(ixyz[0]==0 && ixyz[1]==2 && ixyz[2]==2 && p[0]==1)
               { 
                 
                  
              
                  p[0]=p[0]+1;
                  
                   }
             
                  else if((ixyz[0]!=0 || ixyz[1]!=2 || ixyz[2]!=2) && p[0]>=1)
                  {
                    aplayer1.pause();
                    aplayer1.rewind();
                    p[0]=0;
               
                }
                   
          
       //////////////////////////            
             
                   
             else if(ixyz[0]==0 && ixyz[1]==2 &&  ixyz[2]==1 && p[1]==0)
             {
            
                aplayer2.pause();
                 aplayer2.rewind();
                 aplayer2.play(0);
                 p[1]=1;
               
                  
                }
                        
             else if(ixyz[0]==0 && ixyz[1]==2 &&  ixyz[2]==1 && p[1]==1)
             {
               p[1]=p[1]+1;
             }
                else if((ixyz[0]!=0 || ixyz[1]!=2 || ixyz[2]!=1) && p[1]>=1)
                {
                    
                    aplayer2.pause();
                    p[1]=0;
                }
               
               
               
   ///////////////////////            


      else if(ixyz[0]==0 && ixyz[1]==2 && ixyz[2]==0 && p[2]==0 )
             {
                  aplayer3.pause();
                  aplayer3.rewind();
                  aplayer3.play(1);
              
                  p[2]=1;
                  
                  }
                   else if(ixyz[0]==0 && ixyz[1]==2 && ixyz[2]==0 && p[2]==1 )
             {
               p[2]=p[2]+1;
             }
                  else if((ixyz[0]!=0 || ixyz[1]!=2 || ixyz[2]!=0) && p[2]>=1)
                  {
                    
                     aplayer3.pause();
                    p[2]=0;
                  }
                  
         //////////////////         
                  
              else if(ixyz[0]==1 && ixyz[1]==2 && ixyz[2]==0 && p[3]==0)
             {
                    
                   aplayer4.pause();
                  aplayer4.rewind();
                  aplayer4.play(1);
              
                  p[3]=1;
                  
                  }
                  
                        
              else if(ixyz[0]==1 && ixyz[1]==2 && ixyz[2]==0 && p[3]==1)
             {
                 p[3]=p[3]+1;
             }
                  else if((ixyz[0]!=1 || ixyz[1]!=2 || ixyz[2]!=0) && p[3]>=1)
                  {
                    
                     aplayer4.pause();
                     p[3]=0;
                  }
               
             ////////////////
             
             
              else if(ixyz[0]==1 && ixyz[1]==2 && ixyz[2]==1 && p[4]==0)
             {
                   
                 
                  aplayer5.pause();
                  aplayer5.rewind();
                  aplayer5.play(1);
              
                  p[4]=1;
                  
                  }
                   else if(ixyz[0]==1 && ixyz[1]==2 && ixyz[2]==1 && p[4]==1)
             {
                
                p[4]=p[4]+1; 
             }
                  else if((ixyz[0]!=1 || ixyz[1]!=2 || ixyz[2]!=1) && p[4]>=1)
                  {
                    
                     aplayer5.pause();
                     p[4]=0;
                  }
                  
           ///////////////
           
              else if(ixyz[0]==1 && ixyz[1]==2 && ixyz[2]==2 && p[5]==0)
             {
                    
                
                 aplayer6.pause();
                  aplayer6.rewind();
                  aplayer6.play(1);
              
                  p[5]=1;
                  
                  }
                     else if(ixyz[0]==1 && ixyz[1]==2 && ixyz[2]==2 && p[5]==1)
             {      p[5]=p[5]+1;
             }  
                  else if((ixyz[0]!=1 || ixyz[1]!=2 || ixyz[2]!=2) && p[5]>=1)
                  {
                    
                     aplayer6.pause();
                     p[5]=0;
                  }
                  
                  /////////////////////
             
              else if(ixyz[0]==2 && ixyz[1]==2 && ixyz[2]==2 && p[6]==0 )
             {
                   
            
                 aplayer7.pause();
                  aplayer7.rewind();
                  aplayer7.play(1);
              
                  p[6]=1;
                  }
                  
                   else if(ixyz[0]==2 && ixyz[1]==2 && ixyz[2]==2 && p[6]==1 )
             {
               p[6]=p[6]+1;
             }
                  else if((ixyz[0]!=2 || ixyz[1]!=2 || ixyz[2]!=2) && p[6]>=1)
                  {
                    
                     aplayer7.pause();
                    p[6]=0;
                  }
             /////////////////////////////
             
             
             
              else if(ixyz[0]==2 && ixyz[1]==2 && ixyz[2]==1  && p[7]==0)
             {
                 
               
                  aplayer8.pause();
                  aplayer8.rewind();
                  aplayer8.play(1);
              
                  p[7]=1;
                 
                  
                  }
                  
                   else if(ixyz[0]==2 && ixyz[1]==2 && ixyz[2]==1  && p[7]==1)
             {
               
               p[7]=p[7]+1;
             }
                  else if((ixyz[0]!=2 || ixyz[1]!=2 || ixyz[2]!=1) && p[7]>=1)
                  {
                    
                     aplayer8.pause();
                    p[7]=0;
                  } 
             //////////////////////////////
             
             
               else if(ixyz[0]==2 && ixyz[1]==2 && ixyz[2]==0 && p[8]==0)
             {
               
                
                 aplayer9.pause();
                  aplayer9.rewind();
                  aplayer9.play(1);
              
                  p[8]=1;
                 
                  
                  }
                    else if(ixyz[0]==2 && ixyz[1]==2 && ixyz[2]==0 && p[8]==1)
             {
                 p[8]=  p[8]+1;
               
             }
                  else if((ixyz[0]!=2 || ixyz[1]!=2 || ixyz[2]!=0) &&   p[8]>=1)
                  {
                    
                     aplayer9.pause();
                     p[8]=0;
                  }   
          ///////////////////////////
          
          
               else if(ixyz[0]==0 && ixyz[1]==1 && ixyz[2]==2 &&   p[9]==0)
             {
                   
             
                 aplayer10.pause();
                  aplayer10.rewind();
                  aplayer10.play(1);
              
                  p[9]=1;
                  
                  }
                  
                  
               else if(ixyz[0]==0 && ixyz[1]==1 && ixyz[2]==2 &&   p[9]==1)
             {
                 p[9]=  p[9]+1;
             }
                  else if((ixyz[0]!=0 || ixyz[1]!=1 || ixyz[2]!=2) &&   p[9]>=1)
                  {
                    
                     aplayer10.pause();
                       p[9]=0;
                  }
       
                  ///////////////////////////////
                  
             
               else if(ixyz[0]==0 && ixyz[1]==1 && ixyz[2]==1 &&   p[10]==0)
             {
                   
                
              
                  aplayer11.pause();
                  aplayer11.rewind();
                  aplayer11.play(1);
              
                  p[10]=1;
                  
                  }
                  
                    else if(ixyz[0]==0 && ixyz[1]==1 && ixyz[2]==1 &&   p[10]==1)
             {
               
               p[10]=p[10]+1;
             }
                  else if((ixyz[0]!=0 || ixyz[1]!=1 || ixyz[2]!=1) && p[10]>=1)
                  {
                    
                     aplayer11.pause();
                    p[10]=0;
                  }
       ///////////////////
       
       
                  
               else if(ixyz[0]==0 && ixyz[1]==1 && ixyz[2]==0 && p[11]==0 )
             {
                   
                
              
               aplayer12.pause();
                  aplayer12.rewind();
                  aplayer12.play(1);
              
                  p[11]=1;
                  }
                    else if(ixyz[0]==0 && ixyz[1]==1 && ixyz[2]==0 && p[11]==1 )
             {
                  p[11]= p[11]+1;
               
             }
                  else if((ixyz[0]!=0 || ixyz[1]!=1 || ixyz[2]!=0) &&  p[11]>=1)
                  {
                    
                     aplayer12.pause();
                    p[11]=0;
                  }
                  
        //////////////////////////////
        
               else if(ixyz[0]==1 && ixyz[1]==1 && ixyz[2]==0 && p[12]==0)
             {
                   
           
                 aplayer13.pause();
                  aplayer13.rewind();
                  aplayer13.play(1);
              
                  p[12]=1;
                  
                  }
                  
                   else if(ixyz[0]==1 && ixyz[1]==1 && ixyz[2]==0 && p[12]==1)
             {
               p[12]=p[12]+1;
             }
                  else if((ixyz[0]!=1 || ixyz[1]!=1 || ixyz[2]!=0) && p[12]>=1)
                  {
                    
                     aplayer13.pause();
                   p[12]=0;
                  }    
      ///////////////////////////
      
      
             else if(ixyz[0]==1 && ixyz[1]==1 && ixyz[2]==1 && p[13]==0)
             {
             
             
                  aplayer14.pause();
                  aplayer14.rewind();
                  aplayer14.play(1);
              
                  p[13]=1;
                  
                  }
                  
                   else if(ixyz[0]==1 && ixyz[1]==1 && ixyz[2]==1 && p[13]==1)
             {
                   p[13]=p[13]+1;
             }
                  else if((ixyz[0]!=1 || ixyz[1]!=1 || ixyz[2]!=1) && p[13]>=1)
                  {
                    
                     aplayer14.pause();
                     p[13]=0;
                  }
       /////////////////////////
       
       
             
             else if(ixyz[0]==1 && ixyz[1]==1 && ixyz[2]==2 && p[14]==0)
             {
                
                aplayer15.pause();
                  aplayer15.rewind();
                  aplayer15.play(1);
              
                  p[14]=1;
                  
                  }
                  
                  else if(ixyz[0]==1 && ixyz[1]==1 && ixyz[2]==2 && p[14]==1)
             {
                  p[14]= p[14]+1;
             }
                  else if((ixyz[0]!=1 || ixyz[1]!=1 || ixyz[2]!=2) &&  p[14]>=1)
                  {
                    
                     aplayer15.pause();
                      p[14]=0;
                  }
                  
                  
        ///////////////////////////        
             
             else if(ixyz[0]==2 && ixyz[1]==1 && ixyz[2]==2 &&  p[15]==0)
             {
            
                    aplayer16.pause();
                  aplayer16.rewind();
                  aplayer16.play(1);
              
                  p[15]=1;
                  }
                  
                   else if(ixyz[0]==2 && ixyz[1]==1 && ixyz[2]==2 &&  p[15]==1)
             {
               p[15]=p[15]+1;
             }
                  else if((ixyz[0]!=2 || ixyz[1]!=1 || ixyz[2]!=2) && p[15]>=1)
                  {
                    
                     aplayer16.pause();
                  p[15]=0;
                  }      
           
             
               
    ///////////////////////////////////           
               
               
             else if(ixyz[0]==2 && ixyz[1]==1 && ixyz[2]==1 && p[16]==0 )
             {
                    aplayer17.pause();
                  aplayer17.rewind();
                  aplayer17.play(1);
              
                  p[16]=1;
             
                  
                 }
                 
                 else if(ixyz[0]==2 && ixyz[1]==1 && ixyz[2]==1 && p[16]==1 )
             {
                  p[16]=p[16]+1;   
             }
                 else if((ixyz[0]!=2 || ixyz[1]!=1 || ixyz[2]!=1) && p[16]>=1)
                 {
                    
                    aplayer17.pause();
                    p[16]=0;
                 }
                  
                  
  /////////////////////////////                
             
             else if(ixyz[0]==2 && ixyz[1]==1 &&  ixyz[2]==0  && p[17]==0)
             {
                aplayer18.pause();
                  aplayer18.rewind();
                  aplayer18.play(1);
              
                  p[17]=1;
                  
                 }
                  else if(ixyz[0]==2 && ixyz[1]==1 &&  ixyz[2]==0  && p[17]==1)
             {
               p[17]=p[17]+1;
             }
                 else if((ixyz[0]!=2 || ixyz[1]!=1 || ixyz[2]!=0) && p[17]>=1)
                 {
                    
                    aplayer18.pause();
                    p[17]=0;
                 }
                  
                  
   ///////////////////////////////            
             
             else if(ixyz[0]==2 && ixyz[1]==0 && ixyz[2]==0 && p[18]==0)
             {
                  aplayer19.pause();
                  aplayer19.rewind();
                  aplayer19.play(1);
              
                  p[18]=1;
                  
                 }
                 
                 else if(ixyz[0]==2 && ixyz[1]==0 && ixyz[2]==0 && p[18]==1)
             {
                   p[18]=p[18]+1;
             }
                 else if((ixyz[0]!=2 || ixyz[1]!=0 || ixyz[2]!=0) && p[18]>=1)
                 {
                    
                    aplayer19.pause();
                    p[19]=0;
                 }
                  
     /////////////////////////////////             
                 
             
             else if(ixyz[0]==2 && ixyz[1]==0 && ixyz[2]==1 && p[19]==0)
             {
                    aplayer20.pause();
                  aplayer20.rewind();
                  aplayer20.play(1);
              
                  p[19]=1;
               
                  
                 }
                  else if(ixyz[0]==2 && ixyz[1]==0 && ixyz[2]==1 && p[19]==0)
             {
                p[19]= p[19]+1;
             }
                 else if((ixyz[0]!=2 || ixyz[1]!=0 || ixyz[2]!=1) && p[19]>=1)
                 {
                    
                    aplayer20.pause();
                    p[19]=0;
                 }
                  
      ///////////////////////////////////
      
      
             else if(ixyz[0]==2 && ixyz[1]==0 && ixyz[2]==2 &&  p[20]==0)
             {
                   
                 aplayer21.pause();
                  aplayer21.rewind();
                  aplayer21.play(1);
              
                  p[20]=1;
                  
                 }
                 else if(ixyz[0]==2 && ixyz[1]==0 && ixyz[2]==2 &&  p[20]==1)
             {
                  p[20]= p[20]+1;
             }
                 else if((ixyz[0]!=2 || ixyz[1]!=0 || ixyz[2]!=2) &&  p[20]>=1)
                 {
                    
                    aplayer21.pause();
                     p[20]=0;
                 }
                  
      ////////////////////////
      
      
             else if(ixyz[0]==1 && ixyz[1]==0 && ixyz[2]==2 &&  p[21]==0 )
             {
                 
                 
                 aplayer22.pause();
                  aplayer22.rewind();
                  aplayer22.play(1);
              
                  p[21]=1;
                  
                 }
                 else if(ixyz[0]==1 && ixyz[1]==0 && ixyz[2]==2 &&  p[21]==1 )
             {
                   p[21]=p[21]+1;
             }
                 else if((ixyz[0]!=1 || ixyz[1]!=0 || ixyz[2]!=2) && p[21]>=1)
                 {
                    
                    aplayer22.pause();
                    p[21]=0;
                 }  
       
     ////////////////////////////
             
             else if(ixyz[0]==1 && ixyz[1]==0 && ixyz[2]==1 && p[22]==0)
             {
                   
              aplayer23.pause();
                  aplayer23.rewind();
                  aplayer23.play(1);
              
                  p[22]=1;
                  
                 }
                 else if(ixyz[0]==1 && ixyz[1]==0 && ixyz[2]==1 && p[22]==1)
             {
               p[22]=p[22]+1;
                 
             }
                 else if((ixyz[0]!=1 || ixyz[1]!=0 || ixyz[2]!=1) && p[22]>=1)
                 {
                    
                    aplayer23.pause();
                    p[23]=0;
                 } 
    
             
          /////////////////////////////
             
             
             else if(ixyz[0]==1 && ixyz[1]==0 && ixyz[2]==0 && p[23]==0)
             {
                  
             aplayer24.pause();
                  aplayer24.rewind();
                  aplayer24.play(1);
              
                  p[23]=1;
                  
                 }
                 
                  else if(ixyz[0]==1 && ixyz[1]==0 && ixyz[2]==0 && p[23]==1)
             {
               p[23]=p[23]+1;
             }
                 else if((ixyz[0]!=1 || ixyz[1]!=0 || ixyz[2]!=0) && p[23]>=1)
                 {
                    
                    aplayer24.pause();
                    p[23]=0;
                 }  
     
             
             ////////////////////////
             
             
              else if(ixyz[0]==0 && ixyz[1]==0 && ixyz[2]==0 && p[24]==0)
             {
                aplayer25.pause();
                  aplayer25.rewind();
                  aplayer25.play(1);
              
                  p[24]=1;
             
                  
                 }
                 
                  else if(ixyz[0]==0 && ixyz[1]==0 && ixyz[2]==0 && p[24]==1)
             {
               p[24]=p[24]+1;
             }
                 else if((ixyz[0]!=0 || ixyz[1]!=0 || ixyz[2]!=0) && p[24]>=1)
                 {
                    
                    aplayer25.pause();
                    p[24]=0;
                 }    
        
             
             ////////////////////////////
             
             
              else if(ixyz[0]==0 && ixyz[1]==0 && ixyz[2]==1  && p[25]==0)
             {
                   
             aplayer26.pause();
                  aplayer26.rewind();
                  aplayer26.play(1);
              
                  p[25]=1;
                  
                 }
                 
                  else if(ixyz[0]==0 && ixyz[1]==0 && ixyz[2]==1  && p[25]==1)
             {
                p[25]= p[25]+1;
             }
                 else if((ixyz[0]!=0 || ixyz[1]!=0 || ixyz[2]!=1) &&  p[25]>=1)
                 {
                    
                    aplayer26.pause();
                     p[25]=0;
                 }      
      
             
             /////////////////////////////////
             
             
              else if(ixyz[0]==0 && ixyz[1]==0 && ixyz[2]==2 &&  p[26]==0)
             {
                      aplayer27.pause();
                  aplayer27.rewind();
                  aplayer27.play(1);
              
                  p[26]=1;
           
                  
                 }
                  else if(ixyz[0]==0 && ixyz[1]==0 && ixyz[2]==2 &&  p[26]==1)
             {
               p[26]=p[26]+1;
             }
                 else if((ixyz[0]!=0 || ixyz[1]!=0 || ixyz[2]!=2) && p[26]>=1)
                 {
                    
                    aplayer27.pause();
                 p[26]=0;
       
               }   
         
                 
               
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