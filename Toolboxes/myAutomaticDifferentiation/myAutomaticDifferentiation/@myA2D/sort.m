function varargout = sort(x)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

[val, idx] = sort(x.values);
x.values = val;
x.derivatives = x.derivatives(idx,:);
x.secderiv = x.secderiv(idx,:,:);
varargout{1} = x;
if (nargout>1)
    varargout{2} = idx;
end
