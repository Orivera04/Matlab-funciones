function h=mmtext7(arg)
%MMTEXT7 Place and Drag Text with Mouse.
% MMTEXT7 waits for a mouse click on a text object in the current figure
% then allows it to be dragged while the mouse button remains down.
%
% MMTEXT7('whatever') places the string 'whatever' on the current axes
% and allows it to be dragged with the mouse
%
% Ht = MMTEXT7('whatever') returns the handle to the text object.
%
% MMTEXT7 becomes inactive after the move is complete or no text
% object is selected.

if nargin==0       % call subfunction to set up string drag
   local_mmtext_init
   
elseif ischar(arg) % user entered text to be placed
   
   Ht = text('Units','normalized',...
             'Position',[.5 .5],...
             'String',arg,...
             'HorizontalAlignment','center',...
             'VerticalAlignment','middle');

   if nargout>0, h=Ht; end
   local_mmtext_init     % call subfunction to set up string drag
else
   error('String Input Expected.')
end
%--------------------------------------------------------
function local_mmtext_init(cbo,eventdata)
% two input arguments required even if not used
   
   Hf = get(0,'CurrentFigure');
   if isempty(Hf)
      error('No Figure Window Exists.')
   end
   set(Hf,'BackingStore','off',... % speed up rendering
          'DoubleBuffer','on',...  % get rid of screen flicker
          'WindowButtonDownFcn',@local_mmtext_down)
   figure(Hf)  % bring figure forward
   
%---------------------------------------------------------------
function local_mmtext_down(cbo,eventdata)
% two input arguments required even if not used

if strcmp(get(gco,'type'),'text') % text object selected
   
   set(gco,'Units','data',...
           'HorizontalAlignment','left',...
           'VerticalAlignment','baseline');
   set(gcf,'Pointer','topr',...
           'WindowButtonMotionFcn',@local_mmtext_drag,...
           'WindowButtonUpFcn',@local_mmtext_up)
else
   local_mmtext_up % reset everything
end
			
%---------------------------------------------------------------
function local_mmtext_drag(cbo,eventdata) % dragging text object
% two input arguments required even if not used

cp = get(gca,'CurrentPoint'); % get current mouse point
set(gco,'Position',cp(1,1:3)) % move text to the current point

%---------------------------------------------------------------
function local_mmtext_up(cbo,eventdata) % reset everything
% two input arguments required even if not used

set(gcf,'WindowButtonDownFcn','',...
        'WindowButtonMotionFcn','',...
        'WindowButtonUpFcn','',...
        'Pointer','arrow',...
        'DoubleBuffer','off',...
        'BackingStore','on')
