function x = vertcat(varargin)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

y = []; i = 1;
while (~isa(varargin{i}, 'myA2D'))
    y = [y; varargin{i}];
    i=i+1;
end

x = varargin{i};
if (i>1)
    ny = length(y);
    nd = size(x.derivatives,2);
    x.values = [y; x.values];
    x.derivatives = [zeros(ny, nd); x.derivatives];
    x.secderiv = [zeros(ny, nd, nd); x.secderiv];
end

for j = i+1:nargin
    if (isa(varargin{j}, 'myA2D'))
        x.values = [x.values; varargin{j}.values];
        x.derivatives = [x.derivatives; varargin{j}.derivatives];
        x.secderiv = [x.secderiv; varargin{j}.secderiv];
    else
        x.values = [x.values; varargin{j}];
        n = length(varargin{j});
        x.derivatives(end+n,end) = 0;
        x.secderiv(end+n,end,end) = 0;
    end
end
