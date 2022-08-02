
function varargout = sysDiffEqGui(varargin)
%sysDiffEqGui
% SYSEQ M-file for sysDiffEqGui.fig
%      SYSEQ, by itself, creates a new SYSEQ or raises the existing
%      singleton*.
%
%      H = SYSEQ returns the handle to a new SYSEQ or the handle to
%      the existing singleton*.
%
%      SYSEQ('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SYSEQ.M with the given input arguments.
%
%      SYSEQ('Property','Value',...) creates a new SYSEQ or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before sysDiffEqGui_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to sysDiffEqGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help sysDiffEqGui

% Last Modified by GUIDE v2.5 10-May-2007 20:50:59

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @sysDiffEqGui_OpeningFcn, ...
                   'gui_OutputFcn',  @sysDiffEqGui_OutputFcn, ...
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


% --- Executes just before sysDiffEqGui is made visible.
function sysDiffEqGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to sysDiffEqGui (see VARARGIN)

% Choose default command line output for sysDiffEqGui
handles.output = hObject;
ftnText=textread(varargin{1},'%s');%comflicts with varargout{1} = handles.output;
constText=textread(varargin{2},'%s');
ICText=textread(varargin{3},'%s');
%note that during run-time you can either completely modify the equation or
%substitute it(which technically is a complete modification
handles.blFtnText=char(ftnText); %this step is a must if you wish to modify this string
handles.constText=char(constText);
handles.ICText=char(ICText);
%just have it show the functions with the constants added to them
handles.sysFtns=showEq(handles.blFtnText,handles.constText);
handles.stepSize=0.2;
%now that all the constants are numerated, put it in matForm
% [handles.matDiffForm handles.totNumDiff]=getHorCommaForm(handles.sysFtns);
% [handles.matDiffICForm]=getHorCommaForm(handles.ICText);
% handles.partSol=getPartSol(handles.matDiffForm,handles.matDiffICForm,handles.totNumDiff);

%calculate the eq with the initial condition will just a slight add on
set(handles.ftns_LB,'string',handles.blFtnText);
set(handles.const_LB,'string',handles.constText);
set(handles.IC_LB,'string',handles.ICText);

%result of the 1st iteration
set(handles.symFtns_Static,'string',handles.sysFtns);

%initializations
handles.numIter=1;
handles.eqFtnsSel=1;
handles.currSelIC=1;
handles.currSelConst=1;

handles.eqFtnsSelStr=handles.blFtnText(1,:);
handles.currSelICstr=handles.ICText(1,:);
handles.currSelConstStr=handles.constText(1,:);
guidata(hObject, handles);
% UIWAIT makes sysDiffEqGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = sysDiffEqGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes on selection change in ftns_LB.
function ftns_LB_Callback(hObject, eventdata, handles)
% hObject    handle to ftns_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ftns_LB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ftns_LB


% --- Executes during object creation, after setting all properties.
function ftns_LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ftns_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% hObject    handle to loadFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data_LB (see GUIDATA)

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in eqFtns_LB.
function eqFtns_LB_Callback(hObject, eventdata, handles)
% hObject    handle to eqFtns_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.eqFtnsSel=get(hObject,'Value');
str=get(hObject,'String');
handles.eqFtnsSelStr=str(get(hObject,'Value'),:)
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns eqFtns_LB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from eqFtns_LB


% --- Executes during object creation, after setting all properties.
function eqFtns_LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eqFtns_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadFtns_btn.
function loadFtns_btn_Callback(hObject, eventdata, handles)
% hObject    handle to loadFtns_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,pathName]=uigetfile({'*.m','All m-files (*.m)';'*.mat','All MAT-Files (*.mat)';'*.txt','txt file (*.txt)';'*.*','All Files (*.*)'});

if isequal(fileName,0)%means it's cancelled
    return
else
    myFile=fullfile(pathName,fileName);
    handles.blFtnText=char(textread(myFile,'%s'));
    set(handles.ftns_LB,'string',handles.blFtnText);
    % this file will be distributed into two separate list boxes?
    guidata(hObject, handles);
end


% --- Executes on selection change in const_LB.
function const_LB_Callback(hObject, eventdata, handles)
% hObject    handle to const_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%modVerTxtEq(ithEq,allEq,newFtnStr)
%need to use 

str=get(hObject,'String');
str(get(hObject,'Value'),:);
set(handles.const_Static,'string',str(get(hObject,'Value'),:));

handles.currSelConst=get(hObject,'Value');
handles.currSelConstStr=str(get(hObject,'Value'),:);
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns const_LB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from const_LB


% --- Executes during object creation, after setting all properties.
function const_LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to const_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in loadConst.
function loadConst_Callback(hObject, eventdata, handles)
% hObject    handle to loadConst (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,pathName]=uigetfile({'*.m','All m-files (*.m)';'*.mat','All MAT-Files (*.mat)';'*.txt','txt file (*.txt)';'*.*','All Files (*.*)'});
if isequal(fileName,0)%means it's cancelled
    return
else
    myFile=fullfile(pathName,fileName);
    handles.constText=char(textread(myFile,'%s'));
    set(handles.const_LB,'string',handles.constText);
    handles.sysFtns=showEq(handles.blFtnText,handles.constText);
    set(handles.symFtns_Static,'string',handles.sysFtns);
    guidata(hObject, handles);
end



% --- Executes on button press in saveFtns_btn.
function saveConst_Btn_Callback(hObject, eventdata, handles)
% hObject    handle to saveConst_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[fileName,pathName]=uiputfile({'*.m';'*.*'},'Save as');

if isequal(fileName,0)%means it's cancelled
    return
else
    myFile=fullfile(pathName,fileName);
    s=handles.constText;
    saveStrEqValToFile(myFile,s);
    %DLMWRITE(myFile,s,'delimiter',' ','newline','pc');
    %!!!!it's seen wrong in the text file but it's displayed
    %correctly in matlab
      
 
    guidata(hObject, handles);
end

% --- Executes on selection change in iter_LB.
function iter_LB_Callback(hObject, eventdata, handles)
% hObject    handle to iter_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.iterSelIC=get(hObject,'Value');
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns iter_LB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from iter_LB


% --- Executes during object creation, after setting all properties.
function iter_LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iter_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function numIter_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to numIter_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.numIter=str2double(get(hObject,'String'));
set(handles.numIter_Static,'string',['upToTime:' get(hObject,'String')]);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of numIter_Edit as text
%        str2double(get(hObject,'String')) returns contents of numIter_Edit as a double


% --- Executes during object creation, after setting all properties.
function numIter_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numIter_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in generate.
function generate_Callback(hObject, eventdata, handles)
% hObject    handle to generate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get the numbers to generate it

[r c]=size(handles.ICText);
tempIC=handles.ICText;
numIter=(0:handles.stepSize:(handles.numIter+handles.stepSize))';
totIter=length(numIter);
%gather just the strings of each IC and it's respective value
%eliminate the '=' sign; separate the variable string from the val of that
%variable string

%create a dummy string so that it has some thing to compare it to
ICStr='';
for(w=1:r)
    ICStr=strvcat(ICStr,'a');
end
%modVerTxtEq(ithEqn to modify, the entire eq, the next eqn)
for(w=1:r)
    [f rem]=strtok(tempIC(w,:),'=');
    ICVal(w)=str2num(rem(2:end));
    ICStr=modVerTxtEq(w,ICStr,f);
end


%using just the initial conditions and the system of equation you
%you can do the iterating process
%handles.partSol
% handles.partSol=getPartSol(handles.matDiffForm,handles.matDiffICForm,handles.totNumDiff);
approxPts=approxRK4(handles.sysFtns,handles.stepSize,ICVal,handles.numIter);

res=[numIter approxPts];
handles.iterMatData=res;
blMat=getMat2BlStr(handles.iterMatData);
set(handles.iter_LB,'string',blMat);

%get the proportion of each generation
popul=res(:,2:end);
[totGen totSpec]=size(popul);
totPopVec=sum(popul')';
popPer=zeros(totGen,totSpec);
for(i=1:totSpec)
   popPer(:,i)=popul(:,i)./totPopVec;
end
set(handles.prop_LB,'string',getMat2BlStr(popPer));
%can only do a phase diagram of a max of 3 variable(3d shape)
%you can pick any three, for now it's just these 2
handles.phD1=2;
handles.phD2=3;
%generate the phase diagram

%get the right axis
m=max(max(res));%first it takes the max # from each col and then the max from all the maxes
%res has the format col1:days col2:iterOfEq1 col3:iterOfEq2
    
    
for(i=1:totIter)
    %to create an animation   
    %generate the ftn vs. time
    subplot(handles.ftnWithTime);
    plot(res(1:i,1),res(1:i,handles.phD1),'ro-',res(1:i),res(1:i,handles.phD2),'bo-');
    hold on
    %axis([1 handles.numIter 1 m]);
    %generate the phase diagram
    subplot(handles.phaseFtn);
    plot(res(1:i,handles.phD1),res(1:i,handles.phD2),'ro-');
    pause(.001);
    hold on
    
end
subplot(handles.ftnWithTime);
hold off
subplot(handles.phaseFtn);
hold off
% --- Executes on selection change in IC_LB.
function IC_LB_Callback(hObject, eventdata, handles)
% hObject    handle to IC_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str=get(hObject,'String');
str(get(hObject,'Value'),:);
set(handles.IC_Static,'string',str(get(hObject,'Value'),:));
handles.currSelIC=get(hObject,'Value');
handles.currSelICstr=str(get(hObject,'Value'),:);
set(handles.IC_Static,'string',handles.currSelICstr);
guidata(hObject, handles);
% Hints: contents = get(hObject,'String') returns IC_LB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from IC_LB


% --- Executes during object creation, after setting all properties.
function IC_LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IC_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in saveIC.
function saveIC_Callback(hObject, eventdata, handles)
% hObject    handle to saveIC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,pathName]=uiputfile({'*.txt';'*.*'},'Save as');

if isequal(fileName,0)%means it's cancelled
    return
else
    myFile=fullfile(pathName,fileName);
    s=handles.ICText;
    %for writing string text files
    saveStrEqValToFile(myFile,s);
    guidata(hObject, handles);
end

% --- Executes on button press in loadIC.
function loadIC_Callback(hObject, eventdata, handles)
% hObject    handle to loadIC (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[fileName,pathName]=uigetfile({'*.m','All m-files (*.m)';'*.mat','All MAT-Files (*.mat)';'*.txt','txt file (*.txt)';'*.*','All Files (*.*)'});
if isequal(fileName,0)%means it's cancelled
    return
else
    myFile=fullfile(pathName,fileName);
    handles.ICText=char(textread(myFile,'%s'));
    set(handles.IC_LB,'string',handles.ICText);
    guidata(hObject, handles);
end







function const_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to const_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[f rem]=strtok(handles.currSelConstStr,'=');
%keep f 
f=[f '=' get(hObject,'String')];
handles.constText=modVerTxtEq(handles.currSelConst,handles.constText,f);
set(handles.const_LB,'string',handles.constText);
handles.sysFtns=showEq(handles.blFtnText,handles.constText);
set(handles.symFtns_Static,'string',handles.sysFtns);
set(handles.const_Static,'string',f);

%update the equation and it's particular solution
% [handles.matDiffForm handles.totNumDiff]=getHorCommaForm(handles.sysFtns);

%the constants are updated now the functions need to update these  new
%constants(don't need to make this update for ICs)
%you have to remember the original function so that you can make a uniq.
%substition

guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of const_Edit as text
%        str2double(get(hObject,'String')) returns contents of const_Edit as a double


% --- Executes during object creation, after setting all properties.
function const_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to const_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function IC_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to IC_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%modVerTxtEq(ithEq,allEq,newFtnStr)
%need to use 
%handles.currSelIC(selVal),handles.currSelICstr(the actual entire
[f rem]=strtok(handles.currSelICstr,'=');
%keep f 
f=[f '=' get(hObject,'String')]
q=handles.currSelIC
handles.ICText=modVerTxtEq(handles.currSelIC,handles.ICText,f);
set(handles.IC_LB,'string',handles.ICText);
set(handles.IC_Static,'string',f);
guidata(hObject, handles);
%handles.IC_LB

% Hints: get(hObject,'String') returns contents of IC_Edit as text
%        str2double(get(hObject,'String')) returns contents of IC_Edit as a double


% --- Executes during object creation, after setting all properties.
function IC_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to IC_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function subFrom_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to subFrom_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.subFrom=get(hObject,'String');
set(handles.subFrom_Static,'string',['subTo: ' handles.subFrom]);
guidata(hObject, handles);
% Hints: get(hObject,'String') returns contents of subFrom_Edit as text
%        str2double(get(hObject,'String')) returns contents of subFrom_Edit as a double


% --- Executes during object creation, after setting all properties.
function subFrom_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subFrom_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function subTo_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to subTo_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


handles.subTo=get(hObject,'String');
set(handles.subTo_Static,'string',['subTo: ' handles.subTo]);
guidata(hObject, handles);

% Hints: get(hObject,'String') returns contents of subTo_Edit as text
%        str2double(get(hObject,'String')) returns contents of subTo_Edit as a double


% --- Executes during object creation, after setting all properties.
function subTo_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subTo_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in doSubBtn.
function doSubBtn_Callback(hObject, eventdata, handles)
% hObject    handle to doSubBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


[totEq c]=size(handles.blFtnText);
for(i=1:totEq)%change it's row at a time
    newEq=subs(handles.blFtnText(i,:),handles.subFrom,handles.subTo);%subs each equation
    newEq=simplify(newEq);
    newEq=char(newEq);
    handles.blFtnText=modVerTxtEq(i,handles.blFtnText,newEq);%this is needed to recab. size each time
end
set(handles.ftns_LB,'string',handles.blFtnText);
guidata(hObject, handles);


% --- Executes on selection change in prop_LB.
function prop_LB_Callback(hObject, eventdata, handles)
% hObject    handle to prop_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns prop_LB contents as cell array
%        contents{get(hObject,'Value')} returns selected item from prop_LB


% --- Executes during object creation, after setting all properties.
function prop_LB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prop_LB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end









function stepSize_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to stepSize_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.stepSize=str2double(get(hObject,'String'));
% Hints: get(hObject,'String') returns contents of stepSize_Edit as text
%         returns contents of stepSize_Edit as a double


% --- Executes during object creation, after setting all properties.
function stepSize_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stepSize_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


