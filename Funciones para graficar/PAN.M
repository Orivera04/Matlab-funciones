% PAN adds pan pushbuttons to plots.
% function PAN adds pushbuttons to the current plot to allow
% the user to pan the x and y axes left, right, up, and down.
%     pan, pan on, pan('on') == begin panning
%     pan off, pan('off') == stop panning
%     pan(0.1) == set step size to 10% of axis size
% The default step size is 20% of the current axis size.
% If the figure contains multiple axes (e.g. subplots), all of
% the axes are panned simultaneously in the same direction.
%
% Example:
%    plot(rand(1,100));
%    pan on; pan(0.3);
% enables horizontal and vertical panning.  Each time a pan button
% is pushed, the axis moves 30% of the current axis length.

% Version 1.0
% Mark W. Brown
% mwbrown@ieee.org

function pan(action)

if nargin < 1
  action = 'on';
end

if strcmp(action,'on');
  hleft = uicontrol('style','push','pos',[10 10 20 20],'TooltipString','Pan Left',...
          'callback','pan(''left'');','fontname','symbol','string',char(172));
  hright = uicontrol('style','push','pos',[30 10 20 20],'TooltipString','Pan Right',...
          'callback','pan(''right'');','fontname','symbol','string',char(174));
  hup = uicontrol('style','push','pos',[10 30 20 20],'TooltipString','Pan Up',...
          'callback','pan(''up'');','fontname','symbol','string',char(173));
  hdown = uicontrol('style','push','pos',[30 30 20 20],'TooltipString','Pan Down',...
          'callback','pan(''down'');','fontname','symbol','string',char(175));
  setappdata(gcf,'PanIncrement',0.2);
  setappdata(gcf,'PanHandles',[hleft hright hup hdown]);
  set(gcf,'ToolBar','figure');
  
elseif strcmp(action,'off');
  delete(getappdata(gcf,'PanHandles'));
  rmappdata(gcf,'PanIncrement');
  rmappdata(gcf,'PanHandles');
  
elseif strcmp(action,'left');
  step = getappdata(gcf,'PanIncrement');
  HAX = findobj(gcf,'type','axes');
  for ii=1:length(HAX)
    h = HAX(ii);
    XL = get(h,'xlim');
    set(h,'xlim',XL-step*(XL(2)-XL(1)));
  end
  
elseif strcmp(action,'right');
  step = getappdata(gcf,'PanIncrement');
  HAX = findobj(gcf,'type','axes');
  for ii=1:length(HAX)
    h = HAX(ii);
    XL = get(h,'xlim');
    set(h,'xlim',XL+step*(XL(2)-XL(1)));
  end
  
elseif strcmp(action,'up');
  step = getappdata(gcf,'PanIncrement');
  HAX = findobj(gcf,'type','axes');
  for ii=1:length(HAX)
    h = HAX(ii);
    YL = get(h,'ylim');
    set(h,'ylim',YL+step*(YL(2)-YL(1)));
  end
  
elseif strcmp(action,'down');
  step = getappdata(gcf,'PanIncrement');
  HAX = findobj(gcf,'type','axes');
  for ii=1:length(HAX)
    h = HAX(ii);
    YL = get(h,'ylim');
    set(h,'ylim',YL-step*(YL(2)-YL(1)));
  end
  
elseif ~isstr(action)
  setappdata(gcf,'PanIncrement',action);
end
