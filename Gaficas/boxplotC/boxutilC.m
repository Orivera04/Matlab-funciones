function h = boxutilC(x,notch,lb,lf,sym,vert,whis,whissw,c,fillit,LineWidth,koutline)
%BOXUTIL Produces a single box plot.
%   BOXUTIL(X) is a utility function for BOXPLOT, which calls
%   BOXUTIL once for each column of its first argument. Use
%   BOXPLOT rather than BOXUTIL. 
%
%   BFGK 26-mars-2002
%       c           Color option, uses standard color string
%       fillit      Fill option [0 default, 1 produces filled boxes]
%       LineWidth   Specify LineWidth of box lines (deafult = 0.5)
%   BFGK 23-mai-2003
%       corrected color allocation for outlier SYM
%   BFGK 21-aout-03
%       koutline    if =1 uses 'k-' for the line color while c option us still 
%                   used for the fill. This allows for the outline of the box and 
%                   the mean line to remain black and visible. =0 by default
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
%       corrected treatment of empty SYM

%   Copyright 1993-2000 The MathWorks, Inc. 
% $Revision: 2.14 $  $Date: 2000/05/26 17:28:25 $

% Make sure X is a vector.
if min(size(x)) ~= 1, 
    error('First argument has to be a vector.'); 
end

nargs = nargin  ;
if nargs < 8
    error('Requires at least eight input arguments.');
end

if (nargs < 9 | isempty(c)), 
    nargs = 8; 
    c = 'b';
end
if (nargs < 10 | isempty(fillit)), fillit = 0; end
if (nargs < 11 | isempty(LineWidth)), LineWidth = 0.5; end
if (nargs < 12 | isempty(koutline)), koutline = 0; end

% define the median and the quantiles
med = prctile(x,50);
q1 = prctile(x,25);
q3 = prctile(x,75);

% find the extreme values (to determine where whiskers appear)
vhi = q3+whis*(q3-q1);
upadj = max(x(x<=vhi));
if (isempty(upadj)), upadj = q3; end

vlo = q1-whis*(q3-q1);
loadj = min(x(x>=vlo));
if (isempty(loadj)), loadj = q1; end

x1 = lb*ones(1,2);
x2 = x1+[-0.25*lf,0.25*lf];
yy = x(x<loadj | x > upadj);

if isempty(yy)
   yy = loadj;
   if ~isempty(sym),
       [a1 a2 a3 a4] = colstyle(sym);
       sym = [a2 '.'];
   else
       sym = '';
   end
end

xx = lb*ones(1,length(yy));
    lbp = lb + 0.5*lf;
    lbm = lb - 0.5*lf;

if whissw == 0
   upadj = max(upadj,q3);
   loadj = min(loadj,q1);
end

% Set up (X,Y) data for notches if desired.
if ~notch
    xx2 = [lbm lbp lbp lbm lbm];
    yy2 = [q3 q3 q1 q1 q3];
    xx3 = [lbm lbp];
else
    n1 = med + 1.57*(q3-q1)/sqrt(length(x));
    n2 = med - 1.57*(q3-q1)/sqrt(length(x));
    if n1>q3, n1 = q3; end
    if n2<q1, n2 = q1; end
    lnm = lb-0.25*lf;
    lnp = lb+0.25*lf;
    xx2 = [lnm lbm lbm lbp lbp lnp lbp lbp lbm lbm lnm];
    yy2 = [med n1 q3 q3 n1 med n2 q1 q1 n2 med];
    xx3 = [lnm lnp];
end
yy3 = [med med];

% Determine if the boxes are vertical or horizontal.
% The difference is the choice of x and y in the plot command.
linec = [c '-']    ;
dashc = [c '--']   ;

if nargs < 9,
    endline = 'k-'  ;
    meanline = 'r-' ;
elseif koutline == 1,
    endline = 'k-'  ;
    meanline = 'k-' ;
    linec = 'k-';
else
    endline = linec  ;
    meanline = linec ;
end

% [q3 upadj]
% x1
% dashc
% [loadj q1]
% x1
% dashc
% [loadj loadj]
% x2
% endline
% [upadj upadj]
% x2
% endline
% yy2
% xx2
% linec
% yy3
% xx3
% meanline
% yy
% xx
% [c sym]
% 

if fillit
    if vert
        fill(xx2,yy2,c)
    else
        fill(yy2,xx2,c)
    end
end

if isempty(sym),
	if vert
        H = plot(x1,[q3 upadj],dashc,x1,[loadj q1],dashc,...
            x2,[loadj loadj],endline,...
            x2,[upadj upadj],endline,xx2,yy2,linec,xx3,yy3,meanline);
	else
        H = plot([q3 upadj],x1,dashc,[loadj q1],x1,dashc,...
            [loadj loadj],x2,endline,...
            [upadj upadj],x2,endline,yy2,xx2,linec,yy3,xx3,meanline);
	end
else
	if vert
        H = plot(x1,[q3 upadj],dashc,x1,[loadj q1],dashc,...
            x2,[loadj loadj],endline,...
            x2,[upadj upadj],endline,xx2,yy2,linec,xx3,yy3,meanline,xx,yy,[c sym]);
	else
        H = plot([q3 upadj],x1,dashc,[loadj q1],x1,dashc,...
            [loadj loadj],x2,endline,...
            [upadj upadj],x2,endline,yy2,xx2,linec,yy3,xx3,meanline,yy,xx,[c sym]);
	end
end


set(H,'LineWidth',LineWidth)

if nargout > 0, h = H   ; end

return
