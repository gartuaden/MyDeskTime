int irPin = 0;
int ledIdx = 0;
int sitDistance = 700;
int prev1 = 0;
int prev2 = 0;
int isSit = 0;

void setup() {

  analogReference(DEFAULT);
  Serial.begin(9600);
  pinMode(irPin, INPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(8, OUTPUT);
  pinMode(9, OUTPUT);
  
} 

void loop() {

  int raw = analogRead(irPin);

  // Error Value Check
  if(abs(raw - prev2) < 25 && abs(raw - prev1) > 50 && abs(prev1 - prev2) > 50){
    
    // Do Nothing
    
  }
  else{

    // User Sit Check 
    if(raw > sitDistance) isSit = 1;
    else isSit = 0;
    
  }

  // Send to Processing
  Serial.write(isSit);
  delay(100);
  
  // Read from Processing
  if(Serial.available()){
    
    ledIdx = Serial.read();
    analogWrite(ledIdx, 255);
    
  }

  prev1 = raw;
  prev2 = prev1;
}
