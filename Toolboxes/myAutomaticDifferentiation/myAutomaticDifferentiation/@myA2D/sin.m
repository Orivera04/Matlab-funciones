function x = sin(x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    temp = cos(x.values);
    x.values = sin(x.values);
    x.secderiv = valX2der(-x.values, derXder(x.derivatives, x.derivatives)) + ...
                    valX2der(temp, x.secderiv);
    x.derivatives = valXder(temp, x.derivatives);

