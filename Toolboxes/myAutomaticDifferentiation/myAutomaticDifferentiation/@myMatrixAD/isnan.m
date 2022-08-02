function y = isnan(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    y = isnan(x.values) | isnan(sum(x.derivatives,3));
    