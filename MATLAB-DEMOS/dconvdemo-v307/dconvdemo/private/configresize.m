function configresize(hFig)
%CONFIGRESIZE Configure GUI to handle resizing operations.
%   CONFIGRESIZE(hFig) changes the units and fontunits of all objects that support these
%   units to 'normalized'.  Then, when a figure is resized all objects are resized
%   accordingly.  
%
%   This function should be used in conjunction with the RESIZEFCN function.
%
%   See also RESIZEFCN

% Jordan Rosenthal, 22-Jun-99

error(nargchk(1,1,nargin));

%-------------------------------------------------------------------------------
% Get handles
%-------------------------------------------------------------------------------
hAxes       = findall(hFig,'type','axes');
hText       = findall(hAxes,'type','text');
hUIControls = findall(gcf,'type','uicontrol');
hUIText     = findall(hUIControls,'style','text');
hUIFrames   = findall(hUIControls,'style','frame');

%-------------------------------------------------------------------------------
% Set objects to normalized units
%-------------------------------------------------------------------------------
set([hAxes; hText; hUIControls],'units','normalized','fontunits','normalized');