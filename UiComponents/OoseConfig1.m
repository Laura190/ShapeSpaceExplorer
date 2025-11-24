function varargout = OoseConfig1(varargin)
% OOSECONFIG1 MATLAB code for OoseConfig1.fig
%      OOSECONFIG1, by itself, creates a new OOSECONFIG1 or raises the existing
%      singleton*.
%
%      H = OOSECONFIG1 returns the handle to a new OOSECONFIG1 or the handle to
%      the existing singleton*.
%
%      OOSECONFIG1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OOSECONFIG1.M with the given input arguments.
%
%      OOSECONFIG1('Property','Value',...) creates a new OOSECONFIG1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OoseConfig1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OoseConfig1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OoseConfig1

% Last Modified by GUIDE v2.5 24-Nov-2025 13:40:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @OoseConfig1_OpeningFcn, ...
                   'gui_OutputFcn',  @OoseConfig1_OutputFcn, ...
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


% --- Executes just before OoseConfig1 is made visible.
function OoseConfig1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OoseConfig1 (see VARARGIN)

% Choose default command line output for OoseConfig1
handles.output = hObject;
guidata(hObject, handles);
cPath=mfilename('fullpath');
[folder,~,~] = fileparts(cPath);
imFile = fullfile(folder, 'img/', 'header.png');
img=imread(imFile);
imshow(img,'Parent',handles.axes1);
set(handles.edit1, 'String','...'); 
set(handles.edit2, 'String','...');
set(handles.popupmenu3, 'String',{'K Nearest Neighbors','Laplacian Pyramids'});
set(handles.edit3, 'String','5');

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes OoseConfig1 wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = OoseConfig1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
struc.anaFolder = get(handles.edit1, 'String');
struc.OosFolder = get(handles.edit2, 'String');
struc.chosen_method = get(handles.popupmenu3, 'Value');
struc.nn_value = str2double(get(handles.edit3,'String'));
varargout{1}=struc;
delete(handles.figure1);


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder =uigetdir(matlabroot,'Select Analysis Directory');
set(handles.edit1, 'String',folder)  
set(handles.pushbutton2, 'enable', 'on'); 


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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folderAna =get(handles.edit1, 'String');
folderOos =get(handles.edit2, 'String');
chosen_method = get(handles.popupmenu3, 'Value');
selected_item = get(handles.popupmenu3, 'String');
nn_value = str2double(get(handles.edit3,'String'));
disp(['Running OoSE embeddding using ', selected_item{chosen_method}]);

if strcmp(folderAna,'...')==1 || strcmp(folderOos,'...')
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(12);
    errordlg(msg, 'Error', mode);
    return;
end
if  ~exist(folderAna, 'dir')
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(5);
    errordlg(msg, 'Error', mode);
    return;
end

if  ~exist(folderOos, 'dir')
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(5);
    errordlg(msg, 'Error', mode);
    return;
end
if strcmp(folderAna,folderOos)
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(13);
    errordlg(msg, 'Error', mode);
    return;
end

    
figure1_CloseRequestFcn(hObject, eventdata, handles)








% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
h= handles.figure1;
if isequal(get(h, 'waitstatus'), 'waiting')
    uiresume(h)
else
    h= handles.figure1;
    delete(h);
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


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder =uigetdir(matlabroot,'Select OOSE Directory');
set(handles.edit2, 'String',folder)  
set(handles.pushbutton2, 'enable', 'on'); 


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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
