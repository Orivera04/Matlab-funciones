function x = tan(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.derivatives = valXder(1./cos(x.values).^2, x.derivatives);
    x.values = tan(x.values);
