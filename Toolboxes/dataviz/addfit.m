function [alpha, beta] = addfit(data)
%  calculate additive fit coefficients for a simple data array
%  [alpha, beta] = addfit(data)
%  alpha is the coefficient for the columnwise factor
%  beta is the coefficient for the rowwise factor

% Copyright (c) 1998 by Datatool
% $Revision: 1.00 $

data = data-mean(data(:));
alpha = mean(data,2);
beta = mean(data,1);