# 3D-Interface

This project accomplishes motion and touch tracking using simple household stuff like Aluminium Foil, CardBoard and an Arduino Uno.

### Implementation Details
![Implementation details](https://github.com/prasadchelsea33/3D-Interface/blob/master/Images/IMPLEMENTATION%20DESIGN.jpg?raw=true)

### Softwares used. 
1. Arduino IDE
2. Processing 3.0.

### Libraries used in Processing.
1. Obsessive Camera Direction
2. Minim (audio library)
3. PeasyCam (mouse-controlled camera)

##### Project uses *OPENGL* 3D mode in processing.

### Hardware requirements
1. Cardboard Assembly.
![Cardboard Assembly](https://github.com/prasadchelsea33/3D-Interface/blob/master/Images/Cardboard%20Cube.jpg?raw=true )

2. Audio cables (sheilded)
3. Arduino UNO
4. Another cardboard with aluminium foil coated to provide us *GROUND*.

##### Overall Setup
![Overall Setup](https://github.com/prasadchelsea33/3D-Interface/blob/master/Images/IMG_20160304_143449.jpg?raw=true)

### Circuit diagram
![Circuit Diagram](http://makezine.com/wp-content/uploads/make-images/vnMhkLZVqZmA2rQG.jpg)

### Applications included:
##### 1. Motion Tracking.

*This sketch tracks motion of your hand and presents it in a 3D block grid arrangement wherein the yellow sphere denotes your hands position*
![Motion Tracking](https://github.com/prasadchelsea33/3D-Interface/blob/master/Images/Motion%20Tracking.png?raw=true) 

##### 2. 3D Camera.

*Uses same code as above and uses hands motion to control a camera's viewing angle*
![3D Camera](https://github.com/prasadchelsea33/3D-Interface/blob/master/Images/3D%20CAMERA.png?raw=true) 

##### 3. Musical instruments.

*uses hand gestures to produce different sound output like different chords of guitar*
![Musical Instrument demo](https://github.com/prasadchelsea33/3D-Interface/blob/master/Images/Musical%20Instrument.PNG?raw=true)

##### 4. UFO game.

*uses hands gestures inside a 3D game.Aim is to suck people in and dodge missiles*
![UFO game](https://github.com/prasadchelsea33/3D-Interface/blob/master/Images/%20UFO%20Game.png?raw=true)

##### 5.Drawboard.

*This implementation uses both motion and touch tracking wherein all the 3 plates(X,Y,Z) become touch surfaces as well*
![Drawboard](https://github.com/prasadchelsea33/3D-Interface/blob/master/Images/DRAWBOARD.png?raw=true)

##### 6. Virtual Blocks (Work in progress).

*Uses motion tracking to control 3D blocks height. This is still a work in progress.*
![Virtual Blocks](https://github.com/prasadchelsea33/3D-Interface/blob/master/Images/Virtual%20blocks.jpg?raw=true)


### Steps to get it working
1. Get the hardware setup ready as shown in above image.
2. Open arduino IDE and load the *Arduino\_sketch.ino* file which is in the Arduino_sketch folder.
3. Run the arduino sketch after connecting uno to the computer. Solve any issues like permissions denied(for ports).
4. Check if sketch is uploaded properly by opening serial monitor(tools->serial monitor). It should spit out 3 numbers continuously. These numbers denote your X,Y,Z plates of the cardboard assembly.You can check if each plate is working or not by touching the plate.On touching the values of the particular plate should show significant change(increase in values).
5. Now, open one of the processing sketches mentioned above. **Before running the sketch remember to close arduino serial monitor.**
6. Next the system will require calibration wherein you place your hand on ground plate and move your hand from the top half of cardboard assembly to the innermost point of the assembly.**(Do not touch the plates)**
7. Now you are good to go. PLAY WITH IT! HAVE FUN.


### REFERENCES:
These articles have very good explanation and will guide you properly through the hardware setup.
[Article1](http://www.instructables.com/id/DIY-3D-Controller/).

[Article2](http://makezine.com/projects/a-touchless-3d-tracking-interface/).

[Paper with helpful implementation details](https://seaperch.byu.edu/wp-content/uploads/2013/06/Paper.pdf).
