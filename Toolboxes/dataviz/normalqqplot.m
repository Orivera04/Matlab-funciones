function normalqqplot(x,ylab);
%  plot quantiles of data vs quantiles of normal distribution
%  normalqqplot(x,ylab)
%  does some labelling
%         See also QQPLOT

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

normqqplot(x)
xlabel('Unit Normal Quantile')
if nargin>1
   ylabel(ylab)
end
title(inputname(1))
grid on

