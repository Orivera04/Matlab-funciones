function varargout = Deinterlacing(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Deinterlacing_OpeningFcn, ...
    'gui_OutputFcn',  @Deinterlacing_OutputFcn, ...
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

% --- Executes just before Deinterlacing is made visible.
function Deinterlacing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Deinterlacing (see VARARGIN)
%plot(mov,mov)
% Choose default command line output for Deinterlacing
handles.output = hObject;
handles.pop = 0;
handles.x = 1;
handles.y = 1;
handles.w = 1;
handles.h = 1;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Deinterlacing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Deinterlacing_OutputFcn(hObject, eventdata, handles)
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
sv = get(handles.slider1,'Value');
handles.n=round(sv*max(size(handles.mov)));
if handles.n ==0, handles.n=1,end
set(handles.Frame_NO,'String',handles.n);
axes(handles.axes1);
[I,Map] = frame2im(handles.mov(1,handles.n));
image(I)
axes(handles.axes1)
rectangle('Position',[handles.x,handles.y,handles.w,handles.h],'Curvature',[0.2,0.2],'EdgeColor','r')
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end




% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
val = get(handles.popupmenu1,'Value');
switch val
    case 1
        handles.pop = 1;
    case {2,3}
        handles.pop = 2;
        disp('In the second image select an area that cover your previous selected area of first image')
        disp('----------------------------------------------------------------------------------------')
        set(Deinterlacing,'Pointer','fullcrosshair')
        k = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);
        p1 = min(point1,point2);             % calculate locations
        offset = abs(point1-point2);         % and dimensions
        set(Deinterlacing,'Pointer','arrow')
        x1 = fix(p1(1));
        y1 = fix(p1(2));
        x2 = fix(offset(1))+x1;
        y2 = fix(offset(2))+y1;
        [I,Map] = frame2im(handles.mov(1,1));
        s = size(I)
        if y2>s(1), y2=s(1), end;
        if x2>s(2), x2=s(2), end;

        axes(handles.axes1)
        rectangle('Position',[x1,y1,x2-x1,y2-y1],'Curvature',[0.2,0.2],'EdgeColor','r')
        handles.x11 = x1;
        handles.y11 = y1;
        handles.x21 = x2;
        handles.y21 = y2;

        guidata(hObject, handles);

        %     case 3
        %         handles.pop = 3;
        %         k = waitforbuttonpress;
        %         point1 = get(gca,'CurrentPoint');    % button down detected
        %         finalRect = rbbox;                   % return figure units
        %         point2 = get(gca,'CurrentPoint');    % button up detected
        %         point1 = point1(1,1:2);              % extract x and y
        %         point2 = point2(1,1:2);
        %         p1 = min(point1,point2);             % calculate locations
        %         offset = abs(point1-point2);         % and dimensions
        %         x1 = fix(p1(1));
        %         y1 = fix(p1(2));
        %         x2 = fix(offset(1))+x1;
        %         y2 = fix(offset(2))+y1;
        %         [I,Map] = frame2im(handles.mov(1,1));
        %         s = size(I)
        %         if y2>s(1), y2=s(1), end;
        %         if x2>s(2), x2=s(2), end;
        %
        %         axes(handles.axes1)
        %         rectangle('Position',[x1,y1,x2-x1,y2-y1],'Curvature',[0.2,0.2],'EdgeColor','r')
        %         handles.x11 = x1;
        %         handles.y11 = y1;
        %         handles.x21 = x2;
        %         handles.y21 = y2;
        %
        %         guidata(hObject, handles);
        %
    case 4
        handles.pop = 4;
        set(Deinterlacing,'Pointer','fullcrosshair')
        k = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);
        p1 = min(point1,point2);             % calculate locations
        offset = abs(point1-point2);         % and dimensions
        set(Deinterlacing,'Pointer','arrow')
        x1 = fix(p1(1));
        y1 = fix(p1(2));
        x2 = fix(offset(1))+x1;
        y2 = fix(offset(2))+y1;
        [I,Map] = frame2im(handles.mov(1,1));
        s = size(I)
        if y2>s(1), y2=s(1), end;
        if x2>s(2), x2=s(2), end;

        axes(handles.axes1)
        rectangle('Position',[x1,y1,x2-x1,y2-y1],'Curvature',[0.2,0.2],'EdgeColor','r')
        handles.x11 = x1;
        handles.y11 = y1;
        handles.x21 = x2;
        handles.y21 = y2;
        %***********************
        k = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);
        p1 = min(point1,point2);             % calculate locations
        offset = abs(point1-point2);         % and dimensions
        x1 = fix(p1(1));
        y1 = fix(p1(2));
        x2 = fix(offset(1))+x1;
        y2 = fix(offset(2))+y1;
        [I,Map] = frame2im(handles.mov(1,1));
        s = size(I)
        if y2>s(1), y2=s(1), end;
        if x2>s(2), x2=s(2), end;

        axes(handles.axes1)
        rectangle('Position',[x1,y1,x2-x1,y2-y1],'Curvature',[0.2,0.2],'EdgeColor','r')
        handles.x12 = x1;
        handles.y12 = y1;
        handles.x22 = x2;
        handles.y22 = y2;
        %**************************
        k = waitforbuttonpress;
        point1 = get(gca,'CurrentPoint');    % button down detected
        finalRect = rbbox;                   % return figure units
        point2 = get(gca,'CurrentPoint');    % button up detected
        point1 = point1(1,1:2);              % extract x and y
        point2 = point2(1,1:2);
        p1 = min(point1,point2);             % calculate locations
        offset = abs(point1-point2);         % and dimensions
        x1 = fix(p1(1));
        y1 = fix(p1(2));
        x2 = fix(offset(1))+x1;
        y2 = fix(offset(2))+y1;
        [I,Map] = frame2im(handles.mov(1,1));
        s = size(I)
        if y2>s(1), y2=s(1), end;
        if x2>s(2), x2=s(2), end;

        axes(handles.axes1)
        rectangle('Position',[x1,y1,x2-x1,y2-y1],'Curvature',[0.2,0.2],'EdgeColor','r')
        handles.x13 = x1;
        handles.y13 = y1;
        handles.x23 = x2;
        handles.y23 = y2;
        guidata(hObject, handles);


end
clc
popup = handles.pop
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Frame_NO_Callback(hObject, eventdata, handles)
% hObject    handle to Frame_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Frame_NO as text
%        str2double(get(hObject,'String')) returns contents of Frame_NO as a double
handles.n = round(str2double(get(handles.Frame_NO,'String')));
if handles.n>max(size(handles.mov))
    handles.n = max(size(handles.mov))
    set(handles.Frame_NO,'String',handles.n);
end
set(handles.slider1,'Value',handles.n/max(size(handles.mov)));
[I,Map] = frame2im(handles.mov(1,handles.n));
axes(handles.axes1);
image(I)
guidata(hObject, handles);

% --- Executes on button press in show_selection.
function show_selection_Callback(hObject, eventdata, handles)
% hObject    handle to show_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


ux = str2double(get(handles.ULCX,'String'));
uy = str2double(get(handles.ULCY,'String'));
lx = str2double(get(handles.LRCX,'String'));
ly = str2double(get(handles.LRCY,'String'));
handles.x = ux;
handles.y = uy;
handles.w = lx - handles.x;
handles.h = ly - handles.y;
axes(handles.axes1)
rectangle('Position',[handles.x,handles.y,handles.w,handles.h],'Curvature',[0.2,0.2],'EdgeColor','r')
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in Start_Deinterlacing.
function Start_Deinterlacing_Callback(hObject, eventdata, handles)
% hObject    handle to Start_Deinterlacing (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%handles.F = [];
%handles.F = 1;
if handles.pop==0
    warndlg('To Continue First select the Image type from popup menu');
else
    prompt={'From frame #:','To frame #:'};
    name='Range of frames For Deinterlacing';
    numlines=1;
    defaultanswer={num2str(handles.n),num2str(handles.nof)};
    answer=inputdlg(prompt,name,numlines,defaultanswer);
    st = eval(char(answer(1)));
    en = eval(char(answer(2)));
    h = waitbar(0,'Please wait...');


    if handles.pop == 1
        clc
        ux = str2double(get(handles.ULCX,'String'));
        uy = str2double(get(handles.ULCY,'String'));
        lx = str2double(get(handles.LRCX,'String'));
        ly = str2double(get(handles.LRCY,'String'));
        if fix(uy/2)~=uy/2
            uy=2*fix(uy/2);
            if uy == 0,uy = 2; end
            set(handles.ULCY,'String',uy);
        end
        if fix((ly-uy)/4)~=(ly-uy)/4
            ly=uy + 4*fix((ly-uy)/4);
            set(handles.LRCY,'String',ly);
        end

        liy = round(abs(uy-ly)/2);
        irx = abs(ux-lx); % Image resize X
        iry = abs(uy-ly); % Image resize Y

        for k = st:en
            waitbar((k-st)/(en-st),h)
            clear I1;
            clear I2;
            Frame_Number = k
            [II,Map] = frame2im(handles.mov(1,k));
            F1 = II(uy:ly,ux:lx,:);

            for i=1:liy
                I1(i,:,:) = F1(2*i-1,:,:);
                I2(i,:,:) = F1(2*i,:,:);
            end
            I1 = imresize(I1,[iry irx],'bicubic');
            I2 = imresize(I2,[iry irx],'bicubic');
            I1 = I1(2:iry,:,:);
            I2 = I2(1:iry-1,:,:);

            handles.F(1,2*(k-st+1)-1) = im2frame(I1);
            handles.F(1,2*(k-st+1)-0) = im2frame(I2);

        end

        guidata(hObject, handles);

        disp('------------------------------------------------')
        disp('The Deinterlacing process Completed Successfully')
    end




    if (handles.pop == 2 | handles.pop ==3)
        disp(' Please wait a minute ')
        disp(' Finding the corresponding Regions ...')
        ux = str2double(get(handles.ULCX,'String'));
        uy = str2double(get(handles.ULCY,'String'));
        lx = str2double(get(handles.LRCX,'String'));
        ly = str2double(get(handles.LRCY,'String'));
        if fix(uy/4)~=uy/4
            uy=4*fix(uy/4);
            set(handles.ULCY,'String',uy);
        end
        if fix((ly-uy)/4)~=(ly-uy)/4
            ly=uy + 4*fix((ly-uy)/4);
            set(handles.LRCY,'String',ly);
        end
        liy = round(abs(uy-ly)/2);
        irx = abs(ux-lx); % Image resize X
        iry = abs(uy-ly); % Image resize Y
        [II,Map] = frame2im(handles.mov(1,handles.n));
        I = II(handles.y11:handles.y21,handles.x11:handles.x21,:);
        I1 = II(uy:ly,ux:lx,:);

        [ey,ex,val]=fndc(I,I1,1);

        sf1=size(I);
        sf2=size(I1);

        yf1=sf1(1);
        xf1=sf1(2);
        yf2=sf2(1);
        xf2=sf2(2);

        disp('One Region is Found')
        disp('-------------------')
        disp('Deinterlacing is started ... ')

        for k = st:en
            waitbar((k-st)/(en-st),h)
            clear I1;
            clear I2;
            clear I3;
            clear I4;
            Frame_Number = k
            [II,Map] = frame2im(handles.mov(1,k));
            F1 = II(uy:ly,ux:lx,:);
            F2 = II(handles.y11-1+ey:handles.y11-1+yf2+ey-1,handles.x11+ex-1:handles.x11+ex+(lx-ux)-1,:);

            for i=1:liy
                I1(i,:,:) = F1(2*i-1,:,:);
                I2(i,:,:) = F1(2*i,:,:);
            end
            I1 = imresize(I1,[iry irx],'bicubic');
            I2 = imresize(I2,[iry irx],'bicubic');
            I1 = I1(2:iry,:,:);
            I2 = I2(1:iry-1,:,:);


            for i=1:liy
                I3(i,:,:) = F2(2*i-1,:,:);
                I4(i,:,:) = F2(2*i,:,:);
            end
            I3 = imresize(I3,[iry irx],'bicubic');
            I4 = imresize(I4,[iry irx],'bicubic');
            I3 = I3(2:iry,:,:);
            I4 = I4(1:iry-1,:,:);

            handles.F(1,4*(k-st+1)-3) = im2frame(I1);
            handles.F(1,4*(k-st+1)-2) = im2frame(I3);
            handles.F(1,4*(k-st+1)-1) = im2frame(I2);
            handles.F(1,4*(k-st+1)-0) = im2frame(I4);

        end

        guidata(hObject, handles);

        disp('------------------------------------------------')
        disp('The Deinterlacing process Completed Successfully')
    end


    if handles.pop == 4

        disp(' Please wait a minute ')
        disp(' Finding the corresponding Regions ...')
        ux = str2double(get(handles.ULCX,'String'));
        uy = str2double(get(handles.ULCY,'String'));
        lx = str2double(get(handles.LRCX,'String'));
        ly = str2double(get(handles.LRCY,'String'));
        if fix(uy/4)~=uy/4
            uy=4*fix(uy/4);
            set(handles.ULCY,'String',uy);
        end
        if fix((ly-uy)/4)~=(ly-uy)/4
            ly=uy + 4*fix((ly-uy)/4);
            set(handles.LRCY,'String',ly);
        end
        liy = round(abs(uy-ly)/2);
        irx = abs(ux-lx); % Image resize X
        iry = abs(uy-ly); % Image resize Y
        [II,Map] = frame2im(handles.mov(1,handles.n));
        Ib = II(handles.y11:handles.y21,handles.x11:handles.x21,:);
        Ic = II(handles.y12:handles.y22,handles.x12:handles.x22,:);
        Id = II(handles.y13:handles.y23,handles.x13:handles.x23,:);
        I1 = II(uy:ly,ux:lx,:);

        [eyb,exb]=fnd(Ib,I1);
        [eyc,exc]=fnd(Ic,I1);
        [eyd,exd]=fnd(Id,I1);

        sfb=size(Ib);
        sfc=size(Ic);
        sfd=size(Id);
        sf2=size(I1);

        yfb=sfb(1);
        xfb=sfb(2);
        yfc=sfc(1);
        xfc=sfc(2);
        yfd=sfd(1);
        xfd=sfd(2);
        yf2=sf2(1);
        xf2=sf2(2);


        disp('One Region is Found')
        disp('-------------------')
        disp('Deinterlacing is started ... ')

        for k = st:en
            waitbar((k-st)/(en-st),h)
            clear I1;
            clear I2;
            clear I3;
            clear I4;
            clear I5;
            clear I6;
            clear I7;
            clear I8;
            Frame_Number = k
            [II,Map] = frame2im(handles.mov(1,k));
            F1 = II(uy:ly,ux:lx,:);
            Fb = II(handles.y11-1+eyb:handles.y11-1+yf2+eyb-1,handles.x11+exb-1:handles.x11+exb+(lx-ux)-1,:);
            Fc = II(handles.y12-1+eyc:handles.y12-1+yf2+eyc-1,handles.x12+exc-1:handles.x12+exc+(lx-ux)-1,:);
            Fd = II(handles.y13-1+eyd:handles.y13-1+yf2+eyd-1,handles.x13+exd-1:handles.x13+exd+(lx-ux)-1,:);

            for i=1:liy
                I1(i,:,:) = F1(2*i-1,:,:);
                I2(i,:,:) = F1(2*i,:,:);
            end
            I1 = imresize(I1,[iry irx],'bicubic');
            I2 = imresize(I2,[iry irx],'bicubic');
            I1 = I1(2:iry,:,:);
            I2 = I2(1:iry-1,:,:);


            for i=1:liy
                I3(i,:,:) = Fb(2*i-1,:,:);
                I4(i,:,:) = Fb(2*i,:,:);
            end
            I3 = imresize(I3,[iry irx],'bicubic');
            I4 = imresize(I4,[iry irx],'bicubic');
            I3 = I3(2:iry,:,:);
            I4 = I4(1:iry-1,:,:);

            for i=1:liy
                I5(i,:,:) = Fc(2*i-1,:,:);
                I6(i,:,:) = Fc(2*i,:,:);
            end
            I5 = imresize(I5,[iry irx],'bicubic');
            I6 = imresize(I6,[iry irx],'bicubic');
            I5 = I5(2:iry,:,:);
            I6 = I6(1:iry-1,:,:);

            for i=1:liy
                I7(i,:,:) = Fd(2*i-1,:,:);
                I8(i,:,:) = Fd(2*i,:,:);
            end
            I7 = imresize(I7,[iry irx],'bicubic');
            I8 = imresize(I8,[iry irx],'bicubic');
            I7 = I7(2:iry,:,:);
            I8 = I8(1:iry-1,:,:);

            handles.F(1,8*(k-st+1)-7) = im2frame(I1);
            handles.F(1,8*(k-st+1)-6) = im2frame(I3);
            handles.F(1,8*(k-st+1)-5) = im2frame(I5);
            handles.F(1,8*(k-st+1)-4) = im2frame(I7);
            handles.F(1,8*(k-st+1)-3) = im2frame(I2);
            handles.F(1,8*(k-st+1)-2) = im2frame(I4);
            handles.F(1,8*(k-st+1)-1) = im2frame(I6);
            handles.F(1,8*(k-st+1)-0) = im2frame(I8);

        end

        guidata(hObject, handles);

        disp('------------------------------------------------')
        disp('The Deinterlacing process Completed Successfully')
    end

    close(h)
end



function ULCX_Callback(hObject, eventdata, handles)
% hObject    handle to ULCX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ULCX as text
%        str2double(get(hObject,'String')) returns contents of ULCX as a double


% --- Executes during object creation, after setting all properties.
function ULCX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ULCX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function Frame_NO_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Frame_NO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function ULCY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ULCY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function LRCX_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LRCX (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function LRCY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LRCY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in By_Mouse.
function By_Mouse_Callback(hObject, eventdata, handles)
% hObject    handle to By_Mouse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(Deinterlacing,'Pointer','fullcrosshair')
k = waitforbuttonpress;
point1 = get(gca,'CurrentPoint');    % button down detected
finalRect = rbbox;                   % return figure units
point2 = get(gca,'CurrentPoint');    % button up detected
point1 = point1(1,1:2);              % extract x and y
point2 = point2(1,1:2);
p1 = min(point1,point2);             % calculate locations
offset = abs(point1-point2);         % and dimensions
set(Deinterlacing,'Pointer','arrow')
%x = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
%y = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
handles.x = fix(p1(1));
handles.y = fix(p1(2));
handles.w = fix(offset(1));
handles.h = fix(offset(2));

axes(handles.axes1);
[I,Map] = frame2im(handles.mov(1,handles.n));
image(I)
axes(handles.axes1)
rectangle('Position',[handles.x,handles.y,handles.w,handles.h],'Curvature',[0.2,0.2],'EdgeColor','r')

ux = handles.x;
uy = handles.y;
lx = handles.w + handles.x;
ly = handles.h + handles.y;
set(handles.ULCX,'String',ux);
set(handles.ULCY,'String',uy);
set(handles.LRCX,'String',lx);
set(handles.LRCY,'String',ly);

% Update handles structure
guidata(hObject, handles);



% --------------------------------------------------------------------
function File_menu_Callback(hObject, eventdata, handles)
% hObject    handle to File_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function import_workspace_Callback(hObject, eventdata, handles)
% hObject    handle to import_workspace (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
disp(' please wait ... ');
disp(' Loading data from Workspace ... ');
handles.mov = evalin('base','F');
handles.nof = max(size(handles.mov));
handles.n = handles.nof;
set(handles.slider1,'SliderStep',[1/handles.nof;.1])
set(handles.slider1,'Value',1);
set(handles.Frame_NO,'String',handles.n);
[I,Map] = frame2im(handles.mov(1,handles.n));
image(I)
disp(' Loading Process completed ');
guidata(hObject, handles);


% --------------------------------------------------------------------
function Open_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Open_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile('*.avi', 'Pick an avi-file');
if isequal(filename,0)
    disp('User selected Cancel')
else
    file = fullfile(pathname, filename)
    disp(['User selected', file])
    handles.mov = aviread(file);
    handles.nof = max(size(handles.mov));
    handles.n = handles.nof;
    set(handles.slider1,'Value',1);
    set(handles.Frame_NO,'String',handles.n);
    [I,Map] = frame2im(handles.mov(1,handles.n));
    axes(handles.axes1);
    image(I)
    sz = size(I);
    handles.x = 1;
    handles.y = 1;
    handles.w = sz(1,2) - 1;
    handles.h = sz(1,1) - 1;
    ux = handles.x;
    uy = handles.y;
    lx = handles.w + handles.x;
    ly = handles.h + handles.y;
    set(handles.ULCX,'String',ux);
    set(handles.ULCY,'String',uy);
    set(handles.LRCX,'String',lx);
    set(handles.LRCY,'String',ly);
    set(handles.slider1,'SliderStep',[1/handles.nof;.1])

    guidata(hObject, handles);
end


% --------------------------------------------------------------------
function Save_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Save_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uiputfile('*.avi', 'Save As...');
if isequal(filename,0) | isequal(pathname,0)
    disp('User selected Cancel')
else
    file = fullfile(pathname,filename);
    disp(['User selected: ',file])
    movie2avi(handles.F,file,'fps',25,'compression','Indeo5');
end


% --------------------------------------------------------------------
function Export_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Export_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Exit_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Exit_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close


% --------------------------------------------------------------------
function Contents_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Contents_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%HelpPath = which('deinter.html')
%web(HelpPath);
uiopen('D:\MATLAB701\work\deinter.htm',1)
% --------------------------------------------------------------------
function About_menu_Callback(hObject, eventdata, handles)
% hObject    handle to About_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = sprintf(['Human Motion Tracer - Deinterlacing 1.1.1\n\n',...
    'Sharif University of Technology\n',...
    'Mechanical Engineering Department\n\n',...
    'Copyright 2004-2006 The Microjects, Inc.\n']);
msgbox(str,'About the Human Motion Tracer','modal');

% --------------------------------------------------------------------
function Help_menu_Callback(hObject, eventdata, handles)
% hObject    handle to Help_menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


