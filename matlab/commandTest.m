

delete(instrfind({'Port'},{'COM3'}))%delete characters left in buffer
gpsGround = serial('COM3'); %Declare COM port ***MAKE SURE THIS IS RIGHT***
fopen(gpsGround); %open serial port communication

fprintf(gpsGround,'%s','CMDRELEASE');
disp('Command Sent: CMDRELEASE');
clear gpsGround;

