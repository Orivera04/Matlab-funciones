function y = subsasgn(y, S, x)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at
    if  isempty(S.subs{1})
        return;
    end

% For first run and debugging uncomment:
    if (length(S.subs)==1) error('Use 2D matrix encoding'); end

    if isa(y, 'myMatrixAD')
        if isa(x, 'myMatrixAD')
            y.values(S.subs{:}) = x.values;
            y.derivatives(S.subs{:},:) = x.derivatives;
        else
            y.values(S.subs{:}) = x;
            y.derivatives(S.subs{:},:) = 0;
        end
    else
        testDeriv = zeros([size(y), x.nVariables]);
        y = myMatrixAD(y, testDeriv, x.nVariables);
        y.values(S.subs{:}) = x.values;
        y.derivatives(S.subs{:},:) = x.derivatives;
    end
