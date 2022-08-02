function zoomBox(hParentAxes, hChildAxes, updateMode)
%ZOOMBOX creates a resizable zoom box.
%   ZOOMBOX(hParentAxes, hChildAxes) will create a resizable zoom box in the
%   parent axes that will cause any number of child axes to be rescaled to
%   the limits of the zoom box.
%
%   ZOOMBOX(hParentAxes, hChildAxes, 1) is intended for large data sets.
%
%   ZOOMBOX(hParentAxes, hChildAxes, 2) is intended for large data sets
%   where the parent axes data has been decimated by the user.
%
%   Update Modes: Third argument
%   0 - [default] updates the children axes as zoom box is moved and
%   resized.  This is recommended for small data sets, but when data sets
%   are large (relative to the power of the machine) the graphics will lag.
%
%   1 - does not update the child axes as the zoom box is moved and resized
%   until the mouse button is released.  This mode also changes all
%   EraseMode property to Xor for all the children of the parent axes.  This is
%   always a quick graphically, but the data in the parent axes may look
%   odd for some data sets.
%
%   2 - same as mode 1 above, with the exception that the EraseMode is not
%   changed to Xor for all the children of the parent axes.  It is assumed
%   that the user will decimate the data in the parent axes on their own.
%   A simple decimation scheme would be to plot every Nth data point:
%   plot(x(1:N:end), y(1:N:end))
%   This will make the graphics faster than mode 0, but not as fast as 1.
%   
%   -1 - removes Zoom Box from all of the listed axes.
%
%   EXAMPLE:
%
%      clear; clc; close all
% 
%      n = 3000; %increase n to emulate a large data set.
%      x  = linspace(0,1,n);
%      y1 = polyval([1 0.3 0.4],x);
%      y2 =     cos(20*x);  
% 
%      hChildAxes(1) = subplot(3,1,1);
%      plot (x,y1,'r-')
% 
%      hChildAxes(2) = subplot(3,1,2);
%      plot (x,y2,'b-')
% 
%      hParentAxes   = subplot(3,1,3);
%      plot (x,y1,'r-',x,y2,'b-')
%      %Some people would decimate the data shown in the parent axes
%      % to save on memory and increase graphics speed.
%      % d = round(n * 1/100); %show every 100th point.
%      % plot (x(1:d:end),y1(1:d:end),'r-',x(1:d:end),y2(1:d:end),'b-')
%
%      %zoomBox(hParentAxes, hChildAxes, 1) %large data set switch on.
%      zoomBox(hParentAxes, hChildAxes)
%
%   ZOOMBOX will create appdata in the curent figure to store the handles of
%   the corners of the zoom box, the handle of the patch which is the zoom
%   box, and the handles of the parent and child axes.  This appdata all
%   starts  with the key letters hZB for "Handle Zoom Box".  Temporary
%   application data is also stored while the mouse button is clicked down,
%   but is removed when released. This also uses the key letters ZB.
%
%   Invoking ZOOMBOX will expand the axis limits on the parent axes by 10%
%   on each side because that works better.  This behavior is controlled by
%   EXPANDAXIS. The zoom box is restricted from getting too close to edges of
%   axes by the helper function restrictPointsToLimits. These behaviors can be
%   changed, but the zoom box might stick to the top of the axes if not
%   careful.
%
%   ZOOMBOX can be used across different figures, inside of GUIs, or
%   multiple times in the same figure, on any number of children axes.
%   However any axes can only be associated with one instance of ZOOMBOX.
%
%   ZOOMBOX uses code from MATLAB Central:
%     MOVEPLOT   by Brandon Kuczenski (modified for this project)
%       MOVEPLOT is no longer used, but was used to bootstrap this project.
%     EXPANDAXIS by Doug Hull

%   ZOOMBOX 2.1- modified to support multiple figures, large data set
%   support, cursors that change with shape to show function, cleaned up
%   the code in general.  Return hold to original state.  Removed
%   dependency on MOVEPLOT by Brandon K. Added some HTML doc.
%
%   Future version will put this code into one monolithic file so easier to
%   use as a feature rather than an application.

%    Doug Hull <hull@mathworks.com>     1/03/2003
%    Copyright 1984-2002 The MathWorks, Inc.
%    This function is not supported by The MathWorks, Inc.
%    It is provided 'as is' without any guarantee of
%    accuracy or functionality.
    
if nargin < 3
    updateMode = 0;
end

if nargin < 2
    error('Input must consist of one axes handle and one vector of axes handles')
end

if ~ishandle([hParentAxes; hChildAxes(:)])
    error('Inputs must be valid axes handles')
end

if ~all(strcmp('axes',get([hParentAxes; hChildAxes(:)],'type')))
    error('Inputs must be valid axes handles')
end

destroyExistingZoomBoxes([hParentAxes; hChildAxes(:)]);

if updateMode == -1
    return %if mode -1 then leave after destroying existing zoomBoxes
end
axis(hParentAxes, 'tight')   %This tightens the  axis so that the zoomBox is
                              %as close to the data as possible.

top    = max(ylim(hParentAxes));
bottom = min(ylim(hParentAxes));
left   = min(xlim(hParentAxes));
right  = max(xlim(hParentAxes));

holdOriginalyOn = ishold;
hold on
hZoomBox = patch([left left right right],[bottom  top top bottom],'y','facecolor','none');

expandaxis % It is nice to have a little extra space around the data in the parent axes.
            % The amount of expansion can be changed here.

hNE    = plot(right, top,    'k.');
hSE    = plot(right, bottom, 'k.');
hSW    = plot(left,  bottom, 'k.');
hNW    = plot(left,  top,    'k.');

if holdOriginalyOn
    hold on;
else
    hold off
end

set(get(hParentAxes,'parent'), 'doublebuffer',  'on')

set(hZoomBox, 'buttonDownFcn', ['zoomBoxButtonDownFcn(' num2str(updateMode) ')']);
set(hZoomBox, 'lineWidth',     2);     

setappdata(hParentAxes, 'hZBcorners',    [hNE, hSE, hSW, hNW]);
setappdata(hParentAxes, 'hZBchildAxes',  hChildAxes);
setappdata(hParentAxes, 'hZBzoomBox',    hZoomBox);

set(get(hParentAxes,'parent'), 'doublebuffer',  'on')

for i = 1 : length(hChildAxes)
    setappdata(hChildAxes(i), 'hZBparentAxes', hParentAxes);
    set(get(hChildAxes(i),'parent'), 'doublebuffer',  'on')
end

moveCorner(hNE, updateMode);
moveCorner(hSE, updateMode);
moveCorner(hSW, updateMode);
moveCorner(hNW, updateMode);

if updateMode == 1
    set(siblings(hNE),'eraseMode','xor')
end

refreshAxesAndZoomBoxFromAppData(hParentAxes);

function flag = isChildAxes(hAxes)

flag = isAppData(hAxes, 'hZBparentAxes');

function flag = isParentAxes(hAxes)

flag = isAppData(hAxes, 'hZBchildAxes');

function flag = isZoomBoxAxes(hAxes)

flag = isChildAxes(hAxes) | isParentAxes(hAxes);

function destroyChildAxes(hChildAxes)

rmappdata(hChildAxes, 'hZBparentAxes');

function destroyParentAxes(hParentAxes)

rmappdata(hParentAxes, 'hZBchildAxes')
delete(getappdata(hParentAxes, 'hZBcorners'));
delete(getappdata(hParentAxes, 'hZBzoomBox'));

function destroyAxesFamily(hAxes)

if isChildAxes(hAxes)
    hParentAxes = getappdata(hAxes      , 'hZBparentAxes');
elseif isParentAxes(hAxes)
    hParentAxes = hAxes;
end

hChildAxes  = getappdata(hAxes, 'hZBchildAxes');

destroyParentAxes(hParentAxes);
for i = 1 : length(hChildAxes)
   destroyChildAxes(hChildAxes(i));
end

function destroyExistingZoomBoxes(hAxesList);

for i = 1 : length(hAxesList)
    if isZoomBoxAxes(hAxesList(i))
        destroyAxesFamily(hAxesList(i));
    end
end