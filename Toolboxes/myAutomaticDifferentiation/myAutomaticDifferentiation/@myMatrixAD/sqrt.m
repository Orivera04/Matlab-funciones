function x = sqrt(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.values = sqrt(x.values);
    x.derivatives = valXder(0.5./x.values, x.derivatives);
