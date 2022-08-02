function z_params = h2z(h_params)
%H2Z Convert H-parameters to Z-parameters.  
%   Z_PARAMS = H2Z(H_PARAMS) converts the hybrid parameters H_PARAMS
%   into the impedance parameters Z_PARAMS. 
%   
%   H_PARAMS is a complex 2x2xM array, representing M two-port H-parameters. 
%   Z_PARAMS is a complex 2x2xM array, representing M two-port Z-parameters.
%
%   See also Z2H, H2S, H2Y, H2ABCD, S2Z, Y2Z, ABCD2Z.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:38:59 $

% Check the input H-parameters
if ~isnumeric(h_params)
    error('Input H-parameters must be a complex 2x2xM array.');
end
[n1,n2,m] = size(h_params);
if (n1 ~= 2) || (n2 ~= 2)
    error('Input H-parameters must be a complex 2x2xM array.');
end

% Get the H-parameters
[h11, h12, h21, h22] = deal(h_params(1,1,:), h_params(1,2,:), ...
    h_params(2,1,:), h_params(2,2,:));

% Calculate the Z-parameters
delta = h11 .* h22 - h12 .* h21;
z_params = [delta, h12; -h21, ones(size(h22))] ./ repmat(h22, [2 2 1]);
