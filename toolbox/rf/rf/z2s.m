function s_params = z2s(z_params, z0)
%Z2S Convert Z-parameters to S-parameters.  
%   S_PARAMS = Y2S(Y_PARAMS, Z0) converts the impedance parameters Z_PARAMS 
%   into the scattering parameters S_PARAMS. 
%   
%   Z_PARAMS is a complex NxNxM array, representing M N-port Z-parameters.
%   Z0 is the reference impedance. If not given, 50 Ohms is used. 
%   S_PARAMS is a complex NxNxM array, representing M N-port S-parameters. 
%
%   See also S2Z, Z2Y, Z2H, Z2ABCD, Y2S, H2S, ABCD2S.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:39:15 $

% Check the input Z-parameters
if ~isnumeric(z_params)
    error('Input Z-parameters must be a complex NxNxM array.');
end
[n1,n2,m] = size(z_params);
if (n1 ~= n2) 
    error('Input Z-parameters must be a complex NxNxM array.');
end
 
% Get and check the reference impedance
if nargin < 2
    z0 = 50;
elseif ~isnumeric(z0) || ~isvector(z0) || ((length(z0) ~= 1)&&(length(z0) ~= m))
    error('The reference impedance must be a scalar or vector of length M.');
end
if (length(z0) == 1)
    z0(1:m) = z0;
end

% Allocate memory for the S-parameters
s_params = zeros(n1,n2,m);

% Calculate the S-parameters: S = (Z + Z0 * I) \ (Z - Z0 * I)
I = eye(n1);
for k = 1:m
    s_params(:,:,k) = (z_params(:,:,k) + z0(k) * I) \ ...
        (z_params(:,:,k) - z0(k) * I);
end
