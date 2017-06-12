
#include <main.cpp>

unsigned int x;

void setup()
{
  Serial.begin(781250);

  
  pinMode(4, INPUT);
 
  pinMode(6, OUTPUT);	//used to intiate test bench stimulus (for simulation only)
  digitalWrite(6, HIGH);
  
}

void loop()
{
  x= pulseIn(4,1);
  Serial.print("Calculated\t");
  Serial.print(x);
  Serial.print("\texpected\t");
//  Serial.println("500");
  Serial.print("500\n");

 
  x= pulseInLong(4,1);
  Serial.print("Calculated\t");
  Serial.print(x);
  Serial.print("\texpected\t");
//  Serial.println("500");
  Serial.print("500\n");

  delay(1);

  exit(0);	//to end simulation properly
}



