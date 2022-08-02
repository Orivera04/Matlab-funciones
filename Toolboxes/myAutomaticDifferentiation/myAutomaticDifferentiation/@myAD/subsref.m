function x = subsref(x, S)
% In Package myAD - Automatic Differentiation
% by Martin Fink, May 2007
% martinfink 'at' gmx.at

    x.values = x.values(S.subs{:});
    x.derivatives = x.derivatives(S.subs{1},:);
