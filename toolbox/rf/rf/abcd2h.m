function h_params = abcd2h(abcd_params)
%ABCD2H Convert ABCD-parameters to H-parameters.  
%   H_PARAMS = ABCD2H(ABCD_PARAMS) converts the ABCD-parameters ABCD_PARAMS
%   into the hybrid parameters H_PARAMS.
%   
%   ABCD_PARAMS is a complex 2x2xM array, representing M two-port ABCD-parameters.
%   H_PARAMS is a complex 2x2xM array, representing M two-port H-parameters. 
% 
%   See also H2ABCD, ABCD2S, ABCD2Y, ABCD2Z, S2H, Y2H, Z2H.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:50 $

% Check the input ABCD-parameters
if ~isnumeric(abcd_params)
    error('Input ABCD parameters must be a complex 2x2xM array.');
end
[n1,n2,m] = size(abcd_params);
if (n1 ~= 2) || (n2 ~= 2)
    error('Input ABCD parameters must be a complex 2x2xM array.');
end

% Get the ABCD-parameters
[a, b, c, d] = deal(abcd_params(1,1,:), abcd_params(1,2,:), ...
    abcd_params(2,1,:), abcd_params(2,2,:));

% Calculate the H-parameters
delta = a .* d - b .* c;
h_params = [b, delta; -ones(size(b)), c] ./ repmat(d, [2 2 1]);
