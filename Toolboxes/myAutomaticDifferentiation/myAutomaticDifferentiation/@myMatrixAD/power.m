function x = power(x,y)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    if isa(y, 'myMatrixAD')
        if isa(x, 'myMatrixAD')
            temp = x.values.^(y.values);
            x.derivatives = valXder(y.values.*x.values.^(y.values-1), x.derivatives) ...
                + valXder(temp.*log(x.values), y.derivatives);
            x.values = temp;
        else
            y.values = x.^y.values;
            y.derivatives = valXder(y.values.*log(x), y.derivatives);
            x = y;
        end
    else
        x.derivatives = valXder(y.*x.values.^(y-1), x.derivatives);
        x.values = x.values.^y;
    end
