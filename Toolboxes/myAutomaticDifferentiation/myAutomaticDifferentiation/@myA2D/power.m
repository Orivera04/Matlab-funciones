function x = power(x,y)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

if isa(x, 'myA2D')
    if isa(y, 'myA2D')
        tempA = x.values.^(y.values-2); % x^(y-2)
        tempB = x.values.^(y.values-1); % x^(y-1)
        tempC = x.values.^(y.values);   % x^(y)
        tempD = log(x.values);          % log(x)
        x.secderiv = valX2der(tempB.*(1+y.values.*tempD), derXder(x.derivatives, y.derivatives) + derXder(y.derivatives, x.derivatives)) + ...
                        valX2der(y.values.*(y.values-1).*tempA, derXder(x.derivatives, x.derivatives)) + ...
                        valX2der(tempC.*tempD.^2, derXder(y.derivatives, y.derivatives)) + ...
                        valX2der(y.values.*tempB, x.secderiv) + valX2der(tempC.*tempD, y.secderiv);
        x.derivatives = valXder(y.values.*tempB, x.derivatives) ...
            + valXder(tempC.*tempD, y.derivatives);
        x.values = tempC;
    else
        tempA = x.values.^(y-2);        % x^(y-2)
        tempB = tempA.*x.values;        % x^(y-1)
        tempC = tempB.*x.values;        % x^(y)
        x.secderiv = valX2der(y.*(y-1).*tempA, derXder(x.derivatives, x.derivatives)) + ...
                        valX2der(y.*tempB, x.secderiv);
        x.derivatives = valXder(y.*tempB, x.derivatives);
        x.values = tempC;
    end
else
    y.values = x.^y.values;
    temp = log(x);
    y.secderiv = valX2der(y.values.*temp.^2, derXder(y.derivatives, y.derivatives)) + ...
                    valX2der(y.values.*temp, y.secderiv);
    y.derivatives = valXder(y.values.*temp, y.derivatives);
    x = y;
end
