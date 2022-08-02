function h_params = z2h(z_params)
%Z2H Convert Z-parameters to H-parameters.  
%   Z_PARAMS = Y2Z(Y_PARAMS) converts the impedance parameters Z_PARAMS 
%   into the hybrid parameters H_PARAMS. 
%   
%   Z_PARAMS is a complex 2x2xM array, representing M two-port Z-parameters. 
%   H_PARAMS is a complex 2x2xM array, representing M two-port H-parameters.
%
%   See also H2Z, Z2S, Z2Y, Z2ABCD, S2H, Y2H, ABCD2H.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:39:14 $

% Check the input Z-parameters
if ~isnumeric(z_params)
    error('Input Z-parameters must be a complex 2x2xM array.');
end
[n1,n2,m] = size(z_params);
if (n1 ~= 2) || (n2 ~= 2)
    error('Input Z-parameters must be a complex 2x2xM array.');
end

% Get the Z-parameters
[z11, z12, z21, z22] = deal(z_params(1,1,:), z_params(1,2,:), ...
    z_params(2,1,:), z_params(2,2,:));

% Calculate the H-parameters
delta = z11 .* z22 - z12 .* z21;
h_params = [delta, z12; -z21, ones(size(z22))] ./ repmat(z22, [2 2 1]);
