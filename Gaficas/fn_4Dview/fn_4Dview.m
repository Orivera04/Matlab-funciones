function fn_4Dview(varargin)
% function fn_4Dview(option,optionArgs,...)
%---
% displays spatial or temporal slices of multi-dimensional data
% by default: data is considered to be 3D, 4D or 5D (dimensions ordered as
% x-y-z-t-m) and is displayed as 3 spatial sections at a given time point
% use option flags for other display types
%
% type 'fn_4Dview demo' to see a demo
%
% Input:
% - option..        string - specify an option (see below)
% - optionArgs..    argument of option
%
% Options:
% DATA
% - 'data',data     array, by default, dimensions should be x - y - z - t - m 
%                   (m is used for 'multiple data')   
%                   [the 'data' flag can be omitted]
%                   [default: data=0 or zeros(appropriate size)]
% - 'options',{options}     some display types allow additional options like 
%                   'plot' -> same option possibilities as the Matlab plot function, 
%                   'quiver'...     
%                   [the 'options' flag can be omitted] [default: {}]
% TYPE OF DISPLAY
% - 'space'         data will be displayed spatially, at a given time point [default]
% - 'plot'          data will be plotted against time, at a given space point
% - '3d'            data is three-dimensional (dimensions are x - y - z - t - m)
%                   and will be spatially displayed as three cross sections
%                   [default]
% - '2d'            data is two-dimensional (dimensions are x - y - t - m)
%                   and will be spatially displayed as a single image 
% - '0d',tidx       no data required (implies plot options)
%                   then, give plot instructions inside a cell array (see
%                   'options')
% - 'quiver'        data is a 2D vector field, plus possibly 2D image
%                   (dimensions are x - y - t - [2 vector components +
%                   image component])
%                   this is only applicable for spatial display
% - 'mesh',mesh     data is one-dimensional (dimensions are i - t - m),
%                   where i refers to the ith vertex of a 3D mesh specified
%                   as a cell array or struct following the 'mesh' flag 
%                   {[3 x nv vertices],[3 x nt triangles]}
% - 'ind',indices   data is one-dimensional (dimensions are i - t - m),  
%                   indices is a 2D or 3D image which entails indices of
%                   the first data component (see example)
%                   this is only applicable for temporal display
% - 'timeslider',tidx   creates a slider control to move in time array tidx
% BEHAVIOR
% - 'active'        allows callbacks (e.g. selecting point with mouse) [default]
% - 'passive'       disallows callbacks
% - 'key',k         use this to have independent links between windows
%                   [default: all windows are linked using same key k=1]
% DATA TRANSFORM
% - 'mat',M         defines a spatial linear transformation between
%                   data and world coordinates [default = eye(4)]
% - 'tidx',tidx     defines sampling points time coordinates [default = 1:#times]
%                   it is necessary that they are equally spaced
% - 'heeginv',H     provides a matrix to multiply data with before using it
%                   this is only applicable for spatial mesh display
% - 'applyfun',fun  function handler or {function handler, additional arguments, ...}
%                   data will be transformed according to fun before every
%                   display - NOT IMPLEMENTED YET
% MISCELLANEOUS
% - 'in',handle     forces display in figure or axes specified by handle
%                   [the 'in' flag can be ommited] 
%                   [default: in active figure or axes]
% - 'fifth',f       if data has a 'multiple data' component (dimension m is
%                   non-singleton), specifies which one to use for spatial
%                   display [default: f=1]
% - 'clip',[m M]    specify a clipping for image display
%
%------
% Thomas Deneux
% last modification: 09/01/2007


if nargin==1 && strcmp(varargin{1},'demo')
    demo
    return
end

if nargin>0 && ischar(varargin{1})
    a = varargin{1};
    switch lower(a)
        case 'changexyz'
            ChangeXYZ(varargin{2},varargin{3}), return
        case 'changet'
            ChangeT(varargin{2},varargin{3}), return
    end
end

Init(varargin{:});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INIT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Init(varargin)

if nargin==0, help fn_4Dview, return, end
indarg=1;

%-------
% Input
%-------

% Options
type='3d'; show='space'; data=0; options={};
Heeginv=[]; in=[]; key=1; mat=[]; fifth=1; tidx=[]; active=true; ind=[]; mesh=[]; clip={};
while indarg<=nargin
    flag = varargin{indarg};
    if isfigoraxeshandle(flag), flag='in';
    elseif iscell(flag), flag='options';
    elseif isnumeric(flag), flag='data';
    elseif ischar(flag), indarg=indarg+1;
    else error('argument error')
    end
    flag = lower(flag);
    switch flag
        case 'data'
            data = varargin{indarg};
            indarg = indarg+1;
        case 'options'
            options = varargin{indarg};
            indarg = indarg+1;
        case 'space'
            show = 'space';
        case {'plot','time'}
            show = 'time';
        case '2dplot'
            type = '2d';
            show = 'time';
        case '0d'
            type = '0d';
            show = 'time';
            tidx = varargin{indarg};            
            indarg = indarg+1;
        case {'2d','3d'}
            type = flag;
        case 'quiver'
            type = 'quiver';
            data = varargin{indarg};
            indarg = indarg+1;
            nt = size(data,3);
            while indarg<=nargin && all(size(varargin{indarg})>1) % 2D or more array
                data2 = varargin{indarg};
                indarg = indarg+1;
                nt2 = size(data2,3);
                if nt2>1 && nt==1, data = repmat(data,[1 1 nt2]); end
                if nt>1 && nt2==1, data2 = repmat(data2,[1 1 nt]); end
                try data = cat(4,data,data2); catch error('quiver data: dimensions are incommensurate'), end
            end
        case 'mesh'
            if iscell(varargin{indarg})
                mesh = varargin{indarg};
                indarg = indarg+1;
            elseif isstruct(varargin{indarg})
                mesh = varargin{indarg};
                mesh = {mesh.vertices,mesh.faces};
                indarg = indarg+1;
            else
                mesh = {varargin{indarg},varargin{indarg+1}};
                indarg = indarg+2;
            end
            if size(mesh{1},1)~=3, mesh{1}=mesh{1}'; end
            if size(mesh{2},1)~=3, mesh{2}=mesh{2}'; end
            type = 'mesh';
        case 'ind'
            ind = varargin{indarg};
            indarg = indarg+1;
            type = 'indices';
        case 'timeslider'
            show = 'time';
            type = 'timeslider';
            tidx = varargin{indarg};
            indarg = indarg+1;
        case {'active','passive'}
            active =  strcmp(flag,'active');
        case 'key'
            key = varargin{indarg};
            indarg = indarg+1;
        case 'tidx'
            tidx = varargin{indarg};            
            indarg = indarg+1;
        case 'mat' 
            mat = varargin{indarg};
            indarg = indarg+1;
            switch num2str(size(mat),'%1i')
                case '44'
                case {'34','33'}
                    mat(4,4) = 1;
                case {'13','31'}
                    mat = [eye(3) mat(:) ; 0 0 0 1];
                otherwise
                    error('wrong size for rotation/translation matrix')
            end
        case 'heeginv'
            Heeginv = varargin{indarg};
            indarg = indarg+1;
        case 'in'
            in = varargin{indarg}; 
            indarg = indarg+1; 
        case {'5th','fifth'}
            fifth = varargin{indarg};
            indarg = indarg+1;
        case 'clip'
            clip = {varargin{indarg}};
            indarg = indarg+1;            
        otherwise
            error(['unknown option: ' flag])
    end
end

% Sizes
sizes = [];
switch type
    case '0d' 
        if strcmp(show,'space'), error('no spatial display of temporal only data allowed'); end
        % this variable data will be ignored... the only data goes in the options 
        data = [];
        if isempty(tidx), error('0d flag requires tidx to be defined'), end
    case '2d' 
        % data dimensions should be ordered as: x-y-t-m -> transform into x-t-m
        sizes = size(data); sizes(end+1:4)=1;
        data = reshape(data,[prod(sizes(1:2)) sizes(3:4)]);
    case '3d'
        % data dimensions should be ordered as: x-y-z-t-m -> transform into x-t-m
        sizes = size(data); sizes(end+1:5)=1;
        data = reshape(data,[prod(sizes(1:3)) sizes(4:5)]);
    case 'quiver'
        if strcmp(show,'time'), error('no plot of quiver data allowed'); end
        % data dimensions should be ordered as: x-y-t-m and there may be several arguments
        % to be concatenated along 4th dimension -> transform into x-t-m
        sizes = size(data); sizes(end+1:4) = 1;
        if ~ismember(sizes(4),[2 3]), error('quiver: not enough data'), end
        data = reshape(data,[prod(sizes(1:2)) sizes(3:4)]);
    case 'mesh'
        % data dimensions should be ordered as: x-t-m
        sizes = size(data); 
        % no data given
        if all(sizes==1), data = zeros(size(mesh{1},2),1); sizes = size(data); end
        if isempty(Heeginv), scomp=sizes(1); else scomp=length(Heeginv*data(:,1)); end
        if scomp~=size(mesh{1},2), error('mesh: data dimension does not match number of vertices'), end
    case 'indices'
        if strcmp(show,'space'), error('no image or section display of indexed data allowed'); end
        % data dimensions should be ordered as: x-t-m
        nind = size(data,1);
        sizes = size(ind); sizes(end+1:3) = 1;
        maxind = max(ind(:));
        if maxind~=nind, disp('attention: maximum indice does not match data dimension'), end
    case 'timeslider'
        if strcmp(show,'space'), error('no image or section display of indexed data allowed'); end
        data = data(:)';
        sizes = length(data);
    otherwise 
        error programmation
end

%-------------------
% Other definitions
%-------------------

% Time indices
nt = size(data,2);
if ~isempty(tidx)
    if length(tidx)~=nt && ~ismember(type,{'0d','timeslider'}), error('length of tidx and data are incommensurate'), end
    if any(abs(diff(diff(tidx)))>1e-7), error('tidx: time points must be equally spaced'), end
else
    if strcmp(type,'timeslider')
        tidx = data;
    else
        tidx = 1:nt;
    end
end

% Figure / axes and object handle
if isempty(in) && strcmp(type,'timeslider')
    in = figure('visible','off');
end
if in
    if ishandle(in), df = get(in,'DeleteFcn'); try feval(df{:}), catch end, end
    if (in>0 && mod(in,1)==0) || strcmp(get(in,'type'),'figure')
        figure(in), clf reset
    elseif ishandle(in) && strcmp(get(in,'type'),'axes')
        axes(in), cla reset
    else
        error('a scalar first argument should be a figure or axes handle')
    end
end
switch show
    case 'time'
        switch type
            case 'timeslider'
                hobj = gcf;
            otherwise
                hobj = gca; cla
        end
    case 'space'
        switch type
            case {'2d','quiver'}
                hobj = gca; cla
            case {'mesh','3d'}
                hobj = gcf; clf
        end
end
if strcmp(get(hobj,'type'),'axes'), hf = get(hobj,'parent'); else hf = hobj; end
% enlever les trucs chiants de la fenetre utilis�e
set(hf,'WindowButtonDownFcn','','ResizeFcn','','WindowButtonMotionFcn','','Tag','');
%f = fieldnames(getappdata(hf)); for i=1:length(f), rmappdata(hf,f{i}); end

%---------------------------
% Graphical object settings
%---------------------------

info = struct('key',key,'show',show,'type',type,'data',data,'active',active, ...
    'sizes',sizes,'nind',size(data,1),'nt',size(data,2),'ncomp',size(data,3), ...
    'ind',ind,'mesh',{mesh},'xyzt',[0 0 0 0], ...
    'fifth',fifth,'tidx',tidx,'mat',mat,'options',{options},'heeginv',Heeginv, 'clip', {clip}, ...
    'idx',[],'frame',[],'indselection',{{}},'timeselection',{{}});
setappdata(hobj,'UserData',info)

% Tag (protection against fn_imvalue and enables link search)
set(hobj,'Tag','fn_4Dview')
if strcmp(get(hobj,'type'),'axes'), set(hf,'Tag','used by fn_4Dview'), end

% Figure display and callbacks
switch show
    case 'time'
        switch type
            case 'timeslider'
                InitTimeSlider(hobj)
            otherwise
                InitPlotAxes(hobj)
        end
    case 'space'
        switch type
            case '2d'
                Init2DAxes(hobj)
            case 'quiver'
                InitQuiverAxes(hobj)
            case '3d'
                Init3DFigure(hobj)
            case 'mesh'
                InitMeshFigure(hobj)
        end
end

% Update cursor position (TODO: zoom)
set(hobj,'Tag','')
xyzt = GetXYZT(key);
Update(hobj,xyzt)
set(hobj,'Tag','fn_4Dview')

% % display
% set(hf,'Tag','fn_4Dview_passive') % prevents fn_imvalue callbacks
% if ~strcmp(action,'userdefine'), set(ha,'NextPlot','replace'), end
% Display(hobj)
% 
% % set tag, replacechildren, callback, oldaxis
% set(hobj,'Tag','fn_4Dview') % allow LinkedT or LinkedXYZ to look for information in hobj
% set(ha,'NextPlot','replacechildren')
% for h=ha, setappdata(h,'oldaxis',axis(h)), end
% if ~strcmp(action,'plot') && ~strcmp(action,'userdefine'), set(ha,'ButtonDownFcn',{@fn_4Dview,action}), end
% if strcmp(action,'activeplot'), set(get(ha,'parent'),'KeyPressFcn',{@fn_4Dview,[action '_key']}), end


%---------------------------------------------------------------------
function Init2DAxes(ha)

axes(ha)
set(get(ha,'Parent'),'DoubleBuffer','on')

info = getappdata(ha,'UserData');
s = info.sizes;

hi = imagesc(zeros(s(1),s(2))','Parent',ha,'hittest','off',info.clip{:});
ax = axis(ha);
hc(1) = line([0 0],[ax(3) ax(4)],'Color','white','hittest','off');
hc(2) = line([ax(1) ax(2)],[0 0],'Color','white','hittest','off');
ptext = ax([1 3]) - [0 0.03].*(ax([2 4])-ax([1 3]));
ht = text('Parent',ha,'Position',ptext,'String','text');

info.image = hi;
info.cross = hc;
info.text = ht;
info.ijk = [0 0 1];
info.frame = 0;
setappdata(ha,'oldaxis',axis(ha))
if info.active, set(ha,'ButtonDownFcn',{@CallBack,ha,'2d'}), end
setappdata(ha,'UserData',info)

%---------------------------------------------------------------------
function InitQuiverAxes(ha)

axes(ha)
set(get(ha,'Parent'),'DoubleBuffer','on')

info = getappdata(ha,'UserData');
s = info.sizes;
data = info.data;

if size(data,3)==3
    hi = imagesc(zeros(s(1),s(2))','hittest','off',info.clip{:});
    hold on
elseif size(data,3)==2
    hi = 0;
else
    error programming
end

hq = quiver(zeros(s(1),s(2)),zeros(s(1),s(2)),info.options{:});
if hi, hold off, end

ax = axis(ha);
hc(1) = line([0 0],[ax(3) ax(4)],'Color','white','hittest','off');
hc(2) = line([ax(1) ax(2)],[0 0],'Color','white','hittest','off');

info.image = hi;
info.quiver = hq;
info.cross = hc;
info.ijk = [0 0 1];
info.frame = 0;
setappdata(ha,'oldaxis',axis(ha))
if info.active, set(ha,'ButtonDownFcn',{@CallBack,ha,'2d'}), end
setappdata(ha,'UserData',info)
set(ha,'NextPlot','Add')

%---------------------------------------------------------------------
function Init3DFigure(hf)

figure(hf), clf
set(hf,'DoubleBuffer','on','KeyPressFcn','')

info = getappdata(hf,'UserData');
s = info.sizes;
sa = s(1)+s(2); sb = s(2)+s(3);
ax1 = axes('Parent',hf,'Position',[0.05 0.95-0.8*s(3)/sb 0.8*s(1)/sa 0.8*s(3)/sb]);
ax2 = axes('Parent',hf,'Position',[0.95-0.8*s(2)/sa 0.95-0.8*s(3)/sb 0.8*s(2)/sa 0.8*s(3)/sb]);
ax3 = axes('Parent',hf,'Position',[0.05 0.05 0.8*s(1)/sa 0.8*s(2)/sb]);
ax4 = axes('Parent',hf,'Position',[0.95-0.8*s(2)/sa 0.05 0.8*s(2)/sa 0.8*s(2)/sb]);
set(ax4,'visible','off')
ha = [ax1 ax2 ax3];

if info.active
    % + control [position d�finie par un vecteur de taille 6 : position
    % du centre (en % de la taille de la fenetre), puis position / au centre
    % (en pixels), puis largeur et hauteur (en pixels)]
    center = [s(1)/sa*.8+.1 .9-s(3)/sb*.8];
    hu(1) = uicontrol('parent',hf,'CallBack',{@MoveStep,hf,'controlup'},'String','|');
    setappdata(hu(1),'position',[center 20 -30 20 20]);
    hu(2) = uicontrol('parent',hf,'CallBack',{@MoveStep,hf,'controldown'},'String','|');
    setappdata(hu(2),'position',[center 20 -70 20 20]);
    hu(3) = uicontrol('parent',hf,'CallBack',{@MoveStep,hf,'controlright'},'String','-');
    setappdata(hu(3),'position',[center 0 -50 20 20]);
    hu(4) = uicontrol('parent',hf,'CallBack',{@MoveStep,hf,'controlleft'},'String','-');
    setappdata(hu(4),'position',[center 40 -50 20 20]);
    hu(5) = uicontrol('parent',hf,'CallBack',{@MoveStep,hf,'controlback'},'String','\');
    setappdata(hu(5),'position',[center 40 -70 20 20]);
    hu(6) = uicontrol('parent',hf,'CallBack',{@MoveStep,hf,'controlforward'},'String','\');
    setappdata(hu(6),'position',[center 0 -30 20 20]);
    set(hf,'ResizeFcn',{@UpdateControlPositions})
end

hi(1) = imagesc(zeros(s(3),s(1)),'parent',ax1,'hittest','off',info.clip{:}); 
hi(2) = imagesc(zeros(s(3),s(2)),'parent',ax2,'hittest','off',info.clip{:});
hi(3) = imagesc(zeros(s(2),s(1)),'parent',ax3,'hittest','off',info.clip{:});
set(ax1,'xdir','reverse','ydir','normal')
set(ax2,'xdir','reverse','ydir','normal')
set(ax3,'xdir','reverse','ydir','normal')

x = 0; y = 0; z = 0;
ax = axis(ha(1)); 
hc(1) = line([x x],[ax(3) ax(4)],'Parent',ha(1),'Color','white','hittest','off');
hc(2) = line([ax(1) ax(2)],[z z],'Parent',ha(1),'Color','white','hittest','off');
ax = axis(ha(2));
hc(3) = line([y y],[ax(3) ax(4)],'Parent',ha(2),'Color','white','hittest','off');
hc(4) = line([ax(1) ax(2)],[z z],'Parent',ha(2),'Color','white','hittest','off');
ax = axis(ha(3));
hc(5) = line([x x],[ax(3) ax(4)],'Parent',ha(3),'Color','white','hittest','off');
hc(6) = line([ax(1) ax(2)],[y y],'Parent',ha(3),'Color','white','hittest','off');

ht(1) = text('Parent',ax4,'Position',[.5 .5],'HorizontalAlignment','center','String','text');
ht(2) = text('Parent',ax4,'Position',[.5 .6],'HorizontalAlignment','center','String','text');

info.axes = [ax1 ax2 ax3 ax4];
info.controls = hu;
info.images = hi;
info.cross = hc;
info.text = ht;
info.ijk = [0 0 0];
info.frame = 0;
setappdata(hf,'UserData',info)
UpdateControlPositions(hf)
setappdata(ax1,'oldaxis',axis(ax1))
setappdata(ax2,'oldaxis',axis(ax2))
setappdata(ax3,'oldaxis',axis(ax3))
if info.active
    set(ax1,'ButtonDownFcn',{@CallBack,hf,'3d1'})
    set(ax2,'ButtonDownFcn',{@CallBack,hf,'3d2'})
    set(ax3,'ButtonDownFcn',{@CallBack,hf,'3d3'})
end

%---------------------------------------------------------------------
function UpdateControlPositions(varargin)

hf = varargin{1};
s = get(hf,'Position'); 
s = s([3 4]);
hlist = findobj(hf,'type','uicontrol');
for hu = hlist(:)'
    position = getappdata(hu,'position');
    if isempty(position), continue, end
    set(hu,'position',[s(1)*position(1)+position(3) s(2)*position(2)+position(4) position(5:6)])
end

%---------------------------------------------------------------------
function DeleteControl(dum1,dum2,hu)

if nargin<3, hu=dum1; end
try delete(hu), catch end

%---------------------------------------------------------------------
function InitMeshFigure(hf)

figure(hf), clf
set(hf,'DoubleBuffer','on','KeyPressFcn','')

ha = gca;
info = getappdata(hf,'UserData');
mesh = info.mesh;
[vertex faces] = deal(mesh{:});
nvertex = size(vertex,2);
vcolor=ones(nvertex,1);

% TODO: changer pour rapidit�
ho=patch('Vertices',vertex','Faces',faces','FaceVertexCdata',vcolor,...
    'LineStyle','-',...
    'CDataMapping','scaled','FaceColor','flat',...
    'AmbientStrength', 0.6, 'FaceLighting', 'flat',...
    'HitTest','off');

cameratoolbar
camorbit(0,-90)
axis equal
% camorbit(-135,0)
% camlight
% camorbit(180,0)
% camlight

x = vertex(1,1); y = vertex(2,1); z = vertex(3,1);  
hc(1) = line(x,y,z,'Marker','*','Color','white','LineWidth',3,'HitTest','off');
hc(2) = line(x,y,z,'Marker','o','Color','red','LineWidth',3,'MarkerSize',12,'HitTest','off');

ht = uicontrol('style','text','position',[5 5 180 15],'string','text','HorizontalAlignment','left');

info.object = ho;
info.cross = hc;
info.text = ht;
info.idx = 1;
info.frame = 0;
set(ha,'ButtonDownFcn',{@CallBack,hf,'mesh'})
setappdata(hf,'UserData',info)

%---------------------------------------------------------------------
function InitPlotAxes(ha)

info = getappdata(ha,'UserData');
info.curaxis = [];
info.idx = 0;
set(ha,'ButtonDownFcn',{@CallBack,ha,'plot'},'NextPlot','ReplaceChildren')
hf = get(ha,'parent');
pos = get(ha,'position');
hu(1) = uicontrol('parent',hf,'CallBack',{@MoveStep,ha,'timeleft'},'String','<');
setappdata(hu(1),'position',[pos(1) pos(2) -20 -20 20 20]);
hu(2) = uicontrol('parent',hf,'CallBack',{@MoveStep,ha,'timeright'},'String','>');
setappdata(hu(2),'position',[pos(1)+pos(3) pos(2) 0 -20 20 20]);
hu(3) = uicontrol('parent',hf,'CallBack',{@MoveStep,ha,'windowleft'},'String','<<');
setappdata(hu(3),'position',[pos(1) pos(2) -40 -20 20 20]);
hu(4) = uicontrol('parent',hf,'CallBack',{@MoveStep,ha,'windowright'},'String','>>');
setappdata(hu(4),'position',[pos(1)+pos(3) pos(2) 20 -20 20 20]);
%set(hf,'KeyPressFcn',{@MoveStep,ha,'keyboard'}, ...
%    'ResizeFcn',{@UpdateControlPositions},'DoubleBuffer','on')
set(hf,'ResizeFcn',{@UpdateControlPositions},'DoubleBuffer','on')
set(ha,'DeleteFcn',{@DeleteControl,hu})
UpdateControlPositions(hf)
setappdata(ha,'UserData',info);

%---------------------------------------------------------------------
function InitTimeSlider(hf)

info = getappdata(hf,'UserData');

set(hf,'position',[800 500 300 45],'menubar','none', ...
    'name','Time control','visible','on')
m = info.tidx(1); M = info.tidx(end); n = length(info.tidx);
info.slider = uicontrol('style','slider','position',[5 5 290 20], ...
    'Min',m,'Max',M,'SliderStep',[1/(n-1) 1/15],'Value',(m+M)/2, ...
    'CallBack',{@SliderCallback,hf});
info.text = uicontrol('style','text','position',[100 30 100 10],'String','text');
info.roundbutton = uicontrol('position',[230 27 20 15],'String','r', ...
    'CallBack',{@SliderCallback,hf});

setappdata(hf,'UserData',info);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DISPLAY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Update(hobj,xyzt)

info = getappdata(hobj,'UserData');
switch info.show
    case 'time'
        switch info.type
            case 'timeslider'
                UpdateTimeSlider(hobj,xyzt)
            otherwise
                UpdatePlot(hobj,xyzt)
        end
    case 'space'
        switch info.type
            case '2d'
                Update2D(hobj,xyzt)
            case '3d'
                try
                    Update3D(hobj,xyzt)
                catch % figure a �t� abim�e ? on tente de la reconstruire
                    Init3DFigure(hobj)
                    Update3D(hobj,xyzt)
                end
            case 'quiver'
                UpdateQuiver(hobj,xyzt)
            case 'mesh'
                try
                    UpdateMesh(hobj,xyzt)
                catch % figure a �t� abim�e ? on tente de la reconstruire
                    InitMeshFigure(hobj)
                    UpdateMesh(hobj,xyzt)
                end             
        end
end

%---------------------------------------------------------------------
function Update2D(hobj,xyzt)

info = getappdata(hobj,'UserData');
info.xyzt = xyzt;
oldframe = info.frame;
if isempty(info.timeselection)
    info.frame = World2Frame(hobj,xyzt);
else
    info.frame = -1;
end
[ind ijk] = World2Ind(hobj,xyzt);
oldijk = info.ijk;
info.ijk = ijk(:)';
setappdata(hobj,'UserData',info)

% redraw image if info.frame changed (info.frame = -1 if there is a current
% time points selection for averaging)
if info.frame~=oldframe 
    if isempty(info.timeselection)
        frames = info.frame;
    else
        frames = TSel2Frame(hobj,info.timeselection);
    end
    im = info.data(:,frames,info.fifth);
    im = mean(im,2);
    im = reshape(im,info.sizes(1:2));
    % make the image available in base workspace
    setappdata(hobj,'currentdisplay',im);
    if ~isempty(info.indselection)
        if isempty(info.clip)
            m = min(im(:));
            M = max(im(:));
        else
            m = info.clip{1}(1);
            M = info.clip{1}(2);
        end
        grey = max(0,min(1,(im(:)-m)/(M-m)));
        im = repmat(grey,1,3);
        
        colors = colorset;
        ncolors = size(colors,1);
        
        for i=1:length(info.indselection)        
            indsel = info.indselection{i};
        
            % l'image a l'interieur de la zone est 'filtree' en tenant
            % compte du code couleur
            for j=1:3
                im(indsel,j) = (2*im(indsel,j) + colors(mod(i-1,ncolors)+1,j))/3;
            end
        end
        
        im = reshape(im,[info.sizes(1:2) 3]);
    end
    set(info.image,'CData',permute(im,[2 1 3]))
end

% redraw cross
if any(info.ijk~=oldijk) 
    set(info.cross(1),'XData',ijk([1 1]))
    set(info.cross(2),'YData',ijk([2 2]))
end

% redraw value
rijk = min(max(round(ijk(1:2)),[1 1]'),info.sizes(1:2)');
im = get(info.image,'CData');
set(info.text,'String',['val(' num2str(rijk(1)) ',' num2str(rijk(2)) ')=' num2str(im(rijk(2),rijk(1)))])

%---------------------------------------------------------------------
function UpdateQuiver(hobj,xyzt)

sf = gcf;

info = getappdata(hobj,'UserData');
info.xyzt = xyzt;
oldframe = info.frame;
info.frame = World2Frame(hobj,xyzt);
[ind ijk] = World2Ind(hobj,xyzt);
info.ijk = ijk(:)';
setappdata(hobj,'UserData',info)

if info.frame~=oldframe
    if info.image
        im = reshape(info.data(:,info.frame,3),info.sizes(1:2));
        set(info.image,'CData',im')
    end
    
    delete(info.quiver)
    a = reshape(info.data(:,info.frame,1),info.sizes(1:2));
    b = reshape(info.data(:,info.frame,2),info.sizes(1:2));
    axes(hobj)
    info.quiver = quiver(a,b,info.options{:});
    set(info.quiver,'hittest','off')
    setappdata(hobj,'UserData',info)
end

set(info.cross(1),'XData',ijk([1 1]))
set(info.cross(2),'YData',ijk([2 2]))

figure(sf)

%---------------------------------------------------------------------
function Update3D(hobj,xyzt)

info = getappdata(hobj,'UserData');
info.xyzt = xyzt;
info.frame = World2Frame(hobj,xyzt);
[ind ijk] = World2Ind(hobj,xyzt);
info.ijk = ijk(:)';
setappdata(hobj,'UserData',info)
rijk = min(max(round(ijk),[1 1 1]'),info.sizes(1:3)');

frame = info.frame; fifth = info.fifth;
data = reshape(info.data,info.sizes);
im = squeeze(data(:,rijk(2),:,frame,fifth))';
set(info.images(1),'CData',im)
im = squeeze(data(rijk(1),:,:,frame,fifth))';
set(info.images(2),'CData',im)
im = squeeze(data(:,:,rijk(3),frame,fifth))';
set(info.images(3),'CData',im)

set(info.cross(1),'XData',ijk([1 1]))
set(info.cross(2),'YData',ijk([3 3]))
set(info.cross(3),'XData',ijk([2 2]))
set(info.cross(4),'YData',ijk([3 3]))
set(info.cross(5),'XData',ijk([1 1]))
set(info.cross(6),'YData',ijk([2 2]))

set(info.text(1),'String', ...
    ['val(' num2str(rijk(1)) ',' num2str(rijk(2)) ',' num2str(rijk(3)) ')=' ...
        num2str(data(rijk(1),rijk(2),rijk(3),frame,fifth))])
set(info.text(2),'String', ...
    ['xyzt = ' num2str(xyzt(1:3),'%.1f ')])

%---------------------------------------------------------------------
function UpdateMesh(hf,xyzt)

info = getappdata(hf,'UserData');
oldxyzt = info.xyzt;
info.xyzt = xyzt(:)';
oldframe = info.frame;
info.frame = World2Frame(hf,xyzt);
setappdata(hf,'UserData',info)

if info.frame~=oldframe
    info.frame = World2Frame(hf,xyzt);
    vcolor = info.data(:,info.frame,info.fifth);
    if ~isempty(info.heeginv), vcolor = info.heeginv * vcolor; end
    set(info.object,'FaceVertexCdata',vcolor)
end

vertex = info.mesh{1};
if any(info.xyzt(1:3)~=oldxyzt(1:3))
    idx = World2Ind(hf,xyzt);
    info.idx = idx;
    x = vertex(1,idx); y = vertex(2,idx); z = vertex(3,idx);  
    set(info.cross,'XData',x,'YData',y,'ZData',z)
else
    x = vertex(1,info.idx); y = vertex(2,info.idx); z = vertex(3,info.idx);  
end

% TODO : speed efficient ?
vcolor = get(info.object,'FaceVertexCdata'); val = vcolor(info.idx);    
set(info.text,'string',['val(' num2str(x,'%.1f') ',' num2str(y,'%.1f') ',' num2str(z,'%.1f') ...
        ') = ' num2str(val)])

%---------------------------------------------------------------------
function UpdatePlot(ha,xyzt)

info = getappdata(ha,'UserData');
info.xyzt = xyzt(:)';
info.frame = World2Frame(ha,xyzt);
oldidx = info.idx;
if isempty(info.indselection)
    info.idx = World2Ind(ha,xyzt);
else
    info.idx = -1;
end
t = xyzt(4);

% info.idx represents which indice will be plotted; it is set to -1 if
% there is a current selection of indices
% if info.idx did not change since the last plot update, no need to update
% now
% TODO: changer la maniere dont on force a redessiner ou non - ce info.idx
% est trop obscur, avec comportement diffent selon qu'on a une selection ou
% non
if info.idx~=oldidx
    if strcmp(info.type,'0d') % TODO : pas de cas sp�cial Od
        plot(info.options{:},'parent',ha,'HitTest','off')
        if isempty(info.curaxis)
            axis(ha,'tight')
        else
            ax = axis(ha);
            axis(ha,[info.curaxis([1 2]) ax([3 4])])
        end
    else
        % TODO : remove try end blocks
        if isempty(info.curaxis)
            f = 1:length(info.tidx);
        else
            f = find(info.tidx>info.curaxis(1));
            if isempty(f), f=length(info.tidx); elseif f(1)>1; f=[f(1)-1 f(:)']; end
            f = f(info.tidx(f)<info.curaxis(2));
            if isempty(f), f=1; elseif f(end)<length(info.tidx); f=[f f(end)+1]; end
        end
        try
            if isempty(info.indselection)
                indselection = {info.idx};
            else
                indselection = info.indselection;
            end
            datatoplot = zeros(length(f),length(indselection)*info.ncomp);
            for i=1:length(indselection)
                indsel = indselection{i};
                if isempty(indsel), continue, end
                if isempty(info.heeginv)
                    subdata = info.data(indsel,f,:);
                else
                    % TODO: verifier ca
                    subdata = (info.heeginv(indsel,:)*info.data(:,f,1))';
                end 
                subdata = mean(subdata,1); % average over selected indices
                subdata = shiftdim(subdata,1); % subdata is now time x component
                datatoplot(:,1+(i-1)*info.ncomp:i*info.ncomp) = subdata;
            end
            % make the data available in base workspace
            setappdata(ha,'currentdisplay',datatoplot);
            h=plot(info.tidx(f),datatoplot,info.options{:},'parent',ha,'HitTest','off');
            colors = colorset; ncolors = size(colors,1);
            if length(info.indselection)>1
                for i=1:length(indselection)
                    set(h(1+(i-1)*info.ncomp:i*info.ncomp),'color',colors(mod(i-1,ncolors)+1,:))
                end
            end
        catch
            plot(info.tidx(f),info.tidx(f),'parent',ha,'HitTest','off')
        end
        % TODO: mieux g�r�r l'axis
        axis(ha,'tight'), ax=axis(ha); 
        if ~isempty(info.curaxis)
            axis(ha,[info.curaxis(1:2) ax(3:4)])
        end
        % show the time selection for averaging images
        if ~isempty(info.timeselection)
            for k=1:length(info.timeselection)
                tsel = info.timeselection{k};
                switch length(tsel)
                    case 1
                        line(tsel,ax(3),'marker','.','color','r','parent',ha,'HitTest','off')
                    case 2
                        line(tsel,[ax(3) ax(3)],'linestyle','-','linewidth',5,'color','r','parent',ha,'HitTest','off')
                end
            end
        end
    end
else
    delete(info.line)
end
ax = axis(ha);
info.line = line([t t],ax([3 4]),'color','black','parent',ha,'HitTest','off');
setappdata(ha,'UserData',info) 

%---------------------------------------------------------------------
function UpdateTimeSlider(hf,xyzt)

info = getappdata(hf,'UserData');
info.xyzt = xyzt(:)';
setappdata(hf,'UserData',info) 

t = xyzt(4);
set(info.text,'String',['t = ' num2str(floor(t*100)/100)])
set(info.slider,'Value',t);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CALLBACK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function CallBack(dum1,dum2,hobj,action)

oldselectiontype = getappdata(hobj,'oldselectiontype');
selectiontype = get(gcf,'selectiontype');
setappdata(hobj,'oldselectiontype',selectiontype)

info = getappdata(hobj,'UserData');
point =  get(gca,'CurrentPoint');

switch selectiontype
    case 'normal'                               % CHANGE VIEW AND/OR MOVE CURSOR
        switch action
            case {'2d','3d1','3d2','3d3','plot'}
                rect = fn_mouse('rect-');
                if all(rect(3:4))               % zoom in
                    if strcmp(action,'plot')
                        ChangeAxisPlot(hobj,[rect(1)+[0 rect(3)] rect(2)+[0 rect(4)]])
                    else
                        ChangeAxis(info.key,action, ...
                            [rect(1)+[0 rect(3)] rect(2)+[0 rect(4)]],getappdata(gca,'oldaxis'))
                    end
                else    
                    if strcmp(action,'plot')    % move t
                        t = point(1,1);
                        ChangeT(info.key,t);
                    else                        % move cross
                        ijk = info.ijk(:);
                        switch action
                            case '2d'
                                ijk([1 2]) = point(1,1:2);
                            case '3d1'
                                ijk([1 3]) = point(1,1:2);
                            case '3d2'
                                ijk([2 3]) = point(1,1:2);
                            case '3d3'
                                ijk([1 2]) = point(1,1:2);
                        end
                        xyz = IJK2XYZ(info.mat,ijk);
                        ChangeXYZ(info.key,xyz)
                    end
                end
            case 'mesh'                         % move cursor
                [idx ijk] = fn_meshselectpoint(info.mesh,point);
                xyz = IJK2XYZ(info.mat,ijk);
                ChangeXYZ(info.key,xyz)
        end
    case {'extend','alt'}                       % POINTS SELECTION
        switch action
            case '2d'
                if info.mat, disp(['Points selection not possible for ' ...
                    'transformed images (with a ''mat'' field)']), return, end
                poly = fn_mouse('poly-');
                if size(poly,1)>1               % select points in a region
                    mask = poly2mask(poly(:,2),poly(:,1),info.sizes(1),info.sizes(2));
                else                            % select one point
                    mask = zeros(info.sizes(1:2));
                    mask(round(poly(2)),round(poly(1))) = 1;
                end
                indsel = find(mask);
                indselection = info.indselection;
                switch selectiontype
                    case 'extend'
                        if isempty(indselection), indselection={[]}; end
                        indselection{end} = union(indselection{end},indsel);
                    case 'alt'
                        indselection{end+1} = indsel;
                end
                ChangeIndsel(info.key,indselection)
            case 'plot'
                if ~strcmp(info.type,'2d')
                    disp('Points selection implemented for 2D images only')
                    return
                end
                rect = fn_mouse('rect-');
                if rect(3)==0                   % select a time point
                    tseg = rect(1);
                else                            % select a temporal segment
                    tseg = [rect(1) rect(1)+rect(3)];
                end
                timeselection = info.timeselection;
                switch selectiontype
                    case 'extend'
                        timeselection{end+1} = tseg;
                    case 'alt'
                        timeselection = {tseg};
                end
                ChangeTimesel(info.key,timeselection)
            case {'3d1','3d2','3d3','mesh','quiver'}
                disp('Points selection implemented for 2D images only')
                return
            otherwise
                return
        end
    case 'open'
        switch oldselectiontype
            case 'normal'                       % zoom out
                switch action
                    case {'2d','3d1','3d2','3d3','plot'}
                        if strcmp(action,'plot')
                            ChangeAxisPlot(hobj,[])
                        else
                            ChangeAxis(info.key,action, ...
                                getappdata(gca,'oldaxis'),getappdata(gca,'oldaxis'))
                        end
                end
            case 'extend'                       % unselect current set of points/instants
                switch action
                    case '2d'
                        ChangeIndsel(info.key,{info.indselection{1:end-1}})
                    case 'plot'
                        ChangeTimesel(info.key,[])
                end
            case 'alt'                          % unselect all points/instants
                switch action
                    case '2d'
                        ChangeIndsel(info.key,{})
                    case 'plot'
                        ChangeTimesel(info.key,{})
                end
        end
        
end 


%---------------------------------------------------------------------
function MoveStep(dum1,dum2,hobj,action)
% appele par les controles dans la vue sections (3D)
% ou en appuyant sur le clavier dans un plot

info = getappdata(hobj,'UserData');
s = info.sizes; xyzt = info.xyzt(:);
if strcmp(action,'keyboard')  
    keypressed = double(get(gcf,'CurrentCharacter'));
    if isempty(keypressed), return, end
    switch keypressed
        case 28
            frame = max(info.frame-1,1);
        case 29
            frame = min(info.frame+1,length(info.tidx));
        otherwise
            return
    end
    t = info.tidx(frame);
    ChangeT(info.key,t);
elseif findstr(action,'control')
    ijk = info.ijk(:); 
    switch action
        case 'controlup'
            ijk(3) = min(s(3),ijk(3)+1);
        case 'controldown'
            ijk(3) = max(1,ijk(3)-1);
        case 'controlleft'
            ijk(1) = max(1,ijk(1)-1);
        case 'controlright'
            ijk(1) = min(s(1),ijk(1)+1);
        case 'controlforward'
            ijk(2) = min(s(2),ijk(2)+1);
        case 'controlback'
            ijk(2) = max(1,ijk(2)-1); 
    end 
    xyz = IJK2XYZ(info.mat,ijk);
    ChangeXYZ(info.key,xyz);
elseif findstr(action,'window')
    curaxis = info.curaxis;
    if isempty(curaxis), return, end   
    taille = curaxis(2)-curaxis(1);
    switch action
        case 'windowleft'
            step = -taille;
        case 'windowright'
            step = taille;
    end
    ChangeAxisPlot(hobj,curaxis+step)
    ChangeT(info.key,xyzt(4)+step)
elseif findstr(action,'time')
    switch action
        case 'timeleft'
            frame = max(info.frame-1,1);
        case 'timeright'
            frame = min(info.frame+1,length(info.tidx));
    end
    t = info.tidx(frame);
    ChangeT(info.key,t);
else
    error programming
end

%---------------------------------------------------------------------
function SliderCallback(hu,dum2,hf)
% appel� par le 'time slider'

info = getappdata(hf,'UserData');
switch get(hu,'style')
    case 'slider'
        t = get(hu,'Value');
        ChangeT(info.key,t);
    case 'pushbutton'
        t = get(info.slider,'Value');
        frame = T2Frame(hf,t);
        ChangeT(info.key,info.tidx(frame));
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% LINKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hlist = Linked(key)

hlist0 = findobj('Tag','fn_4Dview');
hlist = [];
for hobj = hlist0'
    info = getappdata(hobj,'UserData');
    if info.key == key
        hlist(end+1) = hobj;
    end
end

%---------------------------------------------------------------------
function xyzt = GetXYZT(key)

hlist = Linked(key);
if ~isempty(hlist)
    info = getappdata(hlist(1),'UserData');
    xyzt = info.xyzt;
else
    xyzt = [1 1 1 1];
end

%---------------------------------------------------------------------
function ChangeAxis(key,action,ax,oldaxis)
% action = '2d', '3d1', '3d2' ou '3d3'
% oldaxis est l'axe d'origine de l'endroit o� on a cliqu�
% 'key', 'action' et 'oldaxis' permettent d'identifier dans quelles fenetres on
% va r�aliser le changement de zoom avec 'ax'

hlist = Linked(key);

% effectuer le changement de zoom dans toutes les fenetres liees et de
% memes dimensions
for hobj = hlist
    info = getappdata(hobj,'UserData');
    if strcmp(info.show,'time'), continue, end
    if strcmp(action,'2d') && ismember(info.type,{'2d','quiver'})
        if all(getappdata(hobj,'oldaxis')==oldaxis)
            axis(hobj,ax)
            if strcmp(info.type,'2d')
                ptext = ax([1 3]) - [0 0.03].*(ax([2 4])-ax([1 3]));
                set(info.text,'Position',ptext)
            end
        end
    elseif any(findstr(action,'3d')) && strcmp(info.type,'3d')
        axes = info.axes;
        switch action
            case '3d1'
                if all(getappdata(axes(1),'oldaxis')==oldaxis), axis(axes(1),ax), end
            case '3d2'
                if all(getappdata(axes(2),'oldaxis')==oldaxis), axis(axes(2),ax), end
            case '3d3'
                if all(getappdata(axes(3),'oldaxis')==oldaxis), axis(axes(3),ax), end
        end
    end
end

%---------------------------------------------------------------------
function ChangeAxisPlot(ha,ax)
% l�g�rement diff�rent de ChangeAxis: pour les repr�sentations temporelles :
% pas de liens entre les fenetres
% soit curaxis vaut [] et alors on fait axis tight
% soit curaxis est fix� et impose un nouvel intervalle temporel (abscisses)

% effectuer le changement de zoom dans les bonnes fenetres
info = getappdata(ha,'UserData');
if ~strcmp(info.show,'time') || strcmp(info.type,'timeslider'), error programming, end
emptyflag = isempty(ax);
if emptyflag, info.curaxis = []; else info.curaxis = ax([1 2]); end
info.idx = 0; setappdata(ha,'UserData',info)  
Update(ha,info.xyzt) % idx = 0 permet de forcer 'redraw cross' - TODO: forcer autrement 
%useless?%if ~isempty(ax), curax=axis(ha); axis(ha,[ax(1:2) curax(3:4)]), end

%---------------------------------------------------------------------
function ChangeXYZ(key,xyz)

hlist = Linked(key);
xyzt = GetXYZT(key);
xyzt(1:3) = xyz(:);

for hobj = hlist
    Update(hobj,xyzt)
end

%---------------------------------------------------------------------
function ChangeT(key,t)

hlist = Linked(key);
xyzt = GetXYZT(key);
xyzt(4) = t;


for hobj = hlist
    Update(hobj,xyzt)
end

%---------------------------------------------------------------------
function ChangeIndsel(key,indselection)

hlist = Linked(key);

for hobj = hlist
    info = getappdata(hobj,'UserData');
    if ~isempty(info.mat), continue, end % no point selection for transformed images
    info.indselection = indselection;
    info.idx = 0; info.frame = 0; setappdata(hobj,'UserData',info)  
    Update(hobj,info.xyzt) % idx,frame = 0 permet de forcer 'redraw image' - TODO: forcer autrement
end

%---------------------------------------------------------------------
function ChangeTimesel(key,timeselection)

hlist = Linked(key);

for hobj = hlist
    info = getappdata(hobj,'UserData');
    info.timeselection = timeselection;
    info.idx = 0; info.frame = 0; setappdata(hobj,'UserData',info)  
    Update(hobj,info.xyzt) % idx,frame = 0 permet de forcer 'redraw image/replot' - TODO: forcer autrement
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONVERSION XYZT <-> INDICES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ind, ijk] = World2Ind(hobj,xyzt)

info = getappdata(hobj,'UserData');
xyz = xyzt(1:3); xyz = xyz(:);
if ~isempty(info.mat)
    ijk = eye(3,4)*inv(info.mat)*[xyz ; 1];
else
    ijk = xyz;
end
switch info.type
    case '0d'
        ind = 1;
    case {'2d','quiver','3d','indices'}
        s = info.sizes;  
        rijk = min(max(round(ijk),[1 1 1]'),s(1:3)');
        ind = rijk(1) + s(1)*(rijk(2)-1+s(2)*(rijk(3)-1));
        if strcmp(info.type,'indices'), ind = info.ind(ind); end
    case 'mesh'
        ind = fn_meshclosestpoint(info.mesh{1},xyz);
    otherwise
        error programming 
end

%---------------------------------------------------------------------
function frame = World2Frame(hobj,xyzt)

info = getappdata(hobj,'UserData');
tidx = info.tidx;
if length(tidx)==1
    frame = 1;
else
    t = xyzt(4); 
    frame = 1 + (length(tidx)-1)*(t-tidx(1))/(tidx(end)-tidx(1));
    frame = min(max(round(frame),1),length(tidx));
end

%---------------------------------------------------------------------
function frame = T2Frame(hobj,t)
% t can be a vector

info = getappdata(hobj,'UserData');
tidx = info.tidx;
frame = 1 + (length(tidx)-1)*(t-tidx(1))/(tidx(end)-tidx(1));
frame = min(max(round(frame),1),length(tidx));

%---------------------------------------------------------------------
function frame = TSel2Frame(hobj,tselection)
% tselection is a cell array of instants or time segments

frame = [];
for k=1:length(tselection)
    tseg = tselection{k};
    switch length(tseg)
        case 1
            fseg = T2Frame(hobj,tseg);
        case 2
            fseg = T2Frame(hobj,tseg(1)):T2Frame(hobj,tseg(2));
    end
    frame = union(frame,fseg);
end

%---------------------------------------------------------------------
function xyz = IJK2XYZ(mat,ijk)

if ~isempty(mat), xyz = eye(3,4)*mat*[ijk(:) ; 1]; else xyz = ijk(:); end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% OTHER TOOLS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function b = isfigoraxeshandle(h)

b = (length(h)==1) && (ishandle(h) || (isnumeric(h) && h>0 && ~mod(h,1)));

function colors = colorset

colors = [0 0 1 ; 0 .5 0 ; 1 0 0 ; 0 .75 .75 ; .75 0 .75 ; .75 .75 0 ; 0 0 0 ; ...
    .75 .35 0 ; 0 1 0 ; 0 .3 0 ; .3 0 0 ; .3 0 .5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% DEMO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function demo
% show a demo

% make data: - 3D volume using flow, 
% - 2 time evolutions from original volume to a symetrical one 
% - surface using isosurface
% - second time evolution interpolated on that surface
% - 2D spatial gradient of first vertical slice

disp('%This is a demonstration of parts of the ''fn_4Dview'' functionalities.')
disp('%Attention, it will close all windows : press CTRL+C if you want to stop.')
fprintf('\npress any key to continue...'), pause, fprintf(repmat('\b',1,28))
close all

disp('%let''s create a 3D volume:')
disp('[x y z v] = flow;')
[x y z v] = flow;
disp('%v is the data, x,y,z are the spatial coordinates of this data')
disp('%each of v,x,y,z is a 3D 25x50x25 array')
disp('%let''s explore this data!')
fprintf('\npress any key to continue...'), pause, fprintf(repmat('\b',1,28))

disp('fn_4Dview(v)')
fn_4Dview(v)
disp('%try clicking and dragging in the graphs, and clicking on the buttons')
fprintf('\npress any key to continue...'), pause, fprintf(repmat('\b',1,28))

disp('%now let''s create data with a temporal dimension:')
disp('vevol = zeros(25,50,25,11);')     
disp('for i=1:11')
disp('  [xx yy zz w] = flow(25+2*(i-1));')
disp('  vevol(:,:,:,i)=w(i:end-(i-1),1+2*(i-1):end-2*(i-1),i:end-(i-1));')
disp('end')
vevol = zeros(25,50,25,11);
for i=1:11
  [xx yy zz w] = flow(25+2*(i-1));
  vevol(:,:,:,i)=w(i:end-(i-1),1+2*(i-1):end-2*(i-1),i:end-(i-1));
end
disp('%let''s explore it...')
fprintf('\npress any key to continue...'), pause, fprintf(repmat('\b',1,28))

disp('%spatial visualization')
disp('fn_4Dview(''in'',2,vevol)')
disp('%temporal visualization')
disp('fn_4Dview(''in'',3,vevol,''plot'')')
fn_4Dview('in',2,vevol)
fn_4Dview('in',3,vevol,'plot')
disp('%try clicking and dragging in the plot graph, and clicking on the buttons')
fprintf('\npress any key to continue...'), pause, fprintf(repmat('\b',1,28))

disp('%a single array can even contain several data of the same dimensions,')
disp('%by adding a fifth dimension:')
disp('vevol(:,:,:,:,2) = vevol + rand(size(vevol));')
vevol(:,:,:,:,2) = vevol + rand(size(vevol));
disp('%now, vevol is a 5D 25x50x25x11x2 array')
disp('%let''s explore it')
fprintf('\npress any key to continue...'), pause, fprintf(repmat('\b',1,28))

disp('%spatial visualization, first data component')
disp('fn_4Dview(''in'',2,vevol,''fifth'',1)')
disp('%spatial visualization, second data component')
disp('fn_4Dview(''in'',3,vevol,''fifth'',2)')
disp('%temporal visualization, both components together')
disp('fn_4Dview(''in'',4,vevol,''plot'')')
fn_4Dview('in',2,vevol,'fifth',1)
fn_4Dview('in',3,vevol,'fifth',2)
fn_4Dview('in',4,vevol,'plot')
disp('')
disp('next examples will be given with less explanation...')
fprintf('\npress any key to continue...'), pause, fprintf(repmat('\b',1,28))

disp('close all')
disp('s = isosurface(x, y, z, v, -3);       % s is a mesh, 3104 vertices, 6020 triangles')
disp('sv = interp3(x,y,z,v,s.vertices(:,1),s.vertices(:,2),s.vertices(:,3));')
disp('sv2 = sv + rand(size(sv));')
disp('nv = length(s.vertices);')
disp('svevol = zeros(nv,nt,1);              % svevol dim� are vertices-t-m')
disp('for i=1:nt')
disp('  svevol(:,i)=(nt-i)/(nt-1)*sv+sin((i-1)*sv2/4);')
disp('end')
disp('va = squeeze(vevol(:,:,1,:,1));       % va is a slice, dim� are y-x-t-m')
disp('[vax vay] = gradient(va);')
disp('% 2D image and quiver')
disp('figure(1)')
disp('fn_4Dview(''in'',subplot(2,2,1),''2D'',va(:,:,1))')
disp('fn_4Dview(''in'',subplot(2,2,2),''quiver'',vax(:,:,1),vay(:,:,1),va(:,:,1))')
disp('% quiver + time displayed spatially, 2D + time displayed temporally, time control')
disp('fn_4Dview(''in'',subplot(2,2,3),''quiver'',vax,vay,va)')
disp('fn_4Dview(''in'',subplot(2,2,4),''2D'',''plot'',va)')
disp('fn_4Dview(''in'',2,''timeslider'',1:nt)')
disp('% 3D + time + multiple data, spatial and temporal display')
disp('M = [diag([.2 .25 .25])*[0 1 0; 1 0 0; 0 0 1] [-.1; -3.25; -3.25] ; 0 0 0 1];')
disp('fn_4Dview(''key'',2,''in'',3,''mat'',M,''fifth'',1,vevol)')
disp('fn_4Dview(''key'',2,''in'',4,''mat'',M,''fifth'',2,vevol)')
disp('figure(5)')
disp('fn_4Dview(''key'',2,''in'',subplot(2,1,1),''mat'',M,''plot'',vevol)')
disp('% mesh spatial and temporal display')
disp('fn_4Dview(''key'',2,''in'',6,''mesh'',s,svevol)')
disp('figure(5)')
disp('fn_4Dview(''key'',2,''in'',subplot(2,1,2),''mesh'',s,''plot'',svevol)')

close all
s = isosurface(x, y, z, v, -3);       % s is a mesh, 3104 vertices, 6020 triangles
sv = interp3(x,y,z,v,s.vertices(:,1),s.vertices(:,2),s.vertices(:,3));
sv2 = sv + rand(size(sv));
nv = length(s.vertices);
svevol = zeros(nv,11,1);              % svevol dim� are vertices-t-m
for i=1:11
  svevol(:,i)=(11-i)/(11-1)*sv+sin((i-1)*sv2/4);
end
va = squeeze(vevol(:,:,1,:,1));       % va is a slice, dim� are y-x-t-m
[vax vay] = gradient(va);
% 2D image and quiver
figure(1)
fn_4Dview('in',subplot(2,2,1),'2D',va(:,:,1))
fn_4Dview('in',subplot(2,2,2),'quiver',vax(:,:,1),vay(:,:,1),va(:,:,1))
% quiver + time displayed spatially, 2D + time displayed temporally, time control
fn_4Dview('in',subplot(2,2,3),'quiver',vax,vay,va)
fn_4Dview('in',subplot(2,2,4),'2D','plot',va)
fn_4Dview('in',2,'timeslider',1:11)
% 3D + time + multiple data, spatial and temporal display
M = [diag([.2 .25 .25])*[0 1 0; 1 0 0; 0 0 1] [-.1; -3.25; -3.25] ; 0 0 0 1];
fn_4Dview('key',2,'in',3,'mat',M,'fifth',1,vevol)
fn_4Dview('key',2,'in',4,'mat',M,'fifth',2,vevol)
figure(5)
fn_4Dview('key',2,'in',subplot(2,1,1),'mat',M,'plot',vevol)
% mesh spatial and temporal display
fn_4Dview('key',2,'in',6,'mesh',s,svevol)
figure(5)
fn_4Dview('key',2,'in',subplot(2,1,2),'mesh',s,'plot',svevol)