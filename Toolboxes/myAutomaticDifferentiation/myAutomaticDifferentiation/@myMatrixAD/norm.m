function x = norm(x, p)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    if min(size(x))>1
        error('Matrix norm not implemented.');
    end

    if nargin==1
        p = 2;
    end
    x = sum(abs(x).^p).^(1/p);
