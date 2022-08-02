function x = sqrt(x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x.values = sqrt(x.values);
    temp = 1./x.values;
    x.secderiv = valX2der(-0.25*temp.^3, derXder(x.derivatives, x.derivatives)) + ...
                    valX2der(0.5*temp, x.secderiv);
    x.derivatives = valXder(0.5*temp, x.derivatives);

