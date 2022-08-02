function s_params_new = s2s(s_params, z0, z0_new)
%S2S Convert S-parameters to S-parameters with a different impedance .  
%   S_PARAMS_NEW = S2S(S_PARAMS, Z0, Z0_NEW) converts the scattering parameters
%   S_PARAMS with the reference impedance Z0 into the scattering parameters
%   S_PARAMS_NEW with the reference impedance Z0_NEW. 
%
%   S_PARAMS_NEW = S2S(S_PARAMS, Z0) converts the scattering parameters S_PARAMS
%   with the reference impedance Z0 into the scattering parameters S_PARAMS_NEW
%   with the reference impedance 50ohm. 
%   
%   S_PARAMS_NEW is a complex NxNxM array, representing M N-port S-parameters. 
%   S_PARAMS is a complex NxNxM array, representing M N-port S-parameters.
%   Z0 is the reference impedance of the input S-parameters.  
%   Z0_NEW is the reference impedance of the output S-parameters. 
%
%   See also S2Y, S2Z, S2H, S2ABCD, Y2S, Z2S, H2S, ABCD2S.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:39:02 $

error(nargchk(2,3,nargin));

% Check the input S-parameters
if ~isnumeric(s_params)
    error('Input S-parameters must be a complex NxNxM array.');
end
[n1,n2,m] = size(s_params);
if (n1 ~= n2)
    error('Input S-parameters must be a complex NxNxM array.');
end

% Check the reference impedance
if nargin == 2
    z0_new = 50;
end

if ~isnumeric(z0) || ~isvector(z0) || ((length(z0) ~= 1)&&(length(z0) ~= m))
    error('The reference impedance must be a scalar or vector of length M.');
end
if ~isnumeric(z0_new) || ~isvector(z0_new) || ((length(z0_new) ~= 1)&&(length(z0_new) ~= m))
    error('The reference impedance must be a scalar or vector of length M.');
end

% Calculate the output S-parameters
if (length(z0) == length(z0_new)) && all(shiftdim(z0) == shiftdim(z0_new))
    s_params_new = s_params;
else
    y_params = s2y(s_params, z0);
    s_params_new = y2s(y_params, z0_new);
end
