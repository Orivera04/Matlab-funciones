function varargout = size(x, varargin)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    if nargin == 1
        [sx, sy] = size(x.values);
        if nargout <= 1
            varargout = {[sx, sy]};
        else
            varargout = {sx, sy};
        end
    else
        sx = size(x.values, varargin{:});
        varargout = {sx};
    end
