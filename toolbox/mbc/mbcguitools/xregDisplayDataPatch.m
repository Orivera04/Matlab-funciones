function xregDisplayDataPatch(axes, string, point)
%XREGDISPLAYDATAPATCH A short description of the function
%
%  XREGDISPLAYDATAPATCH(AXES, STRING, POINT)
%  
%  This helper function displays a data patch on button down with the text
%  in STRING at the point POINT. If POINT is no supplied it is taken as the
%  current point in AXES. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:34:15 $ 

% Ensure that axes is a handle
axes = handle(axes);

% Have we got a point
if nargin < 3
    point = axes.CurrentPoint;
end
% Get the current settings on the axes
oldModes = get(axes, {'xlimmode' 'ylimmode' 'layer'});
oldUnits = axes.units;
% Set the axes properties
set(axes, 'xlimmode', 'manual', 'ylimmode', 'manual', 'layer', 'bottom');
% Define some common unit to work in
commonUnit = 'point';

% Ccreate the text to find out its extent and hence if it fits in the figure
hPatch = handle(patch('FaceColor',[1 1 0.8],...
    'parent',axes,...
    'visible','off',...
    'EdgeColor','k',...
    'tag','xregDataPatch',...
    'FaceAlpha',1,...
    'clipping','off'));

hText = handle(text(point(1), point(2), 3.0, string,...
    'parent',axes,...
    'units','data',...
    'visible','off',...
    'FontName','Lucida Console',...
    'clipping','off',...
    'horiz','left',...
    'vert','bottom',...
    'Interpreter','none'));        

% Everything in same units (commonUnit) to see if it all fits on
set([axes hText],'units',commonUnit);
% Get the size of the axes
axW = axes.Position(3);
axH = axes.Position(4);

% Define our offset from the clicked point
offset = 5;
% Sort out text size (a bit!) (Max Font Size is 10 point)
hText.fontsize = max(6, min([10 axH/size(string, 1) 1.7*axW/size(string, 2)]));
% Lets move the text a little right and up so we can see the point on which
% we clicked (by 5 points)
hText.position(1:2) = hText.position(1:2) + offset;
% Now find how much space the text takes up
ext = hText.extent;
% Does the text go off the end of the axes (to the right)?
if (ext(1) + ext(3)) > axW 
    % Will it go off the left if we right align?
    if (ext(1) - ext(3)) < 0
        hText.Position(1) = 0;
    else
        % Chage the horizontal alignment and modify the offset
        hText.HorizontalAlignment = 'right';
        hText.Position(1) = hText.Position(1) - 2*offset;
    end
end
% Does it go off the top
if (ext(2) + ext(4)) > axH
    % Does it go off the bottom
    if (ext(2) - ext(4)) < 0
        hText.position(2) = 0;
    else
        hText.VerticalAlignment = 'top';
        hText.Position(2) = hText.Position(2) - 2*offset;
    end
end

% Revert to original axes units
axes.units = oldUnits;
hText.units = 'data';
% Get the text extent to set the patch size around the text
ext = hText.extent;

set(hPatch, 'XData', [ext(1) ext(1) ext(1)+ext(3) ext(1)+ext(3)],...
    'YData', [ext(2) ext(2)+ext(4) ext(2)+ext(4),ext(2)],...
    'ZData', repmat(2.0,[1,4]));

oldUpFcn = get(gcbf ,'WindowButtonUpFcn');
set(gcbf ,'WindowButtonUpFcn', {@i_killPatch, axes, [hPatch hText], oldModes, oldUpFcn});
set([hPatch hText],'visible','on');

%----------------------------------------------------------------------
%  SUBFUNCTION i_killPatch
%----------------------------------------------------------------------
function i_killPatch(src, event, axes, handles, oldModes, oldUpFcn)

% Remove text and patch
set(axes, {'xlimmode' 'ylimmode' 'layer'}, oldModes);
set(gcbf, 'WindowButtonUpFcn', oldUpFcn);
delete(handles);

