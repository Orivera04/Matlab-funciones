function x = rdivide(x,y)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

if isa(x, 'myA2D')
    if isa(y, 'myA2D')
        temp = valXder(y.values, x.derivatives) - valXder(x.values, y.derivatives);
        x.secderiv = valX2der(1./y.values, x.secderiv) ...
                        + valX2der(-x.values./y.values.^2, y.secderiv) ...
                        + valX2der(-1./y.values.^3, derXder(temp, y.derivatives) + derXder(y.derivatives, temp));
        x.derivatives = valXder(1./y.values.^2, temp);
        x.values = x.values./y.values;
    else
        x.secderiv = valX2der(1./y, x.secderiv);
        x.derivatives = valXder(1./y, x.derivatives);
        x.values = x.values./y;
    end
else
    temp = x./y.values.^2;
    y.secderiv = valX2der(-temp, y.secderiv) ...
                    + valX2der(2.*x./y.values.^3, derXder(y.derivatives, y.derivatives));
    y.derivatives = valXder(-temp, y.derivatives);
    y.values = x./y.values;
    x = y;
end
