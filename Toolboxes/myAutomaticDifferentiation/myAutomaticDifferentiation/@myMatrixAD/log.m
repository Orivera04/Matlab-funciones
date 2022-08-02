function x = log(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.derivatives = valXder(1./x.values, x.derivatives);
    x.values = log(x.values);
