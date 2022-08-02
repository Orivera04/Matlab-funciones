function x = diff(x, n, dim)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    if nargin < 3
        s = size(x.values);
        if s(1) == 1
            dim = 2;
        else
            dim = 1;
        end
        if nargin < 2
            n = 1;
        end
    end

    x.values = diff(x.values,n,dim);
    x.derivatives = diff(x.derivatives,n,dim);
