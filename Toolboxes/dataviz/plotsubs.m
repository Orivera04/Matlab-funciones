function plotsubs(subRows,subCols,X,Y,xlab,ylab,titl,ax)
%  plot a figure of subplots
%  plotsubs(subRows,subCols,X,Y,xlab,ylab,titl,ax)
%  the arrays X,Y are plotted columnwise
%  subRows, subCols  number of subplot rows and columns
%  xlab, ylab  labels
%  titl   titles
%  ax   axis limits

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

%  repeat inputs as necessary
[xr xc] = size(X);
[yr yc] = size(Y);
if xc<yc
   X = repmat(X,1,yc);
end
[lr lc] = size(xlab);
if lr<yc
   xlab = repmat(xlab,yc,1);
end
[lr lc] = size(ylab);
if lr<yc
   ylab = repmat(ylab,yc,1);
end
[lr lc] = size(titl);
if lr<yc
   titl = repmat(titl,yc,1);
end

%  make subplots in standard layout
np = subRows*subCols;
for ip = 1:np
   subplot(subRows,subCols,ip)
   plot(X(:,ip),Y(:,ip),'.')
   if nargin>7
      axis(ax)
   end
   xlabel(xlab(ip,:))
   ylabel(ylab(ip,:))
   title(titl(ip,:))
end

   