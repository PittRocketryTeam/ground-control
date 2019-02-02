%*******************************************************************************%
%                           PITT ROCKETRY GROUND-CONTROL
%                                GPS GUI and Script
%  FUNCTIONALITY
%               : recieve serial input from teensy 3.6
%               : parse NMEA data string
%               : Display longitude, lattitude, altitude, and flight time
%               : enable start and stop of serial comunication
%               : Display final rocket location
%  NOTES
%               : Set correct serial port on lines 124 and 127
%               : Edit line 203 to correct packet header
%               : To test with input file comment out 125-129 and
%               un-comment 129-130
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

% Last Modified by GUIDE v2.5 30-Jan-2019 14:29:21

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

%format plots
axes(handles.latVsTime);
xlabel('time','FontSize',17);
ylabel('Latitude (degrees)','FontSize',17);

axes(handles.longVsTime);
xlabel('time','FontSize',17);
ylabel('Longitude (degrees)','FontSize',17);

axes(handles.latVsLong);
xlabel('Longitude (degrees)','FontSize',17);
ylabel('Latitude (degrees)','FontSize',17);

axes(handles.altVsTime);
xlabel('time','FontSize',17);
ylabel('Altitude (meter)','FontSize',17);

% %initialze serial communication
delete(instrfind({'Port'},{'COM3'}))%delete characters left in buffer
clear serialIn;
global serialIn;
serialIn = serial('COM3');
fopen(serialIn);


% global serialIn;
% serialIn=fopen('test_data.txt'); %test data
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

global serialIn; %get serial in global variable

count=1;
time=[];
startTime=0;
alt=[];
startAlt=0;
%loop to read serial port
while (1)
    inData=fgetl(serialIn); % read data from serial port
    if (strncmpi(inData,'Got: $GPGGA',11)) %check if GPS data is recieved %TODO correct for actual packet format
        inData=strsplit(inData,','); % split data by commas
        disp(inData{7}); % display TODO what is index 7?
        if (strncmpi(inData{7},'1',1) || strncmpi(inData{7},'2',1))
            cla(handles.fixDisp);
            axes(handles.fixDisp);
            text(.30,.5,'YES','fontsize',24,'Parent',handles.fixDisp,'HorizontalAlignment','left'); %display yes for gps fix
            set(gca,'color','green'); % GPS fix color
            
            if (count==1)
                %read in initial time
                startTime=str2double(inData{2});
                time(count)=0;
                
                %TODO add print time out to timeDisp
                
                %read in initaial altitude
                startAlt=str2double(inData{10});
                alt(count)=0;
                
            else
                %claculate current time
                time(count)=str2double(inData{2})-startTime;
                %disp(time(count));
                %TODO add print time out to timeDisp
                
                %read in altitude and find difference between start and current
                alt(count)=str2double(inData{10})-startAlt;
                
                axes(handles.altVsTime)%TODO find way to append plot to increase speed
                plot(time,alt,'-k');
            end
            
            %find latt and plot against time
            lat(count)=DMStoDD(inData{3},'lat'); %extract lat and convert to proper form
            
            %determine if lat is positive or negative
            if (strncmpi(inData{4},'S',1))
                lat(count)=-1*lat(count);
            end
            
            axes(handles.latVsTime) %TODO find way to append plot to increase speed
            plot(time,lat,'-k');
            disp(lat)
            
            %find long and plot agianst time
            long(count)=DMStoDD(inData{5},'lon'); %TODO convert to proper form
            
            %determine if long is positive or negative
            if (strncmpi(inData{6},'W',1))
                long(count)=-1*long(count);
            end
            
            axes(handles.longVsTime); %TODO find way to append plot to increase speed
            plot(time,long,'-k');
            
            %plot lattitude vs. Longitude
            axes(handles.latVsLong); %TODO find way to append plot to increase speed
            plot(lat,long,'-k');
            
            %display current lattitude
            cla(handles.latDisp) %clears latitude display
            text(.30,.5,num2str(lat(count)),'fontsize',24,'Parent',handles.latDisp,'HorizontalAlignment','left');
            
            
            %display current longitude
            cla(handles.longDisp) %clears latitude display
            text(.30,.5,num2str(long(count)),'fontsize',24,'Parent',handles.longDisp,'HorizontalAlignment','left');
            
            %display current flight time
            cla(handles.timeDisp) %clears latitude display
            text(.30,.5,num2str(time(count)),'fontsize',24,'Parent',handles.timeDisp,'HorizontalAlignment','left');
            
            count=count+1; %incriment count
        else
            cla(handles.fixDisp);
            axes(handles.fixDisp);
            text(.30,.5,'NO','fontsize',24,'Parent',handles.fixDisp,'HorizontalAlignment','left');
            set(gca,'color','red');
            
        end
    end
    
    drawnow; %evaluate push button
    if get(handles.stopCom,'userdata') % stop condition
        break;
    end
    if str2double(inData)==-1.0
        break;
    end
end

% TODO is there a way to wait for a full line of serial to be available,
% rather than pausing for a few ms?
pause(.005); %pause for 5 ms before repeating loop
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
