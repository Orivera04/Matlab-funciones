function quantileplot(data,ylab,leg)
%  Plot the quantile function of the data
%  quantileplot(data,ylab,leg)
%  If data is a matrix, it is treated columnwise
%  The optional string ylab is used as the ylabel
%  The optional string or cell array leg is used as the legend

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

x = sort(data);
[m n] = size(x);
if m>1
   n = m;
end
%  fractions for this number of points
f = ((1:n)-0.5)/n;

%  plt quantile points with optional labels
hg = plot(f,x,'-o');
title(inputname(1))
xlabel('f-value')
if nargin>1
   if ~isempty(ylab)
      ylabel(ylab)
   end
end
if nargin>2
   if ~isempty(leg)
      legend(hg,char(leg),4)
   end
end

