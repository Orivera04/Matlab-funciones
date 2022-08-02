function z = diag(x, k)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    if nargin < 2
        k = 0;
    end
    
    z = x;
    z.values = diag(x.values, k);
    sz = size(z.values);
    if min(sz) == 1 %% matrix to vector
        z.derivatives = zeros(sz(1),sz(2),x.nVariables);
        for i = 1:x.nVariables
            z.derivatives(:,:,i) = diag(x.derivatives(:,:,i), k);
        end
    else
        z.derivatives = zeros(sz(1),sz(2),x.nVariables);
        for i = 1:x.nVariables
            z.derivatives(:,:,i) = diag(x.derivatives(:,:,i), k);
        end
    end
