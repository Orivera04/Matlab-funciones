function num=random(varargin)
% Test function to illustrate the use of the java.util package.
%   Generate a random number between given limits (or 0:1).
%
% Mastering MATLAB 6 Java Example 2 - 7/5/00
%

% Check any input arguments.

if nargin == 0
  rmin=0; rmax=1;
elseif nargin < 3
  if nargin == 1
    lim = varargin{1};
  else
    lim = [varargin{1}, varargin{2}];
  end
  if isnumeric(lim) & length(lim) == 2 
    rmin = min(lim); rmax = max(lim);
  else
    error('Invalid limits.');
  end
else
  error('Too many arguments.')
end
    
% Construct a Random object and generate a uniformly-distributed 
% random number between the desired limits.

rNum = java.util.Random;
num = rNum.nextDouble * (rmax - rmin) + rmin;
