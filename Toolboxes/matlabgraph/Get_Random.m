function r = Get_Random(rmin,rmax,type)
% 
%  r = Get_Random(rmin,rmax,type)
%
% Calculates an random value
%
% Inputs
%        rmin          - The min value of the random number
%        rmax          - The max number of the random value
%        type          - A string of either 'integer' or 'float' - Default float
%        
% Output
%        r     - A random number of the type and range specified above
%
% Date - 8 Jan 2003
% Author by Maj Thomas Rathbun

% set default value
if nargin < 3
    type = 'float';
end

% widen the range to make getting the end points more likely
if strcmp(type,'integer')
    rmin = rmin - .4;
    rmax = rmax + .4;
end

% calculate range
rang = rmax-rmin;

% calculate random in that range
r = rand(1)*rang + rmin;

% roubd in an integer
if strcmp(type,'integer')
    r = round(r);
end
