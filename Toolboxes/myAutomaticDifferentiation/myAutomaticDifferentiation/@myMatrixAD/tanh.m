function x = tanh(x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.derivatives = valXder(1./(cosh(x.values).^2), x.derivatives);
    x.values = tanh(x.values);

