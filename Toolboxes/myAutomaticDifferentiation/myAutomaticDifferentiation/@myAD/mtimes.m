function x = mtimes(x, y)
% In Package myAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

if (length(x)~=1 & length(y)~=1)
    error('Matrix times not implemented, yet. Use ".*" if possible.');
end

if isa(x, 'myAD')
    if isa(y, 'myAD')
        ssOnes = ones(size(x.derivatives,2),1);
        x.derivatives = y.values(:,ssOnes).*x.derivatives + x.values(:,ssOnes).*y.derivatives;
        x.values = x.values.*y.values;
    else
        x.values = x.values.*y;
        x.derivatives = y(:,ones(size(x.derivatives,2),1)).*x.derivatives;
    end
else
    y.values = x.*y.values;
    y.derivatives = x(:,ones(size(y.derivatives,2),1)).*y.derivatives;
    x = y;
end
