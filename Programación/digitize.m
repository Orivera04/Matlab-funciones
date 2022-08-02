function digitize(action,varargin)
%DIGITIZE: Image Digitization Tool
%
%Description:
%
%digitize is a user interfase that allows
%to import image files (.bmp, etc) into MatLab
%to digitize data from. Previous sessions can 
%also be loaded.
%
%Intructions:
% First load a new image by entering the menu "Load"
% and clicking on "Load New Image".
% First the Referennce Points (points on the image whos 
% coordinates are known) must be selected.
% This is done by entering the "Transformation" menu
% and then selecting "Add Points".
% Left-click on the points reference points and Right-click
% when finished.
% Then Right-click on any reference point to enter it's
% "true" coordinate.
% When the coordinated for all the reference points have been
% entered the "Reference Data Complete" is checked inside the
% "Transformation" menu.
% To digitize, select "Add Points" from the "Digitization" menu.
% You may start digitizing points on the image at any time,
% but their transformed coordinated are not calculated until
% the reference data is complete. To see a digitized point's
% transformed coordinate, right-click on a point. 
%
%A session .mat file contains:
%jt,kt - reference points in image axes coordinates
%xt,yt - reference points in transformed coordinates
%img - the RGB 'Cdata' of the image
%jd,kd - digitized points in image axes coordinates
%xd,yd - digitized points in transformed coordinates
%R - the transformation matrix
%The transformation matrix is used to convert from 
%the image axes coordinate system to the desired
%coordinate system by entered the "true" of transformed
%coordinates manually.
%
%The first order linear transformation matrix is:
%   R = [sx ry 0;... 
%       ry sy 0;... 
%       tx ty 1]
%   where s -> scaling, r -> rotation, t -> translation
%
%A second and third order fits are also available in the
%"Transformation" menu. These are useful for distorted images
%or maps of unknown projection. The drawback is that larger
%orders requiere more data.
%
%Click on "Residuals" in the "Transformation" menu
%to see the residuals of the reference points.
%The residuals are defined as the "true" or "given"
%value minus the calculated value using the transformation
%matrix. The residuals should be of the order of magnitude
%of the pixcel size. 
%
%The pixcel size can be seen by clicking on 
%"Pixcel Size" in the "Transformation" menu. 
%The pixcel size is the horizontal x vertical direction. 
%Note that these are approximate because the 
%image is assumed to be rotated. 
%
%The directory is automatically changed to the directory of
%the image file.
%
%An image can be loaded directly by using for example:
%digitize('ImageFileName.bmp')
%
% The userdata of the figure is set to a structure called ud.
% If the userdata already contains a structure,
% new fields are added for internal use of the program.
% Some of fields are describes bellow
%   hAx - Axis handle
%   hAddTrnPts - Add Points uimenu handle
%   hRmvTrnPts - Remove Points uimenu handle
%   hRDC - Reference Data Complete uimenu handle
%   hRes - Residuals uimenu handle
%   hResTxt - Residual labels handle
%   hPix - Pixcel Size uimenu handle
%   hDltDgzPts - Delete Digitized Points uimenu handle
%   hDgzNumPts - Number Digitized Points
%   hNumber - Number uimenu handle
%   hDltAllDgzPts - Delete all Points uimenu handle
%   hCntPts - Connect Points uimenu handle
%   hImg - Image handle
%   hTrnPts - Tranformation Points handle
%   hDgzPts - Digitizated Points handle
%   hHiPt - Highlight line object handle
%   xt - x-coordinate of Transformation Points
%   yt - y-coordinate of Transformation Points
%   xd - x-coordinate of Digitizated Points
%   yd - y-coordinate of Digitizated Points
%   order - Order of fit
%   index - Indexed used for sorting of Points
%   ImgFileName - Image File Name
%   
% A list of the subroutines is given below
%   Initialize(fullname)
%   LoadImageSession(fullname)
%   UpdateNumber
%   UpdatePoints(LineSpec,op)
%   AddPoints(op)
%   DeletePoints(op)
%   ReferencePoints(op)
%   ExpSession
%   ExpPts(op)
%   ExpTrnsMat
%   DeleteAllPts
%   LoadSession
%   HiRefPts
%   Residuals
%   PixcelSize
%   UIOrder
%   NumberPoints
%   [x,y] = jk2xy(j,k,R,order)
%   [R,order] = jkxy2R(j,k,x,y,order)
%   ConnectPts
%
%Copy-Left, Alejandro Sanchez

if nargin==0
    action = 'Initialize';    
else
    [pathstr,name,ext,versn] = fileparts(action);
    %if the ext is not empty it is a file
    if ~isempty(ext)
        Initialize(action)
        return
    end
end

feval(action,varargin{:});

return

%---------------------------------------------------

function Initialize(fullname)

% h = findobj(allchild(0),'tag','hFig');
% if ~isempty(h)
%     close(h)
% end
%'Tag','hFig', ...

try
    editingtool('Off')
end

screensize = get(0,'ScreenSize');
figpos = screensize*0.8 + [0.1*screensize(3),0.1*screensize(4),0,0];
hFig = figure('Name','DIGITIZE: Image Digitization Tool', ...
    'NumberTitle','off','Visible','off',... 
    'HandleVisibility','on','Position',figpos, ...
    'BusyAction','Queue','Interruptible','off', ...
    'Color', 0.8*[1,1,1],'NextPlot','Add', ...
    'DoubleBuffer','On','IntegerHandle','off');

ud.hAx = axes('Position',[0,0,1,1],'Ydir','Reverse',...
    'ButtonDownFcn','digitize(''clean'')');

%------------------ Image -------------------------------------------

hLoad = uimenu('Label','Load');

uimenu(hLoad,'Label','Image File',...
    'Callback','digitize(''LoadImageSession'')');

uimenu(hLoad,'Label','Session',...
    'Callback','digitize(''LoadSession'')');


%------------------ Transformation -----------------------------------

hTrn = uimenu('Label','Transformation');
ud.hAddTrnPts = uimenu(hTrn,'Label','Add Points',...
    'Callback','digitize(''AddPoints'',''t'')');

ud.hRmvTrnPts = uimenu(hTrn,'Label','Delete Points',...
    'Enable','Off','Callback','digitize(''DeletePoints'',''t'')');

hTrnPtsMarker = uimenu(hTrn,'Label','Marker');

hTrnPtsColor = uimenu(hTrnPtsMarker,'Label','Color');

uimenu(hTrnPtsColor,'Label','Red', ...
    'Callback','digitize(''UpdatePoints'',''r'',''t'')');
uimenu(hTrnPtsColor,'Label','Blue', ...
    'Callback','digitize(''UpdatePoints'',''b'',''t'')');
uimenu(hTrnPtsColor,'Label','Green', ...
    'Callback','digitize(''UpdatePoints'',''g'',''t'')');
uimenu(hTrnPtsColor,'Label','Yellow', ...
    'Callback','digitize(''UpdatePoints'',''y'',''t'')');
uimenu(hTrnPtsColor,'Label','Magenta', ...
    'Callback','digitize(''UpdatePoints'',''m'',''t'')');

hTrnPtsSize = uimenu(hTrnPtsMarker,'Label','Size');

uimenu(hTrnPtsSize,'Label','1', ...
    'Callback','digitize(''UpdatePoints'',1,''t'')');
uimenu(hTrnPtsSize,'Label','2', ...
    'Callback','digitize(''UpdatePoints'',2,''t'')');
uimenu(hTrnPtsSize,'Label','3', ...
    'Callback','digitize(''UpdatePoints'',3,''t'')');
uimenu(hTrnPtsSize,'Label','4', ...
    'Callback','digitize(''UpdatePoints'',4,''t'')');
uimenu(hTrnPtsSize,'Label','5', ...
    'Callback','digitize(''UpdatePoints'',5,''t'')');
uimenu(hTrnPtsSize,'Label','6', ...
    'Callback','digitize(''UpdatePoints'',6,''t'')');
uimenu(hTrnPtsSize,'Label','7', ...
    'Callback','digitize(''UpdatePoints'',7,''t'')');
uimenu(hTrnPtsSize,'Label','8', ...
    'Callback','digitize(''UpdatePoints'',8,''t'')');
uimenu(hTrnPtsSize,'Label','9', ...
    'Callback','digitize(''UpdatePoints'',9,''t'')');
uimenu(hTrnPtsSize,'Label','10', ...
    'Callback','digitize(''UpdatePoints'',10,''t'')');

hTrnPtsStyle = uimenu(hTrnPtsMarker,'Label','Style');

uimenu(hTrnPtsStyle,'Label','none', ...
    'Callback','digitize(''UpdatePoints'',''none'',''t'')');
uimenu(hTrnPtsStyle,'Label','Circle', ...
    'Callback','digitize(''UpdatePoints'',''o'',''t'')');
uimenu(hTrnPtsStyle,'Label','Plus', ...
    'Callback','digitize(''UpdatePoints'',''+'',''t'')');
uimenu(hTrnPtsStyle,'Label','Square', ...
    'Callback','digitize(''UpdatePoints'',''s'',''t'')');
uimenu(hTrnPtsStyle,'Label','Star', ...
    'Callback','digitize(''UpdatePoints'',''*'',''t'')');

uimenu(hTrn,'Label','Order of Fit ...', ...
    'Separator','On','Callback','digitize(''UIOrder'')');

ud.hHRP = uimenu(hTrn,'Label','Highlight Referenced Points', ...
    'Checked','off','Callback','digitize(''HiRefPts'')');

ud.hRDC = uimenu(hTrn,'Label','Reference Data Complete', ...
    'Checked','off');

ud.hRes = uimenu(hTrn,'Label','Residuals','Enable','Off', ...
    'Checked','off','Callback','digitize(''Residuals'')');

ud.hResTxt = [];

ud.hPix = uimenu(hTrn,'Label','Pixcel Size', ...
    'Callback','digitize(''PixcelSize'')');

%------------- Digitization ------------------------------------------

hDgz = uimenu('Label','Digitization');

uimenu(hDgz,'Label','Add Points',...
    'Callback','digitize(''AddPoints'',''d'')');

ud.hDltDgzPts = uimenu(hDgz,'Label','Delete Points',...
    'Enable','Off','Callback','digitize(''DeletePoints'',''d'')');

ud.hDgzNumPts =  uimenu(hDgz,'Label','Number Points', ...
    'Enable','Off','Checked','off','Callback','digitize(''NumberPoints'')');

hDgzPtsMarker = uimenu(hDgz,'Label','Marker');

hDgzPtsColor = uimenu(hDgzPtsMarker,'Label','Color');

uimenu(hDgzPtsColor,'Label','Red', ...
    'Callback','digitize(''UpdatePoints'',''r'',''d'')');
uimenu(hDgzPtsColor,'Label','Blue', ...
    'Callback','digitize(''UpdatePoints'',''b'',''d'')');
uimenu(hDgzPtsColor,'Label','Green', ...
    'Callback','digitize(''UpdatePoints'',''g'',''d'')');
uimenu(hDgzPtsColor,'Label','Yellow', ...
    'Callback','digitize(''UpdatePoints'',''y'',''d'')');
uimenu(hDgzPtsColor,'Label','Magenta', ...
    'Callback','digitize(''UpdatePoints'',''m'',''d'')');

hDgzPtsSize = uimenu(hDgzPtsMarker,'Label','Size');

uimenu(hDgzPtsSize,'Label','2', ...
    'Callback','digitize(''UpdatePoints'',2,''d'')');
uimenu(hDgzPtsSize,'Label','3', ...
    'Callback','digitize(''UpdatePoints'',3,''d'')');
uimenu(hDgzPtsSize,'Label','4', ...
    'Callback','digitize(''UpdatePoints'',4,''d'')');
uimenu(hDgzPtsSize,'Label','5', ...
    'Callback','digitize(''UpdatePoints'',5,''d'')');
uimenu(hDgzPtsSize,'Label','6', ...
    'Callback','digitize(''UpdatePoints'',6,''d'')');
uimenu(hDgzPtsSize,'Label','7', ...
    'Callback','digitize(''UpdatePoints'',7,''d'')');
uimenu(hDgzPtsSize,'Label','8', ...
    'Callback','digitize(''UpdatePoints'',8,''d'')');
uimenu(hDgzPtsSize,'Label','9', ...
    'Callback','digitize(''UpdatePoints'',9,''d'')');
uimenu(hDgzPtsSize,'Label','10', ...
    'Callback','digitize(''UpdatePoints'',10,''d'')');

hDgzPtsStyle = uimenu(hDgzPtsMarker,'Label','Style');

uimenu(hDgzPtsStyle,'Label','none', ...
    'Callback','digitize(''UpdatePoints'',''none'',''d'')');
uimenu(hDgzPtsStyle,'Label','Circle', ...
    'Callback','digitize(''UpdatePoints'',''o'',''d'')');
uimenu(hDgzPtsStyle,'Label','Plus', ...
    'Callback','digitize(''UpdatePoints'',''+'',''d'')');
uimenu(hDgzPtsStyle,'Label','Square', ...
    'Callback','digitize(''UpdatePoints'',''s'',''d'')');
uimenu(hDgzPtsStyle,'Label','Star', ...
    'Callback','digitize(''UpdatePoints'',''*'',''d'')');
ud.hNumber = uimenu(hDgzPtsStyle,'Label','Number', ...
    'Checked','off','Callback','digitize(''UpdateNumber'')');

ud.hDltAllDgzPts = uimenu(hDgz,'Label','Delete All Points', ...
    'Enable','Off','Callback','digitize(''DeleteAllPts'')');

ud.hCntPts = uimenu(hDgz,'Label','Connect Points','Enable','Off', ...
    'Separator','On','Checked','Off','Callback','digitize(''ConnectPts'')');

%------------------- Export --------------------------------

hExp = uimenu('Label','Export');

uimenu(hExp,'Label','Session', ...
    'Callback','digitize(''ExpSession'')');

uimenu(hExp,'Label','Digitized Points to Workspace', ...
    'Callback','digitize(''ExpPts'',''WS'')');

uimenu(hExp,'Label','Digitized Points to ASCII File', ...
    'Callback','digitize(''ExpPts'',''ASCII'')');

uimenu(hExp,'Label','Transformation Matrix to Workspace', ...
    'Callback','digitize(''ExpTrnsMat'')');


%============== Plotting =========================

%----------- Image ----------------------
cImgMenu = uicontextmenu;

ud.hImg = image('Parent',ud.hAx, ...
    'UIContextMenu',cImgMenu,'ButtonDownFcn', ...
    'digitize(''clean'')');

uimenu(cImgMenu,'Label','Add Digitization Points', ...
    'Callback','digitize(''AddPoints'',''dc'')');
uimenu(cImgMenu,'Label','Add Transformation Points', ...
    'Callback','digitize(''AddPoints'',''tc'')');

%---------- Transformation Points --------------
jt = [];
kt = [];

cTrnPtsMenu = uicontextmenu;

ud.hTrnPts = line('Xdata',jt,'Ydata',kt, ...
    'LineStyle','None','Parent',ud.hAx, ...
    'Marker','o','Color','r','MarkerSize',6, ...
    'UIContextMenu',cTrnPtsMenu);

set(ud.hTrnPts,'ButtonDownFcn','digitize(''BtnDown'',''t'')')

uimenu(cTrnPtsMenu,'Label','Delete', ...
    'Callback','digitize(''DeletePoints'',''tc'')');
uimenu(cTrnPtsMenu,'Label','Reference', ...
    'Callback','digitize(''ReferencePoints'',''tc'')');

%------------- Digitization Points -----------------
jd = [];
kd = [];

cDgzPtsMenu = uicontextmenu;

ud.hDgzPts = line('Xdata',jd,'Ydata',kd, ...
    'LineStyle','None','Parent',ud.hAx, ...
    'Marker','+','Color','b','MarkerSize',6, ...
    'Parent',ud.hAx,'UIContextMenu',cDgzPtsMenu);

set(ud.hDgzPts,'ButtonDownFcn','digitize(''BtnDown'',''d'')')

uimenu(cDgzPtsMenu,'Label','Delete', ...
    'Callback','digitize(''DeletePoints'',''dc'')');
uimenu(cDgzPtsMenu,'Label','Coordinates', ...
    'Callback','digitize(''ReferencePoints'',''dc'')');

%Highlight Point
ud.hHiPt = line('Xdata',[],'Ydata',[], ...
    'LineStyle','None','Parent',ud.hAx, ...
    'Marker','none','Color','c',...
    'ButtonDownFcn','digitize(''BtnDown'',''h'')');

%Transformation Coordinates of jt and kt
ud.xt = [];
ud.yt = [];

%Digitized Transformed Points of jd and kd
ud.xd = [];
ud.yd = [];

%Transformation Matrix
ud.R = [];

%Order of Fit
ud.order = 1;

%Index of Order of Points
ud.index = [];

set(hFig,'UserData',ud)
if nargin==0
    list = dir('*.bmp');
    if isstruct(list) && ~isempty(list)
        fullname = list(1).name;    
    else
        fullname = 'detail.mat';  
    end
end
LoadImageSession(fullname)
set(hFig,'Visible','On')
return

%----------------------------------------------------
function LoadImageSession(fullname)
% hFig = findobj(allchild(0),'tag','hFig');
% hFig = hFig(end); %if several are open use last
hFig = get(0,'CurrentFigure');
ud = get(hFig,'UserData');
if nargin<1 %Callback
    oldname = ud.ImgFileName;
    [iname,ipath] = uigetfile('*.*','Select an Image-File:');
	if ~any(iname)
        return
    end
    if isempty(ipath)
        ipath = [cd,filesep];
    end
    fullname = [ipath,iname];
%     if strcmpi(oldname,fullname)
%         return
%     end
end
if exist(fullname,'file')~=2
    hw = msgbox('Invalid file name or file does not exist','DIGITIZE','error');
    uiwait(hw)
    drawnow
    [iname,ipath] = uigetfile('*.*','Locate Image-File:');
    if ~any(iname)
        return
    end
    if isempty(ipath)
        ipath = [cd,filesep];
    end
    fullname = [ipath,iname];
    if exist(fullname,'file')~=2
        errordlg('Invalid file name or file does not exist','DIGITIZE')
    end
end 
[pathstr,name,ext] = fileparts(fullname);
if ~isempty(pathstr)
    try
        cd(pathstr) %change to directory of file
    catch
       error([fullname,' has an invalid path'])
    end
end
if strcmpi(ext,'.mat')
    try
        a = load(fullname);
    catch
        error([fullname,' not found'])
    end
    fn = fieldnames(a);
    img = [];
    map = [];
    %---------- Sesssion --------------
    if isfield(a,'R')
%         try
            ud.ImgFileName = a.ImgFileName;
            set(hFig,'Name',['DIGITIZE: Image Digitization Tool - ', ...
                ud.ImgFileName])
            ud.jt = a.jt;
            ud.kt = a.kt;
            ud.jd = a.jd;
            ud.kd = a.kd;
            set(ud.hTrnPts,'Xdata',ud.jt,'Ydata',ud.kt)
            set(ud.hDgzPts,'Xdata',ud.jd,'Ydata',ud.kd)
            ud.xt = a.xt;
            ud.yt = a.yt;
            ud.xd = a.xd;
            ud.yd = a.yd;
            ud.R = a.R;

            [img,map] = imread(ud.ImgFileName);
            if ~isempty(map) %always use true color
                img = ind2rgb(img,map);
            end
            s = size(img);
            xdata = [1,s(2)];
            ydata = [1,s(1)];
            set(ud.hImg,'Xdata',xdata,'Ydata',ydata,'Cdata',img)
            xlim = [0.5,s(2)+0.5];
            ylim = [0.5,s(1)+0.5];
            set(ud.hAx,'Xlim',xlim,'Ylim',ylim)
            
            %check if all transformation data is complete
            if all(isfinite(ud.xt))
                set(ud.hRDC,'Checked','On')
                set(ud.hRes,'Enable','On')
                set(ud.hPix,'Enable','On')
            else
                set(ud.hRDC,'Checked','Off')
                set(ud.hRes,'Enable','Off')
                set(ud.hPix,'Enable','Off')
            end
            set(ud.hResTxt,'Visible','Off')
            set(hFig,'UserData',ud)
            return

    %------- Image File -----------------
    else 
        for k=1:length(fn)
            s = size(a.(fn{k}));
            num = isnumeric(a.(fn{k}));
            if s(2)==3 && num
                map = a.(fn{k});
            elseif num && all(s>20)
                img = a.(fn{k});
            end %if
        end %for
        if isempty(img)
            errordlg('Invalid .mat file','DIGITIZE')
            return
        end %if
    end %if
else
    [img,map] = imread(fullname);
end %if
ud.ImgFileName = fullname;
if ~isempty(map) %always use true color
    img = ind2rgb(img,map);
end
s = size(img);
xdata = [1,s(2)];
ydata = [1,s(1)];
set(ud.hImg,'Xdata',xdata,'Ydata',ydata,'Cdata',img)
xlim = [0.5,s(2)+0.5];
ylim = [0.5,s(1)+0.5];
set(ud.hAx,'Xlim',xlim,'Ylim',ylim)
set(ud.hTrnPts,'Xdata',[],'Ydata',[])
set(ud.hDgzPts,'Xdata',[],'Ydata',[])
set(ud.hHiPt,'Xdata',[],'Ydata',[])
ud.xt = [];
ud.yt = [];
ud.xd = [];
ud.yd = [];
ud.R = [];
set(ud.hRDC,'Checked','Off')
set(ud.hRes,'Enable','Off')
set(ud.hPix,'Enable','Off')
set(ud.hResTxt,'Visible','Off')
set(hFig,'UserData',ud)
set(hFig,'Name',['DIGITIZE: Image Digitization Tool - ',fullname])
return

%----------------------------------------------------
function UpdateNumber
ud = get(gcbf,'UserData');
if strcmpi(get(ud.hNumber,'Checked'),'On')
    set(ud.hNumber,'Checked','Off')
else
    set(ud.hNumber,'Checked','On')
end
set(hFig,'UserData',ud)
return

%--------------------------------------------------------
function UpdatePoints(LineSpec,op)
hFig = gcbf;
ud = get(hFig,'UserData');
isDgz = any(op=='d');
if isDgz %Digitization
    h = ud.hDgzPts;
else %Transformation
    h = ud.hTrnPts;
end %if
if isnumeric(LineSpec)
    set(h,'MarkerSize',LineSpec)
    return
end
if strcmpi(LineSpec,'none')
    set(h,'Marker','none')
    return
end
[style,color,marker,msg] = colstyle(LineSpec);
if ~isempty(msg)
    errordlg(msg,'DIGITIZE')
    return
end
if ~isempty(color)
    set(h,'Color',color)
end
if ~isempty(marker)
    set(h,'Marker',marker)  
end
return

%---------------------------------------------------------
function AddPoints(op)
hFig = gcbf;
ud = get(hFig,'UserData');
isDgz = any(op=='d');
if isDgz %Digitization
    h = ud.hDgzPts;
    x = ud.xd;
    y = ud.yd;
    if ~isempty(ud.index)
        index = ud.index;
        [dummy,newindex] = sort(index);
        j = get(ud.hDgzPts,'XData');
        k = get(ud.hDgzPts,'YData');
        n = length(newindex);
        j(1:n) = j(newindex);
        k(1:n) = k(newindex);
        set(ud.hCntPts,'Checked','Off')
        set(ud.hDgzPts,'XData',j,'YData',k,'LineStyle','None')
        ud.index = [];
    end
else    %Transformation
    h = ud.hTrnPts;
    x = ud.xt;
    y = ud.yt;
end
j = get(h,'Xdata');
k = get(h,'Ydata');
pointer = get(gcf,'pointer');
state = uisuspend(hFig); %Remove figure button functions
set(hFig,'pointer','fullcrosshair');
while 1 %This is much faster than using ginput
    keydown = waitforbuttonpress;
    button = get(hFig,'SelectionType');
    drawnow
    pt = get(gca,'CurrentPoint');
    switch lower(button)
        case {'open','normal'}
            j(end+1) = pt(1,1);
            k(end+1) = pt(1,2);
            set(h,'Xdata',j,'Ydata',k)
        case {'extend','alt'}
            break
    end %switch
end %while
uirestore(state);
set(hFig,'pointer',pointer)
n = length(j);
%DataWrap x and y with NaN's
nn = length(x);
x(nn+1:n) = NaN;
y(nn+1:n) = NaN;
if isDgz %Digitization
    if ~isempty(ud.R)
        [x,y] = jk2xy(j,k,ud.R,ud.order);
    end
    ud.xd = x;
    ud.yd = y;
else %Transformation
    ud.xt = x;
    ud.yt = y;
    if nn<n
        set(ud.hRDC,'Checked','Off')
        set([ud.hRes,ud.hPix],'Enable','Off')
        chck = get(ud.hRes,'Checked');
        if chck
            set(ud.hRes,'Checked','Off')
            set(ud.hResTxt,'Visible','Off')
        end
    end
end
if n>0
    if isDgz %Digitization
        set([ud.hDltDgzPts,ud.hDltAllDgzPts, ...
            ud.hDgzNumPts,ud.hCntPts],'Enable','On')
    else    %Transformation
        set(ud.hRmvTrnPts,'Enable','On')
    end
else
    if isDgz %Digitization
        set([ud.hDltDgzPts,ud.hDltAllDgzPts, ...
            ud.hDgzNumPts,ud.hCntPts],'Enable','Off')
    else    %Transformation
        set(ud.hRmvTrnPts,'Enable','Off')
    end
end
set(hFig,'UserData',ud)
return

%---------------------------------------------------------
function DeletePoints(op)
hFig = gcbf;
ud = get(hFig,'UserData');
isDgz = any(op=='d');
if any(op=='c') %from Mouse
    pt = get(ud.hAx, 'CurrentPoint');
    jp = pt(1,1);
    kp = pt(1,2);
    if isDgz %Digitization
        h = ud.hDgzPts;
        if ~isempty(ud.index)
            index = ud.index;
            [dummy,newindex] = sort(index);
            j = get(ud.hDgzPts,'XData');
            k = get(ud.hDgzPts,'YData');
            n = length(newindex);
            j(1:n) = j(newindex);
            k(1:n) = k(newindex);
            ud.xd(1:n) = ud.xd(ud.index);
            ud.yd(1:n) = ud.yd(ud.index);
            set(ud.hCntPts,'Checked','Off')
            set(ud.hDgzPts,'XData',j,'YData',k,'LineStyle','None')
            ud.index = [];
        end
    else %Transformation
        h = ud.hTrnPts;
    end %if
    j = get(h,'Xdata');
    k = get(h,'Ydata');
    %Delaunay Does not work well
    %when there are few points
    tri = [];
    try
        tri = delaunay(j,k);
        c = dsearch(j,k,tri,jp,kp);
    catch
        d = sqrt((jp-j).^2 + (kp-k).^2);
        [m,c] = min(d);
    end
    j(c) = [];
    k(c) = [];
    set(h,'Xdata',j,'Ydata',k)
    if isDgz %Digitization
        ud.xd(c) = [];
        ud.yd(c) = [];
    else %Transformation
        ud.xt(c) = [];
        ud.yt(c) = [];  
        %Check for complete reference points
        if strcmpi(get(ud.hRDC,'Checked'),'On')
            ud.R = jkxy2R(j,k,ud.xt,ud.yt,ud.order);
        end
    end
else %from Menu
    if isDgz %Digitization
        h = ud.hDgzPts;
        if ~isempty(ud.index)
            index = ud.index;
            [dummy,newindex] = sort(index);
            j = get(ud.hDgzPts,'XData');
            k = get(ud.hDgzPts,'YData');
            n = length(newindex);
            j(1:n) = j(newindex);
            k(1:n) = k(newindex);
            ud.xd(1:n) = ud.xd(ud.index);
            ud.yd(1:n) = ud.yd(ud.index);
            set(ud.hCntPts,'Checked','Off')
            set(ud.hDgzPts,'XData',j,'YData',k,'LineStyle','None')
            ud.index = [];
        end
    else %Transformation
        h = ud.hTrnPts;
    end %if
    j = get(h,'Xdata');
    k = get(h,'Ydata');
    marker = get(h,'Marker');
    set(ud.hHiPt,'Marker',marker)
    n = length(j);
    %Delaunay Does not work well
    %when there are few points
    tri = [];
    if n>30
        try
            tri = delaunay(j,k);
        end
    end
    ind = true(n,1);
    f = false(1);
    while 1
        [jp,kp,button] = ginput(1);
        if button==1
            if ~isempty(tri)
                c = dsearch(j,k,tri,jp,kp);
            else
                d = sqrt((jp-j).^2 + (kp-k).^2);
                [m,c] = min(d);
            end
            set(ud.hHiPt,'Xdata',j(c),'Ydata',k(c))
            [xd,yd,button] = ginput(1);
            if button==1
                ind(c) = f;
                set(h,'Xdata',j(ind),'Ydata',k(ind))
            end %if
        else
            break
        end %if
        set(ud.hHiPt,'Xdata',[],'Ydata',[])
    end %while
    if isDgz
        ud.xd = ud.xd(ind);
        ud.yd = ud.yd(ind);
    else
        ud.xt = ud.xt(ind);
        ud.yt = ud.yt(ind);
        x = ud.xt;
        y = ud.yt;
        j = j(ind);
        k = k(ind);
        ud.R = jkxy2R(j,k,x,y,ud.order);
        if isempty(ud.R)
            ud.xd = [];
            ud.yd = [];
        end
    end %if
end %if
set(hFig,'UserData',ud)
return

%----------------------------------------------------------
function ReferencePoints(op)
hFig = gcbf;
ud = get(hFig,'UserData');
pt = get(ud.hAx, 'CurrentPoint');
jp = pt(1,1);
kp = pt(1,2);
isDgz = any(op=='d');
if isDgz
    if ~isempty(ud.R)
        h = ud.hDgzPts;
        x = ud.xd;
        y = ud.yd;
    else
        errordlg('Transformation Data is not complete','DIGITIZE')
        return
    end
else
    h = ud.hTrnPts;
    x = ud.xt;
    y = ud.yt;
end
j = get(h,'Xdata');
k = get(h,'Ydata');
tri = [];
n = length(j);
if n>30
    try
        tri = delaunay(j,k);
    end
end
if ~isempty(tri)
    c = dsearch(j,k,tri,jp,kp);
else
    d = sqrt((jp-j).^2 + (kp-k).^2);
    [m,c] = min(d);
end
m = get(ud.hTrnPts,'Marker');
ms = get(ud.hTrnPts,'MarkerSize');
set(ud.hHiPt,'Xdata',j(c),'Ydata',k(c), ...
    'Marker',m,'MarkerSize',ms+1,'visible','on')
if isDgz
    msgbox(['X: ',num2str(x(c)),', Y: ',num2str(y(c))])
    set(ud.hHiPt,'Xdata',[],'Ydata',[],'MarkerSize',ms)
    return
end
while 1
    if isnan(x(c))
        xydef = {'',''};
    else
        xydef = {num2str(x(c)),num2str(y(c))};
    end
    xy = inputdlg({'X-Coordinate:','Y-Coordinate:'}, ...
        'Reference',[1,35; 1,35],xydef);
    if isempty(xy)
        break
    end
    try
        xy = str2double(xy);
        x(c) = xy(1);
        y(c) = xy(2);
        break
    catch
        errordlg('Input must be numberic','DIGITIZE')
    end %try
end %while
ud.xt = x;
ud.yt = y;
%Check if All References are entered
if all(isfinite(x))
    set(ud.hRDC,'Checked','On')
    set(ud.hRes,'Enable','On')
    set(ud.hPix,'Enable','On')
    ud.R = jkxy2R(j,k,x,y,ud.order);
    jd = get(ud.hDgzPts,'XData');
    kd = get(ud.hDgzPts,'YData');
    if ~isempty(jd)
        [ud.xd,ud.yd] = jk2xy(jd,kd,ud.R,ud.order);
    end
end
set(hFig,'UserData',ud)
set(ud.hHiPt,'Xdata',[],'Ydata',[],'MarkerSize',ms)
return

%----------------------------------------------------------
function ExpSession
hFig = gcbf;
ud = get(hFig,'UserData');
ImgFileName = ud.ImgFileName;
jt = get(ud.hTrnPts,'Xdata');
kt = get(ud.hTrnPts,'Ydata');
jd = get(ud.hDgzPts,'Xdata');
kd = get(ud.hDgzPts,'Ydata');
xt = ud.xt;
yt = ud.yt;
xd = ud.xd;
yd = ud.yd;
R = ud.R;
[sname,spath] = uiputfile('*.mat','Save Session as:');
if ~any(sname)
    return
end
fullname = [spath,sname];
if exist(fullname,'file')==2
    fileattrib(fullname,'+w'); %make writeable
end
save(fullname,'ImgFileName','jt','kt', ...
    'jd','kd','xt','yt','xd','yd','R')
msgbox('Session Saved Successfully','DIGITIZE')
return

%----------------------------------------------------------
function ExpPts(op)
hFig = gcbf;
ud = get(hFig,'UserData');
if all(~isnan(ud.xd))
    if strcmp(op,'WS')
        assignin('base','xd',ud.xd)
        assignin('base','yd',ud.yd)
        msgbox('Digitized Points (xd,yd) Saved to Workspace','DIGITIZE')
    else %ASCII
        [aname,apath] = uiputfile('*.*','Save as:');
        if ~any(aname)
            return
        end
        fullname = [apath,aname];
        fid = fopen(fullname,'w');
        fprintf(fid,'%f\t%f\n',[ud.xd(:), ud.yd(:)]')
        fclose(fid);
        msgbox('ASCII File Saved Successfully','DIGITIZE')
    end
else
    errordlg('Transformation is not complete','DIGITIZE')
end
return

%-----------------------------------------------------------
function BtnDown(op)
hFig = gcbf;
Button = get(hFig,'SelectionType');
ud = get(hFig,'UserData');
hAx = ud.hAx;
ud.Button = Button;
ud.CurrentPoint = get(hAx,'CurrentPoint');
x0 = ud.CurrentPoint(1,1);
y0 = ud.CurrentPoint(1,2);
if op=='d'
    h = ud.hDgzPts;
    ud.hMod = h;
elseif op=='h'
    h = ud.hHiPt;
else
    h = ud.hTrnPts;
    ud.hMod = h;
end
switch ud.Button
    case 'normal' %Move
        %check if it is alredy highlighted
        if ~isempty(get(ud.hHiPt,'Xdata')) && (op=='h')
            setptr(hFig,'circle');
            set(hFig,'WindowButtonMotionFcn', ...
                'digitize(''BtnMotion'')',...
                'WindowButtonUpFcn', ...
                'digitize(''BtnUp'')')
        else
            clean
        end %if
    
    case 'open' %select
        %check if it is alredy highlighted
        if isempty(get(ud.hHiPt,'Xdata'))
            x = get(h,'Xdata');
            y = get(h,'Ydata');
            [dummy,indMove] = min(sqrt((x0-x).^2 + (y0-y).^2));
            marker = get(h,'Marker');
            ud.indMove = indMove;
            if strcmpi(marker,'.')
                marker = 'o';
            end
            markersize = get(h,'MarkerSize');
            color = get(h,'Color');
            markeredgecolor = get(h,'MarkerEdgeColor');
            markerfacecolor = get(h,'MarkerFaceColor');
            set(ud.hHiPt,'Parent',hAx, ...
                'Xdata',x(indMove),'Ydata',y(indMove), ...
                'Color',color,'Marker',marker, ...
                'MarkerSize',markersize, ...
                'MarkerEdgeColor',markeredgecolor, ...
                'MarkerFaceColor',markerfacecolor, ...
                'Visible','On','Selected','On');
            %Now bring hHiPt to the front
			chldrn = get(hAx,'Children');
			chldrn(chldrn == ud.hHiPt) = [];
			chldrn = [ud.hHiPt; chldrn(:)];
			set(hAx,'Children',chldrn)
        end %if
end %switch
set(hFig,'UserData',ud)
return

%----------------------------------------
function BtnMotion
hFig = gcbf;
ud = get(hFig,'UserData');
hAx = ud.hAx; 
LastPoint = ud.CurrentPoint;
CurrentPoint = get(hAx,'CurrentPoint');
if strcmpi(ud.Button,'normal') && ~isempty(ud.hMod)
    xb = get(ud.hMod,'Xdata');
    yb = get(ud.hMod,'Ydata');
    xb(ud.indMove) = CurrentPoint(1,1);
    yb(ud.indMove) = CurrentPoint(1,2);
    set(ud.hMod,'Xdata',xb,'Ydata',yb)
    set(ud.hHiPt,'Xdata',CurrentPoint(1,1), ...
        'Ydata',CurrentPoint(1,2))
end %if
ud.CurrentPoint = CurrentPoint;
set(hFig,'UserData',ud)
return

%-----------------------------------------------------------
function BtnUp
hFig = gcbf;
setptr(hFig,'arrow');
set(hFig,'WindowButtonMotionFcn','',...
    'WindowButtonUpFcn','');
ud = get(hFig,'UserData');
set(ud.hHiPt,'Xdata',[],'Ydata',[])
if strcmpi(get(ud.hRDC,'Checked'),'On')
    jt = get(ud.hTrnPts,'XData');
    kt = get(ud.hTrnPts,'YData');
    ud.R = jkxy2R(jt,kt,ud.xt,ud.yt,ud.order);
    jd = get(ud.hDgzPts,'XData');
    kd = get(ud.hDgzPts,'YData');
    if ~isempty(jd)
        [ud.xd,ud.yd] = jk2xy(jd,kd,ud.R,ud.order);
    end
end
ud.hMod = [];
ud.indMove = [];
set(hFig,'UserData',ud)
return

%----------------------------------------------------------
function clean
hFig = gcbf;
ud = get(hFig,'UserData');
hAx = ud.hAx;
setptr(hFig,'arrow')
set(hFig,'WindowButtonMotionFcn','', ...
    'WindowButtonUpFcn','', ...
    'WindowButtonDownFcn','')
ud.hMod = [];
ud.indMove = [];
set(ud.hHiPt,'Xdata',[],'Ydata',[])
set(hFig,'UserData',ud)
return

%---------------------------------------------------------
function ExpTrnsMat
hFig = gcbf;
ud = get(hFig,'UserData');
assignin('base','R',ud.R)
return

%----------------------------------------------------------
function DeleteAllPts
hFig = gcbf;
ud = get(hFig,'UserData');
nowork = isempty(ud.xd);
if nowork
   return 
end
button = questdlg('Digitized Points will be erased. Continue?',...
    'Warning','Yes','No','Yes');
if strcmpi(button,'No')
    return
end
ud.xd = [];
ud.yd = [];
set(ud.hDgzPts,'Xdata',[],'Ydata',[])
ud.index = [];
set(hFig,'UserData',ud)
return

%---------------------------------------------------------
function LoadSession
hFig = gcbf;
ud = get(hFig,'UserData');
[fname,fpath] = uigetfile('*.mat','Select a Session:');
if ~any(fname)
    return
end
fullname = [fpath,fname]; %session name
load(fullname) %xt yt xd yd R ImgFileName
if exist(ImgFileName,'file')~=2
    hw = msgbox('Invalid file name or file does not exist','DIGITIZE','error');
    uiwait(hw)
    drawnow
    [ipath,iname,ext] = fileparts(ImgFileName);
    [iname,ipath] = uigetfile('*.*','Locate Image-File:',[iname,ext]);
    if ~any(iname)
        return
    end
    if isempty(ipath)
        ipath = [cd,filesep];
    end
    ImgFileName = [ipath,iname]; %change image file name
    if exist(ImgFileName,'file')~=2
        errordlg('Invalid file name or file does not exist','DIGITIZE')
    end
    save(fullname,'ImgFileName','jt','kt', ...
        'jd','kd','xt','yt','xd','yd','R')
    hw = msgbox('ImgFileName updated','DIGITIZE');
    uiwait(hw)
end 
ud.ImgFileName = ImgFileName;
set(hFig,'UserData',ud)
LoadImageSession(fullname)
set(ud.hTrnPts,'Xdata',jt,'Ydata',kt)
set(ud.hDgzPts,'Xdata',jd,'Ydata',kd)
ud.xt = xt;
ud.yt = yt;
ud.xd = xd;
ud.yd = yd;
ud.R = R;
set(ud.hRDC,'Checked','On')
set(ud.hRes,'Enable','On','Checked','Off')
set(ud.hPix,'Enable','On')
if ~isempty(xd)
   set([ud.hDltDgzPts,ud.hDltAllDgzPts, ...
            ud.hDgzNumPts,ud.hCntPts],'Enable','On')
end
set(hFig,'UserData',ud)
hw = msgbox('Session Loaded Successfully','DIGITIZE');
uiwait(hw)
return

%-----------------------------------------
function HiRefPts
hFig = gcbf;
ud = get(hFig,'UserData');
chck = get(ud.hHRP,'Checked');
if strcmpi(chck,'On')
    set(ud.hHRP,'Checked','Off');
    set(ud.hHiPt,'Visible','Off')
    return
end
set(ud.hHRP,'Checked','On')
jt = get(ud.hTrnPts,'Xdata');
kt = get(ud.hTrnPts,'Ydata');
xt = ud.xt;
ind = isfinite(xt);
marker = get(ud.hTrnPts,'Marker');
if strcmpi(marker,'.')
    marker = 'o';
end
markersize = get(ud.hTrnPts,'MarkerSize');
markeredgecolor = get(ud.hTrnPts,'MarkerEdgeColor');
markerfacecolor = get(ud.hTrnPts,'MarkerFaceColor');
set(ud.hHiPt,'Xdata',jt(ind),'Ydata',kt(ind), ...
    'Color','c','Marker',marker, ...
    'MarkerSize',markersize, ...
    'MarkerEdgeColor',markeredgecolor, ...
    'MarkerFaceColor',markerfacecolor, ...
    'Visible','On','Selected','Off');
%Now bring hHiPt to the front
chldrn = get(ud.hAx,'Children');
chldrn(chldrn == ud.hHiPt) = [];
chldrn = [ud.hHiPt; chldrn(:)];
set(ud.hAx,'Children',chldrn)
return

%-----------------------------------------
function Residuals
hFig = gcbf;
ud = get(hFig,'UserData');
chck = get(ud.hRes,'Checked');
if strcmpi(chck,'On')
    set(ud.hRes,'Checked','Off');
    set(ud.hResTxt,'Visible','Off')
    return
end
set(ud.hRes,'Checked','On')
jt = get(ud.hTrnPts,'Xdata');
kt = get(ud.hTrnPts,'Ydata');
[xc,yc] = jk2xy(jt,kt,ud.R,ud.order);
rx = ud.xt(:) - xc; %Residuals
ry = ud.yt(:) - yc;
%Make Labels
for c=1:length(rx)
    rtxt = strvcat(['res-x: ',num2str(rx(c))],...
        ['res-y: ',num2str(ry(c))]);
    ud.hResTxt(c) = text(jt(c),kt(c),rtxt, ...
        'BackgroundColor','W','EdgeColor','k', ...
        'HorizontalAlignment','Left','Visible','On', ...
        'VerticalAlignment','Bottom','Color','k');
end
set(hFig,'UserData',ud)
return

%------------------------------------------------------------------
function PixcelSize
hFig = gcbf;
ud = get(hFig,'UserData');
j = [0;1];
k = [0;1];
onez = ones(2,1);
switch ud.order
    case 1
        jk = [j, k, onez];
    case 2
        jk = [j, k, j.^2, k.^2, j.*k, onez];
    case 3
        jk = [j, k, j.^2, k.^2, j.*k, j.^3, k.^3, j.^2.*k, j.*k.^2, onez];
end
PixSize = jk*ud.R;
PixSize = diff(PixSize,1,1);
PixSize = abs(PixSize(1:2));
msgbox(['The approximate pixcel size of the image is: [',...
    num2str(PixSize(1)),'x',...
    num2str(PixSize(2)),']'],'DIGITIZE')
return

%------------------------------------------------------------------
function UIOrder
hFig = gcbf;
ud = get(hFig,'UserData');
order = num2str(ud.order);
neworder = inputdlg('Order of Fit:','DIGITIZE',[1,30],{order});
if isempty(neworder)
    return
end
ud.order = str2double(neworder);
jt = get(ud.hTrnPts,'XData');
kt = get(ud.hTrnPts,'YData');
op = get(ud.hRDC,'Checked');
if length(jt)>2 && strcmpi(op,'On')
    [ud.R,ud.order] = jkxy2R(jt,kt,ud.xt,ud.yt,ud.order);
    jd = get(ud.hDgzPts,'XData');
    kd = get(ud.hDgzPts,'YData');
    if ~isempty(jd)
        [ud.xd,ud.yd] = jk2xy(jd,kd,ud.R,ud.order);
    end
end
set(hFig,'UserData',ud)
return

%-----------------------------------------------------------------
function NumberPoints
hFig = gcbf;
ud = get(hFig,'UserData');
chck = get(ud.hDgzNumPts,'Checked');
if strcmpi(chck,'On')
    set(ud.hDgzNumPts,'Checked','Off');
    set(ud.hNumPts,'Visible','Off')
    return
end
set(ud.hDgzNumPts,'Checked','On');
x = get(ud.hDgzPts,'Xdata');
y = get(ud.hDgzPts,'Ydata');
color = get(ud.hDgzPts,'Color');
Numbers = num2str((1:length(x))');
ud.hNumPts = text(x,y,Numbers,'HorizontalAlignment','Left', ...
    'VerticalAlignment','Bottom','Color',color,'FontSize',14);
set(hFig,'UserData',ud)
return

%------------------------------------------------------------------
function [x,y] = jk2xy(j,k,R,order)
j = j(:);
k = k(:);
n = length(j);
onez = ones(n,1);
switch order
    case 1
        jk = [j, k, onez];
    case 2
        jk = [j, k, j.^2, k.^2, j.*k, onez];
    case 3
        jk = [j, k, j.^2, k.^2, j.*k, j.^3, k.^3, j.^2.*k, j.*k.^2, onez];   
end %switch
xy = jk*R;
x = xy(:,1);
y = xy(:,2);
return

%----------------------------------------------------------------
function [R,order] = jkxy2R(j,k,x,y,order)
j = j(:);
k = k(:);
x = x(:);
y = y(:);
n = length(x);
onez = ones(n,1);
while 1
    switch order
        case 1
            if n<3
                R = [];
                warndlg('Not Enough Reference Points','DIGITIZE')
                return
            end
            A = [j, k, onez];
            B = [x, y, onez];
            break
        case 2
            if n<6
                s = char('Not Enough Reference Points.', ...
                    'Reducing Order of Fit.');
                warndlg(s,'DIGITIZE')
                order = 1;
                continue
            end
            A = [j, k, j.^2, k.^2, j.*k, onez];
            B = [x, y, x.^2, y.^2, x.*y, onez];
            break
        case 3
            if n<10
                s = char('Not Enough Reference Points.', ...
                    'Reducing Order of Fit.');
                warndlg(s,'DIGITIZE')
                if n<6
                    order = 1;
                else
                    order = 2;
                end
                continue
            end
            A = [j, k, j.^2, k.^2, j.*k, j.^3, k.^3, j.^2.*k, j.*k.^2, onez];
            B = [x, y, x.^2, y.^2, x.*y, x.^3, y.^3, x.^2.*y, x.*y.^2, onez];
            break
        otherwise
            s = char('Maximum Order is 3.', ...
                    'Reducing Order ...');
            warndlg(s,'DIGITIZE')
            order = 3;
    end %switch
end %while
R = A\B; %Left Division
R(1:end-1,3) = 0; %force these values
R(end,end) = 1;
return

%-----------------------------------------------------------------------
function ConnectPts
hFig = gcbf;
ud = get(hFig,'UserData');
j = get(ud.hDgzPts,'XData');
k = get(ud.hDgzPts,'YData');
chk = get(ud.hCntPts,'Checked');
if strcmpi(chk,'On')
    index = ud.index;
    [dummy,newindex] = sort(index);
    n = length(newindex);
    j(1:n) = j(newindex);
    k(1:n) = k(newindex);
    ud.xd(1:n) = ud.xd(newindex);
    ud.yd(1:n) = ud.yd(newindex);
    set(ud.hCntPts,'Checked','Off')
    set(ud.hDgzPts,'XData',j,'YData',k,'LineStyle','None')
else % strcmpi(chk,'Off')
    if isempty(ud.index)
        j = j(:);
        k = k(:);
        n = size(j,1);
        ik = 1; %Index of Starting Point
        ind = true(n,1); %logicals
        f = false(1);
        ind(ik) = f;
        index = NaN*ones(n,1);
        index(1) = ik;
        %Initialize 1/distances
        d = zeros(n,1);
        %The algorithm is made much faster by
        %only calculating d for the remaining
        %points of the line
        for c=2:n
            d(ind) = 1./sqrt((j(ik)-j(ind)).^2 ...
                + (k(ik)-k(ind)).^2);
            [dummy,ik] = max(d);
            ind(ik) = f; %elimates past points
            d(ik) = 0; %elimates past points
            index(c) = ik; %update final index
        end
        ud.index = index; %saves the sorted index
    end
    n = length(ud.index);
    j(1:n) = j(ud.index);
    k(1:n) = k(ud.index);
    ud.xd(1:n) = ud.xd(ud.index);
    ud.yd(1:n) = ud.yd(ud.index);
    set(ud.hDgzPts,'XData',j,'YData',k,'LineStyle','-');
    set(ud.hCntPts,'Checked','On')
end
set(hFig,'UserData',ud)
return



