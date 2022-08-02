function z = le(x, y)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    if isa(y, 'myMatrixAD')
        if isa(x, 'myMatrixAD')
            z = x.values <= y.values;
        else
            z = x <= y.values;
        end
    else
        z = x.values <= y;
    end
