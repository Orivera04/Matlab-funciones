function x = sum(x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.values = sum(x.values);
    x.derivatives = sum(x.derivatives);
    x.secderiv = sum(x.secderiv);
