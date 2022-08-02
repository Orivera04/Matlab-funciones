function x = sum(x, dim)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    if nargin == 1
        s = size(x.values);
        if s(1) == 1
            dim = 2;
        else
            dim = 1;
        end
    end

    x.values = sum(x.values,dim);
    x.derivatives = sum(x.derivatives,dim);
