%*******************************************************************************%
%                           PITT ROCKETRY GROUND-CONTROL
%                                GPS GUI and Script
%  FUNCTIONALITY
%               : recieve serial input from teensy 3.6
%               : parse NMEA data string
%               : Display longitude, lattitude, altitude, and flight time
%               : enable start and stop of serial comunication
%               : Display final rocket location and path on map
%               : Print raw serial data to file
%               : Calculate and display distance from launch site
%
%  NOTES
%               : Set correct serial port on lines 124 and 127
%               : Edit line 203 to correct packet header
%               : To test with input file comment out 125-129 and
%               un-comment 129-130
%               : set range for long and lat
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

% Last Modified by GUIDE v2.5 02-Feb-2019 13:23:04

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
% --- Executes just before GPS_GUI is made visible.
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

% UIWAIT makes GPS_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%display logo
axes(handles.axes9);
imshow('logo.png');

%format time/lat/long displays to remove axies
axes(handles.latDisp);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.longDisp);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.timeDisp);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.fixDisp)
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.maxDist)
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.maxAlt)
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.status)
set(gca,'xtick',[]);
set(gca,'ytick',[]);
cla(handles.status) 
text(.2,.5,'SYSTEM READY','fontsize',24,'Parent',handles.status,'HorizontalAlignment','left');
axes(handles.rssiDisp)
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(handles.rssiDisp,'color','black');

axes(handles.latVsLong);
set(gca,'xtick',[]);
set(gca,'ytick',[]);

axes(handles.distDisp);
set(gca,'xtick',[]);
set(gca,'ytick',[]);

axes(handles.roverTranSent)
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.roverTranRecieved)
set(gca,'xtick',[]);
set(gca,'ytick',[]);

%setup push toggle safety swithches
set(handles.releaseSafety,'userdata',0);
set(handles.startSafety,'userdata',0);
set(handles.roverStart,'userdata',0);
set(handles.roverRelease,'userdata',0);




global serialIn rawData;

% % %initialze serial communication
% delete(instrfind({'Port'},{'COM8'}))%delete characters left in buffer
% clear serialIn;
% global serialIn;
% serialIn = serial('COM8');
% fopen(serialIn);


d=datestr(now,'dd-HH-MM-SS');
filename=strcat(d,'results.txt');
rawData=fopen(filename,'wt'); %open output file to write serial output to


serialIn=fopen('test_data.txt'); %test data

end

% --- Outputs from this function are returned to the command line.
function varargout = GPS_GUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on button press in startCom.
function startCom_Callback(hObject, eventdata, handles)
% hObject    handle to startCom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.stopCom,'userdata',0); % sets loop stop condition to zero

global serialIn rawData; %get serial in global variable

dist=[];
launchDetected=false;
apogeeDetected=false;
count=1;
time=[];
startTime=0;
alt=[];
startAlt=0;
flightStart=0;
rssi=[];
rssiNum=1;
rssiNumArray=[];

%loop to read serial port
while (1)
    inData=fgetl(serialIn);
    fprintf(rawData,"%s\n",inData);
    
    if (strncmpi(inData,'Got: $GPGGA',11)) %check if GPS data is recieved %TODO correct for actual packet format
        gpsData=strsplit(inData,',');
        if (strncmpi(gpsData{7},'1',1) || strncmpi(gpsData{7},'2',1))
            cla(handles.fixDisp);
            axes(handles.fixDisp);
            text(.30,.5,'YES','fontsize',24,'Parent',handles.fixDisp,'HorizontalAlignment','left'); %display yes for gps fix
            set(gca,'color','green');
            
            if (count==1)
                %read in initial time
                startTime=str2double(gpsData{2});
                time(count)=0;
                
                %TODO add print time out to timeDisp
                
                %read in initaial altitude
                startAlt=str2double(gpsData{10});
                alt(count)=0;
                
            else
                %claculate current time
                time(count)=str2double(gpsData{2})-startTime;
                %disp(time(count));
                
                
                %read in altitude and find difference between start and current
                alt(count)=str2double(gpsData{10})-startAlt;

                if (alt(count)>2 && launchDetected == false)
                    flightStart=time(count);
                    axes(handles.status)
                    cla(handles.status) %clears latitude display
                    text(.15,.5,'LAUNCH DETECTED','fontsize',24,'Parent',handles.status,'HorizontalAlignment','left');
                    set(handles.status,'Color','yellow');
                    launchDetected=true;
                end
                
                if (alt(count)<alt(count-1) && alt(count)<alt(count-2) && alt(count)<alt(count-3) && apogeeDetected==false)
                   
                    axes(handles.status)
                    cla(handles.status) %clears latitude display
                    text(.15,.5,'APOGEE DETECTED','fontsize',24,'Parent',handles.status,'HorizontalAlignment','left');
                    set(handles.status,'Color','yellow');
                    apogeeDetected=true;
                end
                
                if (apogeeDetected==true && alt(count-1)>.999*alt(count) && alt(count-1)<1.001*alt(count) && alt(count)<alt(count-5))
                    axes(handles.status)
                    cla(handles.status) %clears latitude display
                    text(.15,.5,'LANDING DETECTED','fontsize',24,'Parent',handles.status,'HorizontalAlignment','left');
                    set(handles.status,'Color','green');
                end
                
                axes(handles.altVsTime)%TODO find way to append plot to increase speed
                plot(time,alt,'-k');
            end
            
            %find latt and plot against time
            lat(count)=DMStoDD(gpsData{3},'lat'); %extract lat and convert to proper form
            
            %determine if lat is positive or negative
            if (strncmpi(gpsData{4},'S',1))
                lat(count)=-1*lat(count);
            end
            
            
            %find long and plot agianst time
            long(count)=DMStoDD(gpsData{5},'lon'); 
            
            %determine if long is positive or negative
            if (strncmpi(gpsData{6},'W',1))
                long(count)=-1*long(count);
            end
            

            
            %plot lattitude vs. Longitude
            axes(handles.latVsLong); %TODO find way to append plot to increase speed
            
            if(count==1)
                plot(long,lat,'.b','MarkerSize',25);
                set(gca,'xtick',[]);
                set(gca,'ytick',[]);
                ylim([(min(lat)-.0072),(max(lat)+.0072)]);  %set range of long and lat
                xlim([(min(long)-.0072),(max(long)+.0072)]);
                
                plot_google_map('maptype','hybrid');
                
            else
                axes(handles.latVsLong)
                plot(long(1:count-1),lat(1:count-1),'-r','LineWidth',3); 
                set(gca,'xtick',[]);
                set(gca,'ytick',[]);
            end
            
            
            
            %display current lattitude
            cla(handles.latDisp) %clears latitude display
            text(.30,.5,num2str(lat(count)),'fontsize',24,'Parent',handles.latDisp,'HorizontalAlignment','left');
            
            
            %display current longitude
            cla(handles.longDisp) %clears latitude display
            text(.30,.5,num2str(long(count)),'fontsize',24,'Parent',handles.longDisp,'HorizontalAlignment','left');
            
            %display max altitude
            cla(handles.maxAlt) %clears latitude display
            text(.30,.5,num2str(max(alt)),'fontsize',20,'Parent',handles.maxAlt,'HorizontalAlignment','left');
            
            if launchDetected==true
                %display current flight time
                cla(handles.timeDisp) %clears latitude display
                text(.375,.5,num2str(time(count)-flightStart),'fontsize',20,'Parent',handles.timeDisp,'HorizontalAlignment','left');
            else
                cla(handles.timeDisp) %clears latitude display
                text(.375,.5,'0','fontsize',20,'Parent',handles.timeDisp,'HorizontalAlignment','left');
            end
            
            dist(count)=haversine(long(1),long(count),lat(1),lat(count));
            cla(handles.distDisp) %clears latitude display
            text(.2,.5,num2str(dist(count)),'fontsize',20,'Parent',handles.distDisp,'HorizontalAlignment','left');
            
            cla(handles.maxDist) %clears latitude display
            text(.05,.5,num2str(max(dist)),'fontsize',20,'Parent',handles.maxDist,'HorizontalAlignment','left');
            
            
            count=count+1;
            
        else
            cla(handles.fixDisp);
            axes(handles.fixDisp);
            text(.30,.5,'NO','fontsize',24,'Parent',handles.fixDisp,'HorizontalAlignment','left');
            set(gca,'color','red');
        end
    elseif (strncmpi(inData,'RSSI:',5)) && (strncmpi(gpsData{7},'1',1) || strncmpi(gpsData{7},'2',1))
        rssiData=strsplit(inData,':');
        rssi(rssiNum)=str2double(rssiData(2));
        axes(handles.rssiVsTrans)
        rssiNumArray(rssiNum)=rssiNum;
        plot(dist(1:count-1),rssi,'.r','markersize',20);
        cla(handles.rssiDisp);
        text(0,.65,strcat('   ',num2str(rssi(rssiNum))),'fontsize',20,'Parent',handles.rssiDisp,'color','white');
        rssiNum=rssiNum+1;
    end
    
    drawnow; %evaluate push button
    if get(handles.stopCom,'userdata')% stop condition
        axes(handles.latVsLong);
        plot(long(count-1),lat(count-1),'.g','MarkerSize',25);
        set(gca,'xtick',[]);
        set(gca,'ytick',[]);
        
        break;
    end
end
end



% --- Executes on button press in stopCom.
function stopCom_Callback(hObject, eventdata, handles)
% hObject    handle to stopCom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.stopCom,'userdata',1);

%function converts from Degrees Minutes Seconds to decimal degrees
%gps outputs lat: DDMM.MMMM long: DDDMM.MMMM
%DD = d + (min/60) + (sec/3600)
end
function DD = DMStoDD(DMS, type)
if (type=='lat')
    latD=str2double(DMS(1:2));
    latM=str2double(DMS(3:9));
    DD=latD+(latM/60);
elseif (type=='lon')
    longD=str2double(DMS(1:3));
    longM=str2double(DMS(4:10));
    DD=longD+(longM/60);
end
end

% --- Executes during object creation, after setting all properties.
function axes9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes9
end

%--- Haversine function, calculates distance between two coordinates
function dist=haversine(long1,long2,lat1,lat2)

R=6371000; %radius of the earth in meters

p1=degtorad(lat1);
p2=degtorad(lat2);

deltaP=degtorad(lat2-lat1);
deltaL=degtorad(long2-long1);

a=(sin(deltaP/2)^2)+cos(p1)*cos(p2)*(sin(deltaL/2)^2);
c=2*atan2(sqrt(a),sqrt(1-a));

dist=R*c;
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
end


% --- Executes on button press in roverRelease.
function roverRelease_Callback(hObject, eventdata, handles)
% hObject    handle to roverRelease (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.releaseSafety,'userdata') && get(handles.roverRelease,'userdata')~=1
    axes(handles.roverTranSent);
    cla(handles.roverTranSent);
    text(.15,.5,datestr(now,'HH:MM:SS.FFF'),'fontsize',20,'Parent',handles.roverTranSent,'HorizontalAlignment','left');
    cla(handles.status);
    text(.15,.5,'ROVER RELEASED','fontsize',24,'Parent',handles.status,'HorizontalAlignment','left');
    set(handles.status,'color','g');
    %TODO******** put code to release rover here
    
    set(handles.roverRelease,'userdata',1);
else
    if get(handles.roverRelease,'userdata')==1
        cla(handles.status);
        text(0.1,.5,'The rover has already been released','fontsize',14,'Parent',handles.status,'HorizontalAlignment','left','color','w');
        set(handles.status,'color','black');
    else
        cla(handles.status);
        text(0.15,.5,'Toggle Saftey Before Starting','fontsize',14,'Parent',handles.status,'HorizontalAlignment','left','color','w');
        set(handles.status,'color','black');
    end
end
end


% --- Executes on button press in roverStart.
function roverStart_Callback(hObject, eventdata, handles)
% hObject    handle to roverStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.startSafety,'userdata')==1 && get(handles.roverRelease,'userdata')==1 && get(handles.roverStart,'userdata')~= 1 %TODO add time after release condition
    axes(handles.roverTranSent);
    cla(handles.roverTranSent);
    text(.15,.5,datestr(now,'HH:MM:SS.FFF'),'fontsize',20,'Parent',handles.roverTranSent,'HorizontalAlignment','left');
    cla(handles.status);
    text(.15,.5,'ROVER STARTED','fontsize',24,'Parent',handles.status,'HorizontalAlignment','left');
    set(handles.status,'color','g');
    %TODO******** put code to start rover here
    
    set(handles.roverStart,'userdata',1);
    
else
    if get(handles.roverStart,'userdata')==1
        cla(handles.status);
        text(0.1,.5,'The rover has already been started','fontsize',14,'Parent',handles.status,'HorizontalAlignment','left','color','w');
        set(handles.status,'color','black');
    else
        cla(handles.status);
        text(0.01,.5,'Release Rover and Toggle Saftey Before Starting','fontsize',14,'Parent',handles.status,'HorizontalAlignment','left','color','w');
        set(handles.status,'color','black');
    end
end
end

% --- Executes on button press in releaseSafety.
function releaseSafety_Callback(hObject, eventdata, handles)
% hObject    handle to releaseSafety (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of releaseSafety
if get(handles.releaseSafety,'userdata')==0
    set(handles.releaseSafety,'string','ON','BackgroundColor','green','userdata',1);
elseif get(handles.releaseSafety,'userdata')==1
    set(handles.releaseSafety,'string','OFF','BackgroundColor','red','userdata',0);
end
end


% --- Executes on button press in startSafety.
function startSafety_Callback(hObject, eventdata, handles)
% hObject    handle to startSafety (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of startSafety
if get(handles.startSafety,'userdata')==0
    set(handles.startSafety,'string','ON','BackgroundColor','green','userdata',1);
elseif get(handles.startSafety,'userdata')==1
    set(handles.startSafety,'string','OFF','BackgroundColor','red','userdata',0);
end
end
