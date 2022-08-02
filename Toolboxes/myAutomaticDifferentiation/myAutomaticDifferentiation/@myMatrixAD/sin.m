function x = sin(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.derivatives = valXder(cos(x.values), x.derivatives);
    x.values = sin(x.values);
