function xreglinezoom(mode)
% XREGLINEZOOM
% X or Y only replacement for mv_zoom
% set(axis,'ButtonDownFcn', 'xregrbline(''x'')');
% use shift+LMB to zoom
% double click to zoom out.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:34:26 $

seltype=get(gcbf,'selectiontype');

switch seltype
case 'open'
   i_restore
case 'extend'
   % first make sure that there is no other
   % button down function defined
   set(gcbf,'windowbuttondownfcn','',...
      'windowbuttonmotionfcn','');
   i_zoom(mode)
end
%----------------------------------------------------------
% function i_zoom
%----------------------------------------------------------
function i_zoom(mode)

% First check to see if there are any text objects...
tH=findobj(gca,'type','text','clipping','off');
%% and clip all of them
set(tH,'clipping','on');

pt=get(gca,'currentpoint');
pt=pt(1,1:2);

% get the axes position and 
oldunits=get(gca,'units');
set(gca,'units','pixels');
apos=get(gca,'pos');
set(gca,'units',oldunits);
xlim=get(gca,'xlim');
xlen=xlim(2)-xlim(1);
ylim=get(gca,'ylim');
ylen=ylim(2)-ylim(1);

% get ratios to convert pt to pixel units.
xratio=xlen/apos(3);
yratio=ylen/apos(4);

% check for a shift in x or y
xshift=(0-xlim(1));
yshift=(0-ylim(1));

% convert pt into pixels from bottom left of figure.
pt=apos(1:2)+[((pt(1)+xshift)/xratio) ((pt(2)+yshift)/yratio)];

% draw the line
newlim = xregrbline(mode);
newxlim = newlim;
newylim = newlim;

if diff(newxlim)>0 & diff(newylim)>0 
   % update the axes limits
   zlab=get(gca,'zlabel');
   ud=get(zlab,'user');
   if isempty(ud)
      ud.XLimMode= get(gca,'XLimMode');
      ud.YLimMode= get(gca,'YLimMode');
      ud.xlim=xlim;
      ud.ylim=ylim;
   end
   if any(strcmp('x', lower(mode)))
	   set(gca,'xlim',newxlim);
   end
   if any(strcmp('y', lower(mode)))
	   set(gca,'ylim',newylim);
   end
   % store the original values
   ud.Text=tH;
   set(zlab,'user',ud);
end  

%----------------------------------------------------------
% function i_restore
%----------------------------------------------------------
function i_restore
ud=get(get(gca,'zlabel'),'user');
if isempty(ud)
   return
end
set(gca,'xlim',sort(ud.xlim),...
   'ylim',sort(ud.ylim),'XLimMode',ud.XLimMode,'YLimMode',ud.XLimMode);
set(get(gca,'zlabel'),'user',[]);

% Check to see if there are any text objects...
tH = ud.Text;
set(tH(ishandle(tH)),'clipping','off');
