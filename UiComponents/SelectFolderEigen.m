function varargout = SelectFolderEigen(varargin)
% SELECTFOLDEREIGEN MATLAB code for SelectFolderEigen.fig
%      SELECTFOLDEREIGEN, by itself, creates a new SELECTFOLDEREIGEN or raises the existing
%      singleton*.
%
%      H = SELECTFOLDEREIGEN returns the handle to a new SELECTFOLDEREIGEN or the handle to
%      the existing singleton*.
%
%      SELECTFOLDEREIGEN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SELECTFOLDEREIGEN.M with the given input arguments.
%
%      SELECTFOLDEREIGEN('Property','Value',...) creates a new SELECTFOLDEREIGEN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before SelectFolderEigen_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to SelectFolderEigen_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help SelectFolderEigen

% Last Modified by GUIDE v2.5 21-Jul-2015 22:16:01

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SelectFolderEigen_OpeningFcn, ...
                   'gui_OutputFcn',  @SelectFolderEigen_OutputFcn, ...
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


% --- Executes just before SelectFolderEigen is made visible.
function SelectFolderEigen_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to SelectFolderEigen (see VARARGIN)

% Choose default command line output for SelectFolderEigen
handles.output = hObject;
guidata(hObject, handles);
cPath=mfilename('fullpath');
[folder,~,~] = fileparts(cPath);
imFile = fullfile(folder, 'img/', 'header.png');
img=imread(imFile);
imshow(img,'Parent',handles.axes1)
axis('off')
set(handles.edit1, 'String','...')
% show path from last time.
global PATH
if (length(PATH)>2)
set(handles.edit1, 'String', PATH);
set(handles.pushbutton2, 'enable', 'on');
end
handles.root=matlabpath;

% Update handles structure
%guidata(hObject, handles);


dimsbox = uicontrol(Style="popupmenu",Position=[10 15 40 30],Tag="popupmenu1",FontSize=12);
handles.popupmenu1 = dimsbox;
for i=2:101
    list{i-1}=num2str(i);
end
set(handles.popupmenu1, 'string', list);
set(handles.popupmenu1, 'value', 4); % new dimensions default

popup_text = uicontrol(Style="text",Position=[55 10 200 30],Tag="text1",String='Number of Dimensions',BackgroundColor="white",FontSize=12);
handles.text1 = popup_text;
guidata(hObject,handles);

% UIWAIT makes SelectFolderEigen wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = SelectFolderEigen_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout={-1};
if handles.cancel==1,   % if cancel
    delete(handles.figure1);
    return;
end
struc.folder = get(handles.edit1, 'String');
struc.sparse = get(handles.checkbox1,'Value');
struc.dims = get(handles.popupmenu1,'value');
varargout{1}=struc;
delete(handles.figure1);



% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
folder =uigetdir(handles.root,'Select Group Folder');
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

if length(handles.edit1)<1 % empty lenth is one.
    mode = struct('WindowStyle','non-modal','Interpreter','tex');
    msg = DialogMessages(5);
    errordlg(msg, 'Error', mode);
else
    handles.cancel=0;
    guidata(handles.figure1,handles);
    if isequal(get(handles.figure1, 'waitstatus'), 'waiting')
        uiresume(handles.figure1)
    else
        delete(handles.figure1);
    end
end


function ValueChangedCheckbox(hObject, eventdata, handles)





% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
handles.cancel=1;
guidata(handles.figure1,handles);
h= handles.figure1;
if isequal(get(h, 'waitstatus'), 'waiting')
    uiresume(h)
else
    h= handles.figure1;
    delete(h);
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
