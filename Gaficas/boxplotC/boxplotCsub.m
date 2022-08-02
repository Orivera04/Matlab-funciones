function h = boxplotCsub(x,g,notch,sym,vert,whis,c,fillit,LineWidth,koutline,cur_tot)
%BOXPLOTCSUB Display boxplots of a data sample, allowing line property definitions
%   Modification of standard BOXPLOT
%   See BOXPLOT for syntax
% 
%   BOXPLOTCSUB calls BOXUTILC to do the actual plotting.
%
% h = boxplotCsub(x,g,notch,sym,vert,whis,c,fillit,LineWidth,koutline,[cur tot])
%   BFGK 26-mars-2002
%       remove "cla" to allow for hold on overplotting
%       c           option to define color of box/line/sym
%       fillit      option : 1 plots filled boxes, 0 is default (normal)
%       LineWidth   option to set LineWidth, 0.5 default
%
%   BFGK 8-aout-03
%       allow for empty SYM = [] to omit outlier plotting
%           not compatible with WHIS = 1
%       [cur tot]   subplot style boxplot allowing for multiple boxplots
%                   in the style of grouped bar plots. Easiest implementation using
%                   subplot style of calling with CUR bieng current plot out of TOT plots.
%                   no error checking yet to make sure TOT does not change between calls etc.
%   BFGK 21-aout-03
%       koutline    if true uses 'k-' for the line color while c option us still 
%                   used for the fill. This allows for the outline of the box and 
%                   the mean line to remain black and visible. FALSE by default
%   BFGK 17-oct-03
%       h           graphics handle output, outputs matrix of graphics
%                   handles, each column represents a data set. Rows
%                   correspond to 
%                       1: upper whisker line
%                       2: lower whisker line
%                       3: lower extent endline
%                       4: upper extent endline
%                       5: box
%                       6: median line
%                       7: outlier marker
%   BFGK 6-mai-2004
%       included "mgrp2idx" as an internal function as it is private for
%       boxplot in dealing with grouping variables
%
% Example : 2 sets divided into 3 groups of data
% 	dataset = randn(10,2,3)
% 	boxplotCsub( dataset(:,:,1),1,[],0,0,'r',1,0.5,false,[1 3])
% 	boxplotCsub( dataset(:,:,2),1,[],0,0,'g',1,0.5,false,[2 3])
% 	boxplotCsub( dataset(:,:,3),1,[],0,0,'b',1,0.5,false,[3 3])
%   axis;axis([min(min(min(dataset))) max(max(max(dataset))) ans(3) ans(4)])

%   If there are no data outside the whisker, then, there is a dot at the 
%   bottom whisker, the dot color is the same as the whisker color. If
%   a whisker falls inside the box, we choose not to draw it. To force
%   it to be drawn at the right place, set whissw = 1.

%   Copyright 1993-2000 The MathWorks, Inc. 
%   $Revision: 2.12 $  $Date: 2000/09/01 20:02:28 $

if (nargin==1 & length(x(:))==1 & ishandle(x)), resizefcn(x); return; end

if nargin < 10, 
    error('boxplotCsub : insufficient number of arguments')
    return
end

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
   if (nargin>9), cur_tot = koutline; end 
   if (nargin>8), koutline = LineWidth; end 
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
if (nargs < 9 | isempty(koutline)), koutline = 0; end

if ~exist('cur_tot'),
    error('boxplotCsub : insufficient number of arguments (cur_tot absent)')
    return
end
if length(cur_tot) ~= 2,
    error('boxplotCsub : cur_tot must have 2 elements ')
    return
end
    

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

% lf = n*min(0.15,0.5/n);    % was just before '% Scale'
lf = (n*min(0.15,0.5/n))/cur_tot(2);

%lb = 1:n;
sub_list = [1:cur_tot(2)] - mean([1:cur_tot(2)])   ;
lb = [1:n] + (lf*sub_list(cur_tot(1))) ;

xlims = [0.5 n + 0.5];

k = find(~isnan(x));
ymin = min(min(x(k)));
ymax = max(max(x(k)));
dy = (ymax-ymin)/20;
ylims = [(ymin-dy) (ymax+dy)];

% Scale axis for vertical or horizontal boxes.
% cla
set(gca,'NextPlot','add','Box','on');
if vert
    axis([xlims ylims]);
    set(gca,'XTick',[1:n]);
%    set(gca,'XTick',lb);
    set(gca,'YLabel',text(0,0,'Values'));
    if (isempty(g)), set(gca,'XLabel',text(0,0,'Column Number')); end
else
    axis([ylims xlims]);
    set(gca,'YTick',[1:n]);
%    set(gca,'YTick',lb);
    set(gca,'XLabel',text(0,0,'Values'));
    if (isempty(g)), set(gca,'YLabel',text(0,0,'Column Number')); end
end

if (~isempty(g))
   for i=1:n
      z = x(g==i);
      H(:,i) = boxutilC(z,notch,lb(i),lf,sym,vert,whis,whissw,c,fillit,LineWidth,koutline);
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
      H(:,i) = boxutilC(yy(vec),notch,lb,lf,sym,vert,whis,whissw,c,fillit,LineWidth,koutline);
   end
else
   for i=1:n
      z = x(:,i);
      vec = find(~isnan(z));
      if ~isempty(vec)
         H(:,i) = boxutilC(z(vec),notch,lb(i),lf,sym,vert,whis,whissw,c,fillit,LineWidth,koutline);
      end
   end
end
set(gca,'NextPlot','replace');

if nargout > 0, h = H   ; end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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

%%%% copied from private function for boxplot
function [ogroup,glabel,gname,multigroup] = mgrp2idx(group,rows,sep);
%MGRP2IDX Convert multiple grouping variables to index vector
%   [OGROUP,GLABEL,GNAME,MULTIGROUP] = MGRP2IDX(GROUP,ROWS) takes
%   the inputs GROUP, ROWS, and SEP.  GROUP is a grouping variable (numeric
%   vector, string matrix, or cell array of strings) or a cell array
%   of grouping variables.  ROWS is the number of observations.
%   SEP is a separator for the grouping variable values.
%
%   The output OGROUP is a vector of group indices.  GLABEL is a cell
%   array of group labels, each label consisting of the values of the
%   various grouping variables separated by the characters in SEP.
%   GNAME is a cell array containing one column per grouping variable
%   and one row for each distinct combination of grouping variable
%   values.  MULTIGROUP is 1 if there are multiple grouping variables
%   or 0 if there are not.

%   Tom Lane, 12-17-99
%   Copyright 1993-2002 The MathWorks, Inc. 
%   $Revision: 1.4 $  $Date: 2002/02/04 19:25:44 $

multigroup = (iscell(group) & size(group,1)==1);
if (~multigroup)
   [ogroup,gname] = grp2idx(group);
   glabel = gname;
else
   % Group according to each distinct combination of grouping variables
   ngrps = size(group,2);
   grpmat = zeros(rows,ngrps);
   namemat = cell(1,ngrps);
   
   % Get integer codes and names for each grouping variable
   for j=1:ngrps
      [g,gn] = grp2idx(group{1,j});
      grpmat(:,j) = g;
      namemat{1,j} = gn;
   end
   
   % Find all unique combinations
   [urows,ui,uj] = unique(grpmat,'rows');
   
   % Create a cell array, one col for each grouping variable value
   % and one row for each observation
   ogroup = uj;
   gname = cell(size(urows));
   for j=1:ngrps
      gn = namemat{1,j};
      gname(:,j) = gn(urows(:,j));
   end
   
   % Create another cell array of multi-line texts to use as labels
   glabel = cell(size(gname,1),1);
   if (nargin > 2)
      nl = sprintf(sep);
   else
      nl = sprintf('\n');
   end
   fmt = sprintf('%%s%s',nl);
   lnl = length(fmt)-3;        % one less than the length of nl
   for j=1:length(glabel)
      gn = sprintf(fmt, gname{j,:});
      gn(end-lnl:end) = [];
      glabel{j,1} = gn;
   end
end
