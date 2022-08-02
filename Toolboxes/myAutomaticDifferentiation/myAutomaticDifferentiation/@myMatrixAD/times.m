function x = times(x,y)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

if isa(x, 'myMatrixAD')
    if isa(y, 'myMatrixAD')
        a = length(x.values);
        b = length(y.values);
        if a == 1
            if b == 1
                x.derivatives = y.values * x.derivatives + x.values * y.derivatives;
            else
                x.derivatives = y.values(:,:,ones(x.nVariables,1)) .* x.derivatives + x.values * y.derivatives;
            end
        else
            x.derivatives = y.values(:,:,ones(x.nVariables,1)) .* x.derivatives + x.values(:,:,ones(x.nVariables,1)) .* y.derivatives;
        end
        x.values = x.values.*y.values;
    else
        if length(y) == 1
            x.derivatives = y * x.derivatives;
        else
            x.derivatives = y(:,:,ones(x.nVariables,1)) .* x.derivatives;
        end
        x.values = y.*x.values;
    end
else
    if length(x) == 1
        y.derivatives = x * y.derivatives;
    else
        y.derivatives = x(:,:,ones(y.nVariables,1)) .* y.derivatives;
    end
    y.values = x.*y.values;
    x = y;
end
