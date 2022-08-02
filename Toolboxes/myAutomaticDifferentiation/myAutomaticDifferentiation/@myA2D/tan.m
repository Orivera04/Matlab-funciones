function x = tan(x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    temp = cos(x.values);
    x.secderiv = valX2der(2./temp.^3.*sin(x.values), derXder(x.derivatives, x.derivatives)) + ...
                    valX2der(1./temp.^2, x.secderiv);
    x.derivatives = valXder(1./temp.^2, x.derivatives);
    x.values = tan(x.values);

