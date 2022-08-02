function [Hza,Hzr]=mmzoom(arg)
%MMZOOM Picture in a Picture Zoom.
% MMZOOM creates a new axes containing the data inside a box formed by a
% click and drag with the mouse in the current axes. The new zoomed axes
% is placed in the upper right of the current axes, but can be moved with
% the mouse. Clicking in the figure border disables dragging.
%
% Previous axes created by MMZOOM are deleted if MMZOOM is called again.
%
% [Hza,Hzr] = MMZOOM returns handles to the created axes and rectangle
% marking the zoomed area respectively.
%
% MMZOOM DRAG enables dragging of a zoomed axes.
% MMZOOM RESET disables dragging of a zoomed axes.
% MMZOOM OFF removes the zoomed axes and rectangle marking the zoomed area.

if nargin==0
   arg = [];
end
if isempty(arg) % zoom zoom zoom zoom zoom zoom zoom zoom zoom zoom zoom
   
   Hzoom = findobj(0,'Tag','MMZOOM'); % find previous zoomed axes
   if ~isempty(Hzoom)   % delete prior zoomed axes if it exists
      delete(Hzoom)
   end
   
   [xlim,ylim,prect] = getbox;  % get selection box for zoom
   
   if ~isempty(prect) % create axes if rectangle exists
      Haxes = gca; % handle of axes where selection box was drawn
      Hzr = rectangle('Position',prect,... % place rectangle object
         'Linestyle',':',...               % to mark selection box
         'Tag','MMZOOM');

      Hfig = gcf; % handle of Figure where selection box was drawn
      Hzoom = copyobj(Haxes,Hfig); % copy original axes and its children

      OldUnits = get(Haxes,'Units');  % get position vector of original
      set(Haxes,'Units','normalized') % axes in normalized units
      Pvect = get(Haxes,'Position');
      set(Haxes,'Units',OldUnits)

      % scale and shift zoomed axes relative to original axes
      alpha = 1/3;   % position scaling for zoomed axes
      beta = 98/100; % position shift for zoomed axes

      % compute position vector for zoomed axes
      Zwidth = alpha*Pvect(3);                  % zoomed axes width
      Zheight = alpha*Pvect(4);                 % zoomed axes height
      Zleft = Pvect(1)+beta*Pvect(3)-Zwidth;    % zoomed axes left
      Zbottom = Pvect(2)+beta*Pvect(4)-Zheight; % zoomed axes bottom

      % modify zoomed axes as required
      set(Hzoom,'units','Normalized',...            % make units normalized
         'Position',[Zleft Zbottom Zwidth Zheight],...% axes position
         'Xlim',xlim,'Ylim',ylim,...                % axis data limits
         'Box','on',...                             % axis box on
         'Xgrid','off','Ygrid','off',...            % grid lines off
         'FontUnits','points',...
         'FontSize',8,...                           % shrink font size
         'ButtonDownFcn',@selectmoveresize,...      % enable drag
         'Tag','MMZOOM',...                         % tag zoomed axes
         'UserData',Haxes)                          % store original axes

      [Htx,Hty,Htt] = getn(Hzoom,'Xlabel','Ylabel','Title');
      set([Htx,Hty,Htt],'String','')      % delete labels on zoomed axes

      set(Haxes,'DeleteFcn',...           % delete both axes together
         'delete(findobj(0,''Type'',''axes'',''Tag'',''MMZOOM''))')

      % place zoomed axes at top of object stack
      Hchild = findobj(Hfig,'type','axes'); % get all axes in figure
      Hchild(Hchild==Hzoom) = [];           % remove zoomed axes from list

      set(Hfig,'Children',[Hzoom;Hchild],...% put zoom axes at top of stack
         'CurrentAxes',Haxes,...            % make original axes current
         'ButtonDownFcn','mmzoom reset')    % enable reset

      if nargout>=1  % provide output only if requested
         Hza = Hzoom;
      end
   end
   
elseif strncmpi(arg,'d',1) % drag zoom axes drag zoom axes drag zoom axes
   
   Hzoom = findobj(0,'Type','axes','Tag','MMZOOM');
   if ~isempty(Hzoom)
      set(Hzoom,'ButtonDownFcn',@selectmoveresize)
   end
   
elseif strncmpi(arg,'r',1) % reset reset reset reset reset reset reset
   
   Hzoom = findobj(0,'Type','axes','Tag','MMZOOM');
   if ~isempty(Hzoom)
      [Hfig,Haxes] = getn(Hzoom,'Parent','UserData');
      set(Hzoom,'ButtonDownFcn','','Selected','off')% turn off selection
      set(Hfig,'CurrentAxes',Haxes)                 % make Haxes current
   end
   
elseif strncmpi(arg,'o',1)  % off off off off off off off off off off off
   
   Hzoom = findobj(0,'Tag','MMZOOM');
   if ~isempty(Hzoom)
      delete(Hzoom)
   end
else
   error('Unknown Input Argument.')
end