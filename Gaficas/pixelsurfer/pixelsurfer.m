function varargout = pixelsurfer(varargin)
% PIXELSURFER M-file for pixelsurfer.fig
%      PIXELSURFER, by itself, creates a new PIXELSURFER or raises the existing
%      singleton*.
%
%      H = PIXELSURFER returns the handle to a new PIXELSURFER or the handle to
%      the existing singleton*.
%
%      PIXELSURFER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PIXELSURFER.M with the given input arguments.
%
%      PIXELSURFER('Property','Value',...) creates a new PIXELSURFER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pixelsurfer_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pixelsurfer_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES
%The GUI provides a general platform for 4D data exploration. It allows the user to pixesurf the image data and see the vector data for each pixel with instant update. For instance for PET or MR tracer data.
%The GUI is a free floating viewport not connected to the plot allowing for more flexibily, eg. double screen support.
%The GUI is ment as a sceleton for specialized development. It has little
%use but mere visual data exploration in the form presented here.
%The viewport can be rescaled by the user, and is adjusted to be scaled by integer factors by a resize function.
% The code is easily readable and only consists of 300 lines (Including the GUI template).
%An MR datafile (*.mat) is provided.

%type
%>>pixelsurfer(mydata) to try it out.
%mail: chr@pet.auh.dk 
% Edit the above text to modify the response to help pixelsurfer

% Last Modified by GUIDE v2.5 06-Nov-2004 16:04:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pixelsurfer_OpeningFcn, ...
                   'gui_OutputFcn',  @pixelsurfer_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before pixelsurfer is made visible.
function pixelsurfer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pixelsurfer (see VARARGIN)

% Choose default command line output for pixelsurfer
handles.output = hObject;

%initialize
set(handles.figure1,'units','pixels','resizefcn',{@myresize,handles})
set(handles.axes1,'units','pixels')
set(handles.slider1,'units','pixels')
set(handles.slider2,'units','pixels')
handles.colorlist={[1 0 0],[0 1 0],[0 0 1]};

handles.imagedata=varargin{1};

handles.slices=size(handles.imagedata,4);
handles.timepoints=size(handles.imagedata,3);
handles.xsize=size(handles.imagedata,2);
handles.ysize=size(handles.imagedata,1);
handles.cslice=1;
handles.ctimepoint=1;
handles.myim=imagesc(handles.imagedata(:,:,1,1)); axis off; colormap gray;


%curvedata is stored in figure1's userdata
mycurves={[],[],[],[]};
set(handles.figure1,'userdata',mycurves);

%handles.g1 store which group is active

set(handles.g1,'userdata',1);
set(handles.g1,'value',1);
set(handles.slicetext,'string',num2str(1));
set(handles.timetext,'string',num2str(1));
%fix slidebar intervals
set(handles.slider1,'min',1,'max',handles.timepoints,'value',1,'sliderstep',[(1/(handles.timepoints-1)) (1/(handles.timepoints-1))])
set(handles.slider2,'min',1,'max',handles.slices,'value',1,'sliderstep',[(1/(handles.slices-1)) (1/(handles.slices-1))])



% Update handles structure
guidata(hObject, handles);
dolayout;

%activate callbacks for mouseclick and mouse motion
set(gcf,'WindowButtonMotionFcn',@mousemotion)
set(handles.myim,'ButtonDownFcn',@mouseclick)


%open plot window, can be omitted - will open when curser hits imagedata
currentgroupsel=get(handles.g1,'userdata');  

mw=figure('tag','plotwindow');
myax=axes;
xvec=[1:handles.timepoints];
set(myax,'color',[0 0 0],'xlim',[xvec(1) xvec(end)],'ylim',[min(handles.imagedata(:)) max(handles.imagedata(:))],'tag','myaxes')
axes(myax)
myline=line(xvec,zeros(1,length(xvec)));
set(myline,'tag','myline','color',handles.colorlist{currentgroupsel})

%recupdater(handles)
% UIWAIT makes pixelsurfer wait for user response (see UIRESUME)
% uiwait(handles.figure1);







% --- Outputs from this function are returned to the command line.
function varargout = pixelsurfer_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%set(handles.slider1,'userdata',round(get(handles.slider1,'Value')))
handles.ctimepoint=round(get(handles.slider1,'Value'));
set(handles.timetext,'string',num2str(handles.ctimepoint));
guidata(hObject,handles);
updaterawimage;



% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background, change
%       'usewhitebg' to 0 to use default.  See ISPC and COMPUTER.
usewhitebg = 1;
if usewhitebg
    set(hObject,'BackgroundColor',[.9 .9 .9]);
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
%set(handles.slider2,'userdata',round(get(handles.slider2,'Value')))
handles.cslice=round(get(handles.slider2,'Value'));
set(handles.slicetext,'string',num2str(handles.cslice));

guidata(hObject,handles);
updaterawimage;
updaterecs


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1

dolayout;

function updaterawimage   %change the image according to slider positions
handles=guidata(gcbo);
cslice=handles.cslice;
ctimepoint=handles.ctimepoint;
set(handles.myim,'CData',handles.imagedata(:,:,ctimepoint,cslice));


function dolayout      %rearrange layout of the GUI
handles=guidata(gcf);
%what is the zoomfactor?
vec=[1 2 3 4 5 6 7 8];
currentzoomfactor=get(handles.popupmenu1,'value'); %1=x1 2=x2 3=x4;
handles.zoomfactor=currentzoomfactor;
dispimagewidth=vec(currentzoomfactor)*handles.xsize;
dispimageheight=vec(currentzoomfactor)*handles.ysize;

figurewidth=dispimagewidth+50;
figureheight=dispimageheight+90;

figpos=get(handles.figure1,'position');
cheight=figpos(4);
incrementheight=dispimageheight+90-cheight;
%lowerypos=upperypos-dispimageheight;
impos=get(handles.axes1,'position');
slider1pos=get(handles.slider1,'position');
slider2pos=get(handles.slider2,'position');
myresizefcn=get(handles.figure1,'resizefcn');
set(handles.figure1,'resizefcn',[]);
set(handles.figure1,'position',[figpos(1) figpos(2)-incrementheight figurewidth figureheight]);
set(handles.axes1,'position',[impos(1) impos(2) dispimagewidth dispimageheight]);

set(handles.slider1,'position',[impos(1) impos(2)-20 dispimagewidth 15])
set(handles.slider2,'position',[impos(1)+dispimagewidth+5 impos(2) 15 dispimageheight])

handles.impos=[impos(1) impos(2) dispimagewidth dispimageheight];
set(handles.figure1,'resizefcn',myresizefcn);
guidata(gcf,handles);




function mouseclick(obj,eventdata)      %what to do if mouse is clicked on the image
%figure(gcf);
handles=guidata(obj);
impos=handles.impos;
currentpos=get(gcf,'currentpoint');
cslice=handles.cslice;

if (currentpos(1)>=impos(1))&(currentpos(1)<impos(1)+impos(3))&(currentpos(2)>=impos(2))&(currentpos(2)<impos(2)+impos(4))
    set(gcf,'Pointer','crosshair');
    matrixpos=[impos(2)+impos(4)-currentpos(2) currentpos(1)-impos(1)+1];  %[row column]
    indatapos=[ceil(matrixpos(1)/handles.zoomfactor) ceil(matrixpos(2)/handles.zoomfactor)];
    
    coord3d=[indatapos(1) indatapos(2) cslice];
    datavec=squeeze(handles.imagedata(indatapos(1),indatapos(2),:,cslice));
    
    selectedgroupnumber=get(handles.g1,'userdata');
    groups=get(handles.figure1,'userdata');
   
    %is that coord allready clicked?
    %doens't matter which group it is, i pixel is constrained to belong to only 1 group 
    allgroups=[];
    for q=1:length(groups)
        thisgroup=groups{q};
        if ~isempty(thisgroup)
            for n=1:size(thisgroup,1)
                if (sum(thisgroup(n,:)==coord3d)==3)
                    thisgroup(n,:)=[];
                    groups{q}=thisgroup;
                    set(handles.figure1,'userdata',groups);
                    updaterecs
                    updatecurves
                    return
                end
            end
        end
    end
    %no previous coord stored for this selction so:
    
    selectedgroupcoords=groups{selectedgroupnumber};

    if isempty(selectedgroupcoords)
        selectedgroupcoords(1,:)=coord3d;
    else
        selectedgroupcoords(end+1,:)=coord3d;
    end
    groups{selectedgroupnumber}=selectedgroupcoords;
    
    set(handles.figure1,'userdata',groups);
    
    updaterecs
    updatecurves
else
    set(gcf,'Pointer','arrow');
end




function mousemotion(obj,eventdata)     %what to do if mouse hovers the image
figure(gcbo);
handles=guidata(obj);
impos=round(handles.impos);
currentpos=round(get(obj,'currentpoint'));
cslice=handles.cslice;
currentgroupsel=get(handles.g1,'userdata');  

if (currentpos(1)>=impos(1))&(currentpos(1)<impos(1)+impos(3))&(currentpos(2)>=impos(2))&(currentpos(2)<impos(2)+impos(4))
    set(gcf,'Pointer','crosshair');
    matrixpos=[impos(2)+impos(4)-currentpos(2) currentpos(1)-impos(1)+1];  %[row column]
    indatapos=[ceil(matrixpos(1)/handles.zoomfactor) ceil(matrixpos(2)/handles.zoomfactor)];
    cslice=handles.cslice;
    datavec=squeeze(handles.imagedata(indatapos(1),indatapos(2),:,cslice));
    o=findobj('tag','plotwindow');
    
    if isempty(o)  %if figure isn't there
        mw=figure('tag','plotwindow');
        myax=axes;
        xvec=[1:handles.timepoints];
        set(myax,'color',[0 0 0],'xlim',[xvec(1) xvec(end)],'ylim',[min(handles.imagedata(:)) max(handles.imagedata(:))],'tag','myaxes')
        axes(myax)
        myline=line(xvec,zeros(1,length(xvec)));
        set(myline,'tag','myline','color',handles.colorlist{currentgroupsel})
    end
   
    myline=findobj('tag','myline');
    if sum(datavec.^2)==0
        set(myline,'ydata',zeros(1,handles.timepoints))
        return
    end
    
    set(myline,'ydata',datavec)
    
    
else

    set(gcf,'Pointer','arrow');
end


function myresize(hObject, eventdata, handles)           %if the user changed the window size by dragging
%objective: find zoomfactor closest to user choice of window size
handles=guidata(gcbo);

imwidth=handles.xsize;

widthsets=[1:8]*imwidth;

pos=get(handles.figure1,'position');
userwidth=pos(3);

wdiff=abs(widthsets-userwidth); 
[d,zfac]=min(wdiff);

set(handles.popupmenu1,'value',zfac)
dolayout;






function updaterecs                      %update rectangle graphics
handles=guidata(gcbo);
groups=get(handles.figure1,'userdata');

figure(handles.figure1)

delete(findobj(handles.figure1,'type','rectangle'))

for ngroup=1:length(groups)
    currentgroup=groups{ngroup};
    if ~isempty(currentgroup)
        for n=1:size(currentgroup,1)
            currentloc=currentgroup(n,:);
            if handles.cslice==currentloc(3)
                rectangle('position',[currentloc(2)-0.5 currentloc(1)-0.5 1 1],'facecolor',handles.colorlist{ngroup},'linestyle','none','hittest','off'); 
            end
        end
    end
end



function updatecurves              %update curve graphics  - paints average and std of groups
handles=guidata(gcbo);

handles=guidata(gcbo);
groups=get(handles.figure1,'userdata');
xvec=1:handles.timepoints;

for q=1:length(groups)
    currentgroup=groups{q};
    linetag=['avgline' num2str(q)];
    lineebtag=['avgline_eb' num2str(q)];
    if ~isempty(currentgroup)
        datamatrix=zeros(size(currentgroup,1),handles.timepoints);
        for n=1:size(currentgroup,1)
            row=currentgroup(n,1);
            col=currentgroup(n,2);
            slice=currentgroup(n,3);
            datamatrix(n,:)=squeeze(handles.imagedata(row,col,:,slice));
        end

        groupavg=mean(datamatrix,1);
        
        groupstd=std(datamatrix,0,1);
        
        ebartop=groupavg+groupstd;
        ebarmin=groupavg-groupstd;
        
        [xdat,ydat]=ebar2linematrix(ebartop,ebarmin,xvec);
        
        delete(findobj('tag',linetag));
        delete(findobj('tag',lineebtag));
        
       
        axes(findobj('tag','myaxes'));
        
        myline=line(xvec,groupavg);
        myeb=line(xdat+(q*0.05),ydat);
        
        set(myline,'tag',linetag,'color',handles.colorlist{q},'linewidth',3);
        
        set(myeb,'tag',lineebtag,'color',handles.colorlist{q});
        
    else %group was empty
        delete(findobj('tag',linetag));
        delete(findobj('tag',lineebtag));
    end
    
    
end







% --- Executes on button press in clearall.
function clearall_Callback(hObject, eventdata, handles)
% hObject    handle to clearall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.figure1,'userdata',{[],[],[]})
updaterecs
updatecurves



% --- Executes on button press in g2.
function g2_Callback(hObject, eventdata, handles)
% hObject    handle to g2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of g2
if get(hObject,'Value')
    set(handles.g1,'value',0)
    set(handles.g3,'value',0)
end

set(handles.g1,'userdata',2);
set(findobj('tag','myline'),'color',handles.colorlist{2})


% --- Executes on button press in g1.
function g1_Callback(hObject, eventdata, handles)
% hObject    handle to g1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of g1
if get(hObject,'Value')
    set(handles.g2,'value',0)
    set(handles.g3,'value',0)
end

set(handles.g1,'userdata',1);
set(findobj('tag','myline'),'color',handles.colorlist{1})


% --- Executes on button press in g3.
function g3_Callback(hObject, eventdata, handles)
% hObject    handle to g3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of g3

if get(hObject,'Value')
    set(handles.g1,'value',0)
    set(handles.g2,'value',0)
end

set(handles.g1,'userdata',3);
set(findobj('tag','myline'),'color',handles.colorlist{3})






function [xdat,ydat]=ebar2linematrix(ebartop,ebarmin,xcoords)        %makes data for the errorbars
xdat=zeros(1,3*length(xcoords));
ydat=zeros(1,3*length(xcoords));
xdat(1:3:length(xdat))=xcoords;
xdat(2:3:length(xdat))=xcoords;
xdat(3:3:length(xdat))=nan;
ydat(1:3:length(xdat))=ebartop;
ydat(2:3:length(xdat))=ebarmin;
ydat(3:3:length(xdat))=nan;

