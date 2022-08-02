function abcd_params = z2abcd(z_params)
%Z2ABCD Convert Z-parameters to ABCD-parameters.  
%   Z_PARAMS = Y2Z(Y_PARAMS) converts the impedance parameters Z_PARAMS 
%   into the ABCD parameters ABCD_PARAMS. 
%   
%   Z_PARAMS is a complex 2x2xM array, representing M two-port Z-parameters. 
%   ABCD_PARAMS is a complex 2x2xM array, representing M two-port ABCD-parameters.
%
%   See also ABCD2Z, Z2S, Z2Y, Z2H, S2ABCD, Y2ABCD, H2ABCD.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:39:13 $

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

% Calculate the ABCD-parameters
delta = z11 .* z22 - z12 .* z21;
abcd_params = [z11, delta; ones(size(z21)), z22] ./ repmat(z21, [2 2 1]);
