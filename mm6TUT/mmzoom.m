function [Hza,Hzl]=mmzoom(arg)
%MMZOOM Picture in a Picture Zoom. (MM)
% MMZOOM creates a new axes containing the data inside a box
% formed by a click and drag with the mouse in the current axes.
% The new zoomed axes is placed in the upper left of the current axes,
% but can be moved with the mouse. Clicking in the figure border or
% issuing MMZOOM RESET disables dragging. MMZOOM DRAG reenables dragging.
%
% MMZOOM SUBPLOT or MMZOOM('SUBPLOT') creates the zoomed axes as a
% subplot below the original axes. The original axes must not itself
% be a subplot.
%
% MMZOOM(Ha) use the axes having handle Ha.
%
% Previous axes created by MMZOOM are deleted if MMZOOM is called again.
%
% [Hza,Hzl]=MMZOOM returns handles to the created axes and line marking
% the zoomed area respectively.
%
% MMZOOM OFF removes the created zoom axes and line marking the zoom area.

% Calls: mmget mmgetpos mmbox mmputptr

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 3/11/00
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0
   arg=[];
end
if isnumeric(arg) % zoom requested
   Hz=findobj(0,'Tag','MMZOOM');
   if ~isempty(Hz)   % delete prior zoomed axes if it exists
      delete(Hz)
   end
   p=mmbox(arg);  % get rubberband box for zoom
   if ~isempty(p)
      Ha=gca;
      Hzl=line('Parent',Ha,'Xdata',p([1 1 2 2 1]),... % draw zoom box
         'Ydata',p([3 4 4 3 3]),...
         'Color',[0 0 0],...
         'LineStyle',':',...
         'Tag','MMZOOM');
      Hf=get(Ha,'Parent');
      Hz=copyobj(Ha,gcf);        % copy original axes
      Pa=mmgetpos(Ha,'Normalized');
      alpha=1/3; beta=.025;      % shrink and shift copy
      Pa=[Pa(1)+beta Pa(2)+(1-alpha)*Pa(4)+beta alpha*Pa(3:4)];
      Pf=mmgetsiz(Ha,'points');
      set(Hz,'units','Normalized',...     % revise zoomed properties
         'Position',Pa,...                % position
         'Xlim',p(1:2),'Ylim',p(3:4),...  % axis limits
         'Box','on',...                   % axis box on
         'Xgrid','off','Ygrid','off',...  % grid lines off
         'FontUnits','points',...
         'FontSize',max(6,Pf-2),...       % shrink font size
         'ButtonDownFcn','selectmoveresize',...% enable drag
         'Tag','MMZOOM',...               % tag zoomed axes
         'UserData',Ha)                   % store original axes handle
      [Htx,Hty,Htt]=mmget(Hz,'Xlabel','Ylabel','Title');
      set([Htx,Hty,Htt],'String','')      % delete labels on zoomed axes
      set(Ha,'DeleteFcn',...              % delete both axes together
         'delete(findobj(0,''Type'',''axes'',''Tag'',''MMZOOM''))')
      hc=get(Hf,'Children');
      hc(hc==Hz)=[];
      set(Hf,'Children',[Hz;hc],...       % put zoom axes at top of stack
         'CurrentAxes',Ha,...             % make original axes current
         'ButtonDownFcn','mmzoom reset')  % enable reset
      mmputptr(Hz)   % place pointer in zoom axes
      if nargout>=1  % give output if there
         Hza=Hz;
      end
   end
elseif strncmpi(arg,'s',1) % subplot zoom requested
   Hz=findobj(0,'Tag','MMZOOM');
   if ~isempty(Hz)   % delete prior zoomed axes if it exists
      delete(Hz)
   end
   p=mmbox;  % get rubberband box for zoom
   if ~isempty(p)
      Ha=gca;
      Hzl=line('Parent',Ha,'Xdata',p([1 1 2 2 1]),... % draw zoom box
         'Ydata',p([3 4 4 3 3]),...
         'Color',[0 0 0],...
         'LineStyle',':',...
         'Tag','MMZOOM');
      set(Ha,'Units','Normalized',...  % original axes as subplot(2,1,1)
         'Position',[0.13 0.5811 0.775 0.3439],...
         'DeleteFcn',...               % delete both axes together
         'delete(findobj(0,''Type'',''axes'',''Tag'',''MMZOOM''))')
      Hf=get(Ha,'Parent');
      Hz=copyobj(Ha,gcf);        % copy original axes
      set(Hz,'Units','Normalized',...           % revise zoomed properties
         'Position',[0.13 0.11 0.775 0.3439],...% subplot(2,1,2) position
         'Xlim',p(1:2),'Ylim',p(3:4),...        % axis limits
         'ButtonDownFcn','selectmoveresize',... % enable drag
         'Tag','MMZOOM',...                     % tag zoomed axes
         'UserData',Ha)                         % store original axes handle
      set(get(Hz,'Title'),'String','Boxed Area in Above Plot');
      hc=get(Hf,'Children');
      hc(hc==Hz)=[];
      set(Hf,'Children',[Hz;hc],...       % put zoom axes at top of stack
         'CurrentAxes',Ha,...             % make original axes current
         'ButtonDownFcn','mmzoom reset')  % enable reset
      mmputptr(Hz)   % place pointer in zoom axes
      if nargout>=1  % give output if there
         Hza=Hz;
      end
   end
elseif strncmpi(arg,'d',1) % drag zoom axes requested
   Hz=findobj(0,'Type','axes','Tag','MMZOOM');
   if ~isempty(Hz)
      set(Hz,'ButtonDownFcn','selectmoveresize')
   end
elseif strncmpi(arg,'r',1) % reset request
   Hz=findobj(0,'Type','axes','Tag','MMZOOM');
   if ~isempty(Hz)
      Hf=get(Hz,'Parent');
      Ha=get(Hz,'UserData');
      set(Hz,'ButtonDownFcn','','Selected','off')  % turn off selection
      set(Hf,'ButtonDownFcn','','CurrentAxes',Ha)  % make Ha current
   end
elseif strncmpi(arg,'o',1)  % off request
   Hz=findobj(0,'Tag','MMZOOM');
   if ~isempty(Hz)
      delete(Hz)
   end
else
   error('Unknown Input Argument.')
end




