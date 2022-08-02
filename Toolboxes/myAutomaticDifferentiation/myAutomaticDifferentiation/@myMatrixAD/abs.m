function x = abs(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.derivatives = valXder(sign(x.values), x.derivatives);
    x.values = abs(x.values);

