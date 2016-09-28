/*  
 *  ------ LoRaWAN Code Example -------- 
 *  
 *  Explanation: This example shows how to configure the module and
 *  send packets to a LoRaWAN gateway with ACK after join a network
 *  using ABP
 *  
 *  Copyright (C) 2016 Libelium Comunicaciones Distribuidas S.L. 
 *  http://www.libelium.com 
 *  
 *  This program is free software: you can redistribute it and/or modify  
 *  it under the terms of the GNU General Public License as published by  
 *  the Free Software Foundation, either version 3 of the License, or  
 *  (at your option) any later version.  
 *   
 *  This program is distributed in the hope that it will be useful,  
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of  
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the  
 *  GNU General Public License for more details.  
 *   
 *  You should have received a copy of the GNU General Public License  
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.  
 *  
 *  Version:           0.1
 *  Design:            David Gascon 
 *  Implementation:    Luismi Marti
 */

#include <WaspLoRaWAN.h>
#include <WaspSensorAgr_v20.h>

#define UART_DEBUG 2

// socket to use
//////////////////////////////////////////////
uint8_t socket = SOCKET0;
//////////////////////////////////////////////

// Device parameters for Back-End registration
////////////////////////////////////////////////////////////
char DEVICE_EUI[]  = "0102030405060708";
char DEVICE_ADDR[] = "05060708";
char NWK_SESSION_KEY[] = "01020304050607080910111213141516";
char APP_SESSION_KEY[] = "000102030405060708090A0B0C0D0E0F";
uint32_t RADIO_FREQUENCY = 868000000;
int8_t RADIO_POWER = 1;
char SF[] = "sf10";
////////////////////////////////////////////////////////////

// Define port to use in Back-End: from 1 to 223
uint8_t PORT = 3;

// Define data payload to send (maximum is up to data rate)
uint8_t error;

// Generated variable
char  CONNECTOR_A[3] = "CA";                   
char  CONNECTOR_B[3] = "CB";                  
char  CONNECTOR_C[3] = "CC";
char  CONNECTOR_D[3] = "CD";
char  CONNECTOR_E[3] = "CE";
char  CONNECTOR_F[3] = "CF";

long  sequenceNumber = 0;                     
                                               
char  nodeID[10] = "PS1";              

char* sleepTime = "00:00:01:00";             

char data[100]; 
uint8_t data_uc[100];

float connectorAFloatValue;                  
float connectorBFloatValue;              
float connectorCFloatValue;            
float connectorDFloatValue;     
float connectorEFloatValue;
float connectorFFloatValue;

int connectorAIntValue;
int connectorBIntValue;
int connectorCIntValue;
int connectorDIntValue;
int connectorEIntValue;
int connectorFIntValue;

char  connectorAString[10];          
char  connectorBString[10];          
char  connectorCString[10];
char  connectorDString[10];
char  connectorEString[10];
char  connectorFString[10];

int   batteryLevel;
char  batteryLevelString[10];
char  BATTERY[4] = "BAT";
char  TIME_STAMP[3] = "TS";

uint16_t uartreadrx;

long unsigned int delayuart;


void setup() 
{

 
  
  USB.ON();
  USB.println(F("LoRaWAN example - Send Confirmed packets (with ACK)\n"));


  USB.println(F("------------------------------------"));
  USB.println(F("Module configuration"));
  USB.println(F("------------------------------------\n"));


  //////////////////////////////////////////////
  // 1. Switch on
  //////////////////////////////////////////////

  error = LoRaWAN.ON(socket);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("1. Switch ON OK"));     
  }
  else 
  {
    USB.print(F("1. Switch ON error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 2. Set Device EUI
  //////////////////////////////////////////////

  error = LoRaWAN.setDeviceEUI(DEVICE_EUI);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("2. Device EUI set OK"));     
  }
  else 
  {
    USB.print(F("2. Device EUI set error = ")); 
    USB.println(error, DEC);
  }
 

  //////////////////////////////////////////////
  // 3. Set Device Address
  //////////////////////////////////////////////

  error = LoRaWAN.setDeviceAddr(DEVICE_ADDR);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("3. Device address set OK"));     
  }
  else 
  {
    USB.print(F("3. Device address set error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 4. Set Network Session Key
  //////////////////////////////////////////////

  error = LoRaWAN.setNwkSessionKey(NWK_SESSION_KEY);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("4. Network Session Key set OK"));     
  }
  else 
  {
    USB.print(F("4. Network Session Key set error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 5. Set Application Session Key
  //////////////////////////////////////////////

  error = LoRaWAN.setAppSessionKey(APP_SESSION_KEY);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("5. Application Session Key set OK"));     
  }
  else 
  {
    USB.print(F("5. Application Session Key set error = ")); 
    USB.println(error, DEC);
  }
  
  //////////////////////////////////////////////
  // 5.5 Set Spreading Factor to SF10
  //////////////////////////////////////////////

  error = LoRaWAN.setRadioSF(SF);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("5.5 SF set OK"));     
  }
  else 
  {
    USB.print(F("5.5 SF set error = ")); 
    USB.println(error, DEC);
  }


  error = LoRaWAN.setRadioFreq(RADIO_FREQUENCY);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("5.6 Radio Frequency set OK"));     
  }
  else 
  {
    USB.print(F("5.5 SF set error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setRadioPower(RADIO_POWER);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("5.7 Radio Power set OK"));     
  }
  else 
  {
    USB.print(F("5.5 SF set error = ")); 
    USB.println(error, DEC);
  }

  
  error = LoRaWAN.setRetries(4);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("5.8 Retries Set for 4"));     
  }
  else 
  {
    USB.print(F("5.5 SF set error = ")); 
    USB.println(error, DEC);
  }

  //////////////////////////////////////////////
  // 6. Save configuration
  //////////////////////////////////////////////

  error = LoRaWAN.saveConfig();

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("6. Save configuration OK"));     
  }
  else 
  {
    USB.print(F("6. Save configuration error = ")); 
    USB.println(error, DEC);
  }


  USB.println(F("\n------------------------------------"));
  USB.println(F("Module configured start"));
  USB.println(F("------------------------------------\n"));

  LoRaWAN.getDeviceEUI();
  USB.print(F("Device EUI: "));
  USB.println(LoRaWAN._devEUI);  

  LoRaWAN.getDeviceAddr();
  USB.print(F("Device Address: "));
  USB.println(LoRaWAN._devAddr);  
  
  LoRaWAN.getRadioFreq();
  USB.print(F("Radio Frequency: "));
  USB.println(LoRaWAN._radioFreq);  
  
  LoRaWAN.getRadioPower();
  USB.print(F("Radio Power: "));
  USB.println(LoRaWAN._radioPower); 
 
  LoRaWAN.getRadioSF();
  USB.print(F("Radio Spreading Factor:"));
  USB.println(LoRaWAN._radioSF);   
  
  LoRaWAN.getRadioPower();
  USB.print(F("Radio Power:"));
  USB.println(LoRaWAN._radioPower); 
  
  
  USB.println(F("\n------------------------------------"));
  USB.println(F("Module configured end"));
  USB.println(F("------------------------------------\n"));

  USB.println();  
}



void loop() 
{

  //////////////////////////////////////////////
  // 1. Switch on
  //////////////////////////////////////////////

  error = LoRaWAN.ON(socket);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("1. Switch ON OK"));     
  }
  else 
  {
    USB.print(F("1. Switch ON error = ")); 
    USB.println(error, DEC);
  }
  
    //Turn on the sensor board
    SensorAgrv20.ON();
    //Turn on the RTC
    RTC.ON();
    //supply stabilization delay
    delay(100);
 
    //Turn on the sensors

    SensorAgrv20.setSensorMode(SENS_ON, SENS_AGR_TEMP_DS18B20);
    delay(1000);
    
    // Read the sensors

    // First dummy reading for analog-to-digital converter channel selection
    PWR.getBatteryLevel();
    // Getting Battery Level
    batteryLevel = PWR.getBatteryLevel();
    // Conversion into a string
    itoa(batteryLevel, batteryLevelString, 10);

    //Sensor temperature reading
    connectorCFloatValue = SensorAgrv20.readValue(SENS_AGR_TEMP_DS18B20);
    //Conversion into a string
    Utils.float2String(connectorCFloatValue, connectorCString, 2);
    
    //Turn off the sensors
    SensorAgrv20.setSensorMode(SENS_OFF, SENS_AGR_TEMP_DS18B20);
    
    //Data payload composition
     sprintf(data,"{I:%s,N:%li,%s:%s,%s:%s}",
	nodeID ,
	sequenceNumber,
	BATTERY, batteryLevelString,
        //TIME_STAMP, RTC.getTimestamp(),
	CONNECTOR_C , connectorCString);
    
    USB.println(data);
    strcpy( (char*) data_uc, data);
    
    //convert Array Of Hex to String
    char output_s[100];
    Utils.hex2str(data_uc, output_s, strlen(data));
    USB.println(output_s);

  //////////////////////////////////////////////
  // 2. Join network
  //////////////////////////////////////////////

  error = LoRaWAN.joinABP();

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("2. Join network OK"));  

    //////////////////////////////////////////////
    // 3. Send confirmed packet 
    //////////////////////////////////////////////
    USB.println("Sending...");
    error = LoRaWAN.sendConfirmed(PORT, output_s);
    //error = LoRaWAN.sendConfirmed(PORT, "ABC");
    //USB.println(LoRaWAN.WaspUART._buffer);
//    WaspUART.beginUART();
    //USB.println(uartreadrx);

    // Error messages:
    /*
     * '6' : Module hasn't joined a network
     * '5' : Sending error
     * '4' : Error with data length	  
     * '2' : Module didn't response
     * '1' : Module communication error   
     */
    // Check status
    if( error == 0 ) 
    {
      USB.println(F("3. Send Confirmed packet OK"));     
      if (LoRaWAN._dataReceived == true)
      { 
        USB.print(F("   There's data on port number "));
        USB.print(LoRaWAN._port,DEC);
        USB.print(F(".\r\n   Data: "));
        USB.println(LoRaWAN._data);
      }
    }
    else 
    {
      USB.print(F("3. Send Confirmed packet error = ")); 
      USB.println(error, DEC);
    }   
  }
  else 
  {
    USB.print(F("2. Join network error = ")); 
    USB.println(error, DEC);
  }


  //////////////////////////////////////////////
  // 4. Switch off
  //////////////////////////////////////////////

  error = LoRaWAN.OFF(socket);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("4. Switch OFF OK"));     
  }
  else 
  {
    USB.print(F("4. Switch OFF error = ")); 
    USB.println(error, DEC);
  }


  USB.println();
  PWR.deepSleep(sleepTime,RTC_OFFSET,RTC_ALM1_MODE1,ALL_OFF);

    //Increase the sequence number after wake up
    sequenceNumber++;


}




