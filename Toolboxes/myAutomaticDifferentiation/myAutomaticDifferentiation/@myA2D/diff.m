function x = diff(x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.values = diff(x.values);
    x.derivatives = diff(x.derivatives);
    x.secderiv = diff(x.secderiv);
