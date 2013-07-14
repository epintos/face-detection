function varargout = atifinal(varargin)
% ATIFINAL MATLAB code for atifinal.fig
%      ATIFINAL, by itself, creates a new ATIFINAL or raises the existing
%      singleton*.
%
%      H = ATIFINAL returns the handle to a new ATIFINAL or the handle to
%      the existing singleton*.
%
%      ATIFINAL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ATIFINAL.M with the given input arguments.
%
%      ATIFINAL('Property','Value',...) creates a new ATIFINAL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before atifinal_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to atifinal_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help atifinal

% Last Modified by GUIDE v2.5 14-Jul-2013 02:44:43

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @atifinal_OpeningFcn, ...
                   'gui_OutputFcn',  @atifinal_OutputFcn, ...
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


% --- Executes just before atifinal is made visible.
function atifinal_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to atifinal (see VARARGIN)

% Choose default command line output for atifinal
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

set(handles.text2, 'String', 150);
set(handles.text4, 'String', 1);
set(handles.text6, 'String', 50);

% UIWAIT makes atifinal wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = atifinal_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function plot_squares(xs, ys, ds)
    hold on
    for i = 1:length(xs)
       x = xs(i);
       y = ys(i);
       d = ds(i);  
       xplot = [x - d, x + d, x + d, x - d, x - d];
       yplot = [y - d, y - d, y + d, y + d, y - d];
       plot(xplot, yplot, 'r');
    end
    hold off


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global detector
    detector.params.min_face = double(int64(get(hObject,'Value')))
    set(handles.text2, 'String', detector.params.min_face)


% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
set(hObject,'Value',150);


function process(hObject)
    global detector
    detector.data = guidata(hObject); 
    detector.steps = {}
    detect_faces(detector.filename, detector.fileext, detector.data);

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global detector
    [file, dir, ext] = uigetfile({'*.jpeg;*.jpg;*.gif:*.png;*.JPEG;*.JPG;*.GIF:*.PNG', 'Fotos (GIF, PNG, JPEG)'},'Elija la foto');
    filename = [dir, file];
    [pathstr, name, ext] = fileparts(file);
    detector = {};
    detector.params = {}
    detector.params.show_steps  = 1;
    detector.params.show_boxes_always  = 1;
    detector.filename = filename;
    detector.fileext = ext(2:length(ext));
    handles=guidata(hObject); 
    axes(handles.preview)
    rgb = imread([dir, file]);
    imshow(rgb);
    process(hObject)


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
    process(hObject)

% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

    global detector
    detector.params.effect_num = double(int64(get(hObject,'Value')))
    set(handles.text4, 'String', detector.params.effect_num)


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global detector
    detector.params.small_area = double(int64(get(hObject,'Value')))
    set(handles.text6, 'String', detector.params.small_area)


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function handleClick(target, data)
    global detector
    axes(target)
    imshow(data)
    if detector.params.show_boxes_always == 1
        plot_squares(detector.params.res(:,2), detector.params.res(:,1), detector.params.res(:,5))
    end
    
    

% --- Executes on button press in step8_btn.
function step8_btn_Callback(hObject, eventdata, handles)
% hObject    handle to step8_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global detector
    h = guidata(hObject)
    handleClick(h.target, detector.steps.step8)


% --- Executes on button press in step7_btn.
function step7_btn_Callback(hObject, eventdata, handles)
% hObject    handle to step7_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global detector
    h = guidata(hObject)
    handleClick(h.target, detector.steps.step7)

% --- Executes on button press in step6_btn.
function step6_btn_Callback(hObject, eventdata, handles)
% hObject    handle to step6_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global detector
    h = guidata(hObject)
    handleClick(h.target, detector.steps.step6)

% --- Executes on button press in step5_btn.
function step5_btn_Callback(hObject, eventdata, handles)
% hObject    handle to step5_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global detector
    h = guidata(hObject)
    handleClick(h.target, detector.steps.step5)

% --- Executes on button press in step4_btn.
function step4_btn_Callback(hObject, eventdata, handles)
% hObject    handle to step4_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global detector
    h = guidata(hObject)
    handleClick(h.target, detector.steps.step4)

% --- Executes on button press in step2_btn.
function step2_btn_Callback(hObject, eventdata, handles)
% hObject    handle to step2_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global detector
    h = guidata(hObject)
    handleClick(h.target, detector.steps.step2)

% --- Executes on button press in step3_btn.
function step3_btn_Callback(hObject, eventdata, handles)
% hObject    handle to step3_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global detector
    h = guidata(hObject)
    handleClick(h.target, detector.steps.step3)

% --- Executes on button press in step1_btn.
function step1_btn_Callback(hObject, eventdata, handles)
% hObject    handle to step1_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global detector
    h = guidata(hObject)
    handleClick(h.target, detector.steps.step1)


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global detector
    detector.params.show_steps = get(hObject,'Value')


% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global detector
    detector.params.show_boxes_always = get(hObject,'Value')


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider9_Callback(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function slider9_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end
