%*******************************************************************************%
%                           PITT ROCKETRY GROUND-CONTROL
%                                 GUI and Script
%  FUNCTIONALITY
%               : recieve serial input from teensy 3.6 and rover ground
%               control
%               : parse NMEA data string
%               : Display longitude, lattitude, altitude, and flight time
%               : enable start and stop of reading serial comunication
%               : Display final rocket location and path on map
%               : Print raw serial data to file
%               : Calculate and display distance from launch site
%               : display rssi vs distance plot
%               : Provide flight status updates
%               : Display max altitude and max distance
%               : Rover release safety
%               : send rover release signal
%               : send rover start signal
%               : recieve rover transmissions
%
%   INSTRUCTIONS FOR DUMMIES AKA HARRIS
%
%               1) Set correct serial port on lines 206, 207, 211, and 212
%
%               2) Edit line 288 to correct packet header (You shouldn't
%               have to change this)
%
%               3) Set filename on line 216 if desired, just change the
%               'results.txt' to 'NewName.txt' 
%
%               4) set range for long and lat (lines 368 and 369) *This
%               should be fine but if it goes out of range just increase
%               the value in increments of .001
%    
%               5) connect your laptop to a mobile hotspot (it will
%               function without one but you won't see a map
%
%               6) Click run and maximize the window. (have your volume on
%               so you can hear if matlab throws any errors
%       
%               6) Click start below the logo once
%
%               7) at this poit you should see a map load and the gps Fix
%               status will be shown to the right along with the RSSI
%
%               8) Launch the rocket whenever ready. The connection may be
%               lost. the serial port will time out after 30 minutes.
%
%               9) Point the ground control antenna in the direction of the
%               rocket. If you cannot reconnect walk around the field
%               until you can.
%
%               10) assuming the rocket has landed and you are recieving
%               data, you can send a rover release command.
%   
%               11) test the rover then activate it. Don't hit stop durring
%               this, the rover command buttons trigger an interrupt so
%               there is no issue recieving gps data at the same time.
%
%               12) if possible, take a screen video of the flight. 
%        
%               13) call me if anything goes wrong before making
%               significant changes to the code (717-579-9603)
%
%
%  ADDITIONAL FILES
%               *** THESE FILES MUST BE INCLUDED FOR PROPER OPPERATION***
%               : GPS_GUI.m
%               : GPS_GUI.fig
%               : plot_google_map.m
%               : makescale.m
%               : DMStoDD.m
%               : logo.png
%               : api_key.mat
%
%
%******************************************************************************%




%******************** MATLAB GENERATED CODE (DO NOT EDIT!!) ************%
function varargout = GPS_GUI(varargin)
% GPS_GUI MATLAB code for GPS_GUI.fig
%      GPS_GUI, by itself, creates a new GPS_GUI or raises the existing
%      singleton*.
%
%      H = GPS_GUI returns the handle to a new GPS_GUI or the handle to
%      the existing singleton*.
%
%      GPS_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GPS_GUI.M with the given input arguments.
%
%      GPS_GUI('Property','Value',...) creates a new GPS_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GPS_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GPS_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GPS_GUI

% Last Modified by GUIDE v2.5 01-Mar-2019 17:35:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GPS_GUI_OpeningFcn, ...
    'gui_OutputFcn',  @GPS_GUI_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

end
%********************************************************************


% ------ Executes just before GPS_GUI is made visible-------------------
function GPS_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GPS_GUI (see VARARGIN)

% Choose default command line output for GPS_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%^^^^^ DO NOT EDIT ABOVE ^^^^^^

% !!!!! Format Interface and set environment variables !!!!!!!

%display logo
axes(handles.axes9);
imshow('logo.png');

%format all non graph displays to remove axes
axes(handles.latDisp); %latitude
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.longDisp); %longitude
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.timeDisp); %time
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.fixDisp); %gps fix
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.maxDist); %max distance
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.maxAlt); %max altitude
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.status); %status display
set(gca,'xtick',[]);
set(gca,'ytick',[]);
cla(handles.status)  %clear axes then display system ready %TODO add system checklist
text(.2,.5,'SYSTEM READY','fontsize',24,'Parent',handles.status,'HorizontalAlignment','left');
axes(handles.rssiDisp) %rssi display
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(handles.rssiDisp,'color','black'); %set display color to black
axes(handles.latVsLong); %latVsLong display (map)
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.distDisp);% disptance
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.roverTranSent); %rover transmission sent
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.roverTranRecieved); %rover transmission recieved
set(gca,'xtick',[]);
set(gca,'ytick',[]);

%setup push toggle safety swithches- Declare all as 0 (not pressed)
set(handles.releaseSafety,'userdata',0); %release toggle
set(handles.startSafety,'userdata',0); %start toggle
set(handles.roverStart,'userdata',0); %rover start
set(handles.roverRelease,'userdata',0); %rover release
set(handles.LoadRover,'userdata',0); %rover load

%initialize global variables for serial input and raw output file
global gpsGround roverGround rawData;

%initialze serial communication for gps ground control
delete(instrfind({'Port'},{'COM3'}))%delete characters left in buffer                               ***MAKE SURE THIS IS RIGHT***
gpsGround = serial('COM3'); %Declare COM port                                                       ***MAKE SURE THIS IS RIGHT***
fopen(gpsGround); %open serial port communication

%initialze serial communication for rover ground control
delete(instrfind({'Port'},{'COM7'}))%delete characters left in buffer                               ***MAKE SURE THIS IS RIGHT***
roverGround = serial('COM7'); %Declare COM port                                                     ***MAKE SURE THIS IS RIGHT***
fopen(roverGround); %open serial port communication

d=datestr(now,'dd-HH-MM-SS'); %declare string for date
filename=strcat(d,'results.txt'); %create unique raw output file name
rawData=fopen(filename,'wt'); %open output file to write raw serial output to

Timeout = 1800;
set(gpsGround, 'Timeout', Timeout);
set(roverGround,'Timeout',Timeout);


%serialIn=fopen('test_data.txt'); %test data **** COMMENT OUT UNLESS TESTING FROM FILE ***

%******** END OF ENVIRONMENT and VARIABLE SETUP ************
end


% !!!!!!!!!!!!! OBJECT CREATION (DO NOT EDIT!!) !!!!!!!!!!!!!!!!

% --- Outputs from this function are returned to the command line.
function varargout = GPS_GUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end
%^^^^^^^^^^^ END OBJECT CREATION ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

% --- Function executed when start button is pressed
% --- when button is pressed, loop reading serial data begins
function startCom_Callback(hObject, eventdata, handles)

set(handles.stopCom,'userdata',0); %set loop stop condition to zero

global gpsGround rawData; %get serial in global variable

%initialize variables used within function (purposes commented)
dist=[]; % array to store distances from launchpad
launchDetected=false; % bool variable to determine launch status
apogeeDetected=false; % bool variable to determine apogee status
count=1; % loop count variable
time=[]; % time from start of serial communication
startTime=0; %UTC time of start of serial communication
alt=[]; %array to store altitude
startAlt=0; %variable to be assinged starting altitude
flightStart=0; % variable to be assinged time at launch
rssi=[]; % array to store rssi values
rssiNum=1; % count of number of rssi values read from serial input
gpsData{7}=' '; % set gpsData cell 7 to empty string to eleminate error if loop is stoped and started between gps and rssi

%loop to read serial port
while (1) %loop is always true, will be broken by break in if statement
    
    inData=fgetl(gpsGround); %get a line from serial input
    
    fprintf(rawData,"%s\n",inData); %echo serial input to raw data output file
    
    if (strncmpi(inData,'GOT REPLY: HEYY$GPGGA',21)) %check if GPS data is recieved %*** ENSURE PACKET HEADER IS CORRECT ***
        
        gpsData=strsplit(inData,','); %slpit string using ,
        
        %check to see if the gps has a fix (if not, do not run data
        %analysis and processing
        if (strncmpi(gpsData{7},'1',1) || strncmpi(gpsData{7},'2',1))
            %if gps has a fix
            
            cla(handles.fixDisp); %clear fix displayi to prevent writing over old display
            
            axes(handles.fixDisp); %open fix display object
            
            text(.30,.5,'YES','fontsize',24,'Parent',handles.fixDisp,'HorizontalAlignment','left'); %display yes for gps fix
            set(gca,'color','green'); %display background color green
            
            if (count==1) %check to see if this is the first time through the loop
                
                %read in time of serial read initiatin
                startTime=str2double(gpsData{2}); %convert string to double and assign start time
                
                time(count)=0; %set first time point to zero
                
                %read in initaial altitude
                startAlt=str2double(gpsData{10}); %convert to double and assing to starting altitude
                alt(count)=0; % assing initial altitude to value of zero
                
            else %if the loop has been run more than one time (count>1)
                
                %claculate current time
                time(count)=str2double(gpsData{2})-startTime; %subtract start time from converted to double time
                
                %read in altitude and find difference between start and current
                alt(count)=str2double(gpsData{10})-startAlt; %assign altitude relative to start
                
                
                % ********* DETERMINE STATUS BASED ON ALTITUDE DATA ********
                if (alt(count)>1 && launchDetected == false) %if altitude is greater than 1 meters ~ one half rocket length and no launch has been detected
                    
                    flightStart=time(count); %set launch flight time start
                    
                    axes(handles.status); % open status display object
                    cla(handles.status); %clear previous status display
                    text(.15,.5,'LAUNCH DETECTED','fontsize',24,'Parent',handles.status,'HorizontalAlignment','left'); %display launch detected in status bar
                    set(handles.status,'Color','yellow'); %set status bg color to yellow
                    
                    launchDetected=true; % set bool launch detected var to true
                end
                
%               ADD CODE FOR DETERMINING APOGEE and LANDING          
                
                % ^^^^^^^^ END DETERMINE STATUS BASED ON ALTITUDE DATA ^^^^^^
                
                axes(handles.altVsTime) %get altitude vs time graph object
                plot(time,alt,'-k','LineWidth',2); %plot alt vs time with thick black line
                
            end
            
            lat(count)=DMStoDD(gpsData{3},'lat'); %extract lat and convert to Decimal degrees by calling function
            
            %determine if lat is positive or negative
            if (strncmpi(gpsData{4},'S',1)) %check direction cell
                lat(count)=-1*lat(count); % if latitude is S than make negative
            end
            
            long(count)=DMStoDD(gpsData{5},'lon');  %get value of longitude and convert to Decimal Degrees using function
            
            %determine if long is positive or negative
            if (strncmpi(gpsData{6},'W',1)) %check direction cell
                long(count)=-1*long(count); %if long is west then make negative
            end
            
            %plot lattitude vs. Longitude on map
            axes(handles.latVsLong); %get map display object
            
            if(count==1) %if this is the first time through the loop
                
                plot(long(1),lat(1),'.b','MarkerSize',25); %display starting location on map using blue dot
                set(gca,'xtick',[]); %format axis
                set(gca,'ytick',[]);
                ylim([(min(lat)-.009),(max(lat)+.009)]);  %set range of long and lat to ~2500 ft in each direction
                xlim([(min(long)-.009),(max(long)+.009)]);
                
                plot_google_map('maptype','hybrid'); %use google maps to plot location on the map
                
            else %if the loop has been run more than one time with a fix
                
                %this will overlay the plot on the same map without haveing
                %to reload the google maps api
                axes(handles.latVsLong) %get map display object
                plot(long,lat,'-r','LineWidth',3); %plot line representing path
                
            end
            
            %*********** DISPLAY FLIGHT VARIABLES **************%
            
            %display current lattitude
            cla(handles.latDisp) %clears latitude display
            text(.30,.5,num2str(lat(count)),'fontsize',24,'Parent',handles.latDisp,'HorizontalAlignment','left'); %display text
            
            %display current longitude
            cla(handles.longDisp) %clears longitude display
            text(.30,.5,num2str(long(count)),'fontsize',24,'Parent',handles.longDisp,'HorizontalAlignment','left');%display text
            
            %display max altitude
            cla(handles.maxAlt) %clears max altitude display
            text(.30,.5,num2str(max(alt)),'fontsize',20,'Parent',handles.maxAlt,'HorizontalAlignment','left'); %display text
            
            if launchDetected==true %if a launch has been detected then display flight time
                
                cla(handles.timeDisp) %clears flight time display
                text(.375,.5,num2str(time(count)-flightStart),'fontsize',20,'Parent',handles.timeDisp,'HorizontalAlignment','left'); %display time from start - fight start time
                
            else % if a launch hasn't been detected then display zero for flight time
                
                cla(handles.timeDisp) %clears flight time display
                text(.375,.5,'0','fontsize',20,'Parent',handles.timeDisp,'HorizontalAlignment','left'); %display text
            end
            
            %claculate and display distance
            dist(count)=haversine(long(1),long(count),lat(1),lat(count)); %claculate distance using haversine function
            cla(handles.distDisp) %clears distance display display
            text(.2,.5,num2str(dist(count)),'fontsize',20,'Parent',handles.distDisp,'HorizontalAlignment','left'); %display text
            
            %display max distance
            cla(handles.maxDist) %clears max distance display
            text(.05,.5,num2str(max(dist)),'fontsize',20,'Parent',handles.maxDist,'HorizontalAlignment','left'); %displayt text
            
            %*********** END DISPLAY FLIGHT VARIABLES **************%
            
            count=count+1; %increase count loop variable by one (this only occurs if there was gps data and a fix)
            
        else % if there was no fix
            
            cla(handles.fixDisp); %clear fix display
            axes(handles.fixDisp); %get fix display object
            text(.30,.5,'NO','fontsize',24,'Parent',handles.fixDisp,'HorizontalAlignment','left'); %display 'NO' for fix status
            set(gca,'color','red'); %set background color to red
        end
        
    elseif ((strncmpi(inData,'RSSI:',5))&& count>1 && (strncmpi(gpsData{7},'1',1) || strncmpi(gpsData{7},'2',1))) % check if RSSI data was recieved
        
        rssiData=strsplit(inData,':'); % split string
        rssi(rssiNum)=str2double(rssiData(2)); %convert rssi value to a double
        axes(handles.rssiVsTrans) % get rssi plot display object
        plot(dist(1:count-1),rssi,'.r','markersize',20); %plot rssi vs distance
        
        cla(handles.rssiDisp); %clear rssi value display
        text(0,.65,strcat('   ',num2str(rssi(rssiNum))),'fontsize',20,'Parent',handles.rssiDisp,'color','white'); %display rssi value in white
        rssiNum=rssiNum+1; %incriment the count of rssi values read
    end
    
    drawnow; %evaluate push button
    
    if get(handles.stopCom,'userdata') %check push button value
        assignin('base','rssi',rssi);
        assignin('base','dist',dist)
        if launchDetected==true
            axes(handles.latVsLong); %get map display object
            plot(long(count-1),lat(count-1),'.g','MarkerSize',25); %if stop button was pushed then display a green dot for final rocket location
            
        end
        break; %break loop and end function
    end
    
end
end



% --- Executes when button is pressed to stop reading serial data
function stopCom_Callback(hObject, eventdata, handles)
set(handles.stopCom,'userdata',1); %sets button value to 1 which will triger the end of the loop above
end


%function converts from Degrees Minutes Seconds to decimal degrees
%gps outputs lat: DDMM.MMMM long: DDDMM.MMMM
%DD = d + (min/60) + (sec/3600)
function DD = DMStoDD(DMS, type)
if (type=='lat') %if latitude
    latD=str2double(DMS(1:2)); %parse string and convert to double
    latM=str2double(DMS(3:9));
    DD=latD+(latM/60); %set DD value
    
elseif (type=='lon') %if longitude
    longD=str2double(DMS(1:3));%parse string and convert to double
    longM=str2double(DMS(4:10));
    DD=longD+(longM/60); %set DD value
end
end

% ** DO NOT REMOVE **
function axes9_CreateFcn(hObject, eventdata, handles)
end

%--- Haversine function, calculates distance between two coordinates on a
%sphere
function dist=haversine(long1,long2,lat1,lat2)

R=6371000; %radius of the earth in meters

p1=degtorad(lat1); %calculate phi values
p2=degtorad(lat2);

deltaP=degtorad(lat2-lat1); %calculate angle deltas
deltaL=degtorad(long2-long1);

a=(sin(deltaP/2)^2)+cos(p1)*cos(p2)*(sin(deltaL/2)^2);
c=2*atan2(sqrt(a),sqrt(1-a));

dist=R*c; %set distance variable in meters
end

% **** THE FOLLOWING FUNCTIONS CONTROL THE ROVER *****************

% --- Executes on button press in roverRelease
% function will release rover as long as the saftey toggle has been turned
% on and rover has not already been released
function roverRelease_Callback(hObject, eventdata, handles)

global gpsGround rawData;

%check to see if the button has been turned on and rover has not already
%been released
if get(handles.releaseSafety,'userdata') && get(handles.roverRelease,'userdata')~=1
    
    axes(handles.roverTranSent); %get rover transmission sent display object
    cla(handles.roverTranSent); %clear rover tran sent display
    
    %TODO******** put code to release rover here
    fprintf(gpsGround,'%s','CMDRELEASE');
    fprintf(rawData,'%s','Command Sent: U_UPCMDRELEASE');
    
    cla(handles.roverTranSent);
    text(.15,.5,datestr(now,'HH:MM:SS.FFF'),'fontsize',20,'Parent',handles.roverTranSent,'HorizontalAlignment','left'); %display the time that the transmission was sent
    
    str=fgetl(gpsGround);
    fprintf(rawData,str);
    for i=1:5
        if (strncmp(str,'EXECUTION CONFIRMED',19) ~= 1)
            pause(.5);
            str=fgetl(gpsGround);
            fprintf(rawData,str);
        end
    end
    
    cla(handles.roverTranRecieved);
    text(.15,.5,datestr(now,'HH:MM:SS.FFF'),'fontsize',20,'Parent',handles.roverTranRecieved,'HorizontalAlignment','left'); %display the time the transmission was sent
    
    cla(handles.status); %clear status bar
    text(.15,.5,'ROVER RELEASED','fontsize',24,'Parent',handles.status,'HorizontalAlignment','left'); %display rover released
    set(handles.status,'color','g'); %set background color to green
    
    set(handles.roverRelease,'userdata',1); %set rover release variable to one meaning rover release is true
    
    
else % either rover was already released or release button was not turned on using safety toggle
    
    if get(handles.roverRelease,'userdata')==1 %check to see if rover was already released
        
        cla(handles.status); %clear status bar
        text(0.1,.5,'The rover has already been released','fontsize',14,'Parent',handles.status,'HorizontalAlignment','left','color','w');%display error message
        set(handles.status,'color','black'); %bg color balck
        
    else %release button was not turned on
        
        cla(handles.status); %clear status bar
        text(0.15,.5,'Toggle Saftey Before Releasing Rover','fontsize',14,'Parent',handles.status,'HorizontalAlignment','left','color','w'); %display error message
        set(handles.status,'color','black'); %bg color balck
    end
end
startCom_Callback(hObject, eventdata, handles)
end


% --- Executes on button press in roverStart.
%function will start the rover as long as the rover has been released and
%certian amount of time has passed and the rover has not already been
%started
function roverStart_Callback(hObject, eventdata, handles)

global roverGround;
%check if the rover start button is turned on and if the rover was released
%and the the rover has not already been started %TODO add time condition
if get(handles.startSafety,'userdata')==1 && get(handles.roverRelease,'userdata')==1 && get(handles.roverStart,'userdata')~= 1 %TODO add time after release condition
    
    axes(handles.roverTranSent); %get rover tran sent display object
    cla(handles.roverTranSent); %clear display
    
    %code to start rover here
    fprintf(roverGround,'A');
    text(.15,.5,datestr(now,'HH:MM:SS.FFF'),'fontsize',20,'Parent',handles.roverTranSent,'HorizontalAlignment','left'); %display the time that the transmission was sent
    while strncmp(fgetl(roverGround),'Got reply:',10)~=1
        fprintf(roverGround,'A');
        cla(handles.roverTranSent);
        text(.15,.5,datestr(now,'HH:MM:SS.FFF'),'fontsize',20,'Parent',handles.roverTranSent,'HorizontalAlignment','left'); %display the time that the transmission was sent
        pause(1);
    end
    
    cla(handles.roverTranRecieved);
    text(.15,.5,datestr(now,'HH:MM:SS.FFF'),'fontsize',20,'Parent',handles.roverTranRecieved,'HorizontalAlignment','left'); %display the time that the transmission was recieved
    cla(handles.status);
    text(.15,.5,'ROVER STARTED','fontsize',24,'Parent',handles.status,'HorizontalAlignment','left');
    set(handles.status,'color','g');
    
    
    set(handles.roverStart,'userdata',1); %set the rover start variable to one meaning that the rover has been started
    
else %if one of above conditions is false
    
    if get(handles.roverStart,'userdata')==1 %check to see if rover has already been started
        
        cla(handles.status); %clear status bar
        text(0.1,.5,'The rover has already been started','fontsize',14,'Parent',handles.status,'HorizontalAlignment','left','color','w'); %display error message
        set(handles.status,'color','black'); %bg color black
        
    else %start button hasn't been engaged or rover hasn't been released yet
        
        cla(handles.status); %clear status bar
        text(0.01,.5,'Release Rover and Toggle Saftey Before Starting','fontsize',14,'Parent',handles.status,'HorizontalAlignment','left','color','w'); %display error message
        set(handles.status,'color','black'); %bg color black
        
    end
end
startCom_Callback(hObject, eventdata, handles)
end

% --- Executes on button press in releaseSafety.
%this function creates the toggle saftey button for the rover release
function releaseSafety_Callback(hObject, eventdata, handles)

if get(handles.releaseSafety,'userdata')==0 %check if release safety off
    set(handles.releaseSafety,'string','ON','BackgroundColor','green','userdata',1); %toggle and change display
elseif get(handles.releaseSafety,'userdata')==1 %check if release safety on
    set(handles.releaseSafety,'string','OFF','BackgroundColor','red','userdata',0); %toggle and change display
end

end


% --- Executes on button press in startSafety.
%function creates the safety toggle button for the rover start
function startSafety_Callback(hObject, eventdata, handles)

if get(handles.startSafety,'userdata')==0 %check if start safety off
    set(handles.startSafety,'string','ON','BackgroundColor','green','userdata',1); %toggle and change display
elseif get(handles.startSafety,'userdata')==1 %check if start safety on
    set(handles.startSafety,'string','OFF','BackgroundColor','red','userdata',0); %toggle and change display
end

end


% --- Executes on button press in LoadRover.
function LoadRover_Callback(hObject, eventdata, handles)
global gpsGround rawData;
%load payload

%check if payload has already been loaded
if get(handles.LoadRover,'userdata')==0

    %send command to load the rover
    fprintf(gpsGround,'%s','CMDLOADPAYLOAD');
    fprintf(rawData,'%s','Command Sent: CMDLOADROVER');
    
    cla(handles.roverTranSent);
    text(.15,.5,datestr(now,'HH:MM:SS.FFF'),'fontsize',20,'Parent',handles.roverTranSent,'HorizontalAlignment','left'); %display the time that the transmission was sent
    
    str=fgetl(gpsGround);
    fprintf(rawData,str);
    for i=1:6
        if (strncmp(str,'EXECUTION CONFIRMED',19) ~= 1)
            pause(.5);
            str=fgetl(gpsGround);
            cla(handles.roverTranRecieved);
            text(.15,.5,datestr(now,'HH:MM:SS.FFF'),'fontsize',20,'Parent',handles.roverTranRecieved,'HorizontalAlignment','left'); %display the time that the transmission was sent
            fprintf(rawData,str);
        end
    end
    
    cla(handles.status); %clear status bar
    text(0.15,.5,'ROVER LOADED','fontsize',28,'Parent',handles.status,'HorizontalAlignment','left','color','k');
    set(handles.status,'color','yellow'); %bg color yellow
    
    set(handles.LoadRover,'userdata',1);
    
else
    cla(handles.status); %clear status bar
    text(0.01,.5,'The rover has already been loaded','fontsize',14,'Parent',handles.status,'HorizontalAlignment','left','color','w'); %display error message
    set(handles.status,'color','black'); %bg color black
end

startCom_Callback(hObject, eventdata, handles)

end


% --- Executes on button press in testRover.
function testRover_Callback(hObject, eventdata, handles)

global roverGround;

fprintf(roverGround,'T');

pause(4);
str=fgetl(roverGround);
str=fgetl(roverGround);
str=fgetl(roverGround);
disp(str);
if strncmp(str,'Got reply:',10)==1
    
    cla(handles.roverTranRecieved);
    text(.15,.5,datestr(now,'HH:MM:SS.FFF'),'fontsize',20,'Parent',handles.roverTranRecieved,'HorizontalAlignment','left'); %display the time that the transmission was sent
    
    cla(handles.status); %clear status bar
    text(0.15,.5,'TEST SUCCESSFUL','fontsize',28,'Parent',handles.status,'HorizontalAlignment','left','color','k');
    set(handles.status,'color','b'); %bg color yellow
else
    cla(handles.status); %clear status bar
    text(0.01,.5,'No test signal recieved','fontsize',14,'Parent',handles.status,'HorizontalAlignment','left','color','w'); %display error message
    set(handles.status,'color','black'); %bg color black
end


end
