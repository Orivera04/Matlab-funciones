function x = minus(x,y)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

if isa(x, 'myA2D')
    if isa(y, 'myA2D')
        x.values = x.values - y.values;
        x.derivatives = x.derivatives - y.derivatives;
        x.secderiv = x.secderiv - y.secderiv;
    else
        x.values = x.values - y;
    end
else
    y.values = x - y.values ;
    y.derivatives = - y.derivatives;
    y.secderiv = - y.secderiv;
    x = y;
end
