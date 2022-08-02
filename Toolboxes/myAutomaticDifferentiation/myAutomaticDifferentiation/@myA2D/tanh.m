function x = tanh(x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    temp = 1./(cosh(x.values).^2);
    x.secderiv = valX2der(-2*sinh(x.values)./(cosh(x.values).^3), derXder(x.derivatives, x.derivatives)) + ...
                    valX2der(temp, x.secderiv);
    x.derivatives = valXder(temp, x.derivatives);
    x.values = tanh(x.values);
    
