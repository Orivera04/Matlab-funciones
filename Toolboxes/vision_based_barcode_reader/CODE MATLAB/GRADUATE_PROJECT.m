function varargout = GRADUATE_PROJECT(varargin)
% GRADUATE_PROJECT M-file for GRADUATE_PROJECT.fig
%      GRADUATE_PROJECT, by itself, creates a new GRADUATE_PROJECT or raises the existing
%      singleton*.
%
%      H = GRADUATE_PROJECT returns the handle to a new GRADUATE_PROJECT or the handle to
%      the existing singleton*.
%
%      GRADUATE_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GRADUATE_PROJECT.M with the given input arguments.
%
%      GRADUATE_PROJECT('Property','Value',...) creates a new GRADUATE_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GRADUATE_PROJECT_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GRADUATE_PROJECT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GRADUATE_PROJECT

% Last Modified by GUIDE v2.5 05-Mar-2009 18:40:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GRADUATE_PROJECT_OpeningFcn, ...
                   'gui_OutputFcn',  @GRADUATE_PROJECT_OutputFcn, ...
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


% --- Executes just before GRADUATE_PROJECT is made visible.
function GRADUATE_PROJECT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GRADUATE_PROJECT (see VARARGIN)

% Choose default command line output for GRADUATE_PROJECT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GRADUATE_PROJECT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GRADUATE_PROJECT_OutputFcn(hObject, eventdata, handles) 
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



function Vertical_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Vertical_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Vertical_edit as text
%        str2double(get(hObject,'String')) returns contents of Vertical_edit as a double


% --- Executes during object creation, after setting all properties.
function Vertical_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Vertical_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Obelique_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Obelique_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Obelique_edit as text
%        str2double(get(hObject,'String')) returns contents of Obelique_edit as a double


% --- Executes during object creation, after setting all properties.
function Obelique_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Obelique_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Result.
function Result_Callback(hObject, eventdata, handles)
doc=get(handles.Horizontal_edit,'String');
ngang=get(handles.Vertical_edit,'String');
cheo=get(handles.Obelique_edit,'String');
doc=str2num(doc);
ngang=str2num(ngang);
cheo=str2num(cheo);
linengang=doc+1;
linedoc=ngang+1;
linecheo=cheo+1;
S = handles.S;
I=rgb2gray(S);
I = imadjust(I);
I=im2bw(I);
hang=size(I,1);
cot=size(I,2);
for i=1:(linengang-1)
    x=[0 cot];
    y=[i*(hang/linengang) i*(hang/linengang)];
    line(x,y,'Color','m');
end
for i=1:(linedoc-1)
    y=[0 hang];
    x=[i*(cot/linedoc) i*(cot/linedoc)];
    line(x,y,'Color','y');
end
for i=1:(linecheo-1)    
    dt=round(i*((hang+cot)/linecheo));
    x=[0 dt];
    y=[dt 0];
    line(x,y,'Color','b');
end
for i=1:(linecheo-1)  
    dt=round(i*((hang+cot)/linecheo));
    x=[cot-dt cot];
    y=[0 dt];
    line(x,y,'Color','g');
end

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%theo cac duong ngang
biendung1=0;
for i=1:(linengang-1)
    biendung1=biendung1+1;
    x=[0 cot];
    y=[i*(hang/linengang) i*(hang/linengang)];
    %line(x,y);
    c=ngangtp(i,linengang,hang,cot,I);
    td=solandoi(c);
    if (td < 28)|(td==11)
        continue;
    end
    s=tongmoivach(c,td);
    if length(s)==11
        continue;
    end
    [k,g]=nhieutrenduoi(s);
    mau=s(k);
    q=s./mau;
    p=round(q);
    mau1=s(k+1);    
    q1=s./mau1;    
    p1=round(q1);
    sokytu=round((td-k-g)/10);
    sovach=td-k-g;
    sodata=round((td-k-g-19)/6);    
    if (td-g-k)==57 & p(k)==1 & p(k+1)==1 & p(k+2)==1 
        result=ean13(p,k)
        line(x,y,'Color','r','LineWidth',4);
        if result==[1 2 3 4 5 6 1 2 3 4 5 6]
            c=ngangpt(i,linengang,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            result=ean13(p,k)
            line(x,y,'Color','r','LineWidth',4);
        end
        break;        
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)~=1 & p(k+2)==1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)~=1)&(p(k+7)==1)&(p(k+8)==1)
        result=code39(sokytu,p,k);
        line(x,y,'Color','r','LineWidth',4);
        break;
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)==1 & p(k+2)~=1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)==1)&(p(k+7)~=1)&(p(k+8)==1)
            c=ngangpt(i,linengang,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            sokytu=round((td-k-g)/10);
            result=code39(sokytu,p,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==2 & p1(k+4)==3 & p1(k+5)==2 
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==1 & p1(k+4)==3 & p1(k+5)==3 & p1(k+6)==2
            c=ngangpt(i,linengang,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau1=s(k+1);
            q1=s./mau1;
            p1=round(q1);
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    end
end
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%theo cac duong doc
biendung2=0;
for i=1:(linedoc-1)
  if biendung1<(linengang-1)     
        break;
  else
    biendung2=biendung2+1;  
    y=[0 hang];
    x=[i*(cot/linedoc) i*(cot/linedoc)];
    %line(x,y);
    c=doctp(i,linedoc,hang,cot,I);
    td=solandoi(c);
    if (td < 28)|(td==11)
        continue;
    end
    s=tongmoivach(c,td);
    if length(s)==11
        continue;
    end
    [k,g]=nhieutrenduoi(s);
    mau=s(k);
    q=s./mau;
    p=round(q);
    mau1=s(k+1);    
    q1=s./mau1;    
    p1=round(q1);
    sodata=round((td-k-g-19)/6);
    sokytu=round((td-k-g)/10);
    sovach=td-k-g;
    if (td-g-k)==57 & p(k)==1 & p(k+1)==1 & p(k+2)==1
        result=ean13(p,k)
        line(x,y,'Color','r','LineWidth',4);
        if result==[1 2 3 4 5 6 1 2 3 4 5 6]
            c=docpt(i,linedoc,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            result=ean13(p,k)
            line(x,y,'Color','r','LineWidth',4);
        end
        break;        
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)~=1 & p(k+2)==1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)~=1)&(p(k+7)==1)&(p(k+8)==1)
        result=code39(sokytu,p,k);
        line(x,y,'Color','r','LineWidth',4);
        break;
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)==1 & p(k+2)~=1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)==1)&(p(k+7)~=1)&(p(k+8)==1)
            c=docpt(i,linedoc,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q);
            sokytu=round((td-k-g)/10);
            result=code39(sokytu,p,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==2 & p1(k+4)==3 & p1(k+5)==2 
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==1 & p1(k+4)==3 & p1(k+5)==3 & p1(k+6)==2
            c=docpt(i,linedoc,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau1=s(k+1);
            q1=s./mau1;
            p1=round(q1);
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    end
  end
end
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%theo duong cheo 45
biendung3=0;
for i=1:(linecheo-1)
    if biendung2<(linedoc-1)
        break;
    else
    biendung3=biendung3+1;
    dt=round(i*((hang+cot)/linecheo));
    x=[0 dt];
    y=[dt 0];
    %line(x,y);    
    c=cheo45tp(dt,hang,cot,I);
    td=solandoi(c);
    if (td < 28)|(td==11)
        continue;
    end
    s=tongmoivach(c,td);
    if length(s)==11
        continue;
    end
    [k,g]=nhieutrenduoi(s);
    mau=s(k);
    q=s./mau;
    p=round(q);
    mau1=s(k+1);    
    q1=s./mau1;    
    p1=round(q1);
    sodata=round((td-k-g-19)/6);
    sokytu=round((td-k-g)/10);
    sovach=td-k-g;
    if (td-g-k)==57 
        result=ean13(p,k)
        line(x,y,'Color','r','LineWidth',4);
        if result==[1 2 3 4 5 6 1 2 3 4 5 6]
            c=cheo45pt(dt,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            result=ean13(p,k)
            line(x,y,'Color','r','LineWidth',4);
        end
        break;        
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)~=1 & p(k+2)==1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)~=1)&(p(k+7)==1)&(p(k+8)==1)
        result=code39(sokytu,p,k) 
        line(x,y,'Color','r','LineWidth',4);
        break;
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)==1 & p(k+2)~=1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)==1)&(p(k+7)~=1)&(p(k+8)==1)
            c=cheo45pt(dt,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q);
            sokytu=round((td-k-g)/10);
            result=code39(sokytu,p,k)
            line(x,y,'Color','r','LineWidth',4);
            break;
     elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==2 & p1(k+4)==3 & p1(k+5)==2 
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
     elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==1 & p1(k+4)==3 & p1(k+5)==3 & p1(k+6)==2
            c=cheo45pt(dt,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau1=s(k+1);
            q1=s./mau1;
            p1=round(q1);
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
        
    end
  end
end
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%theo duong cheo -45
biendung4=0;
for i=1:(linecheo-1)
  if biendung3<(linecheo-1)
        break;
  else
    biendung4=biendung4+1;
    dt=round(i*((hang+cot)/linecheo));
    x=[cot-dt cot];
    y=[0 dt];
    %line(x,y);
    c=cheoam45tp(dt,hang,cot,I);
    td=solandoi(c);
    if (td < 28)|(td==11)
        continue;
    end
    s=tongmoivach(c,td);
    if length(s)==11
        continue;
    end
    [k,g]=nhieutrenduoi(s);
    mau=s(k);
    q=s./mau;
    p=round(q);
    mau1=s(k+1);    
    q1=s./mau1;    
    p1=round(q1);
    sodata=round((td-k-g-19)/6);
    sokytu=round((td-k-g)/10);
    sovach=td-k-g;
    if (td-g-k)==57 
        result=ean13(p,k)
        line(x,y,'Color','r','LineWidth',4);
        if result==[1 2 3 4 5 6 1 2 3 4 5 6]
            c=cheoam45pt(dt,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            result=ean13(p,k)
            line(x,y,'Color','r','LineWidth',4);
        end
        break;        
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)~=1 & p(k+2)==1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)~=1)&(p(k+7)==1)&(p(k+8)==1)
        result=code39(sokytu,p,k)
        line(x,y,'Color','r','LineWidth',4);
        break;
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)==1 & p(k+2)~=1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)==1)&(p(k+7)~=1)&(p(k+8)==1)
            c=cheoam45pt(dt,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q);
            sokytu=round((td-k-g)/10);
            result=code39(sokytu,p,k)
            line(x,y,'Color','r','LineWidth',4);
            break;
     elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==2 & p1(k+4)==3 & p1(k+5)==2 
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
     elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==1 & p1(k+4)==3 & p1(k+5)==3 & p1(k+6)==2
            c=cheoam45pt(dt,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau1=s(k+1);
            q1=s./mau1;
            p1=round(q1);
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;        
    end
  end
end
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dty=hang/10;
for i=0:10
    x=[1 cot];
    y=[i*dty (hang-i*dty)];
    line(x,y);
end
dtx=cot/15;
for i=1:14
    y=[1 hang];
    x=[i*dtx (cot-i*dtx)];
    line(x,y);
end
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
biendung5=0;
for i=0:10
    if biendung4 < (linecheo-1)
        break;
    end
    biendung5=biendung5+1;
    x=[1 cot];
    y=[i*dty (hang-i*dty)];
    c=tpy(i,dty,hang,cot,I);
    td=solandoi(c);
    if (td < 28)|(td==11)
        continue;
    end
    s=tongmoivach(c,td);
    if length(s)==11
        continue;
    end
    [k,g]=nhieutrenduoi(s);
    mau=s(k);
    q=s./mau;
    p=round(q);
    mau1=s(k+1);    
    q1=s./mau1;    
    p1=round(q1);
    sokytu=round((td-k-g)/10);
    sovach=td-k-g;
    sodata=round((td-k-g-19)/6);    
    if (td-g-k)==57 & p(k)==1 & p(k+1)==1 & p(k+2)==1 
        result=ean13(p,k);
        line(x,y,'Color','r','LineWidth',4);
        if result==[1 2 3 4 5 6 1 2 3 4 5 6]
            c=pty(i,dty,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            result=ean13(p,k)
            line(x,y,'Color','r','LineWidth',4);
        end
        break;        
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)~=1 & p(k+2)==1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)~=1)& (p(k+7)==1)&(p(k+8)==1)
        result=code39(sokytu,p,k);
        line(x,y,'Color','r','LineWidth',4);
        break;
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)==1 & p(k+2)~=1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)==1)& (p(k+7)~=1)&(p(k+8)==1)
            c=pty(i,dty,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            sokytu=round((td-k-g)/10);
            result=code39(sokytu,p,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==2 & p1(k+4)==3 & p1(k+5)==2 
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==1 & p1(k+4)==3 & p1(k+5)==3 & p1(k+6)==2
            c=pty(i,dty,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau1=s(k+1);
            q1=s./mau1;
            p1=round(q1);
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    end
end
%
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
biendung6=0;
for i=1:14
    if biendung5 < 10
        break;
    end
    biendung6 = biendung6+1;
    x=[i*dtx (cot-i*dtx)];
    y=[1 hang];
    c=tpx(i,dtx,hang,cot,I);
    td=solandoi(c);
    if (td < 28)|(td==11)
        continue;
    end
    s=tongmoivach(c,td);
    if length(s)==11
        continue;
    end
    [k,g]=nhieutrenduoi(s);
    mau=s(k);
    q=s./mau;
    p=round(q);
    mau1=s(k+1);    
    q1=s./mau1;    
    p1=round(q1);
    sokytu=round((td-k-g)/10);
    sovach=td-k-g;
    sodata=round((td-k-g-19)/6);    
    if (td-g-k)==57 & p(k)==1 & p(k+1)==1 & p(k+2)==1 
        result=ean13(p,k);
        line(x,y,'Color','r','LineWidth',4);
        if result==[1 2 3 4 5 6 1 2 3 4 5 6]
            c=pty(i,dty,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            result=ean13(p,k)
            line(x,y,'Color','r','LineWidth',4);
        end
        break;        
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)~=1 & p(k+2)==1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)~=1)& (p(k+7)==1)&(p(k+8)==1)
        result=code39(sokytu,p,k);
        line(x,y,'Color','r','LineWidth',4);
        break;
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)==1 & p(k+2)~=1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)==1)& (p(k+7)~=1)&(p(k+8)==1)
            c=ptx(i,dtx,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            sokytu=round((td-k-g)/10);
            result=code39(sokytu,p,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==2 & p1(k+4)==3 & p1(k+5)==2 
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==1 & p1(k+4)==3 & p1(k+5)==3 & p1(k+6)==2
            c=ptx(i,dtx,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau1=s(k+1);
            q1=s./mau1;
            p1=round(q1);
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    end
end
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if biendung6 == 14 
    set(handles.Result_Barcode,'string','can not read');
end
if ischar(result)
    set(handles.Result_Barcode,'string',result);
else
    result=num2str(result);
    set(handles.Result_Barcode,'string',result);
end

% hObject    handle to Result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Capture.
function Capture_Callback(hObject, eventdata, handles)
    global vid;
    S=getsnapshot(vid);
    axes(handles.Capture_image);
    imshow(S);
    handles.S = S;
    guidata(hObject, handles);
% hObject    handle to Capture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Load_Image.
function Load_Image_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.jpg';'*.bmp';'*.jpg';'*.gif'}, 'Pick an Image File');
S = imread([pathname,filename]);
axes(handles.Capture_image);
imshow(S);
handles.S = S;
guidata(hObject, handles);
% hObject    handle to Load_Image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.

function Capture_image_CreateFcn(hObject, eventdata, handles)
    
% hObject    handle to Capture_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate Capture_image

function Horizontal_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Horizontal_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Horizontal_edit as text
%        str2double(get(hObject,'String')) returns contents of Horizontal_edit as a double


% --- Executes during object creation, after setting all properties.
function Horizontal_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Horizontal_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --- Executes during object creation, after setting all properties.
% --- Executes on button press in Preview.
function Preview_Callback(hObject, eventdata, handles)
global vid;    
    cla(handles.Camera,'reset');
    guidata(hObject, handles); %updates the handles
    imaqreset;
    set(gcf,'CurrentAxes',handles.Camera);
    set(gcf,'DoubleBuffer','on');
    imaqhwinfo;
    imaqhwinfo('winvideo',1);
    vid=videoinput('winvideo',1,'YUY2_640x480');  
    vid.ReturnedColorSpace = 'rgb'
    vidRes = get(vid, 'VideoResolution');
    nBands = get(vid, 'NumberOfBands');
    hImage = image( zeros(vidRes(2), vidRes(1), nBands) );   
    preview(vid, hImage);
% hObject    handle to Preview (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in Exit_program.
function Exit_program_Callback(hObject, eventdata, handles)    
    delete(handles.figure1);

% hObject    handle to Exit_program (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function LOGO_CreateFcn(hObject, eventdata, handles)
imshow(imread('HCMUTE_logo.jpg'));
% hObject    handle to LOGO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate LOGO

% --- Executes on button press in Default.
function Default_Callback(hObject, eventdata, handles)
       set(handles.Horizontal_edit,'string','10');
       set(handles.Vertical_edit,'string','10');
       set(handles.Obelique_edit,'string','10');
% hObject    handle to Default (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in Process.
function Process_Callback(hObject, eventdata, handles)
axes(handles.Processed_Image);
S = handles.S;
I=S;
hang=size(I,1);
cot=size(I,2);
I=rgb2gray(I);
I = imadjust(I,stretchlim(I),[]);
I= medfilt2(I);
level = graythresh(I);
I = im2bw(I,level);
se = strel('square',2);
I = imdilate(I,se);
I = imerode(I,se);
imshow(I);


% hObject    handle to Process (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function axes8_CreateFcn(hObject, eventdata, handles)
imshow(imread('GRADUATE_PROJECT.jpg'));
% hObject    handle to axes8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes8





function First_Picture_edit_Callback(hObject, eventdata, handles)
% hObject    handle to First_Picture_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of First_Picture_edit as text
%        str2double(get(hObject,'String')) returns contents of First_Picture_edit as a double


% --- Executes during object creation, after setting all properties.
function First_Picture_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to First_Picture_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Last_Picture_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Last_Picture_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Last_Picture_edit as text
%        str2double(get(hObject,'String')) returns contents of Last_Picture_edit as a double


% --- Executes during object creation, after setting all properties.
function Last_Picture_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Last_Picture_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Delay_edit_Callback(hObject, eventdata, handles)
% hObject    handle to Delay_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Delay_edit as text
%        str2double(get(hObject,'String')) returns contents of Delay_edit as a double


% --- Executes during object creation, after setting all properties.
function Delay_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Delay_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Result_Auto.
function Result_Auto_Callback(hObject, eventdata, handles)
first=get(handles.First_Picture_edit,'String');
last=get(handles.Last_Picture_edit,'String');
delay=get(handles.Delay_edit,'String');
first=str2num(first);
last=str2num(last);
delay=str2num(delay);
for i=first:last
    str = num2str(i)
    str = strcat(str,'.jpg');
    S=imread(str);    
axes(handles.Capture_image);
imshow(S);
handles.S = S;
doc=get(handles.Horizontal_edit,'String');
ngang=get(handles.Vertical_edit,'String');
cheo=get(handles.Obelique_edit,'String');
doc=str2num(doc);
ngang=str2num(ngang);
cheo=str2num(cheo);
linengang=doc+1;
linedoc=ngang+1;
linecheo=cheo+1;
S = handles.S;
I=im2bw(S);
hang=size(I,1);
cot=size(I,2);
for i=1:(linengang-1)
    x=[0 cot];
    y=[i*(hang/linengang) i*(hang/linengang)];
    line(x,y,'Color','m');
end
for i=1:(linedoc-1)
    y=[0 hang];
    x=[i*(cot/linedoc) i*(cot/linedoc)];
    line(x,y,'Color','y');
end
for i=1:(linecheo-1)    
    dt=round(i*((hang+cot)/linecheo));
    x=[0 dt];
    y=[dt 0];
    line(x,y,'Color','b');
end
for i=1:(linecheo-1)  
    dt=round(i*((hang+cot)/linecheo));
    x=[cot-dt cot];
    y=[0 dt];
    line(x,y,'Color','g');
end

%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%theo cac duong ngang
biendung1=0;
for i=1:(linengang-1)
    biendung1=biendung1+1;
    x=[0 cot];
    y=[i*(hang/linengang) i*(hang/linengang)];
    %line(x,y);
    c=ngangtp(i,linengang,hang,cot,I);
    td=solandoi(c);
    if (td < 28)|(td==11)
        continue;
    end
    s=tongmoivach(c,td);
    if length(s)==11
        continue;
    end
    [k,g]=nhieutrenduoi(s);
    mau=s(k);
    q=s./mau;
    p=round(q);
    mau1=s(k+1);    
    q1=s./mau1;    
    p1=round(q1);
    sokytu=round((td-k-g)/10);
    sovach=td-k-g;
    sodata=round((td-k-g-19)/6);    
    if (td-g-k)==57 & p(k)==1 & p(k+1)==1 & p(k+2)==1 
        result=ean13(p,k)
        line(x,y,'Color','r','LineWidth',4);
        if result==[1 2 3 4 5 6 1 2 3 4 5 6]
            c=ngangpt(i,linengang,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            result=ean13(p,k)
            line(x,y,'Color','r','LineWidth',4);
        end
        break;        
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)~=1 & p(k+2)==1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)~=1)&(p(k+7)==1)&(p(k+8)==1)
        result=code39(sokytu,p,k);
        line(x,y,'Color','r','LineWidth',4);
        break;
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)==1 & p(k+2)~=1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)==1)&(p(k+7)~=1)&(p(k+8)==1)
            c=ngangpt(i,linengang,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            sokytu=round((td-k-g)/10);
            result=code39(sokytu,p,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==2 & p1(k+4)==3 & p1(k+5)==2 
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==1 & p1(k+4)==3 & p1(k+5)==3 & p1(k+6)==2
            c=ngangpt(i,linengang,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau1=s(k+1);
            q1=s./mau1;
            p1=round(q1);
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    end
end
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%theo cac duong doc
biendung2=0;
for i=1:(linedoc-1)
  if biendung1<(linengang-1)     
        break;
  else
    biendung2=biendung2+1;  
    y=[0 hang];
    x=[i*(cot/linedoc) i*(cot/linedoc)];
    %line(x,y);
    c=doctp(i,linedoc,hang,cot,I);
    td=solandoi(c);
    if (td < 28)|(td==11)
        continue;
    end
    s=tongmoivach(c,td);
    if length(s)==11
        continue;
    end
    [k,g]=nhieutrenduoi(s);
    mau=s(k);
    q=s./mau;
    p=round(q);
    mau1=s(k+1);    
    q1=s./mau1;    
    p1=round(q1);
    sodata=round((td-k-g-19)/6);
    sokytu=round((td-k-g)/10);
    sovach=td-k-g;
    if (td-g-k)==57 & p(k)==1 & p(k+1)==1 & p(k+2)==1
        result=ean13(p,k)
        line(x,y,'Color','r','LineWidth',4);
        if result==[1 2 3 4 5 6 1 2 3 4 5 6]
            c=docpt(i,linedoc,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            result=ean13(p,k)
            line(x,y,'Color','r','LineWidth',4);
        end
        break;        
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)~=1 & p(k+2)==1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)~=1)&(p(k+7)==1)&(p(k+8)==1)
        result=code39(sokytu,p,k);
        line(x,y,'Color','r','LineWidth',4);
        break;
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)==1 & p(k+2)~=1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)==1)&(p(k+7)~=1)&(p(k+8)==1)
            c=docpt(i,linedoc,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q);
            sokytu=round((td-k-g)/10);
            result=code39(sokytu,p,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==2 & p1(k+4)==3 & p1(k+5)==2 
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==1 & p1(k+4)==3 & p1(k+5)==3 & p1(k+6)==2
            c=docpt(i,linedoc,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau1=s(k+1);
            q1=s./mau1;
            p1=round(q1);
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    end
  end
end
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%theo duong cheo 45
biendung3=0;
for i=1:(linecheo-1)
    if biendung2<(linedoc-1)
        break;
    else
    biendung3=biendung3+1;
    dt=round(i*((hang+cot)/linecheo));
    x=[0 dt];
    y=[dt 0];
    %line(x,y);    
    c=cheo45tp(dt,hang,cot,I);
    td=solandoi(c);
    if (td < 28)|(td==11)
        continue;
    end
    s=tongmoivach(c,td);
    if length(s)==11
        continue;
    end
    [k,g]=nhieutrenduoi(s);
    mau=s(k);
    q=s./mau;
    p=round(q);
    mau1=s(k+1);    
    q1=s./mau1;    
    p1=round(q1);
    sodata=round((td-k-g-19)/6);
    sokytu=round((td-k-g)/10);
    sovach=td-k-g;
    if (td-g-k)==57 
        result=ean13(p,k)
        line(x,y,'Color','r','LineWidth',4);
        if result==[1 2 3 4 5 6 1 2 3 4 5 6]
            c=cheo45pt(dt,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            result=ean13(p,k)
            line(x,y,'Color','r','LineWidth',4);
        end
        break;        
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)~=1 & p(k+2)==1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)~=1)&(p(k+7)==1)&(p(k+8)==1)
        result=code39(sokytu,p,k) 
        line(x,y,'Color','r','LineWidth',4);
        break;
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)==1 & p(k+2)~=1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)==1)&(p(k+7)~=1)&(p(k+8)==1)
            c=cheo45pt(dt,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q);
            sokytu=round((td-k-g)/10);
            result=code39(sokytu,p,k)
            line(x,y,'Color','r','LineWidth',4);
            break;
     elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==2 & p1(k+4)==3 & p1(k+5)==2 
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
     elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==1 & p1(k+4)==3 & p1(k+5)==3 & p1(k+6)==2
            c=cheo45pt(dt,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau1=s(k+1);
            q1=s./mau1;
            p1=round(q1);
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
        
    end
  end
end
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
%theo duong cheo -45
biendung4=0;
for i=1:(linecheo-1)
  if biendung3<(linecheo-1)
        break;
  else
    biendung4=biendung4+1;
    dt=round(i*((hang+cot)/linecheo));
    x=[cot-dt cot];
    y=[0 dt];
    %line(x,y);
    c=cheoam45tp(dt,hang,cot,I);
    td=solandoi(c);
    if (td < 28)|(td==11)
        continue;
    end
    s=tongmoivach(c,td);
    if length(s)==11
        continue;
    end
    [k,g]=nhieutrenduoi(s);
    mau=s(k);
    q=s./mau;
    p=round(q);
    mau1=s(k+1);    
    q1=s./mau1;    
    p1=round(q1);
    sodata=round((td-k-g-19)/6);
    sokytu=round((td-k-g)/10);
    sovach=td-k-g;
    if (td-g-k)==57 
        result=ean13(p,k)
        line(x,y,'Color','r','LineWidth',4);
        if result==[1 2 3 4 5 6 1 2 3 4 5 6]
            c=cheoam45pt(dt,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            result=ean13(p,k)
            line(x,y,'Color','r','LineWidth',4);
        end
        break;        
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)~=1 & p(k+2)==1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)~=1)&(p(k+7)==1)&(p(k+8)==1)
        result=code39(sokytu,p,k)
        line(x,y,'Color','r','LineWidth',4);
        break;
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)==1 & p(k+2)~=1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)==1)&(p(k+7)~=1)&(p(k+8)==1)
            c=cheoam45pt(dt,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q);
            sokytu=round((td-k-g)/10);
            result=code39(sokytu,p,k)
            line(x,y,'Color','r','LineWidth',4);
            break;
     elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==2 & p1(k+4)==3 & p1(k+5)==2 
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
     elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==1 & p1(k+4)==3 & p1(k+5)==3 & p1(k+6)==2
            c=cheoam45pt(dt,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau1=s(k+1);
            q1=s./mau1;
            p1=round(q1);
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;        
    end
  end
end
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
dty=hang/10;
for i=0:10
    x=[1 cot];
    y=[i*dty (hang-i*dty)];
    line(x,y);
end
dtx=cot/15;
for i=1:14
    y=[1 hang];
    x=[i*dtx (cot-i*dtx)];
    line(x,y);
end
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
biendung5=0;
for i=0:10
    if biendung4 < (linecheo-1)
        break;
    end
    biendung5=biendung5+1;
    x=[1 cot];
    y=[i*dty (hang-i*dty)];
    c=tpy(i,dty,hang,cot,I);
    td=solandoi(c);
    if (td < 28)|(td==11)
        continue;
    end
    s=tongmoivach(c,td);
    if length(s)==11
        continue;
    end
    [k,g]=nhieutrenduoi(s);
    mau=s(k);
    q=s./mau;
    p=round(q);
    mau1=s(k+1);    
    q1=s./mau1;    
    p1=round(q1);
    sokytu=round((td-k-g)/10);
    sovach=td-k-g;
    sodata=round((td-k-g-19)/6);    
    if (td-g-k)==57 & p(k)==1 & p(k+1)==1 & p(k+2)==1 
        result=ean13(p,k);
        line(x,y,'Color','r','LineWidth',4);
        if result==[1 2 3 4 5 6 1 2 3 4 5 6]
            c=pty(i,dty,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            result=ean13(p,k)
            line(x,y,'Color','r','LineWidth',4);
        end
        break;        
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)~=1 & p(k+2)==1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)~=1)& (p(k+7)==1)&(p(k+8)==1)
        result=code39(sokytu,p,k);
        line(x,y,'Color','r','LineWidth',4);
        break;
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)==1 & p(k+2)~=1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)==1)& (p(k+7)~=1)&(p(k+8)==1)
            c=pty(i,dty,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            sokytu=round((td-k-g)/10);
            result=code39(sokytu,p,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==2 & p1(k+4)==3 & p1(k+5)==2 
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==1 & p1(k+4)==3 & p1(k+5)==3 & p1(k+6)==2
            c=pty(i,dty,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau1=s(k+1);
            q1=s./mau1;
            p1=round(q1);
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    end
end
%
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
biendung6=0;
for i=1:14
    if biendung5 < 10
        break;
    end
    biendung6 = biendung6+1;
    x=[i*dtx (cot-i*dtx)];
    y=[1 hang];
    c=tpx(i,dtx,hang,cot,I);
    td=solandoi(c);
    if (td < 28)|(td==11)
        continue;
    end
    s=tongmoivach(c,td);
    if length(s)==11
        continue;
    end
    [k,g]=nhieutrenduoi(s);
    mau=s(k);
    q=s./mau;
    p=round(q);
    mau1=s(k+1);    
    q1=s./mau1;    
    p1=round(q1);
    sokytu=round((td-k-g)/10);
    sovach=td-k-g;
    sodata=round((td-k-g-19)/6);    
    if (td-g-k)==57 & p(k)==1 & p(k+1)==1 & p(k+2)==1 
        result=ean13(p,k);
        line(x,y,'Color','r','LineWidth',4);
        if result==[1 2 3 4 5 6 1 2 3 4 5 6]
            c=pty(i,dty,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            result=ean13(p,k)
            line(x,y,'Color','r','LineWidth',4);
        end
        break;        
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)~=1 & p(k+2)==1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)~=1)& (p(k+7)==1)&(p(k+8)==1)
        result=code39(sokytu,p,k);
        line(x,y,'Color','r','LineWidth',4);
        break;
    elseif rem(sovach,10)==7 & p(k)==1 & p(k+1)==1 & p(k+2)~=1 & (p(k+3)==1)&(p(k+4)~=1)&(p(k+5)==1)&(p(k+6)==1)& (p(k+7)~=1)&(p(k+8)==1)
            c=ptx(i,dtx,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau=s(k);
            q=s./mau;
            p=round(q); 
            sokytu=round((td-k-g)/10);
            result=code39(sokytu,p,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==2 & p1(k+4)==3 & p1(k+5)==2 
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    elseif p1(k)==2 & p1(k+1)==1 & p1(k+2)==1 & p1(k+3)==1 & p1(k+4)==3 & p1(k+5)==3 & p1(k+6)==2
            c=ptx(i,dtx,hang,cot,I);
            td=solandoi(c);
            s=tongmoivach(c,td);
            [k,g]=nhieutrenduoi(s);
            mau1=s(k+1);
            q1=s./mau1;
            p1=round(q1);
            result=code128C(sodata,p1,k);
            line(x,y,'Color','r','LineWidth',4);
            break;
    end
end
%+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if biendung6 == 14 
    set(handles.Result_Barcode,'string','can not read');
end
if ischar(result)
    set(handles.Result_Barcode,'string',result);
else
    result=num2str(result);
    set(handles.Result_Barcode,'string',result);
end  
 myWait(delay)
end
% hObject    handle to Result_Auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function Logokhoa_CreateFcn(hObject, eventdata, handles)
imshow(imread('logokhoa.jpg'));
% hObject    handle to Logokhoa (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate Logokhoa


