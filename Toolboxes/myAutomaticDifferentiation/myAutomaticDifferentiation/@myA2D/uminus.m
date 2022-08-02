function x = uminus(x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.values = - x.values;
    x.derivatives = - x.derivatives;
    x.secderiv = - x.secderiv;

