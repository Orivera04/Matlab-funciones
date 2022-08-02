function out=mmxy(arg)
%MMXY Show and Get x-y Coordinates Using Mouse.
% MMXY shows the coordinates of the pointer location over the
% the current axes. Clicking the mouse button returns the
% coordinates at the pointer location.

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 6/29/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

persistent xy

if nargin==0 % initialize
   Hf=get(0,'CurrentFigure');
   if isempty(Hf) % do nothing if there is no figure
      return
   end
   Ha=get(Hf,'CurrentAxes');
   if isempty(Ha) % do nothing if there is no axes
      return
   end
   v=get(gca,'view');
   if any(v~=[0 90])
      error('MMXY works only for 2-D axes.')
   end
   xlim=get(gca,'XLim'); % get axes limits
   ylim=get(gca,'YLim');
   xy=[sum(xlim) sum(ylim)]/2;
   text('Parent',gca,... % create text to display coordinates
      'Position',xy,...
      'HorizontalAlignment','left',...
      'VerticalAlignment','bottom',...
      'Tag','MMXYtext')
   set(Hf,'Pointer','crossh',...        % change pointer
      'DoubleBuffer','on',...       % eliminate flickering
      'WindowButtonMotionFcn','mmxy move',... % motion callback
      'WindowButtonDownFcn','mmxy done')      % end callback
   figure(Hf) % bring current figure forward
   
   tf=waitforbuttonpress; % sit and wait for button press
   if ~tf % button press so return data
      out=xy;
   end
   
elseif strcmp(arg,'move') %'WindowButtonMotionFcn' callback
   cp=get(gca,'CurrentPoint'); % current mouse position
   xy=cp(1,1:2);
   Ht=findobj(gca,'Type','text','Tag','MMXYtext');
   set(Ht,'Position',xy,...
      'String',sprintf('x=  %.2g\ny= %.2g',xy))
   
elseif strcmp(arg,'done') % mouse click occurred, clean things up
   Ht=findobj(gca,'Type','text','Tag','MMXYtext');
   delete(Ht)
   set(gcf,'Pointer','arrow',...
      'DoubleBuffer','off',...
      'WindowButtonMotionFcn','',...
      'WindowButtonDownFcn','')
end