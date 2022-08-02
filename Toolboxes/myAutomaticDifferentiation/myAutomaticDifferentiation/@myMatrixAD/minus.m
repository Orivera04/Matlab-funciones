function x = minus(x,y)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    if isa(y, 'myMatrixAD')
        if isa(x, 'myMatrixAD')
            x.values = x.values - y.values;
            x.derivatives = x.derivatives - y.derivatives;
        else
            y.values = x - y.values ;
            y.derivatives = - y.derivatives;
            x = y;
        end
    else
        x.values = x.values - y;
    end
