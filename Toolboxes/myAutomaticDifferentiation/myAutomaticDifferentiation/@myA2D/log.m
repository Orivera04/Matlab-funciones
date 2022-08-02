function x = log(x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    temp = 1./x.values;
    x.secderiv = valX2der(-1./x.values.^2, derXder(x.derivatives, x.derivatives)) + ...
                    valX2der(temp, x.secderiv);
    x.derivatives = valXder(temp, x.derivatives);
    x.values = log(x.values);

