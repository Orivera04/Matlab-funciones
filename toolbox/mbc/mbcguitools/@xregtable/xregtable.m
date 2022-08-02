function hnd = xregtable(varargin)
%XREGTABLE Constructor for xregtable object
%
%   TBL = XREGTABLE
%   TBL = XREGTABLE(FIG)
%   TBL = XREGTABLE('Property1',Value1,...)
%   TBL = XREGTABLE(FIG,'Property1',Value1,...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:33:56 $

% Use given figure handle or current figure by default (creates one if necessary)
if nargin>0 && ~ischar(varargin{1}) && ishandle(varargin{1})
    hnd.parent = varargin{1};
    varargin(1) = [];
else
    hnd.parent = gcf;
end

% need to know this before making frame
fud.position=[50 50 400 400];
fud.units='pixels';
fud.parent=hnd.parent;

% ** Create frame and slider handles **
hnd.frame.handle=xregaxes(...
   'parent',hnd.parent,...
   'visible', 'off',...
   'units','pixels',...
   'position',fud.position,...
   'xtick',[],...
   'ytick',[],...
   'box','on',...
   'Color',get(0,'defaultuicontrolbackground'),...
   'XColor',[0 0 0],...
   'YColor',[0 0 0],...
   'xlim',[0 1],'ylim',[0 1],...
   'handlevisibility','off',...
   'hittest','off');

%Sliders inherit units from object...??
hnd.hslider.handle=xreguicontrol(hnd.parent,...
   'style','slider',...
   'visible','off',...
   'units',fud.units,...
   'position',[0 0 1 1],...
   'min',1,...
   'max',2,...
   'value',1);
hnd.vslider.handle=xreguicontrol(hnd.parent,...
   'style','slider',...
   'visible','off',...
   'units',fud.units,...
   'position',[0 0 1 1],...
   'min', -2,...
   'max',-1,...
   'value',-1);
% Diagonal scrolling button
hnd.dslider.handle=xreguicontrol(hnd.parent,...
   'style','togglebutton',...
   'visible','off',...
   'units',fud.units,...
   'position',[0 0 1 1],...
   'value',0,...
   'tooltip','Enable diagonal scrolling');


% Set up data in frame ud
fud.cells.shandles=[];
fud.cells.flefthandles=[];
fud.cells.ftophandles=[];
fud.cells.fcornerhandles=[];
fud.cells.exist=false(0,0);
fud.cells.userprops=false(0,0);
fud.cells.uiprops={};
fud.userdata=[];
fud.cellchangecb='';

uip.callback='';

% new coded type matrix
% types are:
%              1   -   text
%              2   -   uitext
%              3   -   uiedit
%              4   -   uiradiobutton
%              5   -   uicheckbox
%              6   -   uitogglebutton
%              7   -   uipushbutton
%              8   -   uislider
%              9   -   uiframe
%              10  -   uilistbox
%              11  -   uipopupmenu
%              12  -   uiemuedit0
%              13  -   uiemuedit1
%              14  -   uiemuedit   -  full editing emulation
%                
fud.cells.ctype=[];
fud.cells.positions=[];
fud.cells.visible={};
fud.cells.value=[];
fud.cells.format={};
fud.cells.string={};

fud.cells.rowselection=[1 0];
fud.cells.colselection=[1 0];

fud.rows.number=0;
fud.rows.size=20;
fud.rows.fixed=0;
fud.rows.spacing=0;
fud.rows.autosize=0;
fud.rows.autosizenumber=20;
fud.rows.autosizeminsize=20;

fud.cols.number=0;
fud.cols.size=50;
fud.cols.fixed=0;
fud.cols.spacing=0;
fud.cols.autosize=0;
fud.cols.autosizenumber=8;
fud.cols.autosizeminsize=50;

fud.frame.visible='on';
fud.frame.hborder=[2 2];
fud.frame.vborder=[2 2];
fud.frame.handle=hnd.frame.handle;
fud.frame.boxcolor=[0 0 0];

fud.visible='on';
fud.defaultcelltype=3;
fud.defaultcellformat='%5.3f';
fud.zeroindex=[1 1];
fud.redrawmode=1;
fud.colormap=[];
fud.colorintervals=[];
fud.usecolors='off';

fud.vslider.width=17;
fud.vslider.visible='off';
fud.vslider.offset=0;      % drawing offset from table
fud.hslider.width=17;
fud.hslider.visible='off';
fud.hslider.offset=0;      % drawing offset from table
fud.hslider.handle=hnd.hslider.handle;
fud.vslider.handle=hnd.vslider.handle;
fud.dslider.handle=hnd.dslider.handle;
fud.dslider.visible='off';

fud.filters.type='none';
fud.filters.value=0;
fud.filters.tol=0;
fud.sliders=1;    % flag for turning sliders vis/invis permanently


% Set up link to frame and initialise slider steps property
% for scrolling
vslud.parent=hnd.frame.handle;
vslud.steps=[];

hslud.parent=hnd.frame.handle;
hslud.steps=[];

% Create table object
hnd=class(hnd,'xregtable');

% make up new name for hnd carrier frame
m=1;
n=0;
while m
   n=n+1;
   current=findobj('type','axes','tag',['tablehandle' sprintf('%d',n)]);
   if isempty(current)
      m=0;
   end
end

fud.objecthandle=axes('parent',hnd.parent,'Visible','off','Units','pixels',...
   'position',[0 0 1 1],'Userdata',hnd,'Tag',['tablehandle' sprintf('%d',n)],...
   'handlevisibility','off');

uip.callback = ['cellcb(get(' sprintf('%20.15f',fud.objecthandle) ',''Userdata''));'];
uip.enable = get(double(hnd.parent),'defaultuicontrolenable');
fud.cells.defaultuip = uip;


set(hnd.frame.handle,'UserData',fud);
set(hnd.vslider.handle,'UserData',vslud,'callback',...
   ['vsliderscroll(get(' sprintf('%20.15f',fud.objecthandle) ',''Userdata''));']);
set(hnd.hslider.handle,'UserData',hslud,'callback',...
   ['hsliderscroll(get(' sprintf('%20.15f',fud.objecthandle) ',''Userdata''));']);

% Call set function for any initial properties.  This will handle
% redraw if necessary.  If no arguments, then call redraw from here.
if length(varargin)
    % Set properties that are passed in
    set(hnd.frame.handle,'Visible','on');
    set(hnd,varargin{:});
else
    % Scroll cells need to be created and positioned.  Frame will be seen
    % ?? For no inputs, sliders are not necessary, not are values
    %hnd=redraw(hnd,uint8([1 1 1 1 0 0 0 0 0 0]));
    set(hnd.frame.handle,'Visible','on');
end
