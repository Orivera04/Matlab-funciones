function x = cumsum(x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.secderiv = cumsum(x.secderiv);
    x.derivatives = cumsum(x.derivatives);
    x.values = cumsum(x.values);
