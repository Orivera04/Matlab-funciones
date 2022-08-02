function z_params = s2z(s_params, z0)
%S2Z Convert S-parameters to Z-parameters.  
%   Z_PARAMS = S2H(S_PARAMS, Z0) converts the scattering parameters S_PARAMS 
%   into the impedance parameters Z_PARAMS. 
%   
%   S_PARAMS is a complex NxNxM array, representing M N-port S-parameters.
%   Z0 is the reference impedance. If not given, 50 Ohms is used. 
%   Z_PARAMS is a complex NxNxM array, representing M N-port Z-parameters. 
%
%   See also Z2S, S2Y, S2H, S2ABCD, Y2Z, H2Z, ABCD2Z.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:39:05 $

% Check the input S-parameters
if ~isnumeric(s_params)
    error('Input S-parameters must be a complex NxNxM array.');
end
[n1,n2,m] = size(s_params);
if (n1 ~= n2)
    error('Input S-parameters must be a complex NxNxM array.');
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

% Allocate memory for the Z-parameters
z_params = zeros(n1, n2, m); 

% Calc the Z-parameters: Z = Z0 * (I + S) * inv(I - S)
I = eye(n1);
for k = 1:m
    z_params(:,:,k) = (z0(k) * (I + s_params(:,:,k))) * ...
        inv(I - s_params(:,:,k));
end
