function x = vertcat(varargin)
% In Package myAD - Automatic Differentiation
% by Martin Fink, May 2007
% martinfink 'at' gmx.at

y = []; i = 1;
while (~isa(varargin{i}, 'myAD'))
    y = [y; varargin{i}];
    i=i+1;
end

x = varargin{i};
if (i>1)
    n = length(y);
    x.values = [y; x.values];
    x.derivatives = [zeros(n, size(x.derivatives,2)); x.derivatives];
end

for j = i+1:nargin
    if isa(varargin{j}, 'myAD')
        x.values = [x.values; varargin{j}.values];
        x.derivatives = [x.derivatives; varargin{j}.derivatives];
    elseif (~isempty(varargin{j}))
        x.values = [x.values; varargin{j}];
        x.derivatives(end+length(varargin{j}),end) = 0;
    end
end
