function ci_example(arg);
% example of the use function Circles_Intersection
% is in sub-function 'apply_circles_intersection;'
%
% run without arguments
%
%   Vesrion 2.0
%   Author:  Alexander Vakulenko
%   e-mail:  dspt@yandex.ru
%   Last modified: 20050207
         
global hCI; % handle to main window

narg=nargin;
if narg==0,arg=0;end;
if arg==0,
    hobj=findobj('Type','figure','Tag','ci_example');
    if ~isempty(hobj),
        figure(hobj);
    else
        ci_example_create;
    end;
    return;
end;

switch arg
    case 'WindowButtonMotionFcn',
        WindowButtonMotionFcn;
    case 'WindowButtonDownFcn',
        WindowButtonDownFcn;
    case 'WindowButtonUpFcn',
        WindowButtonUpFcn;
    case 'popKT',
        popKT;
    case 'popSel',
        popSel;
    case 'edit',
        edit;
    case 'pbInsert',
        pbInsert;
    case 'pbRemove',
        pbRemove;
    case 'edit',
        edit;
    case 'pbLoad',
        pbLoad;
    case 'pbSave',
        pbSave;
    case 'popRenderer',
        popRenderer;
    case 'chkCalc',
        chkCalc;
    case 'pbCalc',
        pbCalc;
        
end; % end of main program


%-------------------------------------------------------------------
% functions
%-------------------------------------------------------------------

function apply_circles_intersection;
global hCI;
gw=getappdata(hCI,'handles');
v=get(gw.chkCalc,'value');
if v==1,
    G=gw.G; % input circles
    tic;
    % resolving of singulariyies
    if get(gw.chkDispose,'Value')==1,
        MaxRnd=str2num(get(gw.edtRndVal,'String'));
        ng=size(G);
        G(:,1:2)=G(:,1:2)+randn(ng(1),2)*MaxRnd;
    end;
    try,
        c=Circles_Intersection(G);
        set(gw.chkDispose,'BackGroundColor',[0.64705882352941   0.82352941176471   0.82745098039216]);
    catch
        set(gw.chkDispose,'BackGroundColor','r');
        return;
    end;
    gw.tcalc=toc; % calculation time
    try,
        delete(gw.hr);
    end;
    if gw.kt<=c.K, 
        % convertion contours of arcs to poligonal region
        R=arcs2region(c,gw.kt,3);
        % draw region
        gw.hr=reg_patch(R,'c',gw.hAxs);
        setappdata(hCI,'handles',gw);
        area_of_region=c.w(gw.kt).S;
    else
        area_of_region=0;
    end;
    set(gw.txtTCalc,'String',['Last calcul. time : ' num2str(round(gw.tcalc*1000)/1000) ' s']);
    display_area(gw,area_of_region);
end;
%-------------------------------------------------------------------



function ci_example_create;
global hCI;

% create figure
figColor=[0.64705882352941   0.82352941176471   0.82745098039216];
hCI = figure(...
    'Position',[50 50 700 500],...
    'Units','pixels', ...
    'NumberTitle','off', ...
    'Toolbar','figure', ...
    'MenuBar','none', ...
    'pointer','arrow',...
    'Color',figColor,...
    'Name','INTERACTIVE CIRCLES INTERSECTION', ...
    'NumberTitle','off', ...
    'Resize','off', ...
    'Tag','ci_example');

gw.hCI=hCI;

% create axes
WndPos=get(hCI,'Position');
Hxy_wnd=WndPos(4);
Hxy_axs=Hxy_wnd-20-20;
Wxyh=30+Hxy_axs;
saxy=[30 20 Hxy_axs Hxy_axs]; 
gw.hAxs = axes('Parent',hCI, ...
    'Units','pixels', ...
    'NextPlot','add', ...
    'Box','on', ...
    'Layer','top', ...
    'gridlinestyle',':',...
    'FontName','Times New Roman', ...
    'FontSize',8, ...
    'FontWeight','normal', ...
    'Position',saxy, ...
    'Tag','axesXY', ...
    'XGrid','on', ...
    'XLimMode','manual', ...
    'YGrid','on', ...
    'YLimMode','manual', ...
    'XLim',[-100 100], ...
    'YLim',[-100 100] );
ht=text( -100, 100,'Y axis');
set(ht,'Parent',gw.hAxs,'FontUnits','pixels','FontName','Times New Roman','FontSize',16,'HorizontalAlignment','left','VerticalAlignment','top','Units','pixels','Color','c');
ht=text( 100, -100,'X axis');
set(ht,'Parent',gw.hAxs,'FontUnits','pixels','FontName','Times New Roman','FontSize',16,'HorizontalAlignment','right','VerticalAlignment','bottom','Units','pixels','Color','c');

%create initial circles
G=[      15  70  25;...
        -50  40  48;...
         63  45  31;...
         50  20  15;
         15  13  35;...
         48 -50  15;...
         50 -55  25;...
         65 -65  30];
% draw circamferences
Ng=size(G,1);
ang=(0:3:360)*pi/180;
for k=1:Ng,
    hG(k)=line(G(k,1)+G(k,3)*cos(ang),G(k,2)+G(k,3)*sin(ang),'Parent',gw.hAxs,'Color','g','linestyle',':','linewidth',2);
end;
c_sel=1;
set(hG(c_sel),'Color','b');
h_center_sel=line(G(c_sel,1),G(c_sel,2),'Parent',gw.hAxs,'Color','b','linestyle','none','marker','o','markersize',3);
gw.Ng=Ng;
gw.G=G;
gw.hG=hG;
gw.c_sel=c_sel;
gw.h_center_sel=h_center_sel;

% create the custom pointer
gw.pntr=custom_pointer;
gw.action='none';
gw.kt=1; % number of overlappad circles

xpos=saxy(1)+saxy(3)+3;
ypos=saxy(2)+saxy(4)-100;
wdth=WndPos(3)-xpos-3;
strInf=['Select Circle: click non-selected (green) circumference;' char(13) ...
        'Move   Circle: press mouse button on center of selected circle(blue) and move;' char(13) ...
        'Resize Circle: press mouse button on selected circumference(blue) and move mouse;'];
gw.txtInform=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth 100],...
    'style','text','backgroundcolor',figColor,'HorizontalAlignment','left','string',strInf);
ypos=ypos-18;
gw.txtRenderer=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth*0.3 14],...
    'style','text','backgroundcolor',figColor,'foregroundcolor','k','HorizontalAlignment','left',...
    'string','Renderer:');
strpop={'opengl','zbuffer','painters'};

gw.Renderer=2;
gw.popRenderer=uicontrol('Parent',hCI,'units','pixels','position',[xpos+2+wdth*0.3 ypos wdth*0.7-3 16],...
    'style','popupmenu','backgroundcolor',figColor,'foregroundcolor','k','HorizontalAlignment','left',...
    'string',strpop,'FontWeight','normal','CallBack','ci_example(''popRenderer'');','value',gw.Renderer);
set(hCI,'Renderer',strpop{gw.Renderer});

ypos=ypos-25;;
gw.txtKT=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth 16],...
    'style','text','backgroundcolor',figColor,'foregroundcolor',[0 0.4 0.4],'HorizontalAlignment','left',...
    'string',['Number of overlapped circles (>=):'],'FontWeight','bold');

ypos=ypos-20;
strpop=popupmenustring(gw.Ng);
gw.popKT=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth 20],...
    'style','popupmenu','backgroundcolor',figColor,'foregroundcolor',[0 0.4 0.4],'HorizontalAlignment','left',...
    'string',strpop,'FontWeight','bold','CallBack','ci_example(''popKT'');','value',gw.kt);

ypos=ypos-25;
gw.txtArea_1=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth*0.55 18],...
    'style','text','backgroundcolor',figColor,'foregroundcolor',[0 0.4 0.4],'HorizontalAlignment','left',...
    'string','Area of region:','FontWeight','bold','fontsize',8);
gw.txtArea=uicontrol('Parent',hCI,'units','pixels','position',[xpos+wdth*0.55 ypos wdth*0.45 18],...
    'style','text','backgroundcolor',figColor,'foregroundcolor',[0 0.4 0.4],'HorizontalAlignment','center',...
    'string','0','FontWeight','bold','fontsize',8);
ypos=ypos-5;
gw.frmPrgbB=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth 5],...
    'style','frame','backgroundcolor',figColor);
gw.frmPrgb=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth-10 5],...
    'style','frame','backgroundcolor',[0.5 0.7 0.4],'UserData',1000);

ypos=ypos-25;
gw.txtSel=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth 18],...
    'style','text','backgroundcolor',figColor,'foregroundcolor','b','HorizontalAlignment','center',...
    'string','Selected Circle:','FontWeight','bold','fontsize',8);
ypos=ypos-20;
strpop=popupmenustring(gw.Ng);
gw.popSel=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth 20],...
    'style','popupmenu','backgroundcolor',figColor,'foregroundcolor','b','HorizontalAlignment','left',...
    'string',strpop,'FontWeight','bold','CallBack','ci_example(''popSel'');','value',gw.c_sel);
ypos=ypos-18;
gw.txtX=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth/2 16],...
    'style','text','backgroundcolor',figColor,'foregroundcolor','b','HorizontalAlignment','right',...
    'string','X coord:   ','FontWeight','bold','fontsize',8);
gw.edtX=uicontrol('Parent',hCI,'units','pixels','position',[xpos+wdth/2 ypos wdth/2 16],...
    'style','edit','backgroundcolor',figColor,'foregroundcolor','b','HorizontalAlignment','left',...
    'string','123','FontWeight','bold','fontsize',8,'Callback','ci_example(''edit'');');
ypos=ypos-18;
gw.txtY=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth/2 16],...
    'style','text','backgroundcolor',figColor,'foregroundcolor','b','HorizontalAlignment','right',...
    'string','Y coord:   ','FontWeight','bold','fontsize',8);
gw.edtY=uicontrol('Parent',hCI,'units','pixels','position',[xpos+wdth/2 ypos wdth/2 16],...
    'style','edit','backgroundcolor',figColor,'foregroundcolor','b','HorizontalAlignment','left',...
    'string','-234','FontWeight','bold','fontsize',8,'Callback','ci_example(''edit'');');
ypos=ypos-18;
gw.txtR=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth/2 16],...
    'style','text','backgroundcolor',figColor,'foregroundcolor','b','HorizontalAlignment','right',...
    'string','Radius:    ','FontWeight','bold','fontsize',8);
gw.edtR=uicontrol('Parent',hCI,'units','pixels','position',[xpos+wdth/2 ypos wdth/2 16],...
    'style','edit','backgroundcolor',figColor,'foregroundcolor','b','HorizontalAlignment','left',...
    'string','222','FontWeight','bold','fontsize',8,'Callback','ci_example(''edit'');');
ypos=ypos-20;
gw.pbInsert=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth/2 18],...
    'style','pushbutton','backgroundcolor',figColor,'foregroundcolor','k','HorizontalAlignment','right',...
    'string','INSERT','FontWeight','bold','fontsize',8,'Callback','ci_example(''pbInsert'');');
gw.pbRemove=uicontrol('Parent',hCI,'units','pixels','position',[xpos+wdth/2 ypos wdth/2 18],...
    'style','pushbutton','backgroundcolor',figColor,'foregroundcolor','k','HorizontalAlignment','left',...
    'string','REMOVE','FontWeight','bold','fontsize',8,'Callback','ci_example(''pbRemove'');');

ypos=ypos-20;
gw.chkCalc=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth/2 16],'Value',1,...
    'style','checkbox','backgroundcolor',figColor,'foregroundcolor','k','HorizontalAlignment','left',...
    'string','AutoCalc','FontWeight','bold','fontsize',8,'Callback','ci_example(''chkCalc'');');
gw.pbCalc=uicontrol('Parent',hCI,'units','pixels','position',[xpos+wdth/2 ypos wdth/2 18],'Enable','off',...
    'style','pushbutton','backgroundcolor',figColor,'foregroundcolor',[0 0.5 0],'HorizontalAlignment','left',...
    'string','ReCalc','FontWeight','bold','fontsize',8,'Callback','ci_example(''pbCalc'');');
ypos=ypos-18;
gw.chkDispose=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth 16],'Value',1,...
    'style','checkbox','backgroundcolor',figColor,'foregroundcolor',[0.2392    0.4941    0.5608],'HorizontalAlignment','left',...
    'string','Dispose singular case','FontWeight','bold','fontsize',8);
ypos=ypos-18;
gw.txtRndVal=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth*0.6 16],'Value',0,...
    'style','text','backgroundcolor',figColor,'foregroundcolor',[0.2392    0.4941    0.5608],'HorizontalAlignment','left',...
    'string','Max Random Value:','FontWeight','bold','fontsize',8);
gw.edtRndVal=uicontrol('Parent',hCI,'units','pixels','position',[xpos+wdth*0.6 ypos wdth*0.4 16],'Value',0,...
    'style','edit','backgroundcolor',figColor,'foregroundcolor',[0.2392    0.4941    0.5608],'HorizontalAlignment','left',...
    'string','1e-9','FontWeight','bold','fontsize',8);

ypos=ypos-30;
gw.pbSave=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth/2 18],...
    'style','pushbutton','backgroundcolor',figColor,'foregroundcolor',[0 0.5 0],'HorizontalAlignment','right',...
    'string','SAVE...','FontWeight','bold','fontsize',8,'Callback','ci_example(''pbSave'');');
gw.pbLoad=uicontrol('Parent',hCI,'units','pixels','position',[xpos+wdth/2 ypos wdth/2 18],...
    'style','pushbutton','backgroundcolor',figColor,'foregroundcolor',[0 0.5 0],'HorizontalAlignment','left',...
    'string','LOAD...','FontWeight','bold','fontsize',8,'Callback','ci_example(''pbLoad'');');

ypos=ypos-30;
gw.txtTCalc=uicontrol('Parent',hCI,'units','pixels','position',[xpos ypos wdth 16],...
    'style','text','backgroundcolor',figColor,'foregroundcolor','k','HorizontalAlignment','left',...
    'string','Last Calcul. time :  0  s','FontWeight','bold','fontsize',8);
gw.tcalc=0;


setappdata(hCI,'handles',gw);
SelectCircle(c_sel,gw);


apply_circles_intersection;

drawnow;

% set mouse events
set(hCI,'WindowButtonMotionFcn','ci_example(''WindowButtonMotionFcn'');');
set(hCI,'WindowButtonDownFcn','ci_example(''WindowButtonDownFcn'');');
set(hCI,'WindowButtonUpFcn','ci_example(''WindowButtonUpFcn'');');




function pntr=custom_pointer;
x=[0.5 6 6 10 10 15.5 10 10 6 6 0.5];
y=[8 15.5 10 10 15.5 8 0.5 6 6 0.5 8];
dx=diff(x);
dy=diff(y);
v=sqrt(dx.*dx+dy.*dy);
n=ceil(v./1);
x1=[];
y1=[];
for k=1:length(n),
    x1=[x1 x(k) (x(k)+(dx(k)*(1:n(k)-1))./n(k))];
    y1=[y1 y(k) (y(k)+(dy(k)*(1:n(k)-1))./n(k))];
end;
x1=[x1 x(end)];
y1=[y1 y(end)];
pntr=[x1;y1];



function WindowButtonMotionFcn;
global hCI;
gw=getappdata(hCI,'handles');
[st,px,py,dxyr,nc]=current_state(gw);
switch gw.action,
    case 'none',
        if st==1,
            set(hCI,'pointer','crosshair');
        else
            if st==2,
                c_sel=gw.c_sel;
                degr=atan2(py-gw.G(c_sel,2),px-gw.G(c_sel,1));
                m=transform_pointer(gw.pntr,degr);
                set(hCI,'pointer','custom','pointershapecdata',m,'PointerShapeHotSpot',[8 8]);
            else
                set(hCI,'pointer','arrow');
            end;
        end;
    case 'radius',
        c_sel=gw.c_sel;
        rad=sqrt((px-gw.G(c_sel,1))^2+(py-gw.G(c_sel,2))^2);
        gw.G(c_sel,3)=rad-gw.dxyr(3);
        ang=(0:360)*pi/180;
        set(gw.hG(c_sel),'XData',gw.G(c_sel,1)+gw.G(c_sel,3)*cos(ang),'YData',gw.G(c_sel,2)+gw.G(c_sel,3)*sin(ang));
        set(gw.h_center_sel,'XData',gw.G(c_sel,1),'YData',gw.G(c_sel,2));
        set(gw.edtR,'String',num2str(round(10*gw.G(c_sel,3))/10));
        setappdata(hCI,'handles',gw);
        degr=atan2(py-gw.G(c_sel,2),px-gw.G(c_sel,1));
        m=transform_pointer(gw.pntr,degr);
        set(hCI,'pointer','custom','pointershapecdata',m,'PointerShapeHotSpot',[8 8]);
        apply_circles_intersection;
    case 'center'
        c_sel=gw.c_sel;
        gw.G(c_sel,1)=px-gw.dxyr(1);
        gw.G(c_sel,2)=py-gw.dxyr(2);
        ang=(0:360)*pi/180;
        set(gw.hG(c_sel),'XData',gw.G(c_sel,1)+gw.G(c_sel,3)*cos(ang),'YData',gw.G(c_sel,2)+gw.G(c_sel,3)*sin(ang));
        set(gw.h_center_sel,'XData',gw.G(c_sel,1),'YData',gw.G(c_sel,2));
        set(gw.edtX,'String',num2str(round(10*gw.G(c_sel,1))/10));
        set(gw.edtY,'String',num2str(round(10*gw.G(c_sel,2))/10));
        setappdata(hCI,'handles',gw);
        apply_circles_intersection;
end;


function WindowButtonDownFcn;
global hCI;
gw=getappdata(hCI,'handles');
[st,px,py,dxyr,nc]=current_state(gw);
gw.action='none';
if st==3,
    SelectCircle(nc,gw);
end;
if st==1,
    gw.action='center';
    gw.dxyr=dxyr;
    setappdata(hCI,'handles',gw);
end;
if st==2,
    gw.action='radius';
    gw.dxyr=dxyr;
    setappdata(hCI,'handles',gw);
end;


function WindowButtonUpFcn;
global hCI;
gw=getappdata(hCI,'handles');
gw.action='none';
setappdata(hCI,'handles',gw);


function popKT;
global hCI;
gw=getappdata(hCI,'handles');
v=get(gw.popKT,'Value');
if v~=gw.kt,
    gw.kt=v;
    setappdata(hCI,'handles',gw);
    apply_circles_intersection;
end;


function [st,px,py,dxyr,nc]=current_state(gw);
c_sel=gw.c_sel;
xlim=get(gw.hAxs,'xlim');
ylim=get(gw.hAxs,'ylim');
pa=get(gw.hAxs,'position');
kx=diff(xlim)/pa(3);
ky=diff(ylim)/pa(4);
p=get(gw.hAxs,'CurrentPoint');
px=p(1,1);
py=p(1,2);
dx=px-gw.G(c_sel,1);
dy=py-gw.G(c_sel,2);
dc=sqrt(dx*dx+dy*dy);
dr=dc-gw.G(c_sel,3);
dxyr=[dx dy dr];
do=abs(dr);
if 2*dc/(kx+ky)<7,
    % center of selected circle
    st=1;
    nc=c_sel;
else
    if 2*do/(kx+ky)<7,
        % over selected circumference
        st=2;
        nc=c_sel;
    else
        % over non-selected circumference
        for k=1:gw.Ng,
            if k~=c_sel,
                dx=px-gw.G(k,1);
                dy=py-gw.G(k,2);
                dc=sqrt(dx*dx+dy*dy);
                dr=dc-gw.G(k,3);
                do=abs(dr);
                if 2*do/(kx+ky)<7,
                    nc=k;
                    st=3;
                    return;
                end;
            end;
        end;
        st=0;
        nc=0;
    end;
end;



function m=transform_pointer(pntr,deg);
sn=sin(deg);
cn=cos(deg);
rot=[cn -sn;sn cn];
pntr=((pntr-8)'*rot)'+8;
m=zeros(16)*NaN;
z=16*floor(pntr(1,:))+floor(pntr(2,:));
m(z+1)=1;

function strpop=popupmenustring(Ng);
strpop=[];
for k=1:Ng,
    ppp='          ';
    sss=num2str(k);
    ls=length(sss);lp=length(ppp);
    ppp(lp-ls+1:lp)=sss;
    strpop{k}=ppp;
end;
function popSel;
global hCI;
gw=getappdata(hCI,'handles');
nc=get(gw.popSel,'Value');
SelectCircle(nc,gw);


function edit;
global hCI;
gw=getappdata(hCI,'handles');
c_sel=gw.c_sel;
gw.G(c_sel,1)=str2num(get(gw.edtX,'String'));
gw.G(c_sel,2)=str2num(get(gw.edtY,'String'));
gw.G(c_sel,3)=str2num(get(gw.edtR,'String'));
ang=(0:360)*pi/180;
set(gw.hG(c_sel),'XData',gw.G(c_sel,1)+gw.G(c_sel,3)*cos(ang),'YData',gw.G(c_sel,2)+gw.G(c_sel,3)*sin(ang));
set(gw.h_center_sel,'XData',gw.G(c_sel,1),'YData',gw.G(c_sel,2));
setappdata(hCI,'handles',gw);
apply_circles_intersection;



function pbInsert;
global hCI;
gw=getappdata(hCI,'handles');
gw.G=[gw.G;[160*(rand-0.5) 160*(rand-0.5) 30]];
gw.Ng=size(gw.G,1);
Ng=gw.Ng;
ang=(0:3:360)*pi/180;
gw.hG(Ng)=line(gw.G(Ng,1)+gw.G(Ng,3)*cos(ang),gw.G(Ng,2)+gw.G(Ng,3)*sin(ang),'Parent',gw.hAxs,'Color','g','linestyle',':','linewidth',2);
setappdata(hCI,'handles',gw);
strpop=popupmenustring(Ng);
set(gw.popKT,'String',strpop);
set(gw.popSel,'String',strpop);
SelectCircle(Ng,gw);
apply_circles_intersection;


function pbRemove;
global hCI;
gw=getappdata(hCI,'handles');
if gw.Ng>1,
    nc=gw.c_sel;
    idx=[1:nc-1 nc+1:gw.Ng];
    nn=idx(1);
    SelectCircle(nn,gw);
    gw=getappdata(hCI,'handles');
    delete(gw.hG(nc));
    gw.G=gw.G(idx,:);
    gw.hG=gw.hG(idx);
    gw.Ng=size(gw.G,1);
    strpop=popupmenustring(gw.Ng);
    v=get(gw.popKT,'Value');
    if v>gw.Ng, v=gw.Ng; gw.kt=v; end;
    set(gw.popKT,'String',strpop,'value',v);
    if nn>nc,gw.c_sel=nn-1;end;
    set(gw.popSel,'String',strpop,'value',gw.c_sel);
    setappdata(hCI,'handles',gw);
    apply_circles_intersection;
end;


function pbSave;
global hCI;
gw=getappdata(hCI,'handles');
[fn,fp]=uiputfile('*.mat','SAVE IN');
if ischar(fn),
    ffn=[fp fn];
    gx.G=gw.G;
    gx.Ng=gw.Ng;
    gx.kt=gw.kt;
    gx.c_sel=gw.c_sel;
    save(ffn,'gx');
end;


function pbLoad;
global hCI;
gw=getappdata(hCI,'handles');
[fn,fp]=uigetfile('*.mat','LOAD FROM');
if ischar(fn),
    ffn=[fp fn];
    load(ffn);
    gw.G=gx.G;
    gw.c_sel=gx.c_sel;
    gw.Ng=size(gw.G,1);
    gw.kt=gx.kt;
    delete(gw.hG);
    delete(gw.h_center_sel);
    ang=(0:3:360)*pi/180;
    for k=1:gw.Ng,
        hG(k)=line(gw.G(k,1)+gw.G(k,3)*cos(ang),gw.G(k,2)+gw.G(k,3)*sin(ang),'Parent',gw.hAxs,'Color','g','linestyle',':','linewidth',2);
    end;
    set(hG(gw.c_sel),'Color','b');
    h_center_sel=line(gw.G(gw.c_sel,1),gw.G(gw.c_sel,2),'Parent',gw.hAxs,'Color','b','linestyle','none','marker','o','markersize',3);
    gw.hG=hG;
    gw.h_center_sel=h_center_sel;
    strpop=popupmenustring(gw.Ng);
    set(gw.popKT,'String',strpop,'value',gw.kt);
    set(gw.popSel,'String',strpop,'value',gw.c_sel);
    SelectCircle(gw.c_sel,gw);
    apply_circles_intersection;
end;




function SelectCircle(nc,gw);
set(gw.hG(gw.c_sel),'Color','g');
gw.c_sel=nc;
set(gw.hG(nc),'Color','b');
set(gw.h_center_sel,'XData',gw.G(nc,1),'YData',gw.G(nc,2));
set(gw.edtX,'String',num2str(round(10*gw.G(nc,1))/10));
set(gw.edtY,'String',num2str(round(10*gw.G(nc,2))/10));
set(gw.edtR,'String',num2str(round(10*gw.G(nc,3))/10));
set(gw.popSel,'Value',nc);
setappdata(gw.hCI,'handles',gw);

function display_area(gw,area_of_region);
A=sum(gw.G(:,3).*gw.G(:,3))*pi;
set(gw.txtArea,'String',num2str(round(area_of_region*10)/10));
W=get(gw.frmPrgbB,'position');
wdth=W(3);
W=get(gw.frmPrgb,'position');
W(3)=round(area_of_region*wdth/A);
if W(3)==0,W(3)=1;end;
set(gw.frmPrgb,'position',W);



function popRenderer;
global hCI;
gw=getappdata(hCI,'handles');
r=get(gw.popRenderer,'value');
ss=get(gw.popRenderer,'string');
set(hCI,'Renderer',ss{r});


function chkCalc;
global hCI;
gw=getappdata(hCI,'handles');
v=get(gw.chkCalc,'value');
if v==1,
    set(gw.pbCalc,'Enable','off');
else
    set(gw.pbCalc,'Enable','on');
end;



function pbCalc;
global hCI;
gw=getappdata(hCI,'handles');
v=get(gw.chkCalc,'value');
set(gw.chkCalc,'value',1);
apply_circles_intersection;
set(gw.chkCalc,'value',v);
