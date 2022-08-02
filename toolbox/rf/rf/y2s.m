function s_params = y2s(y_params, z0)
%Y2S Convert Y-parameters to S-parameters.  
%   S_PARAMS = Y2S(Y_PARAMS, Z0) converts the admittance parameters Y_PARAMS 
%   into the scattering parameters S_PARAMS. 
%   
%   Y_PARAMS is a complex NxNxM array, representing M N-port Y-parameters.
%   Z0 is the reference impedance. If not given, 50 Ohms is used. 
%   S_PARAMS is a complex NxNxM array, representing M N-port S-parameters. 
%
%   See also S2Y, Y2Z, Y2H, Y2ABCD, Y2S, Z2S, H2S, ABCD2S.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:39:11 $

% Check the input Y-parameters
if ~isnumeric(y_params)
    error('Input Y-parameters must be a complex NxNxM array.');
end
[n1,n2,m] = size(y_params);
if (n1 ~= n2)
    error('Input Y-parameters must be a complex NxNxM array.');
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

% Calculate the S-parameters: S = (I + Z0 * Y) \ (I - Z0 * Y)
I = eye(n1);
for k = 1:m
    s_params(:,:,k) =  (I + z0(k) * y_params(:,:,k)) \ ...
        (I - z0(k) * y_params(:,:,k));
end
