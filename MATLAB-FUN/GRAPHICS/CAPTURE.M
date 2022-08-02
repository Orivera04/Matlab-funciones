function [XX,map] = capture(fig)
%CAPTURE Screen capture of the current figure.
%	CAPTURE(FIG) makes a new figure containing a copy of the specified
%	figure, including any uimenus and uicontrols.
%	CAPTURE, without any input arguments, captures the current figure.
%
%	CAPTURE is often followed by PRINT to produce hard copy.  Since this
%	is only a bitmap copy of the screen image, the resolution will not
%	be as good as PRINT applied to the original figure, but it will
%	include the overlaying menus and controls.
%
%	[X,map] = CAPTURE returns an image matrix and a color map without
%	displaying it.
%
%	See also PRINT, IMAGE.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Make sure all the figure is visible.
if nargin < 1, fig = gcf; end
figure(fig);

c = computer;
if strcmp(c(1:2),'PC') | strcmp(c(1:3),'MAC')
   [XX,map] = getframe(fig);
   return
end

% Is there a menubar?
menubar = 0;
for c = get(fig,'child')';
   menubar = strcmp(get(c,'type'),'uimenu');
   if menubar, break, end
end

% Obtain image and colormap from the graphics root.
groot = 0;
units = get(fig,'units');
set(fig,'units','pixels');
pos = get(fig,'pos') + [0 0 0 29*menubar];
set(fig,'units',units);
set(groot,'capturerect',pos);
X = get(groot,'capturemat');
map = get(groot,'capturemap');
m = max(max(X));
map = map(1:m,:);

% Either display the image, or return it.
if nargout == 0
   figure('pos',pos,'mincolor',m,'colormap',map);
   h = axes('pos',[0 0 1 1]);
   image(X)
   set(h,'visible','off')
   clear X
else
   XX = X;
end
