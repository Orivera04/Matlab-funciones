% EX12_8.M Perform 2D symbolic integration of the function
%   x*sin(y)+y*cos(x) over fixed limits
%     pi < y < 2pi, 0 < x < pi
inty=int('x*sin(y)+y*cos(x)','y',pi,2*pi) % Inner integral
intx=int(inty,'x',0,pi)                   % Outer integral
twodint=numeric(intx)                % Convert to a number
%
% Modify the script to allow input of arbitrary functions
%  and arbitrary integration limits
%
