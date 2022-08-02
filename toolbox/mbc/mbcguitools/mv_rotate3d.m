function mv_rotate3d(arg,arg2,varargin)
%MV_ROTATE3D Interactively rotate the view of a 3-D plot.
%   ROTATE3D ON turns on mouse-based 3-D rotation.
%   ROTATE3D OFF turns if off.
%
%   ROTATE3D(AX,...) works on the axes AX.
%
%   See also ZOOM.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   rotate3d on enables  text feedback
%   rotate3d ON disables text feedback.

%   Revised by Rick Paxson 10-25-96
%   Clay M. Thompson 5-3-94
%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:33:40 $

if nargin==1
   if ishandle(arg)
      setState(arg,'toggle')
   else
      switch(lower(arg)) % how much performance hit here
      case 'on'
         setState(gcf,arg,gca);
      case 'off'
         setState(gcf,arg,gca);
      otherwise
         error('Unknown action string.');
      end
   end
   
elseif nargin==2
   if ~ishandle(arg), error('Unknown axes.'); end
   if strcmp(get(arg,'type'),'axes')
      ax= arg;
      hFig= get(ax,'parent');
   end
   switch(lower(arg2)) % how much performance hit here
   case 'on'
      setState(hFig,arg2,double(ax))
   case 'off'
      setState(hFig,arg2,double(ax));
   otherwise
      error('Unknown action string.');
   end
end




%--------------------------------
% Set activation state. Options on, ON, off
function setState(fig,state,ax)

rotaObj = findobj(allchild(fig),'Tag','xreg.rotaObj');
if(strcmp(lower(state),'on'))
   if(isempty(rotaObj))
      rotaObj = makeRotaObj(fig,ax);
   else
      % add axes to rotaobj list
      rdata=get(rotaObj,'Userdata');
      rdata.targetAxis=unique([rdata.targetAxis ax]);
      set(rotaObj,'Userdata',rdata); 
   end
   % Handle toggle of text feedback. ON means no feedback on means feedback.
   rdata = get(rotaObj,'UserData');
   if(strcmp(state,'on'))
      rdata.textState = 1;
   else
      rdata.textState = 0;
   end
   set(rotaObj,'UserData',rdata);
elseif(strcmp(lower(state),'off'))
   % remove axis handle from list of rotation axes
   if ~isempty(rotaObj)
      rdata = get(rotaObj,'UserData');
      rdata.targetAxis(rdata.targetAxis==ax)=[];
      if isempty(rdata.targetAxis)
         destroyRotaObj(rotaObj);
      else
         set(rotaObj,'userdata',rdata);
      end
   end
end






%---------------------------
% Button down callback
function rotaButtonDownFcn(figH,evt,rotaObj)

ax=get(figH,'currentaxes');
if isempty(ax) | ~ishandle(ax) | strcmp(get(ax,'visible'),'off')
   return
end
rdata = get(rotaObj,'UserData');
if ~ismember(ax,rdata.targetAxis)
   return
end

% Activate axis that is clicked in
funits = get(figH,'units');
set(figH,'units','pixels');

rdata.currentAxis=ax;
cp = get(figH,'CurrentPoint');
aunits = get(ax,'units');
set(ax,'units','pixels');
pos = get(ax,'position');
set(ax,'units',aunits);
axes_found = 0;
if cp(1) >= pos(1) & cp(1) <= pos(1)+pos(3) & ...
      cp(2) >= pos(2) & cp(2) <= pos(2)+pos(4)
   axes_found = 1;
   set(figH,'currentaxes',ax);
end % if
set(figH,'units',funits)
if axes_found==0, return, end


% store the state on the zlabel:  that way if the user
% plots over this axis, this state will be cleared and
% we get to start over.
viewData = getappdata(get(ax,'ZLabel'),'ROTATEAxesView');
if isempty(viewData)
   setappdata(get(ax,'ZLabel'),'ROTATEAxesView', get(ax, 'View'));
end

selection_type = get(figH,'SelectionType');
if strcmp(selection_type,'open')
   % this assumes that we will be getting a button up
   % callback after the open button down
   new_azel = getappdata(get(ax,'ZLabel'),'ROTATEAxesView');
   if(rdata.textState)
      set(rdata.textBoxText,'String',...
         sprintf('Az: %4.0f El: %4.0f',new_azel));
   end
   set(rotaObj, 'View', new_azel);
   return
end

rdata.oldFigureUnits = get(figH,'Units');
set(figH,'Units','pixels');
rdata.oldPt = get(figH,'CurrentPoint');
rdata.oldAzEl = get(ax,'View');

% Map azel from -180 to 180.
rdata.oldAzEl = rem(rem(rdata.oldAzEl+360,360)+180,360)-180; 
if abs(rdata.oldAzEl(2))>90
   % Switch az to other side.
   rdata.oldAzEl(1) = rem(rem(rdata.oldAzEl(1)+180,360)+180,360)-180;
   % Update el
   rdata.oldAzEl(2) = sign(rdata.oldAzEl(2))*(180-abs(rdata.oldAzEl(2)));
end

set(rotaObj,'UserData',rdata);
setOutlineObjToFitAxes(rotaObj);
copyAxisProps(ax, rotaObj);

rdata = get(rotaObj,'UserData');
if(rdata.oldAzEl(2) < 0)
   rdata.CrossPos = 1;
   set(rdata.outlineObj,'ZData',rdata.scaledData(4,:));
else
   rdata.CrossPos = 0;
   set(rdata.outlineObj,'ZData',rdata.scaledData(3,:));
end
set(rotaObj,'UserData',rdata);

if(rdata.textState)
   fig_color = get(figH,'Color');
   c = sum([.3 .6 .1].*fig_color);
   set(rdata.textBoxText,'BackgroundColor',fig_color);
   if(c > .5)
      set(rdata.textBoxText,'ForegroundColor',[0 0 0]);
   else
      set(rdata.textBoxText,'ForegroundColor',[1 1 1]);
   end
   set(rdata.textBoxText,'Visible','on');
end
set(rdata.outlineObj,'Visible','on');
set(figH,'WindowButtonUpFcn'  ,{@rotaButtonUpFcn, rotaObj});
% attach to motion manager
rdata.manager.EnableTree=false;
rdata.manager.MouseMoveFcn={@rotaMotionFcn, rotaObj};




%-------------------------------
% Button up callback
function rotaButtonUpFcn(figH,evt,rotaObj)

if isempty(rotaObj)
   return;
else
   set(figH,'WindowButtonUpFcn','');
   rdata = get(rotaObj,'UserData');
   set([rdata.outlineObj rdata.textBoxText],'Visible','off');
   rdata.oldAzEl = get(rotaObj,'View');
   set(rdata.currentAxis,'View',rdata.oldAzEl);
   hL= findobj(rdata.targetAxis,'type','light');
   if length(hL)==1
      camlight(hL,'headlight');
   end
   set(figH,'Units',rdata.oldFigureUnits);
   set(rotaObj,'UserData',rdata);
   rdata.manager.EnableTree=true;
   rdata.manager.MouseMoveFcn='';
end




%-----------------------------
% Mouse motion callback
function rotaMotionFcn(figH,evt,rotaObj)
rdata = get(rotaObj,'UserData');
figH=rdata.figure;
new_pt = get(figH,'CurrentPoint');
old_pt = rdata.oldPt;
dx = new_pt(1) - old_pt(1);
dy = new_pt(2) - old_pt(2);
new_azel = mappingFunction(rdata, dx, dy);
set(rotaObj,'View',new_azel);
if(new_azel(2) < 0 & rdata.crossPos == 0)
   set(rdata.outlineObj,'ZData',rdata.scaledData(4,:));
   rdata.crossPos = 1;
   set(rotaObj,'UserData',rdata);
end
if(new_azel(2) > 0 & rdata.crossPos == 1) 
   set(rdata.outlineObj,'ZData',rdata.scaledData(3,:));
   rdata.crossPos = 0;
   set(rotaObj,'UserData',rdata);
end
if(rdata.textState)
   set(rdata.textBoxText,'String',sprintf('Az: %4.0f El: %4.0f',new_azel));
end

%----------------------------
% Map a dx dy to an azimuth and elevation
function azel = mappingFunction(rdata, dx, dy)
delta_az = round(rdata.GAIN*(-dx));
delta_el = round(rdata.GAIN*(-dy));
azel(1) = rdata.oldAzEl(1) + delta_az;
azel(2) = min(max(rdata.oldAzEl(2) + 2*delta_el,-90),90);
if abs(azel(2))>90
   % Switch az to other side.
   azel(1) = rem(rem(azel(1)+180,360)+180,360)-180; % Map new az from -180 to 180.
   % Update el
   azel(2) = sign(azel(2))*(180-abs(azel(2)));
end

%-----------------------------
% Scale data to fit target axes limits
function setOutlineObjToFitAxes(rotaObj)
rdata = get(rotaObj,'UserData');

ax = rdata.currentAxis;

x_extent = get(ax,'XLim');
y_extent = get(ax,'YLim');
z_extent = get(ax,'ZLim');
X = rdata.outlineData;
X(1,:) = X(1,:)*diff(x_extent) + x_extent(1);
X(2,:) = X(2,:)*diff(y_extent) + y_extent(1);
X(3,:) = X(3,:)*diff(z_extent) + z_extent(1);
X(4,:) = X(4,:)*diff(z_extent) + z_extent(1);
set(rdata.outlineObj,'XData',X(1,:),'YData',X(2,:),'ZData',X(3,:));
rdata.scaledData = X;
set(rotaObj,'UserData',rdata);



%-------------------------------
% Copy properties from one axes to another.
function copyAxisProps(original, dest)
props = {
   'DataAspectRatio'
   'DataAspectRatioMode'
   'CameraViewAngle'
   'CameraViewAngleMode'
   'XLim'
   'YLim'
   'ZLim'
   'PlotBoxAspectRatio'
   'PlotBoxAspectRatioMode'
   'Units'
   'Position'
   'View'
   'Projection'
};
values = get(original,props);
set(dest,props,values);



%-------------------------------------------
% Constructor for the Rotate object.
function rotaObj = makeRotaObj(fig,ax)

% save the previous state of the figure window
% rdata.uistate = uiclearmode(fig,mfilename,fig,'off');

rdata.targetAxis = ax; % Axis that is being rotated (target axis)
rdata.GAIN    = 0.4;    % Motion gain
rdata.oldPt   = [];  % Point where the button down happened
rdata.oldAzEl = [];
curax = get(fig,'currentaxes');
rotaObj = axes('Parent',fig,'Visible','off','HandleVisibility','off','Drawmode','fast');
% Data points for the outline box.
rdata.outlineData = [0 0 1 0;0 1 1 0;1 1 1 0;1 1 0 1;0 0 0 1;0 0 1 0; ...
      1 0 1 0;1 0 0 1;0 0 0 1;0 1 0 1;1 1 0 1;1 0 0 1;0 1 0 1;0 1 1 0; ...
      NaN NaN NaN NaN;1 1 1 0;1 0 1 0]'; 
rdata.outlineObj = line(rdata.outlineData(1,:),rdata.outlineData(2,:),rdata.outlineData(3,:), ...
   'Parent',rotaObj,'Erasemode','xor','Visible','off','HandleVisibility','off', ...
   'Clipping','off');

% Make text box.
rdata.textBoxText = uicontrol('parent',fig,'Units','Pixels','Position',[2 2 130 20],'Visible','off', ...
   'Style','text','HandleVisibility','off');

rdata.textState = [];
rdata.oldFigureUnits = '';
rdata.crossPos = 0;  % where do we put the X at zmin or zmax? 0 means zmin 1 means zmax
rdata.scaledData = rdata.outlineData;
rdata.figure=fig;
% property to link with mouse motion manager
rdata.manager=MotionManager(fig);

set(fig,'WindowButtonDownFcn',{@rotaButtonDownFcn, rotaObj});
set(fig,'ButtonDownFcn','');
set(rotaObj,'Tag','xreg.rotaObj','UserData',rdata);
if ~isempty(curax)
    set(fig,'currentaxes',curax)
end




%----------------------------------
% Deactivate rotate object
function destroyRotaObj(rotaObj)
rdata = get(rotaObj,'UserData');

fig=get(rotaObj,'parent');
delete(rdata.textBoxText);
delete(rotaObj);

set(fig,'WindowButtonDownFcn','');
set(fig,'WindowButtonUpFcn'  ,'');
