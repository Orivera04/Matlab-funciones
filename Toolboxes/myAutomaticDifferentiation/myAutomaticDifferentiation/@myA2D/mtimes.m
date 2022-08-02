function x = mtimes(x, y)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

if (length(x)~=1 & length(y)~=1)
    error('Matrix times not implemented, yet. Use ".*" if possible.');
end

if isa(x, 'myA2D')
    if isa(y, 'myA2D')
        x.secderiv = valX2der(y.values, x.secderiv) + derXder(x.derivatives, y.derivatives) + ...
                        derXder(y.derivatives, x.derivatives) + valX2der(x.values, y.secderiv);
        x.derivatives = valXder(y.values, x.derivatives) + valXder(x.values, y.derivatives);
        x.values = x.values.*y.values;
    else
        x.secderiv = valX2der(y, x.secderiv);
        x.derivatives = valXder(y, x.derivatives);
        x.values = x.values.*y;
    end
else
    y.secderiv = valX2der(x, y.secderiv);
    y.derivatives = valXder(x, y.derivatives);
    y.values = x.*y.values;
    x = y;
end
