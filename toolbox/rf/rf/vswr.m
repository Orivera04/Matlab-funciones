function result = vswr(gamma)
%VSWR Calculates the VSWR at the given reflection coefficient gamma. 
%   RESULT = VSWR(GAMMA) calculates the VSWR at the given reflection
%   coefficient gamma by
%
%       VSWR = (1+abs(GAMMA))/(1-abs(GAMMA))
%
%   GAMMA is the given reflection coefficient gamma. 
% 
%   See also GAMMAIN, GAMMAOUT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision.1 $  $Date: 2004/04/12 23:39:08 $

% Check the input GAMMA
error(nargchk(1,1,nargin));

% Input GAMMA must be a scalar or vector
if ~isnumeric(gamma) || ~isvector(gamma)
  error('Input must be a scalar or vector.');
end


% Calculate the VSWR
result = (1+abs(gamma))./(1-abs(gamma));
