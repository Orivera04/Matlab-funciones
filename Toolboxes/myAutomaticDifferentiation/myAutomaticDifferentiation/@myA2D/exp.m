function x = exp(x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.values = exp(x.values);
    temp = x.derivatives;
    x.derivatives = valXder(x.values, x.derivatives);
    x.secderiv = derXder(x.derivatives, temp) + ...
                    valX2der(x.values, x.secderiv);

