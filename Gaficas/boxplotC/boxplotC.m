function boxplotC(x,g,notch,sym,vert,whis,c,fillit,LineWidth)
%BOXPLOTC Display boxplots of a data sample, allowing line property definitions
%   Modification of standard BOXPLOT
%   See BOXPLOT for syntax
% 
%   BOXPLOTC calls BOXUTILC to do the actual plotting.
%
% boxplotC(x,g,notch,sym,vert,whis,c,fillit,LineWidth)
%   BFGK 26-mars-2002
%       remove "cla" to allow for hold on overplotting
%       c           option to define color of box/line/sym
%       fillit      option : 1 plots filled boxes, 0 is default (normal)
%       LineWidth   option to set LineWidth, 0.5 default
%
%   BFGK 8-aout-03
%       allow for empty SYM = [] to omit outlier plotting
%           not compatible with WHIS = 1
%
% Example   Create a notched filled box plot with outlier symbol 'p' in color 'm'
%           Overlay a second notched boxplot (not filled) in 'g' with line thickness 2
%   boxplotC(randn(10,2),1,'p',1,1.5,'m',1)
%   boxplotC(randn(10,2),1,'o',1,1.5,'g',0,2)

%   If there are no data outside the whisker, then, there is a dot at the 
%   bottom whisker, the dot color is the same as the whisker color. If
%   a whisker falls inside the box, we choose not to draw it. To force
%   it to be drawn at the right place, set whissw = 1.

%   Copyright 1993-2000 The MathWorks, Inc. 
%   $Revision: 2.12 $  $Date: 2000/09/01 20:02:28 $

if (nargin==1 & length(x(:))==1 & ishandle(x)), resizefcn(x); return; end

whissw = 0; % don't plot whisker inside the box.

[m n] = size(x);
if min(m,n) > 1 
    xx = x(:,1);
    yy = xx;
else
    n = 1;
    xx = x;
    yy = x;
end

% If the 2nd arg is not a grouping variable, shift arguments
nargs = nargin;
if (nargin<2)
   g = [];
elseif (nargin>1 & (isequal(g,1) | isequal(g,0)))
   if (nargin>7), LineWidth = fillit; end 
   if (nargin>6), fillit = c; end 
   if (nargin>5), c = whis; end
   if (nargin>4), whis = vert; end
   if (nargin>3), vert = sym; end
   if (nargin>2), sym = notch; end
   notch = g;
   g = [];
else
   nargs = nargin - 1;
end

if (nargs < 2 | isempty(notch)), notch = 0; end
if (nargs < 3 ), sym = '+'; end
%if (nargs < 3 | isempty(sym)), sym = '+'; end
if (nargs < 4 | isempty(vert)), vert = 1; end
if (nargs < 5 | isempty(whis)), whis = 1.5; end
if (nargs < 6 | isempty(c)), c = ''; end
if (nargs < 7 | isempty(fillit)), fillit = 0; end
if (nargs < 8 | isempty(LineWidth)), LineWidth = 0.5; end

% Deal with grouping variable
if (~isempty(g))
   x = x(:);
   
   if (vert)
      sep = '\n';
   else
      sep = ',';
   end

   [g,glabel,gname,multigroup] = mgrp2idx(g,size(x,1),sep);
   n = size(gname,1);
   
   k = (isnan(g) | isnan(x));
   if (any(k))
      x(k) = [];
      g(k) = [];
   end
end

lb = 1:n;

xlims = [0.5 n + 0.5];

k = find(~isnan(x));
ymin = min(min(x(k)));
ymax = max(max(x(k)));
dy = (ymax-ymin)/20;
ylims = [(ymin-dy) (ymax+dy)];

lf = n*min(0.15,0.5/n);

% Scale axis for vertical or horizontal boxes.
% cla
set(gca,'NextPlot','add','Box','on');
if vert
    axis([xlims ylims]);
    set(gca,'XTick',lb);
    set(gca,'YLabel',text(0,0,'Values'));
    if (isempty(g)), set(gca,'XLabel',text(0,0,'Column Number')); end
else
    axis([ylims xlims]);
    set(gca,'YTick',lb);
    set(gca,'XLabel',text(0,0,'Values'));
    if (isempty(g)), set(gca,'YLabel',text(0,0,'Column Number')); end
end

if (~isempty(g))
   for i=1:n
      z = x(g==i);
      boxutilC(z,notch,lb(i),lf,sym,vert,whis,whissw,c,fillit,LineWidth);
   end

   if (multigroup & vert)
      % Turn off tick labels and axis label
      set(gca, 'XTickLabel','','UserData',size(gname,2));
      xlabel('');
      ylim = get(gca, 'YLim');
      
      % Place multi-line text approximately where tick labels belong
      for j=1:n
         ht = text(j,ylim(1),glabel{j,1},'HorizontalAlignment','center',...
              'VerticalAlignment','top', 'UserData','xtick');
      end

      % Resize function will position text more accurately
      set(gcf, 'ResizeFcn', sprintf('boxplot(%d)', gcf), ...
               'Interruptible','off', 'PaperPositionMode','auto');
      resizefcn(gcf);
   elseif (vert)
      set(gca, 'XTickLabel',glabel);
   else
      set(gca, 'YTickLabel',glabel);
   end

elseif n==1
   vec = find(~isnan(yy));
   if ~isempty(vec)
      boxutilC(yy(vec),notch,lb,lf,sym,vert,whis,whissw,c,fillit,LineWidth);
   end
else
   for i=1:n
      z = x(:,i);
      vec = find(~isnan(z));
      if ~isempty(vec)
         boxutilC(z(vec),notch,lb(i),lf,sym,vert,whis,whissw,c,fillit,LineWidth);
      end
   end
end
set(gca,'NextPlot','replace');


function resizefcn(f)
% Adjust figure layout to make sure labels remain visible
h = findobj(f, 'UserData','xtick');
if (isempty(h))
   set(f, 'ResizeFcn', '');
   return;
end
ax = get(f, 'CurrentAxes');
nlines = get(ax, 'UserData');

% Position the axes so that the fake X tick labels have room to display
set(ax, 'Units', 'characters');
p = get(ax, 'Position');
ptop = p(2) + p(4);
if (p(4) < nlines+1.5)
   p(2) = ptop/2;
else
   p(2) = nlines + 1;
end
p(4) = ptop - p(2);
set(ax, 'Position', p);
set(ax, 'Units', 'normalized');

% Position the labels at the proper place
xl = get(gca, 'XLabel');
set(xl, 'Units', 'data');
p = get(xl, 'Position');
ylim = get(gca, 'YLim');
p2 = (p(2)+ylim(1))/2;
for j=1:length(h)
   p = get(h(j), 'Position') ;
   p(2) = p2;
   set(h(j), 'Position', p);
end

