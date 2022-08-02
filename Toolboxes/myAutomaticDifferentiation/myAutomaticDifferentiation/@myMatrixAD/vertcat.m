function x = vertcat(varargin)
% In Package myMatrixAD - Automatic Differentiation
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

    y = []; i = 1;
    while ~isa(varargin{i}, 'myMatrixAD')
        y = [y; varargin{i}];
        i=i+1;
    end

    x = varargin{i};
    if i>1
        x.values = [y; x.values];
        x.derivatives = [zeros([size(y), x.nVariables]); x.derivatives];
    end

    for j = i+1:nargin
        if isa(varargin{j}, 'myMatrixAD')
            x.values = [x.values; varargin{j}.values];
            x.derivatives = [x.derivatives; varargin{j}.derivatives];
        elseif ~isempty(varargin{j})
            x.values = [x.values; varargin{j}];
            [sx, sy] = size(varargin{j});
            x.derivatives(end+sx, sy, x.nVariables) = 0;
        end
    end
