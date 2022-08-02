function varargout = get(x, varargin)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

if nargin <2
    varargout = [];
    display(x, inputname(1));
    return;
end

try
    varargout{1} = x.(varargin{1});
catch
    error(sprintf('Field %s doesn''t exist.', varargin{1}));
end
