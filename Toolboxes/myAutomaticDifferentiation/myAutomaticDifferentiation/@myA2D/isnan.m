function y = isnan(x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    y = isnan(x.values) | isnan(sum(x.derivatives,2)) | isnan(sum(sum(x.secderiv,3),2));
