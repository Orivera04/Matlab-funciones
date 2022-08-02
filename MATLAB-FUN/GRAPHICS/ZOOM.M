function zoom(m)
%ZOOM	Zoom in and out on a 2-D plot.
%	ZOOM ON turns zoom on for the current figure.  Click 
%	the left mouse button to zoom in on the point under the 
%	mouse.  Click the right mouse button to zoom out 
%	(shift-click on the Macintosh).  Each time you click, 
%	the axes limits will be changed by a factor of 2 (in or out).
%	You can also click and drag to zoom into an area.
%	
%	ZOOM OFF turns zoom off. ZOOM with no arguments 
%	toggles the zoom status.  ZOOM OUT returns the plot
%	to its initial (full) zoom.

%	Clay M. Thompson 1-25-93
%	Revised 11 Jan 94 by Steven L. Eddins
%	Copyright (c) 1984-94 by The MathWorks, Inc.
%	$Revision: 1.10 $  $Date: 1994/02/14 17:00:34 $

%	Note: zoom uses the userdata of the zlabel of the axis and
%	the figure buttondown and buttonmotion functions

if any(get(gca,'view')~=[0 90]), error('Only works for 2-D plots'); end

getlimits = 1; rbbox_mode = 0;
if nargin==0, % Toggle buttondown function
   if strcmp(get(gcf,'windowbuttondownfcn'),'zoom(''down'')'),
      set(gcf,'windowbuttondownfcn','','windowbuttonupfcn','', ...
              'windowbuttonmotionfcn','');
   else
      set(gcf,'windowbuttondownfcn','zoom(''down'')', ...
              'windowbuttonupfcn','1;', ...
              'windowbuttonmotionfcn','', ...
              'interruptible','yes');
      set(gca,'interruptible','yes')
      figure(gcf)
   end
   return

elseif nargin==1, % Process call backs
  if isstr(m),
    m = lower(m);
    if strcmp(m,'down'),
      % Activate axis that is clicked in
      ax = get(gcf,'Children');
      ZOOM_found = 0;
      for i=1:length(ax),
        if strcmp(get(ax(i),'Type'),'axes'),
          ZOOM_Pt1 = get(ax(i),'CurrentPoint');
          xlim = get(ax(i),'XLim');
          ylim = get(ax(i),'YLim');
          if (xlim(1) <= ZOOM_Pt1(1,1) & ZOOM_Pt1(1,1) <= xlim(2) & ...
              ylim(1) <= ZOOM_Pt1(1,2) & ZOOM_Pt1(1,2) <= ylim(2))
            ZOOM_found = 1;
            axes(ax(i))
            break
          end
        end
      end

      if ZOOM_found==0, return, end

      % Check for selection type
      selection_type = get(gcf,'SelectionType');
      if (strcmp(selection_type, 'normal'))
        % Zoom in
        m = 1;
      elseif (strcmp(selection_type, 'open'))
        % Zoom all the way out
        zoom('out');
        return;
      else
        % Zoom partially out
        m = -1;
      end
      
      ZOOM_Pt1 = get(gca,'currentpoint');
      ZOOM_Pt2 = ZOOM_Pt1;
      center = ZOOM_Pt1(1,1:2);
      
      if (m == 1)
        % Zoom in
        rbbox([get(gcf,'currentpoint') 0 0],get(gcf,'currentpoint'))
        ZOOM_Pt2 = get(gca,'currentpoint');

        % Note the currenpoint is set by having a non-trivial up function.
        if min(abs(ZOOM_Pt1(1,1:2)-ZOOM_Pt2(1,1:2))) >= ...
	      min(.01*[diff(get(gca,'xlim')) diff(get(gca,'ylim'))]),
          % determine axis from rbbox 
          a = [ZOOM_Pt1(1,1:2);ZOOM_Pt2(1,1:2)]; a = [min(a);max(a)];
          rbbox_mode = 1;
        end
      end
      limits = get(get(gca,'ZLabel'),'UserData');
      if all(size(limits)==[1 4]), % Do simple checking of userdata
        if all(limits([1 3])<limits([2 4])), 
          getlimits = 0; 
        else
          getlimits = -1; % Don't munge data
        end
      else
        if isempty(limits), getlimits = 1; else getlimits = -1; end
      end

    elseif strcmp(m,'on'),
      set(gcf,'windowbuttondownfcn','zoom(''down'')', ...
              'windowbuttonupfcn','1;', ...
              'windowbuttonmotionfcn','',...
              'interruptible','yes');
      set(gca,'interruptible','yes')
      figure(gcf)       
      return

    elseif strcmp(m,'off'),
      set(gcf,'windowbuttondownfcn','','windowbuttonupfcn','',...
              'windowbuttonmotionfcn','');
      return

    elseif strcmp(m,'out'),
      limits = get(get(gca,'ZLabel'),'UserData');
      if all(size(limits)==[1 4]), % Do simple checking of userdata
        if all(limits([1 3])<limits([2 4])), 
          getlimits = 0; 
        else
          getlimits = -1; % Don't munge data
        end
      else
        if isempty(limits), getlimits = 1; else getlimits = -1; end
      end

      center = [sum(get(gca,'Xlim'))/2 sum(get(gca,'Ylim'))/2];
      m = -inf; % Zoom totally out
    else
      error(['Unknown option: ',m,'.']);
    end

  else
    error('Only takes the strings ''on'',''off'', or ''out''.')
  end
end

% Determine which IMAGE coordinate system is being used.
s = [version '    ']; k = find(s<46 & s>58);
if ~isempty(k), s = s(1:min(k)); end
[ver,count,msg,next] = sscanf(s,'%f',1);
if ver > 4.1,
  useNew = 1;
elseif ver < 4.1,
  useNew = 0;
else
  if s(next)>='a', useNew = 1; else useNew = 0; end
end
  
if getlimits~=0,  % Get min and max info for axis children

  if isempty(get(get(gca,'ZLabel'),'userdata')),
    % Use quick method if possible
    xlim = get(gca,'xlim'); xmin = xlim(1); xmax = xlim(2); 
    ylim = get(gca,'ylim'); ymin = ylim(1); ymax = ylim(2); 

  else

    % Use slow method only if someone else is using the userdata
    h = get(gca,'Children');
    xmin = inf; xmax = -inf; ymin = inf; ymax = -inf;
    for i=1:length(h),
      t = get(h(i),'Type');
      if ~strcmp(t,'text'),
        if strcmp(t,'image') & useNew, % Determine axis limits for image
          x = get(h(i),'Xdata'); y = get(h(i),'Ydata');
          x = [min(min(x)) max(max(x))];
          y = [min(min(y)) max(max(y))];
          [ma,na] = size(get(h(i),'Cdata'));
          if na>1, dx = diff(x)/(na-1); else dx = 1; end
          if ma>1, dy = diff(y)/(ma-1); else dy = 1; end
          x = x + [-dx dx]/2; y = y + [-dy dy]/2;
        else
          x = get(h(i),'Xdata'); y = get(h(i),'Ydata');
        end
        xmin = min(xmin,min(min(x)));
        xmax = max(xmax,max(max(x)));
        ymin = min(ymin,min(min(y)));
        ymax = max(ymax,max(max(y)));
      end
    end

    % Use automatic limits if in use.
    if strcmp(get(gca,'xLimMode'),'auto'),
      xlim = get(gca,'xlim'); xmin = xlim(1); xmax = xlim(2); 
    end
    if strcmp(get(gca,'yLimMode'),'auto'),
      ylim = get(gca,'ylim'); ymin = ylim(1); ymax = ylim(2); 
    end
  end

  limits = [xmin xmax ymin ymax];
  if getlimits~=-1, % Don't munge existing userdata.
    set(get(gca,'ZLabel'),'UserData',limits); % Store limits in ZLabel userdata
  end
end

%
% Actual zoom operation
%
if rbbox_mode,
  axis(a(:)')
else
  xmin = limits(1); xmax = limits(2); ymin = limits(3); ymax = limits(4);
  if m==(-inf),
    dx = xmax-xmin;
    dy = ymax-ymin;
  else
    dx = diff(get(gca,'Xlim'))*(2.^(-m-1)); dx = min(dx,xmax-xmin);
    dy = diff(get(gca,'Ylim'))*(2.^(-m-1)); dy = min(dy,ymax-ymin);
  end

  % Limit zoom.
  center = max(center,[xmin ymin] + [dx dy]);
  center = min(center,[xmax ymax] - [dx dy]);
  axis([max(xmin,center(1)-dx) min(xmax,center(1)+dx) ...
       max(ymin,center(2)-dy) min(ymax,center(2)+dy)])
end
