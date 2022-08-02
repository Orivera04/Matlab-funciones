function z = eq(x, y)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

if isa(x, 'myA2D')
    if isa(y, 'myA2D')
        z = x.values == y.values;
    else
        z = x.values == y;
    end
else
    z = x == y.values;
end
