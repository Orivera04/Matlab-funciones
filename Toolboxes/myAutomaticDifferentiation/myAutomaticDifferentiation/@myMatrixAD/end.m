function idx = end(x, k, n)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    if k == 1 && min(size(x.values)) == 1
        idx = length(x.values);
        return
    end

    if k < 3
        idx = size(x.values,k);
    else
        idx = 1;
    end
