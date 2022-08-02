function x = times(x,y)
% In Package myAD - Automatic Differentiation
% by Martin Fink, May 2007
% martinfink 'at' gmx.at

if isa(x, 'myAD')
    ssOnes = ones(size(x.derivatives,2),1);
    if isa(y, 'myAD')
        x.derivatives = y.values(:,ssOnes).*x.derivatives + x.values(:,ssOnes).*y.derivatives;
        x.values = x.values.*y.values;
    else
        x.values = x.values.*y;
        x.derivatives = y(:,ssOnes).*x.derivatives;
    end
else
    y.values = x.*y.values;
    y.derivatives = x(:,ones(size(y.derivatives,2),1)).*y.derivatives;
    x = y;
end
