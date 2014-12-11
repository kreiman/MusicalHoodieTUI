/**
  * This sketch demonstrates how to use the BeatDetect object in FREQ_ENERGY mode.<br />
  * You can use <code>isKick</code>, <code>isSnare</code>, </code>isHat</code>, <code>isRange</code>, 
  * and <code>isOnset(int)</code> to track whatever kind of beats you are looking to track, they will report 
  * true or false based on the state of the analysis. To "tick" the analysis you must call <code>detect</code> 
  * with successive buffers of audio. You can do this inside of <code>draw</code>, but you are likely to miss some 
  * audio buffers if you do this. The sketch implements an <code>AudioListener</code> called <code>BeatListener</code> 
  * so that it can call <code>detect</code> on every buffer of audio processed by the system without repeating a buffer 
  * or missing one.
  * <p>
  * This sketch plays an entire song so it may be a little slow to load.
  */
  
/** Modified by Athena Kihara, Sahsa Levy and Kelsey Reiman. We changed
which pins where the output and added more output pins to the original code */

import processing.serial.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import cc.arduino.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;
Arduino arduino;

//LED pin for collar LED's
int ledPin  = 5;    // LED connected to digital pin 5
int ledPin2 =  6;    // LED connected to digital pin 6
int ledPin3 =  7;    // LED connected to digital pin 7
int ledPin4 =  11;    // LED connected to ditigal pin 11
int ledPin5 =  12;    // LED connected to ditigal pin 12
int ledPin6 =  13;    // LED connected to ditigal pin 13

//temp pin and LED pin for shoulder
int tempPin1 = 8;
int tempReading;

int lightPin1 = 9;
//int lightPin2 = 2;
//int lightPin3 = 3;
//int lightPin3 = 4;

int groundPin1 = 2;    //setting 16 to be another - (ground) pin
int groundPin2 = 3;    //setting 17 to be another - (ground) pin
int positivePin = 4;   //setting 19 to be a positive pin.
 
int brightness1 = 0;    // how bright the LED is
int fadeAmount1 = 5;    // how many points to fade the LED by
 
int brightness2 = 25;    // how bright the LED is
int fadeAmount2 = 5;    // how many points to fade the LED by
 
int brightness3 = 45;    // how bright the LED is
int fadeAmount3 = 5;    // how many points to fade the LED by
 
int brightness4 = 70;    // how bright the LED is
int fadeAmount4 = 5;    // how many points to fade the LED by
 
int brightness5 = 90;    // how bright the LED is
int fadeAmount5 = 5;    // how many points to fade the LED by


float kickSize, snareSize, hatSize, kick2Size;

void setup() {
  size(900, 200, P3D);
  
  minim = new Minim(this);
  arduino = new Arduino(this, Arduino.list()[2], 57600);
  
  StringList tswift = new StringList();
  tswift.append("shakeitoff.mp3");
  tswift.append("blankspace.mp3");
  tswift.append("tyleroakley.mp3");
  tswift.shuffle();
  
  song = minim.loadFile(tswift.get(1), 2048);
  song.play();
  // a beat detection object that is FREQ_ENERGY mode that 
  // expects buffers the length of song's buffer size
  // and samples captured at songs's sample rate
  beat = new BeatDetect(song.bufferSize(), song.sampleRate());
  // set the sensitivity to 300 milliseconds
  // After a beat has been detected, the algorithm will wait for 300 milliseconds 
  // before allowing another beat to be reported. You can use this to dampen the 
  // algorithm if it is giving too many false-positives. The default value is 10, 
  // which is essentially no damping. If you try to set the sensitivity to a negative value, 
  // an error will be reported and it will be set to 10 instead. 
  beat.setSensitivity(100);  
  kickSize = snareSize = hatSize = 16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);  
  textFont(createFont("Helvetica", 16));
  textAlign(CENTER);
  
  arduino.pinMode(ledPin, Arduino.OUTPUT);    
  arduino.pinMode(ledPin2, Arduino.OUTPUT);  
  arduino.pinMode(ledPin3, Arduino.OUTPUT);
  arduino.pinMode(ledPin4, Arduino.OUTPUT); 
  arduino.pinMode(ledPin5, Arduino.OUTPUT);  
  arduino.pinMode(ledPin6, Arduino.OUTPUT); 

 //temperature sensor  
 //Serial.begin(9600);
 
 arduino.pinMode(lightPin1, Arduino.OUTPUT);
 //arduino.pinMode(lightPin1, Arduino.OUTPUT);
 //arduino.pinMode(lightPin2, Arduino.OUTPUT);
 //arduino.pinMode(lightPin3, Arduino.OUTPUT);
 //arduino.pinMode(lightPin4, Arduino.OUTPUT);
 //arduino.pinMode(lightPin5, Arduino.OUTPUT);
 arduino.pinMode(groundPin1, Arduino.OUTPUT);
 arduino.pinMode(groundPin2, Arduino.OUTPUT);
 arduino.pinMode(positivePin, Arduino.OUTPUT);
 arduino.digitalWrite(groundPin1, Arduino.LOW);
 arduino.digitalWrite(groundPin2, Arduino.LOW);
 arduino.digitalWrite(positivePin, Arduino.HIGH);
}

void draw() {
  background(0);
  fill(255);
  if(beat.isKick()) {
      arduino.digitalWrite(ledPin, Arduino.HIGH);   // set the LED on
      arduino.digitalWrite(ledPin6, Arduino.HIGH);  // set the LED on
      kickSize = 32;
  }
  if(beat.isSnare()) {
      arduino.digitalWrite(ledPin2, Arduino.HIGH);   // set the LED on
      arduino.digitalWrite(ledPin5, Arduino.HIGH);  // set the LED on
      snareSize = 32;
  }
  if(beat.isHat()) {
      arduino.digitalWrite(ledPin3, Arduino.HIGH);   // set the LED on
      arduino.digitalWrite(ledPin4, Arduino.HIGH);  // set the LED on
      hatSize = 32;
  }
  arduino.digitalWrite(ledPin, Arduino.LOW);    // set the LED off
  arduino.digitalWrite(ledPin2, Arduino.LOW);    // set the LED off
  arduino.digitalWrite(ledPin3, Arduino.LOW);    // set the LED off
  arduino.digitalWrite(ledPin4, Arduino.LOW);
  arduino.digitalWrite(ledPin5, Arduino.LOW);
  arduino.digitalWrite(ledPin6, Arduino.LOW);
  textSize(kickSize);
  text("KICK", width/4, height/2);
  textSize(snareSize);
  text("SNARE", width/2, height/2);
  textSize(hatSize);
  text("HAT", 3*width/4, height/2);
  kickSize = constrain(kickSize * 0.95, 16, 32);
  snareSize = constrain(snareSize * 0.95, 16, 32);
  hatSize = constrain(hatSize * 0.95, 16, 32);
}

void stop() {
  // always close Minim audio classes when you are finished with them
  song.close();
  // always stop Minim before exiting
  minim.stop();
  // this closes the sketch
  super.stop();
}
