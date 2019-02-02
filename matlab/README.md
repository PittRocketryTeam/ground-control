
                        
PITT ROCKETRY GROUND-CONTROL - GPS GUI and Script
  
  FUNCTIONALITY
  
               -recieve serial input from teensy 3.6
               -parse NMEA data string
               -Display longitude, lattitude, altitude, and flight time
               -enable start and stop of serial comunication
               -Display final rocket location and path on map
               -Print raw serial data to file
               -Calculate and display distance from launch site

  NOTES
  
               -Set correct serial port on lines 124 and 127
               -Edit line 203 to correct packet header
               -To test with input file comment out 125-129 and
               un-comment 129-130
               -set range for long and lat

  ADDITIONAL FILES
  
               *** THESE FILES MUST BE INCLUDED FOR PROPER OPPERATION***
               -GPS_GUI.m
               -GPS_GUI.fig
               -plot_google_map.m
               -makescale.m
               -DMStoDD.m
               -logo.png
               -api_key.mat



