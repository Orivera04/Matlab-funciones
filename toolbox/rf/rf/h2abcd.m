function abcd_params = h2abcd(h_params)
%H2ABCD Convert H-parameters to ABCD-parameters.  
%   ABCD_PARAMS = H2ABCD(H_PARAMS) converts the hybrid parameters H_PARAMS
%   into the ABCD-parameters ABCD_PARAMS. 
%   
%   H_PARAMS is a complex 2x2xM array, representing M two-port H-parameters. 
%   ABCD_PARAMS is a complex 2x2xM array, representing M two-port ABCD-parameters.
%
%   See also ABCD2H, H2S, H2Y, H2Z, S2ABCD, Y2ABCD, Z2ABCD.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:38:56 $

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

% Calculate the ABCD-parameters
delta = h11 .* h22 - h12 .* h21;
abcd_params = [-delta, -h11; -h22, -ones(size(h22))] ./ repmat(h21, [2 2 1]);
