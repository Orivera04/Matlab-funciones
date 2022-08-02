function [cout,hand] = mbccontour(ax,varargin)
%MBCCONTOUR Contour plot.
%
% Similar to "contour", but first parameter must be the handle
% to the parent axes
% 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $

if ~ishandle(ax) | ~strcmp(get(ax,'type'),'axes')
    error('First parameter to mbccontour must be a handle to axes');
end

error(nargchk(2,6,nargin));

nin = nargin-1;
if isstr(varargin{end})
    nin = nin - 1;
end

if nin <= 2,
    [mc,nc] = size(varargin{1});
    lims = [1 nc 1 mc];
else
    lims = [min(varargin{1}(:)),max(varargin{1}(:)), ...
            min(varargin{2}(:)),max(varargin{2}(:))];
end

[c,h,msg] = i_contour(ax,varargin{:});
if ~isempty(msg), error(msg); end

for i = 1:length(h)
  set(h(i),'Zdata',[]);
end

view(ax,2);
set(ax,'box','on');

if nargout > 0
    cout = c;
    hand = h;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%
function [cout,h,msg] = i_contour(ax,varargin)
% This is almost a straight copy of contour3, but with
% the extra first argument.

error(nargchk(2,6,nargin));
msg = [];

% Check for empty arguments.
for i = 1:nargin-1
  if isempty(varargin{i})
    error ('Invalid Argument - Input matrix is empty');
  end
end

% Trim off the last arg if it's a string (line_spec).
nin = nargin-1;
if isstr(varargin{end})
  [lin,col,mark,msg] = colstyle(varargin{end});
  if ~isempty(msg), error(msg); end
  nin = nin - 1;
else
  lin = '';
  col = '';
end

if nin <= 2,
    [mc,nc] = size(varargin{1});
    lims = [1 nc 1 mc];
else
    lims = [min(varargin{1}(:)),max(varargin{1}(:)), ...
            min(varargin{2}(:)),max(varargin{2}(:))];
end

if isempty(col) % no color spec was given
  colortab = get(ax,'colororder');
  [mc,nc] = size(colortab);
end

% Check for level or number of levels N.  If it's a scalar and a
% non-zero integer, we assume that it must be N.  Otherwise we
% duplicate it so it's treated as a contour level.
if nin == 2 | nin == 4,
  if prod(size(varargin{2})) == 1 % might be N or a contour level
     if ~(varargin{2} == fix(varargin{2}) & varargin{2})
        varargin{2} = [varargin{2},varargin{2}];
     end
  end
end

% Use contours to get the contour levels.
[c,msg] = contours(varargin{1:nin}); 
if ~isempty(msg)
  if nargout==3, 
    cout = []; h = [];
    return
  else
    error(msg);
  end
end
  
if isempty(c)
    h = [];
    cout = c;
    return;
end

set(ax,'xlim',lims(1:2),'ylim',lims(3:4));

limit = size(c,2);
i = 1;
h = [];
color_h = [];
while(i < limit)
  z_level = c(1,i);
  npoints = c(2,i);
  nexti = i+npoints+1;

  xdata = c(1,i+1:i+npoints);
  ydata = c(2,i+1:i+npoints);
  zdata = z_level + 0*xdata;  % Make zdata the same size as xdata

  % Create the patches or lines
  if isempty(col) & isempty(lin),
    cu = patch('parent',ax,'XData',[xdata NaN],'YData',[ydata NaN], ...
               'ZData',[zdata NaN],'CData',[zdata NaN], ... 
               'facecolor','none','edgecolor','flat',...
               'userdata',z_level);
  else
    cu = line('parent',ax,'XData',xdata,'YData',ydata,'ZData',zdata,'userdata',z_level);
  end
  h = [h; cu(:)];
  color_h = [color_h ; z_level];
  i = nexti;
end

if isempty(col) & ~isempty(lin)
  % set linecolors - all LEVEL lines should be same color
  % first find number of unique contour levels
  [zlev, ind] = sort(color_h);
  h = h(ind);     % handles are now sorted by level
  ncon = length(find(diff(zlev))) + 1;    % number of unique levels
  if ncon > mc    % more contour levels than colors, so cycle colors
                  % build list of colors with cycling
    ncomp = round(ncon/mc); % number of complete cycles
    remains = ncon - ncomp*mc;
    one_cycle = (1:mc)';
    index = one_cycle(:,ones(1,ncomp));
    index = [index(:); (1:remains)'];
    colortab = colortab(index,:);
  end
  j = 1;
  zl = min(zlev);
  for i = 1:length(h)
    if zl < zlev(i)
      j = j + 1;
      zl = zlev(i);
    end
    set(h(i),'linestyle',lin,'color',colortab(j,:));
  end
else
  if ~isempty(lin)
    set(h,'linestyle',lin);
  end
  if ~isempty(col)
    set(h,'color',col);
  end
end

% If command was of the form 'c = contour(...)', return the results
% of the contours command.
if nargout > 0
  cout = c;
end


