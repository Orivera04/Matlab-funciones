function x = mpower(x,y)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

error('Matrix power not implemented, yet. Use ".*" if possible.');

    if isa(y, 'myMatrixAD')
        if isa(x, 'myMatrixAD')
            temp = x.values.^(y.values-1);
            x.derivatives = valXder(y.values.*temp, x.derivatives) ...
                + valXder(temp.*x.values.*log(x.values), y.derivatives);
            x.values = temp.*x.values;
        else
            y.values = x.^y.values;
            y.derivatives = valXder(y.values.*log(x), y.derivatives);
            x = y;
        end
    else
        x.derivatives = valXder(y.*x.values.^(y-1), x.derivatives);
        x.values = x.values.^y;
    end
