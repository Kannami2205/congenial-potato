#include <dht.h>
#include <LiquidCrystal.h>


#define DHT11PIN 2 //Define the temperature and humidity pin
LiquidCrystal lcd(12, 11, 10, 9, 8, 7); //setup the port 
dht DHT11;
int incomedate = 0;
int relayPin = 3; 
int relayPin =4 ; //relay pin 
void setup()
{
Serial. begin(9600); //serial 
pinMode(relayPin, OUTPUT); //Relay output 
pinMode (DHT11PIN, INPUT); //DHT11 module output 
lcd.begin(16,2);
lcd.clear(); 
delay(1000); // delay 1000ms
}
void loop ()
{
int chk = DHT11.read11(DHT11PIN) ;  //Assign the read value to chk
int tem=(float )DHT11.temperature; //Assign the temperature value to tem
int hum=(float )DHT11.humidity; 
Serial.print( "Humidity:"); 
Serial.print(hum);
Serial.print("Tempeature:" );
Serial.print(tem);  
Serial.println("%" ); // Print temperature and humidity 
delay(200);
lcd.setCursor(0, 0) ; //Set the cursor position 
lcd.print(" Tempeature:");
lcd.print(tem); 
lcd.setCursor(0, 1) ;
lcd.print("Humidity:");
lcd.print(hum); //Make the screen display temperature and humidity
if (tem >36) //If the temperature is > 36 degree C
{digitalWrite(relayPin, LOW);  //relay on, fan on
Serial.println(" OPEN!");
} 
else
{
digitalWrite(relayPin,HIGH);
Serial.println("CLOSE!");
}
if (tem < 0 || hum > 75) //If the tem is < 0 degree C or hun > 75%
{digitalWrite(relayPin2, LOW); // relay on, heating pad on
    Serial.println("Relay 2 OPEN!");
}
    else {
    digitalWrite(relayPin2, HIGH);
    Serial.println("Relay 2 CLOSE!");
  }

delay(500); //refresh rate 0.1 sec 
}
}
