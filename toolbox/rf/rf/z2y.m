function y_params = z2y(z_params)
%Z2Y Convert Z-parameters to Y-parameters.  
%   Y_PARAMS = Y2S(Y_PARAMS) converts the impedance parameters Z_PARAMS 
%   into the admittance parameters Y_PARAMS. 
%   
%   Z_PARAMS is a complex NxNxM array, representing M N-port Z-parameters. 
%   Y_PARAMS is a complex NxNxM array, representing M N-port Y-parameters.
%
%   See also Y2Z, Z2S, Z2H, Z2ABCD, S2Y, H2Y, ABCD2Y.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:39:16 $

% Check the input Z-parameters
if ~isnumeric(z_params)
    error('Input Z-parameters must be a complex NxNxM array.');
end
[n1,n2,m] = size(z_params);
if n1 ~= n2
    error('Input Z-parameters must be a complex NxNxM array.');
end

% Allocate memory for the Y-parameters
y_params = zeros(n1,n2,m);

% Calculate the Y-parameters
for k = 1:m
    y_params(:,:,k) = inv(z_params(:,:,k));
end
