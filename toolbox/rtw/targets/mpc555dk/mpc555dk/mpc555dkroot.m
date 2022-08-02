% File : mpc555dkroot
%
% Abstract :
%   Return the root directory of the mpc555 toolbox 
%

% Copyright 2002 The MathWorks, Inc.
% $Revision: 1.1 $ 
% $Date: 2002/10/03 15:03:26 $
function root = mpc555dkroot
    root = fileparts(fileparts(mfilename('fullpath')));
