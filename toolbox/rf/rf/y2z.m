function z_params = y2z(y_params)
%Y2Z Convert Y-parameters to Z-parameters.  
%   Z_PARAMS = Y2Z(Y_PARAMS) converts the admittance parameters Y_PARAMS 
%   into the impedance parameters Z_PARAMS. 
%   
%   Y_PARAMS is a complex NxNxM array, representing M N-port Y-parameters.
%   Z_PARAMS is a complex NxNxM array, representing M N-port Z-parameters. 
%
%   See also Z2Y, Y2S, Y2H, Y2ABCD, Z2S, Y2Z, H2Z, ABCD2Z.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:39:12 $

% Check the input Y-parameters
if ~isnumeric(y_params)
    error('Input Y-parameters must be a complex NxNxM array.');
end
[n1,n2,m] = size(y_params);
if (n1 ~= n2)
    error('Input Y-parameters must be a complex NxNxM array.');
end

% Allocate memory for the Z-parameters
z_params = zeros(n1,n2,m);

% Calculate the Z-parameters
for k = 1:m
    z_params(:,:,k) = inv(y_params(:,:,k));
end
