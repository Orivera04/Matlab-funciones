function x = uminus(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.values = - x.values;
    x.derivatives = - x.derivatives;
