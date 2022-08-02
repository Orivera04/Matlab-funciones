function [hl,ht]=mmgrid(varargin)
%MMGRID Custom Axis Grids. (MM)
% MMGRID('xyz',V) places grid lines along the axis specified by
% the string 'xyz' at the locations given in the numerical vector V.
% For example, MMGRID('y',[-1 2]) places grid lines at y=-1 and y=2.
% Standard grid lines and tick locations are not changed.
%
% More than one axis or multiple commands for one axis can be specified
% by repeating input arguments: MMGRID('xyz1',V1,'xyz2',V2,...)
%
% If V='on' or 'off', standard grid lines are added or removed.
% For example, MMGRID('x','on') or MMGRID x on  turns the X-axis
% grid on. MMGRID('x','on','y',[-1 2]) turns the standard X-axis grid on
% and places custom grid lines at y=-1 and y=2.
%
% Grid linestyles and color can be specified by adding linespecs to
% the 'xyz' string, e.g., MMGRID('yr-.',[-1 2]) places Red Dash-Dot
% grid lines at y=-1 and y=2.
% If the character 't' appears in the linespec, tick labels are added
% at the custom grid locations. MMGRID('yrt',[-1 2] places Red grid
% lines at y=-1 and y=2 and labels these points along the Y-axis.
%
% Custom grid lines from previous calls to MMGRID are erased.
% MMGRID(H,'xyz',V,...) places grids on the axes having handle H.
% [Hl,Ht]=MMGRID(...) returns the hidden handles to the created
% grid lines and optional tick labels.
%
% MMGRID off or MMGRID(H,'off') removes all custom grids from the axes.

% Calls mmgcf mmgca mmrepeat mmlimit mmempty mmget mmis2d mmprintf

% D.C. Hanselman, University of Maine, Orono ME 04469
% 1/5/00, 1/11/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

narg=nargin;
if narg==0 % standard grid
   grid
   return
elseif ishandle(varargin{1})
   Ha=varargin{1};
   if ~strcmp(get(Ha,'type'),'axes')
      error('Handle Must Point to an Axes Object.')
   end
   varargin(1)=[];
   narg=narg-1;
else
   Hf=mmgcf(1);
   Ha=mmgca(Hf,1); % axes is now known
end
if narg==1 & ischar(varargin{1}) & strcmpi(varargin{1},'off') % off requested
   delete(findall(Ha,'tag','MMGRID'))
   if ~mmis2d(Ha) % restore defaults for 3D axis
      set(Ha,'Xgrid','on','YGrid','on','ZGrid','on','Box','off')
   end
   return
end
if rem(narg,2)~=0
   error('Incorrect Number of Input Arguments.')
end
[GLstyle,Xcolor,Xlim,Ycolor,Ylim,Zcolor,Zlim]=mmget(Ha,'GridLineStyle',...
   'XColor','Xlim','YColor','Ylim','ZColor','Zlim');
Xavg=sum(Xlim)/2;
Yavg=sum(Ylim)/2;
delete(findall(Ha,'tag','MMGRID')) % delete old grids

v.Tag='MMGRID';
v.HandleVisibility='off';
v.Parent=Ha;
t.Units='data';
t.VerticalAlignment='Bottom';
t.HorizontalAlignment='Center';
t.FontSize=get(Ha,'FontSize');
t.FontName=get(Ha,'FontName');
t.Parent=Ha;
t.Tag='MMGRID';
t.HandleVisibility='off';

hhl=[]; % handle storage for output arguments
hht=[];

if mmis2d(Ha) % handle 2D and 3D axes separately
   for i=1:2:narg-1 % scan thru input arguments
      xyz=varargin{i};
      V=varargin{i+1};
      if ~ischar(xyz)
         error('Argument Must be a String.')
      end
      xyz=lower(xyz);
      tick=find(xyz=='t');
      xyz(tick)=[];
      if ischar(V) % turn on standard grid
         if strncmp(xyz,'x',1)
            set(Ha,'Xgrid',V)
         elseif strncmp(xyz,'y',1)
            set(Ha,'YGrid',V)
         else
            error(sprintf('Unknown Input Argument: %s',xyz(1)))
         end
      elseif isnumeric(V) % custom grid specified
         V=V(:).';
         Vlen=length(V);
         if strncmp(xyz,'x',1)
            v.Xdata=mmrepeat(mmlimit(V,Xlim(1),Xlim(2)),6);
            v.Ydata=repmat([Ylim(1) Ylim(2) nan  Yavg    Yavg   nan],1,Vlen);
            [ls,c]=colstyle(xyz(2:end));
            v.LineStyle=mmempty(ls,GLstyle);
            v.Color=mmempty(c,Xcolor);
            hhl=[hhl;line(v)];
            if ~isempty(tick)
               t.Color=v.Color;
               t.VerticalAlignment='Bottom';
               t.HorizontalAlignment='Center';
               s=local_getscale(Ha,'X');
               hht=[hht;text(V.',repmat(Ylim(1),Vlen,1),mmprintf('%.3g',V/s),t)];
            end
         elseif strncmp(xyz,'y',1)
            v.Xdata=repmat([Xlim(1) Xlim(2) nan  Xavg    Xavg   nan],1,Vlen);
            v.Ydata=mmrepeat(mmlimit(V,Ylim(1),Ylim(2)),6);
            [ls,c]=colstyle(xyz(2:end));
            v.LineStyle=mmempty(ls,GLstyle);
            v.Color=mmempty(c,Ycolor);
            hhl=[hhl;line(v)];
            if ~isempty(tick)
               t.Color=v.Color;
               t.VerticalAlignment='Baseline';
               t.HorizontalAlignment='Left';
               s=local_getscale(Ha,'Y');
               hht=[hht;text(repmat(Xlim(1),Vlen,1),V.',mmprintf('%.3g',V/s),t)];
            end
         else
            error('Unknown Axis Direction Specified.')
         end
      else
         error('Argument Must be a String or Numeric.')
      end
   end
else % 3D axes--draw a box at the grid locations
   set(Ha,'Box','on')
   for i=1:2:narg-1 % scan thru input arguments
      xyz=varargin{i};
      V=varargin{i+1};
      if ~ischar(xyz)
         error('Argument Must be a String.')
      end
      xyz=lower(xyz);
      tick=find(xyz=='t');
      xyz(tick)=[];
      if ischar(V) % turn on standard grid
         if strncmp(xyz,'x',1)
            set(Ha,'Xgrid',V)
         elseif strncmp(xyz,'y',1)
            set(Ha,'YGrid',V)
         elseif strncmp(xyz,'z',1)
            set(Ha,'ZGrid',V)
         else
            error(sprintf('Unknown Input Argument: %s',xyz(1)))
         end
      elseif isnumeric(V) % custom grid specified
         V=V(:).';
         Vlen=length(V);
         if strncmp(xyz,'x',1)
            v.Xdata=mmrepeat(mmlimit(V,Xlim(1),Xlim(2)),6);
            v.Ydata=repmat([Ylim(1) Ylim(2) Ylim(2) Ylim(1) Ylim(1) nan],1,Vlen);
            v.Zdata=repmat([Zlim(1) Zlim(1) Zlim(2) Zlim(2) Zlim(1) nan],1,Vlen);
            [ls,c]=colstyle(xyz(2:end));
            v.LineStyle=mmempty(ls,GLstyle);
            v.Color=mmempty(c,Xcolor);
            hhl=[hhl;line(v)];
            if ~isempty(tick)
               t.Color=v.Color;
               s=local_getscale(Ha,'X');
               hht=[hht;text(V.',repmat(Ylim(1),Vlen,1),repmat(Zlim(1),Vlen,1),...
                     mmprintf('%.3g',V/s),t)];
            end
         elseif strncmp(xyz,'y',1)
            v.Xdata=repmat([Xlim(1) Xlim(1) Xlim(2) Xlim(2) Xlim(1) nan],1,Vlen);
            v.Ydata=mmrepeat(mmlimit(V,Ylim(1),Ylim(2)),6);
            v.Zdata=repmat([Zlim(1) Zlim(2) Zlim(2) Zlim(1) Zlim(1) nan],1,Vlen);
            [ls,c]=colstyle(xyz(2:end));
            v.LineStyle=mmempty(ls,GLstyle);
            v.Color=mmempty(c,Ycolor);
            hhl=[hhl;line(v)];
            if ~isempty(tick)
               t.Color=v.Color;
               s=local_getscale(Ha,'Y');
               hht=[hht;text(repmat(Xlim(1),Vlen,1),V.',repmat(Zlim(1),Vlen,1),...
                     mmprintf('%.3g',V/s),t)];
            end
         elseif strncmp(xyz,'z',1)
            v.Xdata=repmat([Xlim(1) Xlim(1) Xlim(2) Xlim(2) Xlim(1) nan],1,Vlen);
            v.Ydata=repmat([Ylim(2) Ylim(1) Ylim(1) Ylim(2) Ylim(2) nan],1,Vlen);
            v.Zdata=mmrepeat(mmlimit(V,Zlim(1),Zlim(2)),6);
            [ls,c]=colstyle(xyz(2:end));
            v.LineStyle=mmempty(ls,GLstyle);
            v.Color=mmempty(c,Zcolor);
            hhl=[hhl;line(v)];
            if ~isempty(tick)
               t.Color=v.Color;
               s=local_getscale(Ha,'Z');
               hht=[hht text(repmat(Xlim(1),Vlen,1),repmat(Ylim(1),Vlen,1),V.',...
                     mmprintf('%.3g',V/s),t)];
            end
         else
            error('Unknown Axis Direction Specified.')
         end
      else
         error('Argument Must be a String or Numeric.')
      end
   end
end  
if nargout~=0
   hl=hhl;
   ht=hht;
end
%----------------------------------
function s=local_getscale(Ha,axis)
% get axis scaling
tmode=sprintf('%sTickMode',axis);
tlabel=sprintf('%sTickLabel',axis);
tnum=sprintf('%sTick',axis);
[tm,tl,tn]=mmget(Ha,tmode,tlabel,tnum);
if strcmp(tm,'manual')  % scaling can't be determined
   s=1;
elseif tn(end)~=0       % get scaling from last tick
   s=tn(end)/str2double(tl(end,:));
else                    % get scaling from first tick
   s=tn(1)/str2double(tl(1,:));
end