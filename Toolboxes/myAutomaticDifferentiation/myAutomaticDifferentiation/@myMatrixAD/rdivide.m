function x = rdivide(x,y)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    if isa(y, 'myMatrixAD')
        if isa(x, 'myMatrixAD')
            x.derivatives = valXder(1./y.values, x.derivatives) - valXder(x.values./y.values.^2, y.derivatives);
            x.values = x.values./y.values;
        else
            y.derivatives = valXder(- x./y.values.^2, y.derivatives);
            y.values = x./y.values;
            x = y;
        end
    else
        x.derivatives = valXder(1./y, x.derivatives);
        x.values = x.values./y;
    end
