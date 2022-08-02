function xregorbit3d(arg,arg2)
% XREGORBIT3D Interactively orbit the view of a 3-D plot.
% 
%   XREGORBIT3D ON turns on mouse-based 3-D orbit function.
%   XREGORBIT3D OFF turns if off.
%   XREGORBIT3D by itself toggles the state.
%
%   XREGORBIT3D(FIG,...) works on the figure FIG.
%
%   xreorbit3d on enables  text feedback
%   xregorbit3d ON disables text feedback.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:02:26 $


if(nargin == 0)
   setState(gcf,'toggle');
elseif nargin==1
   if ishandle(arg)
      setState(arg,'toggle')
   else
      switch(lower(arg)) % how much performance hit here
      case 'motion'
         orbMotionFcn
      case 'down'
         orbButtonDownFcn
      case 'up'
         orbButtonUpFcn
      case 'on'
         setState(gcf,arg);
      case 'off'
         setState(gcf,arg);
      otherwise
         error('Unknown action string.');
      end
   end
elseif nargin==2
   if ~ishandle(arg), error('Unknown figure.'); end
   switch(lower(arg2)) % how much performance hit here
   case 'on'
      setState(arg,arg2)
   case 'off'
      setState(arg,arg2);
   otherwise
      error('Unknown action string.');
   end
end

%--------------------------------
% Set activation state. Options on, ON, off
function setState(fig,state)
orbObj = findobj(allchild(fig),'Tag','orbObj');
if(strcmp(state,'toggle'))
   if(~isempty(orbObj))
      setState(fig,'off');
   else
      setState(fig,'on');
   end
elseif(strcmp(lower(state),'on'))

   if(isempty(orbObj))
      plotedit(fig,'locktoolbarvisibility'); % can't be changed while doing this operation
      orbObj = makeorbObj(fig);
      set(findall(fig,'Tag','figToolOrbit3D'),'State','on');
   end
   % Handle toggle of text feedback. ON means no feedback on means feedback.
   odata = get(orbObj,'UserData');
   if(strcmp(state,'on'))
      odata.textState = 1;
   else
      odata.textState = 0;
   end
   set(orbObj,'UserData',odata);
elseif(strcmp(lower(state),'off'))
   set(findall(fig,'Tag','figToolOrbit3D'),'State','off');
   if(~isempty(orbObj))
      destroyOrbObj(orbObj);
   end
end

%-----------------------------------------------------------------------------------------------
% Button down callback
function orbButtonDownFcn
orbObj = findobj(allchild(gcbf),'Tag','orbObj');
if(isempty(orbObj))
   return;
else
   odata = get(orbObj,'UserData');
   setpointer(1);
  h_light=findobj(gcbf,'type','light');
  ax=get(h_light,'parent');
   if length(h_light)>1
      error('More than one light object, xregorbit3d will not work')
   end
   
   odata.oldFigureUnits = get(gcbf,'Units');
   set(gcbf,'Units','pixels');
   odata.oldPt = get(0,'PointerLocation');
   odata.lightoldPos = get(h_light,'Pos');
   odata.lightoldAzEl=pos2azel(odata.lightoldPos);

   set(orbObj,'UserData',odata);
   
   if(odata.textState)
      fig_color = get(gcbf,'Color');
      c = sum([.3 .6 .1].*fig_color);
      set(odata.textBoxText,'BackgroundColor',fig_color);
      if(c > .5)
         set(odata.textBoxText,'ForegroundColor',[0 0 0]);
      else
         set(odata.textBoxText,'ForegroundColor',[1 1 1]);
      end
      set(odata.textBoxText,'Visible','on');
   end
   %set(odata.outlineObj,'Visible','on');
   set(gcbf,'WindowButtonMotionFcn','xregorbit3d(''motion'')');
end

%------------------------------------------------------------------------------------------
% Button up callback
function orbButtonUpFcn
orbObj = findobj(allchild(gcbf),'Tag','orbObj');
if isempty(orbObj) | ...
    ~strcmp(get(gcbf,'WindowButtonMotionFcn'),'xregorbit3d(''motion'')')
   return;
else
   set(gcbf,'WindowButtonMotionFcn','');
   odata = get(orbObj,'UserData');
   setpointer(0);
   odata.lightoldAzEl = get(orbObj,'Pos');
   set(odata.targetAxis,'View',odata.lightoldAzEl);
   set(gcbf,'Units',odata.oldFigureUnits);
   set(orbObj,'UserData',odata)
   odata.textState=0;
   set(odata.textBoxText,'Visible','off');
end

%------------------------------------------------------------------------------------------
% Mouse motion callback
function orbMotionFcn
orbObj = findobj(allchild(gcbf),'Tag','orbObj');
odata = get(orbObj,'UserData');
new_pt = get(0,'PointerLocation');
old_pt = odata.oldPt;
dx = new_pt(1) - old_pt(1);
dy = new_pt(2) - old_pt(2);
new_azel = mappingFunction(odata, dx, dy);
h_light=findobj(gcbf,'type','light');
camlight(h_light,new_azel(1),new_azel(2));
%if(new_azel(2) < 0 & odata.crossPos == 0)
%   set(odata.outlineObj,'ZData',odata.scaledData(4,:));
   %odata.crossPos = 1;
   set(orbObj,'UserData',odata);
%end
%if(new_azel(2) > 0 & odata.crossPos == 1) 
   %odata.crossPos = 0;
%   set(orbObj,'UserData',odata);
%end
if(odata.textState)
   set(odata.textBoxText,'String',sprintf('Az: %4.0f El: %4.0f',new_azel));
end

%---------------------------------------------------------------------------------------------------
% Map a dx dy to an azimuth and elevation
function azel = mappingFunction(odata, dx, dy)
wdth=odata.screensize(1); hght=odata.screensize(2);
delta_az = round(odata.GAIN*(-dx/wdth));
delta_el = round(odata.GAIN*(-dy/hght));
azel(1) = mod((odata.lightoldAzEl(1) + delta_az),360);
azel(2) = mod((odata.lightoldAzEl(2) + delta_el),360);
%if abs(azel(2))>90
   % Switch az to other side.
   azel(1) = rem(rem(azel(1)+180,360)+180,360)-180; % Map new az from -180 to 180.
   % Update el
%   azel(2) = sign(azel(2))*(180-abs(azel(2)));
%end


%-------------------------------------------------------------------------------------------------
% Constructor for the orbit object.
function orbObj = makeorbObj(fig)

% save the previous state of the figure window
odata.uistate = uiclearmode(fig,'xregorbit3d',fig,'off');

odata.targetAxis = []; % Axis that is being orbited (target axis)
odata.GAIN    = 360;   % Motion gain
odata.oldPt   = [];  % Point where the button down happened
odata.lightoldPos = [];
scrnsze=get(0,'screensize');
odata.screensize=scrnsze(3:4);
curax = get(fig,'currentaxes');
hl=findobj(fig,'type','light');
orbObj = hl;
% Make text box.
odata.textBoxText = uicontrol('parent',fig,'Units','Pixels','Position',[2 2 130 20],'Visible','off', ...
   'Style','text','HandleVisibility','off');
%odata.crossPos = 0;
odata.textState = [];
odata.oldFigureUnits = '';

set(fig,'WindowButtonDownFcn','xregorbit3d(''down'')');
set(fig,'WindowButtonUpFcn'  ,'xregorbit3d(''up'')');
set(fig,'WindowButtonMotionFcn','');
set(fig,'ButtonDownFcn','');

set(orbObj,'Tag','orbObj','Userdata',odata);
set(fig,'currentaxes',curax)

%----------------------------------------------------------------------------------------------------
function setpointer(val)

% Values for the custom pointer.
CustomPointerCData1 = [
    nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan nan 
    nan nan nan nan nan nan nan 1   nan nan nan nan nan nan nan nan 
    nan nan nan nan nan nan nan 1   nan nan nan nan nan nan nan nan 
    nan nan 1   nan nan nan nan 1   nan nan nan nan 1   nan nan nan 
    nan nan nan 1   nan nan nan nan nan nan nan 1   nan nan nan nan 
    nan nan nan nan nan nan 1   1   1   nan nan nan nan nan nan nan 
    nan nan nan nan nan 1   2   2   2   1   nan nan nan nan nan nan 
    nan nan nan nan 1   2   2   2   2   2   1   nan nan nan nan nan 
    1   1   1   nan 1   2   2   2   2   2   1   nan 1   1   1   nan
    nan nan nan nan 1   2   2   2   2   2   1   nan nan nan nan nan 
    nan nan nan nan nan 1   2   2   2   1   nan nan nan nan nan nan 
    nan nan nan nan nan nan 1   1   1   nan nan nan nan nan nan nan 
    nan nan nan 1   nan nan nan nan nan nan nan 1   nan nan nan nan 
    nan nan 1   nan nan nan nan 1   nan nan nan nan 1   nan nan nan 
    nan nan nan nan nan nan nan 1   nan nan nan nan nan nan nan nan 
    nan nan nan nan nan nan nan 1   nan nan nan nan nan nan nan nan 
 ];
  
 CustomPointerHotSpot=[9,9];
 switch val
 case 0
    set(gcbf,'pointer','arrow','pointershapehotspot',[1,1])
 case 1
    set(gcbf,'pointer','custom','pointershapecdata',CustomPointerCData1,'pointershapeho',CustomPointerHotSpot)
 end
 
 
%----------------------------------------------------------------------------------------------------
function azel=pos2azel(pos)
unit = pos/norm(pos);
        az = atan2(unit(1),-unit(2))*180/pi;
        el = atan2(unit(3),sqrt(unit(1)^2+unit(2)^2))*180/pi;
        azel=[az,el];
        

 
%----------------------------------------------------------------------------------------------------
% Deactivate orbit object -fine SJB
function destroyOrbObj(orbObj)
odata = get(orbObj,'UserData');
set(orbObj,'tag','');
delete(odata.textBoxText);
uirestore(odata.uistate);

