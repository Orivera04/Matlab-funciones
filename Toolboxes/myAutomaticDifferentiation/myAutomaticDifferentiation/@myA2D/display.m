function display(x, varargin)
% In Package myA2D - Automatic Differentiation of 1st and 2nd Derivative
% by Martin Fink, June 2006
% martinfink 'at' gmx.at

if (nargin < 2)
    disp([inputname(1) ':']);
else
    disp([varargin{1} ':']);
end
disp('Values =');
disp(x.values);
disp('Derivatives =');
disp(x.derivatives);
disp('Second Derivatives =');
disp(x.secderiv);
