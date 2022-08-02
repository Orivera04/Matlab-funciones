function y_params = s2y(s_params, z0)
%S2Y Convert S-parameters to Y-parameters.  
%   Y_PARAMS = S2Y(S_PARAMS, Z0) converts the scattering parameters S_PARAMS 
%   into the admittance parameters Y_PARAMS. 
%   
%   S_PARAMS is a complex NxNxM array, representing M N-port S-parameters. 
%   Z0 is the reference impedance. If not given, 50 Ohms is used. 
%   Y_PARAMS is a complex NxNxM array, representing M N-port Y-parameters.
%
%   See also Y2S, S2Z, S2H, S2ABCD, Z2Y, H2Y, ABCD2Y.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:39:04 $

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

% Allocate memory for the Y-parameters
y_params = zeros(n1, n2, m); 

% Calculate the Y-parameters:  Y = (I - S) * inv(Z0 * S + Z0 * I)
I = eye(n1);
for k = 1:m
    y_params(:,:,k) = (I - s_params(:,:,k)) * ...
        inv(z0(k) * (I + s_params(:,:,k)));
end
