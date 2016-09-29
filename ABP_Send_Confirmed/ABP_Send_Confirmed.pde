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
#define SOCKET0 0

// socket to use
//////////////////////////////////////////////
uint8_t socket = SOCKET0;
//////////////////////////////////////////////

// Device parameters for Back-End registration
////////////////////////////////////////////////////////////
char DEVICE_EUI[]  = "0011223344556677";
char APP_KEY1[] = "62F534B954C7C136";
char APP_KEY2[] = "CBA19C03277612DE";
char DEVICE_ADDR[] = "87654321";
char NWK_SESSION_KEY[] = "01020304050607080910111213141516";
char APP_SESSION_KEY[] = "000102030405060708090A0B0C0D0E0F";
uint32_t RX2_FREQUENCY = 867200000;
int8_t RADIO_POWER = 2;
//uint8_t DR = 2; //SF10 - 980bps
uint8_t DR = 5; //SF7BW125 - 5470bps
uint8_t DR_RX2 = 3; //SF10BW125 - 440bps
////////////////////////////////////////////////////////////

// Define port to use in Back-End: from 1 to 223
uint8_t PORT = 3;

// Define data payload to send (maximum is up to data rate)

// Generated variable
char  CONNECTOR_A[3] = "CA";                   
char  CONNECTOR_B[3] = "CB";                  
char  CONNECTOR_C[3] = "CC";
char  CONNECTOR_D[3] = "CD";
char  CONNECTOR_E[3] = "CE";
char  CONNECTOR_F[3] = "CF";

long  sequenceNumber = 0;                     
                                               
char  nodeID[10] = "PS1";              

char* sleepTime = "00:00:30:00";             

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


// User variable
////////////////////////////////////////////////////////////
uint16_t uartreadrx;
long unsigned int delayuart;
bool PrevACK = 0;
uint8_t error;
char on[4] = "on";
char off[5] = "off";
////////////////////////////////////////////////////////////

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
  // 6 User Defined Setting
  //////////////////////////////////////////////
  
  // Set Power
  error = LoRaWAN.setPower(RADIO_POWER);

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

  // Set RX1 Delay 
  error = LoRaWAN.setRX1Delay(2000);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("5.8 RX1 Delay Set to 2000ms"));     
  }
  else 
  {
    USB.print(F("5.5 SF set error = ")); 
    USB.println(error, DEC);
  }
  
  // Set Retries
  error = LoRaWAN.setRetries(2);

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
  
  //////////////////////////////////////////////////
  // 5. Configure Channel For New Zealand Frequency
  //////////////////////////////////////////////////
  
  // Set EU default frequency 868.1 MHz in channel 0 off  
  //-----------------------------------------------------
  error = LoRaWAN.setChannelStatus(0, off);

  if( error == 0 ) 
  {
    USB.println(F("Channel 0 set to off"));     
  }
  else 
  {
    USB.print(F("Set Channel 0 set to off error = ")); 
    USB.println(error, DEC);
  }
  
  // Set EU default frequency 868.3 MHz in channel 1 off  
  //-----------------------------------------------------
  error = LoRaWAN.setChannelStatus(1, off);

  if( error == 0 ) 
  {
    USB.println(F("Channel 1 set to off"));     
  }
  else 
  {
    USB.print(F("Set Channel 1 set to off error = ")); 
    USB.println(error, DEC);
  }
  
  // Set EU default frequency 868.5 MHz in channel 2 off  
  //-----------------------------------------------------
  error = LoRaWAN.setChannelStatus(2, off);

  if( error == 0 ) 
  {
    USB.println(F("Channel 2 set to off"));     
  }
  else 
  {
    USB.print(F("Set Channel 2 set to off error = ")); 
    USB.println(error, DEC);
  }
  
  // Set channel 3 frequency to 865.0 MHz
  //---------------------------------------
  error = LoRaWAN.setChannelFreq(3, 865000000);

  if( error == 0 ) 
  {
    USB.println(F("Channel 3 set to 865Mhz"));     
  }
  else 
  {
    USB.print(F("Set Channel 3 to 865Mhz error = ")); 
    USB.println(error, DEC);
  }
  
  // Set channel 3 duty cycle, DR range, and switch on
  //---------------------------------------------------
  error = LoRaWAN.setChannelDutyCycle(3, 0);

  if( error == 0 ) 
  {
    USB.println(F("Channel 3 set Duty Cycle"));     
  }
  else 
  {
    USB.print(F("Set Channel Duty Cycle error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelDRRange(3, 0, 5);

  if( error == 0 ) 
  {
    USB.println(F("Channel 3 set DR Range"));     
  }
  else 
  {
    USB.print(F("Set Channel DR Range error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelStatus(3, on);

  if( error == 0 ) 
  {
    USB.println(F("Channel 3 set to ON"));     
  }
  else 
  {
    USB.print(F("Set Channel Status to ON error = ")); 
    USB.println(error, DEC);
  }
  
  
 // Set channel 4 frequency to 865.2 MHz
 // ---------------------------------------
  error = LoRaWAN.setChannelFreq(4, 865200000);

  if( error == 0 ) 
  {
    USB.println(F("Channel 4 set to 865.2 Mhz"));     
  }
  else 
  {
    USB.print(F("Set Channel 4 to 865.2 Mhz error = ")); 
    USB.println(error, DEC);
  }
  
  // Set channel 4 duty cycle, DR range, and switch on
  //---------------------------------------------------
  error = LoRaWAN.setChannelDutyCycle(4, 0);

  if( error == 0 ) 
  {
    USB.println(F("Channel 4 set Duty Cycle"));     
  }
  else 
  {
    USB.print(F("Set Channel Duty Cycle error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelDRRange(4, 0, 5);

  if( error == 0 ) 
  {
    USB.println(F("Channel 4 set DR Range"));     
  }
  else 
  {
    USB.print(F("Set Channel DR Range error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelStatus(4, on);

  if( error == 0 ) 
  {
    USB.println(F("Channel 4 set to ON"));     
  }
  else 
  {
    USB.print(F("Set Channel Status to ON error = ")); 
    USB.println(error, DEC);
  }
  
// Set channel 5 frequency to 865.4 MHz
//---------------------------------------
  error = LoRaWAN.setChannelFreq(5, 865400000);

  if( error == 0 ) 
  {
    USB.println(F("Channel 5 set to 865.4 Mhz"));     
  }
  else 
  {
    USB.print(F("Set Channel 5 to 865.4 Mhz error = ")); 
    USB.println(error, DEC);
  }
  
  // Set channel 5 duty cycle, DR range, and switch on
  //---------------------------------------------------
  error = LoRaWAN.setChannelDutyCycle(5, 0);

  if( error == 0 ) 
  {
    USB.println(F("Channel 5 set Duty Cycle"));     
  }
  else 
  {
    USB.print(F("Set Channel Duty Cycle error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelDRRange(5, 0, 5);

  if( error == 0 ) 
  {
    USB.println(F("Channel 5 set DR Range"));     
  }
  else 
  {
    USB.print(F("Set Channel DR Range error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelStatus(5, on);

  if( error == 0 ) 
  {
    USB.println(F("Channel 5 set to ON"));     
  }
  else 
  {
    USB.print(F("Set Channel Status to ON error = ")); 
    USB.println(error, DEC);
  }
  
// Set channel 6 frequency to 866.2 MHz
//---------------------------------------
  error = LoRaWAN.setChannelFreq(6, 866200000);

  if( error == 0 ) 
  {
    USB.println(F("Channel 6 set to 866.2 Mhz"));     
  }
  else 
  {
    USB.print(F("Set Channel 6 to 866.2 Mhz error = ")); 
    USB.println(error, DEC);
  }
  
  // Set channel 6 duty cycle, DR range, and switch on
  //---------------------------------------------------
  error = LoRaWAN.setChannelDutyCycle(6, 0);

  if( error == 0 ) 
  {
    USB.println(F("Channel 6 set Duty Cycle"));     
  }
  else 
  {
    USB.print(F("Set Channel Duty Cycle error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelDRRange(6, 0, 5);

  if( error == 0 ) 
  {
    USB.println(F("Channel 6 set DR Range"));     
  }
  else 
  {
    USB.print(F("Set Channel DR Range error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelStatus(6, on);

  if( error == 0 ) 
  {
    USB.println(F("Channel 6 set to ON"));     
  }
  else 
  {
    USB.print(F("Set Channel Status to ON error = ")); 
    USB.println(error, DEC);
  }
  
  // Set channel 7 frequency to 866.4 MHz
//---------------------------------------
  error = LoRaWAN.setChannelFreq(7, 866400000);

  if( error == 0 ) 
  {
    USB.println(F("Channel 7 set to 866.4 Mhz"));     
  }
  else 
  {
    USB.print(F("Set Channel 7 to 866.4 Mhz error = ")); 
    USB.println(error, DEC);
  }
  
  // Set channel 7 duty cycle, DR range, and switch on
  //---------------------------------------------------
  error = LoRaWAN.setChannelDutyCycle(7, 0);

  if( error == 0 ) 
  {
    USB.println(F("Channel 7 set Duty Cycle"));     
  }
  else 
  {
    USB.print(F("Set Channel Duty Cycle error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelDRRange(7, 0, 5);

  if( error == 0 ) 
  {
    USB.println(F("Channel 7 set DR Range"));     
  }
  else 
  {
    USB.print(F("Set Channel DR Range error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelStatus(7, on);

  if( error == 0 ) 
  {
    USB.println(F("Channel 7 set to ON"));     
  }
  else 
  {
    USB.print(F("Set Channel Status to ON error = ")); 
    USB.println(error, DEC);
  }
  
// Set channel 8 frequency to 866.6 MHz
//---------------------------------------
  error = LoRaWAN.setChannelFreq(8, 866600000);

  if( error == 0 ) 
  {
    USB.println(F("Channel 8 set to 866.6 Mhz"));     
  }
  else 
  {
    USB.print(F("Set Channel 8 to 866.6 Mhz error = ")); 
    USB.println(error, DEC);
  }
  
  // Set channel 8 duty cycle, DR range, and switch on
  //---------------------------------------------------
  error = LoRaWAN.setChannelDutyCycle(8, 0);

  if( error == 0 ) 
  {
    USB.println(F("Channel 8 set Duty Cycle"));     
  }
  else 
  {
    USB.print(F("Set Channel Duty Cycle error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelDRRange(8, 0, 5);

  if( error == 0 ) 
  {
    USB.println(F("Channel 8 set DR Range"));     
  }
  else 
  {
    USB.print(F("Set Channel DR Range error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelStatus(8, on);

  if( error == 0 ) 
  {
    USB.println(F("Channel 8 set to ON"));     
  }
  else 
  {
    USB.print(F("Set Channel Status to ON error = ")); 
    USB.println(error, DEC);
  }

// Set channel 9 frequency to 866.8 MHz
//---------------------------------------
  error = LoRaWAN.setChannelFreq(9, 866800000);

  if( error == 0 ) 
  {
    USB.println(F("Channel 9 set to 866.8 Mhz"));     
  }
  else 
  {
    USB.print(F("Set Channel 9 to 866.8 Mhz error = ")); 
    USB.println(error, DEC);
  }
  
  // Set channel 9 duty cycle, DR range, and switch on
  //---------------------------------------------------
  error = LoRaWAN.setChannelDutyCycle(9, 0);

  if( error == 0 ) 
  {
    USB.println(F("Channel 9 set Duty Cycle"));     
  }
  else 
  {
    USB.print(F("Set Channel Duty Cycle error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelDRRange(9, 0, 5);

  if( error == 0 ) 
  {
    USB.println(F("Channel 9 set DR Range"));     
  }
  else 
  {
    USB.print(F("Set Channel DR Range error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelStatus(9, on);

  if( error == 0 ) 
  {
    USB.println(F("Channel 9 set to ON"));     
  }
  else 
  {
    USB.print(F("Set Channel Status to ON error = ")); 
    USB.println(error, DEC);
  }

// Set channel 10 frequency to 867 MHz
//---------------------------------------
  error = LoRaWAN.setChannelFreq(10, 867000000);

  if( error == 0 ) 
  {
    USB.println(F("Channel 10 set to 867 Mhz"));     
  }
  else 
  {
    USB.print(F("Set Channel 10 to 867 Mhz error = ")); 
    USB.println(error, DEC);
  }
  
  // Set channel 10 duty cycle, DR range, and switch on
  //---------------------------------------------------
  error = LoRaWAN.setChannelDutyCycle(10, 0);

  if( error == 0 ) 
  {
    USB.println(F("Channel 10 set Duty Cycle"));     
  }
  else 
  {
    USB.print(F("Set Channel Duty Cycle error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelDRRange(10, 0, 5);

  if( error == 0 ) 
  {
    USB.println(F("Channel 10 set DR Range"));     
  }
  else 
  {
    USB.print(F("Set Channel DR Range error = ")); 
    USB.println(error, DEC);
  }
  
  error = LoRaWAN.setChannelStatus(10, on);

  if( error == 0 ) 
  {
    USB.println(F("Channel 10 set to ON"));     
  }
  else 
  {
    USB.print(F("Set Channel Status to ON error = ")); 
    USB.println(error, DEC);
  }  
  
  // Set RX2 Parameters
  error = LoRaWAN.setRX2Parameters(DR_RX2, RX2_FREQUENCY);

  // Check status
  if( error == 0 ) 
  {
    USB.println(F("RX2 Parameters Set"));     
  }
  else 
  {
    USB.print(F("Set RX2 Parameter error = ")); 
    USB.println(error, DEC);
  }

 
  //////////////////////////////////////////////
  // 8. Save configuration
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
  
  LoRaWAN.getChannelFreq(0);
  USB.print(F("Radio Frequency: "));
  USB.println(LoRaWAN._freq[0]);  
  
  LoRaWAN.getPower();
  USB.print(F("Radio Power: "));
  USB.println(LoRaWAN._powerIndex); 
 
  LoRaWAN.getDataRate();
  USB.print(F("Data Rate:"));
  USB.printHex(LoRaWAN._dataRate);   
  
  LoRaWAN.getADR();
  USB.print(F("Adaptive Data Rate:"));
  USB.println(LoRaWAN._adr); 
  
  LoRaWAN.getUpCounter();
  USB.print(F("Up Counter:"));
  USB.println(LoRaWAN._upCounter); 
  
  LoRaWAN.getDownCounter();
  USB.print(F("Down Counter:"));
  USB.println(LoRaWAN._downCounter); 
  
  
  
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
    //RTC.ON();
    //supply stabilization delay
    delay(100);
 
    //Turn on the sensors

    SensorAgrv20.setSensorMode(SENS_ON, SENS_AGR_TEMP_DS18B20);
    delay(1000);
    
    SensorAgrv20.setSensorMode(SENS_ON, SENS_AGR_WATERMARK_1);
    delay(100);
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
    
    //Sensor moisture reading
    connectorFFloatValue = SensorAgrv20.readValue(SENS_AGR_WATERMARK_1);
    //Conversion into a string
    Utils.float2String(connectorFFloatValue, connectorFString, 2);
    
    //Turn off the sensors
    SensorAgrv20.setSensorMode(SENS_OFF, SENS_AGR_TEMP_DS18B20);
    SensorAgrv20.setSensorMode(SENS_OFF, SENS_AGR_WATERMARK_1);
    
    //Data payload composition
     sprintf(data,"{I:%s,N:%li,%s:%s,%s:%s,%s:%s,PA:%d}",
	nodeID ,
	sequenceNumber,
	BATTERY, batteryLevelString,
        //TIME_STAMP, RTC.getTimestamp(),
	CONNECTOR_C , connectorCString,
        CONNECTOR_F , connectorFString,
        PrevACK );
    
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
    delay(10000); 

    //////////////////////////////////////////////
    // 3. Send confirmed packet 
    //////////////////////////////////////////////
    
    
    USB.println("Sending...");
    error = LoRaWAN.sendConfirmed(PORT, output_s);

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
      PrevACK = 1;
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
      PrevACK = 0;
      USB.print(F("3. Send Confirmed packet error = ")); 
      USB.println(error, DEC);
    }   
  }
  
  else 
  {
    PrevACK = 0;
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
  //delay(50000);
    //Increase the sequence number after wake up
    sequenceNumber++;


}




