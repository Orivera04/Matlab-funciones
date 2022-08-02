function x = subsref(x, S)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

x.values = x.values(S.subs{:});
x.derivatives = x.derivatives(S.subs{1},:);
x.secderiv = x.secderiv(S.subs{1},:,:);

