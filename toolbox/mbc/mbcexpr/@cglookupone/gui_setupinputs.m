function [T,ok]=gui_setupinputs(T,action,varargin)
%GUI_SETUPINPUTS  Select variables as inputs to table
%
%  [T,OK]=GUI_SETUPINPUTS(T,'figure','DD',P_DD)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.2.4 $  $Date: 2004/04/04 03:27:31 $

switch lower(action)
case 'figure'
   [T,ok] = i_createfig(T,varargin{:});
end



function [Tout,ok] = i_createfig(T,varargin)
scrpos=get(0,'screensize');
figh=xregdialog('name','Table Setup',...
   'resize','off',...
   'tag','tableinputs');
xregcenterfigure(figh,[300 130]);

p=xregpointer(T);
lyt=i_createlyt(figh,p,varargin{:});
set(lyt,'visible','on');
okbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','OK',...
   'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');',...
   'interruptible','off');
cancbtn=uicontrol('parent',figh,...
   'style','pushbutton',...
   'string','Cancel',...
   'callback','set(gcbf,''visible'',''off'');',...
   'interruptible','off');

grd=xreggridbaglayout(figh,...
   'dimension',[2 3],...
   'rowsizes',[-1 25],...
   'colsizes',[-1 65 65],...
   'gapy',10,'gapx',7,...
   'border',[7 7 7 7],...
   'mergeblock',{[1 1],[1 3]},...
   'elements',{lyt,[],[],okbtn,[],cancbtn});
figh.LayoutManager=grd;
set(grd,'packstatus','on');

figh.showDialog(okbtn);

%dialog blocks here

tg=get(figh,'tag');
if strcmp(tg,'ok')
   i_finalise(lyt);
   Tout=p.info;
   ok=1;
else
   Tout=T;
   ok=0;
end
delete(figh);
freeptr(p);


function lyt=i_createlyt(figh,p,varargin)
p_ud=xregGui.RunTimePointer;

ud.Tpointer=p;
ud.DDpointer=[];

for n=1:2:length(varargin)
   switch lower(varargin{n})
   case 'dd'
      % pick up data dictionary
      ud.DDpointer=varargin{n+1};
   end
end

ud.Name=xregGui.labelcontrol('parent',figh,...
   'labelsize',40,...
   'labelsizemode','absolute',...
   'string','Name:',...
   'controlsize',1,...
   'controlsizemode','relative',...
   'gap',5,...
   'Control',uicontrol('parent',figh,...
   'style','edit',...
   'backgroundcolor','w',...
   'horizontalalignment','left',...
   'callback',@i_disallowempty));   
   
ud.Xvar=xregGui.labelcontrol('parent',figh,...
   'labelsize',40,...
   'labelsizemode','absolute',...
   'string','Input:',...
   'controlsize',1,...
   'controlsizemode','relative',...
   'gap',5,...
   'Control',uicontrol('parent',figh,...
   'style','edit',...
   'backgroundcolor','w',...
   'horizontalalignment','left',...
   'callback',@i_disallowempty));   

ud.EditXSize = xregGui.clickedit('parent', figh, ...
    'horizontalalign','right',...
    'min', 2, ...
    'rule', 'int', ...
    'dragging', 'off', ...
    'enable','off');
ud.ManTextX = xregGui.labelcontrol('parent',figh, ...
    'string','Rows: ',...
    'LabelAlignment','left', ...
    'LabelSizeMode', 'Absolute', ...
    'LabelSize', 40, ...
    'gap',5,...
    'ControlSize',50, ...
    'control', ud.EditXSize);

ud.EditValue = xregGui.clickedit('parent', figh, ...
    'enable','off');
ud.ValueLabel = xregGui.labelcontrol('parent',figh, ...
    'string', 'Initial value:',...
    'LabelAlignment','left', ...
    'LabelSizeMode', 'Absolute', ...
    'LabelSize', 60, ...
    'gap',5,...
    'ControlSize',70, ...
    'control', ud.EditValue);

lyt = xreggridbaglayout(figh, ...
    'packstatus', 'off', ...
    'dimension', [3 3], ...
    'rowsizes', [20 20 20], ...
    'colsizes', [120 150 -1], ...
    'gapy', 10, ...
    'mergeblock', {[1 1], [1 3]}, ...
    'mergeblock', {[2 2], [1 3]}, ...
    'elements', {ud.Name, ud.Xvar, ud.ManTextX, [], [], ud.ValueLabel}, ...
    'userdata', p_ud);
    
ud=i_setvalues(ud);
p_ud.info=ud;
return


function i_disallowempty(src,evt)
str=get(src,'string');
if isempty(str)
   set(src,'string',get(src,'userdata'));
else
   set(src,'userdata',str);
end



function ud=i_setvalues(ud);
T=ud.Tpointer.info;

% get default strings from normaliser settings if possible
Vx=get(T,'x');

strX='';
if ~isempty(Vx) & Vx~=0
   strX=Vx.getname;
end
if isempty(strX)
   % get list of names from DD
   DD=ud.DDpointer;
   if ~isempty(DD)
      nms= DD.listnames;
      N_nms=length(nms);
      if isempty(strX)
         if N_nms
            strX=nms{1};
         else
            strX='X';
         end
      end
   else
      % make up some default names
      if isempty(strX)
         strX='X';
      end
   end
end

name = getname(T);
set(ud.Xvar.Control,'string',strX,'userdata',strX);
set(ud.Name.Control,'string', name, 'userdata', name);

function i_finalise(lyt)

p_ud=get(lyt,'userdata');
ud=p_ud.info;

strX = get(ud.Xvar.Control,'string');
name = get(ud.Name.Control,'string');
xsize = get(ud.EditXSize, 'value');
val   = get(ud.EditValue, 'value');
val   = repmat(val, 1, xsize);

T=ud.Tpointer.info;

if ~isempty(ud.DDpointer);
   DD=ud.DDpointer.info;
   [DD,Vx]= add(DD,strX);
else
   % make standalone value objects if needed
   Vx=get(T,'x');
   if isempty(Vx) | Vx==0
      Vx = cgvalue(strX);
      Vx.info = Vx.set('range', [-1 1]);
      Vx.info = Vx.setpoint(0);
   else
      Vx.info=Vx.setname(strX);
   end
end

% set value pointers
T = setX(T,Vx);

ud.Tpointer.info = setname(ud.Tpointer.info, name);

% set the tables values
if xsize>0
    xRange = Vx.get('range');
    ud.Tpointer.info = set(ud.Tpointer.info, 'matrix', [linspace(xRange(1), xRange(2), xsize)', val']);
end
