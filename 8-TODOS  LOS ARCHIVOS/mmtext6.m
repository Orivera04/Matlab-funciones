function h=mmtext6(arg)
%MMTEXT6 Place and Drag Text with Mouse.
% MMTEXT6 waits for a mouse click on a text object in the current figure
% then allows it to be dragged while the mouse button remains down.
%
% MMTEXT6('whatever') places the string 'whatever' on the current axes
% and allows it to be dragged with the mouse
%
% Ht=MMTEXT6('whatever') returns the handle to the text object.
%
% MMTEXT6 becomes inactive after the move is complete or no text
% object is selected.

if nargin==0, arg=0; end

if ischar(arg)  % user entered text to be placed
   Ht = text('Units','normalized',...
             'Position',[.5 .5],...
             'String',arg,...
             'HorizontalAlignment','center',...
             'VerticalAlignment','middle');
	if nargout>0, h=Ht; end
	mmtext6(0)  % call mmtext again to drag it
	
elseif arg==0  % initial call, select text for dragging
   Hf = get(0,'CurrentFigure');
   if isempty(Hf)
      error('No Figure Window Exists.')
   end
	set(Hf,'BackingStore','off',... % speed up rendering
          'DoubleBuffer','on',...  % get rid of screen flicker
          'WindowButtonDownFcn','mmtext6(1)')
   figure(Hf)  % bring figure forward

elseif arg==1 & strcmp(get(gco,'type'),'text') % text object selected
	set(gco,'Units','data',...
           'HorizontalAlignment','left',...
           'VerticalAlignment','baseline');
	set(gcf,'Pointer','topr',...
           'WindowButtonMotionFcn','mmtext6(2)',...
           'WindowButtonUpFcn','mmtext6(99)')
			
elseif arg==2  % dragging text object
	cp = get(gca,'CurrentPoint');
	set(gco,'Position',cp(1,1:3))
	
else		% mouse button up or incorrect object selected, reset everything
	set(gcf,'WindowButtonDownFcn','',...
           'WindowButtonMotionFcn','',...
           'WindowButtonUpFcn','',...
           'Pointer','arrow',...
           'DoubleBuffer','on',...
           'BackingStore','on')
end
