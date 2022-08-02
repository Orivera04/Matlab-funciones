function x = subsref(x, S)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

% For first run and debugging uncomment:
    if (length(S.subs)==1) error('Use 2D matrix encoding'); end
    x.values = x.values(S.subs{:});
    x.derivatives = x.derivatives(S.subs{:},:);
