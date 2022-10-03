import processing.serial.*;
Serial port;

boolean startButton, endButton;
int startX, startY, endX, endY, buttonW, buttonH;
int isSit;
String typing, saved;
int goalTime;
double userTime;
String date;
int ledIdx, ledNum;
int indent;
int windowW, windowH, rectW, rectH, r, g, b;

PFont font;

void setup() {
  // put your setup code here, to run once:
  windowW = 1080;
  windowH = 480;
  rectW = 1020;
  rectH = 440;
  size(windowW, windowH);
  background(255);
  
  isSit = -1;
  goalTime = 0;
  userTime = 0;
  typing = "";
  saved = "0";
  
  startButton = false;
  endButton = false;
  buttonW = 240;
  buttonH = 40;
  startX = windowW / 2 - buttonW / 2;
  startY = windowH * 2 / 3 + 20;
  endX = windowW / 2 - buttonW / 2;
  endY = windowH * 2 / 3 + buttonH + 30;
  
  ledIdx = 5;
  ledNum = 5;
  
  indent = 50;
  date = String.format("%4d.%02d.%02d", year(), month(), day());
  r = 51;
  g = 112;
  b = 255;
  
  font = createFont("Galmuri9.ttf", 24);
  port = new Serial(this, Serial.list()[1], 9600);

}

void draw(){
  
  // Text Setting
  fill(r, g, b);
  noStroke();
  rect(windowW / 2 - rectW / 2, windowH / 2 - rectH / 2, rectW, rectH, 28);
  
  
  textFont(font);
  textSize(36);
  fill(255);
  textAlign(CENTER);
  text(date, windowW / 2, windowH / 6);
  textSize(15);
  text("Type your goal time. Hit enter to save.", windowW / 2, windowH / 4);
  fill(255);
  rect(windowW / 2 - 400 / 2, windowH / 4 + 40 / 2, 400, 40, 28);
  fill(r, g, b);
  textSize(28);
  text(typing, windowW / 2, windowH / 4 + indent + 2);
  fill(255);
  textSize(18);
  text("Your Goal Time: " + saved + "   min", windowW / 2, windowH / 4 + indent + 45);
  
  int minute = (int)userTime / 60;
  String currentMinute = String.valueOf(minute);
  String currentSecond = String.format("%02d", (int)userTime % 60);
  textSize(25);
  text("Current Study Time\n" + currentMinute + " min  " + currentSecond + " sec", windowW / 2, windowH / 4 + indent + 96);
  
  // Save Input Goal Time
  if(saved != "0") goalTime = Integer.parseInt(saved);
  
  // Read Signal from Arduino
  isSit = port.read();                                           

  // If user started app
  if(startButton == true){
    
    // Calculate userTime as seconds
    if(isSit == 1) userTime += 0.1;
    
    // Send led index to Arduino
    if(userTime >= ((ledIdx - 4) * goalTime * 60) / ledNum){
      port.write(ledIdx);
      ledIdx++;
    }
    
    // If Goal is achived, change the main color
    if(userTime >= goalTime * 60) r = 200;
  }
  
  
  // If user ended app
  if(endButton == true && startButton == false){
    
    // Read and Save data to .txt File
    int temp = (int)userTime;
    int min = temp / 60;
    String newData = date + " " + String.valueOf(min) + " " + String.valueOf(goalTime);
    String[] originData = loadStrings("input.txt");
    String[] data = new String[originData.length + 1];
    int i = 0;
    for(i = 0; i < originData.length; i++) data[i] = originData[i];
    data[i] = newData;
    saveStrings("input.txt", data);
    
  }
  
  // Start Button End Button Setting
  fill(0, 255, 0);
  rect(startX, startY, buttonW, buttonH, 28);
  fill(255, 0, 0);
  rect(endX, endY, buttonW, buttonH, 28);

}

// User Input
void keyPressed(){
  if(key == '\n'){
    saved = typing;
    typing = "";
  }
  else typing = typing + key;
}

// Button Input
void mousePressed(){
  if(mouseX > startX && mouseX < startX+buttonW && mouseY > startY && mouseY < startY+buttonH) startButton = true;
  if(mouseX > endX && mouseX < endX+buttonW && mouseY > endY && mouseY < endY+buttonH){
    endButton = true;
    startButton = false;
  }
  
}
