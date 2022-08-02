function h=mmtext(arg)
%MMTEXT Place and Drag Text with Mouse. (MM)
% MMTEXT waits for a mouse click on a text object in the current figure
% then allows it to be dragged while the mouse button remains down.
%
% MMTEXT('whatever') places the string 'whatever' on the current axes
% and allows it to be dragged with the mouse
%
% Ht=MMTEXT('whatever') returns the handle to the text object.
%
% MMTEXT becomes inactive after the move is complete or no text
% object is selected.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 6/22/95, v5: 1/14/97, 9/1/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0, arg=0; end

if ischar(arg)  % user entered text to be placed
   Ht=text('Units','normalized',...
      'Position',[.5 .5],...
      'String',arg,...
      'HorizontalAlignment','center',...
      'VerticalAlignment','middle');
   if nargout>0, h=Ht; end
   mmtext(0)  % call mmtext again to drag it
   
elseif arg==0  % initial call, select text for dragging
   Hf=get(0,'CurrentFigure');
   if isempty(Hf)
      error('No Figure Window Exists.')
   end
   set(Hf,'BackingStore','off',...
      'DoubleBuffer','on',...
      'WindowButtonDownFcn','mmtext(1)')
   figure(Hf)  % bring figure forward
   
elseif arg==1 & strcmp(get(gco,'type'),'text') % text object selected
   set(gco,'Units','data',...
      'HorizontalAlignment','left',...
      'VerticalAlignment','baseline');
   set(gcf,'Pointer','topr',...
      'WindowButtonMotionFcn','mmtext(2)',...
      'WindowButtonUpFcn','mmtext(99)')
   
elseif arg==2  % dragging text object
   cp=get(gca,'CurrentPoint');
   set(gco,'Position',cp(1,1:3))
   
else		% mouse button up or incorrect object selected, reset
   set(gcf,'WindowButtonDownFcn','',...
      'WindowButtonMotionFcn','',...
      'WindowButtonUpFcn','',...
      'Pointer','arrow',...
      'DoubleBuffer','on',...
      'BackingStore','on')
end
