function [params, outsideValues] = boxparams(x)
%  calculate boxplot parameters for data vector x
%  function [params, outside_values] = boxparams(x)
%  params = [lowerAdjacentValue lowerQuartile med upperQuartile upperAdjacentValue];
%  output is used by boxplotter

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

%  get the quartiles
temp = quantile(x,[.25 .5 .75]);
lowerQuartile = temp(1);
med = temp(2);
upperQuartile = temp(3);
%  get adjacent values
interquartileRange = upperQuartile-lowerQuartile;
limit = upperQuartile+1.5*interquartileRange;
index = x<=limit;
upperAdjacentValue = max(x(index));
limit = lowerQuartile-1.5*interquartileRange;
index = x>=limit;
lowerAdjacentValue = min(x(index));
%  concatenate the parameters
params = [lowerAdjacentValue lowerQuartile med upperQuartile upperAdjacentValue];

%  get outside values
index = x>upperAdjacentValue|x<lowerAdjacentValue;
outsideValues = x(index);
outsideValues = outsideValues(:)';