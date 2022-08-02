function varargout = max(varargin)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

% Many problems with this routine
% max neglects the derivative with respect to the time at the moment
% idx has to be rescaled after the output idx = idx.*diff(t(1:2));
%
% Overall it's a rough approx at the moment, but better than nought.

%     warning('The max-function should be only used, when the vector corresponds to a linspaced function f(t). Otherwise use a workaround in your code.');
    if nargin == 2
        maxx = max(varargin{1}.values, varargin{2}.values);
        idx = find(maxx == [varargin{1}.values, varargin{2}.values]);
        x = varargin{idx};
%         x.values = maxx;
%         x.derivatives = varargin{idx}.derivatives;
        if nargout < 2
            varargout = {x};
        else
            varargout = {x, idx};
        end
        return;
    else
        x = varargin{:};
    end

    if min(size(x)) > 1
        error('Matrix maximum not implemented.');
    end
    
    [maxx, idx] = max(x.values);

    n = length(x);
    x.derivatives = reshape(x.derivatives, n, 1, x.nVariables);

    if nargout < 2
        x.values = maxx;
        x.derivatives = reshape(x.derivatives(idx,:), 1, 1, x.nVariables);
        varargout = {x};
        return;
    end
    
    if idx == 1
        dfdp = 1/2*(-3*x.derivatives(idx,:) + 4*x.derivatives(idx+1,:) - x.derivatives(idx+2,:));
    elseif idx == n
        dfdp = 1/2*(3*x.derivatives(idx,:) - 4*x.derivatives(idx-1,:) + x.derivatives(idx-2,:));
    else
        dfdp = (x.derivatives(idx+1,:) - x.derivatives(idx-1,:));
    end

    if idx <= 2
        dfdt = (-x.values(idx+3) + 4*x.values(idx+2) - 5*x.values(idx+1) + 2*x.values(idx));
    elseif idx >= n-1
        dfdt = (x.values(idx-3) - 4*x.values(idx-2) + 5*x.values(idx-1) - 2*x.values(idx));
    else
        dfdt = 1/12*(-x.values(idx+2) + 16*x.values(idx+1) - 30*x.values(idx) + 16*x.values(idx-1) - x.values(idx-2));
    end

    x.values = maxx;
    x.derivatives = reshape(x.derivatives(idx,:), 1, 1, x.nVariables);

    y = x;
    y.values = idx;
    y.derivatives(1,1,:) = -dfdp/dfdt;

    varargout = {x, y};
