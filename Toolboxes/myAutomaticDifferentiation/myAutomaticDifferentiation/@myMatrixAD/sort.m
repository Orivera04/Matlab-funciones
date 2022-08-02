function varargout = sort(varargin)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    x = varargin{1};
    varargin{1} = x.values;
    [val, idx] = sort(varargin{:});
    x.values = val;
    if nargin==1 || varargin{2}==1
        x.derivatives = x.derivatives(idx,:,:);
    else
        x.derivatives = x.derivatives(:,idx,:);
    end
    varargout{1} = x;
    if nargout>1
        varargout{2} = idx;
    end
