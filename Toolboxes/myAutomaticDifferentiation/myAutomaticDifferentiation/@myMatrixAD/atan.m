function x = atan(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.derivatives = valXder(1./(1+x.values.^2), x.derivatives);
    x.values = atan(x.values);
