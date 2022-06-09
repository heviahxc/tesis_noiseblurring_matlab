function varargout = interfaz(varargin)


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @interfaz_OpeningFcn, ...
                   'gui_OutputFcn',  @interfaz_OutputFcn, ...
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






% --- Executes just before interfaz is made visible.
function interfaz_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to interfaz (see VARARGIN)

% Choose default command line output for interfaz
handles.output = hObject;
setGlobalx (0)

a = imread('fondo.jpg');
   image(a);
set(handles.radiobutton6,'Enable','off')
set(handles.slider6,'Enable','off')
% Update handles structure
guidata(hObject, handles);
global intensidad
intensidad = 0;
global inten
inten = 0;
global cond;
cond = 0;

a=imread('boton.jpg');
set(handles.uploadimagen,'CData',a)
set(handles.deteriorar,'CData',a)
set(handles.filtrar,'CData',a)
set(handles.pushbutton5,'CData',a)



% UIWAIT makes interfaz wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = interfaz_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function setGlobalx(val)
global condicionimagen
condicionimagen = val;

function r = getGlobalx
global condicionimagen
r = condicionimagen;



% --- Executes on button press in uploadimagen.
function uploadimagen_Callback(hObject, eventdata, handles)
% hObject    handle to uploadimagen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global ruta;

setGlobalx (1)
[img, ruta] = uigetfile({'*.bmp; *.jpg; *.png;'});
   if isequal(img,0)   
   axes(handles.axes1);
   set(handles.uploadimagen, 'UserData',img);
   else
  im = imread(strcat(ruta, img));
   I = uint8(im);
   axes(handles.axes1);
   imshow(I);
   set(handles.uploadimagen, 'UserData', I);
   
end
   



% --- Executes on button press in deteriorar.
function deteriorar_Callback(hObject, eventdata, handles)
global modo;
global intensidad;
global PSF;
global ruta;
global intensi;


im = get(handles.uploadimagen, 'UserData');
r = getGlobalx;

if r == 0
    msgbox('Inserte una imagen'); 
    set(handles.deteriorar, 'UserData', im);
elseif isequal(im,0)
  msgbox('Inserte una imagen'); 
  set(handles.deteriorar, 'UserData', im);
else
  

if modo==1
   
    if intensidad == 0
    msgbox('Asigne una intensidad'); 
    
    else
    I=imnoise(im,'salt & pepper',intensidad);
    axes(handles.axes2);
   imshow(I);
    title('Sal y pimienta');
    set(handles.deteriorar, 'UserData', I);

    end
end
if modo==2
   
    if intensidad == 0
    msgbox('Asigne una intensidad'); 
    
    else
 I=imnoise(im,'gaussian',0,intensidad);
 axes(handles.axes2);
 imshow(I);
 title('Gaussian');
 set(handles.deteriorar, 'UserData', I);

    end
end
if modo==3
    if intensidad == 0
    msgbox('Asigne una intensidad'); 
    
    else
    I=imnoise(im,'speckle',intensidad);
axes(handles.axes2)
imshow(I);
title('Speckle');
set(handles.deteriorar, 'UserData', I);
    end

end

if modo==5
PSF = fspecial('gaussian',intensi,5);
blurred = imfilter(im,PSF,'symmetric','conv');


axes(handles.axes2)
 imshow(blurred)
 title('Simulate Blur and Noise')
set(handles.deteriorar, 'UserData', blurred);



end    
end




% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
global modo;
if hObject == handles.salypimienta
    modo=1;
   
set(handles.radiobutton6,'Enable','off')
set(handles.radiobutton4,'Enable','on')
set(handles.fbilateral,'Enable','on')
set(handles.slider1,'Enable','on')
set(handles.slider6,'Enable','off')
end
if hObject == handles.gaussiano
    modo=2;
   
set(handles.radiobutton6,'Enable','off')
set(handles.radiobutton4,'Enable','on')
set(handles.fbilateral,'Enable','on')
set(handles.slider1,'Enable','on')
set(handles.slider6,'Enable','off')
end
if hObject == handles.speckle
    modo=3;
 
set(handles.radiobutton6,'Enable','off')
set(handles.radiobutton4,'Enable','on')
set(handles.fbilateral,'Enable','on')
set(handles.slider1,'Enable','on')
set(handles.slider6,'Enable','off')
end

if hObject == handles.desenfoquegaussiano
    modo=5;
   
set(handles.radiobutton6,'Enable','on')
set(handles.radiobutton4,'Enable','off')
set(handles.fbilateral,'Enable','off')
    set(handles.slider1,'Enable','off')
set(handles.slider6,'Enable','on')
end



% --- Executes on button press in speckle.
function speckle_Callback(hObject, eventdata, handles)
% hObject    handle to speckle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of speckle


% --- Executes on button press in filtrar.
function filtrar_Callback(hObject, eventdata, handles)

global mod;
global x;
global inten;

global ruta;
global cond;
global PSF;
im = get(handles.deteriorar, 'UserData');
r = getGlobalx;

if r == 0
    msgbox('Inserte una imagen'); 
elseif isequal(im,0)
  msgbox('Inserte una imagen'); 
else

if mod==1
    
    
    filtro1=fspecial('average');
    im=imfilter(im,filtro1);

    axes(handles.axes3);
    imshow(im);
    title('Promediador');
    set(handles.filtrar, 'UserData', im);

end

if mod==3
    if inten == 0
    msgbox('Asigne una intensidad'); 
    
    else
        im = deconvlucy(im,PSF,inten);
axes(handles.axes3);
imshow(im);
title('Richardson');
    set(handles.filtrar, 'UserData', im);

    end
end
if mod==4
   
   if cond == 0
   msgbox('Asigne los parametros necesarios'); 
   else
    
  J = peronaYMalik(im, x(1), x(2), inten);
   axes(handles.axes3);
    imshow(J);
    title('PM');
   
    set(handles.filtrar, 'UserData', J);

   end
end    
end

function I = peronaYMalik(I, numIt, dt, k)

 

    I = double(I);

 

    [xDim, yDim, numCh] = size(I);

 

    xf = [1 1:xDim-1];
    xb = [2:xDim xDim];

 

    yf = [1 1:yDim-1];
    yb = [2:yDim yDim];

 


    for i = 1: numIt
            In = I(xf,:,:) - I;
         Is = I(xb,:,:) - I;    
            Ie = I(:,yf,:) - I;
        Io = I(:,yb,:) - I;
    
            gn =  1./(1 + (abs(In)./k).^2);
            gs =  1./(1 + (abs(Is)./k).^2);
            ge =  1./(1 + (abs(Ie)./k).^2);
            go =  1./(1 + (abs(Io)./k).^2);
    
            I = I  + dt.*(In.*gn + Is.*gs + Ie.*ge + Io.*go);
    end
         I = uint8(I);

         function v = snr(x,y)
x = double(x);
y = double(y);
% snr - signal to noise ratio
%
%   v = snr(x,y);
%
% v = 20*log10( norm(x(:)) / norm(x(:)-y(:)) )
%
%   x is the original clean signal (reference).
%   y is the denoised signal.
% 
%   Copyright (c) 2008 Gabriel Peyre

 

v = 20*log10(norm(x(:))/norm(x(:)-y(:)));




% --- Executes when selected object is changed in uibuttongroup3.
function uibuttongroup3_SelectionChangedFcn(hObject, eventdata, handles)

global mod;
if hObject == handles.radiobutton4
    mod=1;
end

if hObject == handles.radiobutton6
    mod=3;
end
if hObject == handles.fbilateral
    mod=4;
end



% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)

global intensidad;
valor = get(hObject,'Value');
set(handles.text2,'String',valor);
intensidad = valor;


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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


imo = get(handles.uploadimagen, 'UserData');
imd = get(handles.deteriorar, 'UserData');
imf = get(handles.filtrar, 'UserData');

v = snr(imo,imd);
set(handles.text3,'String',v);

s = snr(imo,imf);
set(handles.text10,'String',s);


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
global inten;
valor = get(hObject,'Value');

Y = round(valor);
set(handles.text12,'String',Y);
inten = valor;

% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
global intensi;
valor = get(hObject,'Value');

valor = (valor/0.2*2 +1 );

set(handles.text2,'String',valor);
intensi = valor;


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in guardar.
function guardar_Callback(hObject, eventdata, handles)
% hObject    handle to guardar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ruta;


Ires = get(handles.filtrar, 'UserData');
if isempty(Ires)
    msgbox('No existe una imagen para guardar');
    
else
   imwrite(Ires,strcat(ruta,'imageResult.png'));
msgbox('Imagen guardada'); 
end   


% --- Executes on key press with focus on fbilateral and none of its controls.


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over fbilateral.
function fbilateral_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to fbilateral (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global x;
global cond;
x = [0,0];
prompt = {'Iteraciones','dt'};
dlgtitle = 'PARAMETROS';
definput = {'100','0.25'};
dims = [1 30];
opts.Interpreter = 'tex';

rta = inputdlg(prompt,dlgtitle,dims,definput,opts);
x = str2double(rta);
cond = 1;

% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)

% --- Executes on button press in fbilateral.
function fbilateral_Callback(hObject, eventdata, handles)

function figure1_SizeChangedFcn(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function fondo_CreateFcn(hObject, eventdata, handles)


% --- Executes during object deletion, before destroying properties.
function figure1_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
