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

% Last Modified by GUIDE v2.5 29-Jan-2019 22:55:32

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
axes(handles.lattDisp);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.longDisp);
set(gca,'xtick',[]);
set(gca,'ytick',[]);
axes(handles.timeDisp);
set(gca,'xtick',[]);
set(gca,'ytick',[]);

%format plots 
axes(handles.lattVsTime);
grid on;
xlabel('time','FontSize',17);
ylabel('Lattitude (degrees)','FontSize',17);

axes(handles.longVsTime);
grid on;
xlabel('time','FontSize',17);
ylabel('Longitude (degrees)','FontSize',17);

axes(handles.lattVsLong);
grid on;
xlabel('Longitude (degrees)','FontSize',17);
ylabel('Lattitude (degrees)','FontSize',17);

axes(handles.altVsTime);
grid on;
xlabel('time','FontSize',17);
ylabel('Altitude (meter)','FontSize',17);

%initialze serial communication
delete(instrfind({'Port'},{'COM4'}))%delete characters left in buffer
clear serialIn;
global serialIn;
serialIn = arduino('COM4');%FILL IN CORRECT COM PORT



% --- Outputs from this function are returned to the command line.
function varargout = GPS_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


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



function edit3_Callback(hObject, eventdata, handles)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


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


% --- Executes during object creation, after setting all properties.
function axes9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: place code in OpeningFcn to populate axes9


% --- Executes on button press in startCom.
function startCom_Callback(hObject, eventdata, handles)
% hObject    handle to startCom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global serialIn; %get serial in global variable
count=1;
time=[];
%loop to read serial port
while (1)
    inData=fscanf(serialIn,'%s');
    
    if (strncmpi(inData,"$GPGGA",6)) %check if GPS data is recieved
        inData=splitstr(inData,',');
        if (count==0)
            %read in initial time
            startTime=inData(2);
            time(count)=0;
            %TODO add print time out to timeDisp 
            
            %read in initaial altitude
            startAlt=inData(9);
            alt(cout)=0;

        else
            %claculate current time
            time(count)=inData(2)-startTime;
            %TODO add print time out to timeDisp 
            
            %read in altitude and find difference between start and current
            alt(count)=inData(10)-startAlt;
            altDisp=[time,alt];
            axes(handle.altVsTime)%TODO find way to append plot to increase speed
            plot(altDisp,'-k');
        end
        
        %find latt and plot against time
        latt(count)=inData(3); %TODO convert to proper form 
        lattDisp=[time,latt];
        axes(handle.lattVsTime) %TODO find way to append plot to increase speed
        plot(lattDisp,'-k');
        
        %find long and plot agianst time
        long(count)=inData(5); %TODO convert to proper form 
        longDisp=[time,latt];
        axes(handle.longVsTime); %TODO find way to append plot to increase speed
        plot(longDisp,'-k');
        
        %plot lattitude vs. Longitude
        LvLDisp=[latt,long];
        axes(handle.lattVsLong); %TODO find way to append plot to increase speed
        plot(LvLDisp,'-k');
        
        %TODO display current lattitude
        
        %TODO display current longitude
        
        %TODO display current flight time
    end
end




% --- Executes on button press in stopCom.
function stopCom_Callback(hObject, eventdata, handles)
% hObject    handle to stopCom (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
