function x = zeros(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.values = x.values*0;
    x.derivatives = x.derivatives*0;
