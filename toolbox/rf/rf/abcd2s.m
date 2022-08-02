function s_params = abcd2s(abcd_params, z0)
%ABCD2S Convert ABCD-parameters to S-parameters.  
%   S_PARAMS = ABCD2S(ABCD_PARAMS, Z0) converts the ABCD-parameters ABCD_PARAMS
%   into the scattering parameters S_PARAMS.
%   
%   ABCD_PARAMS is a complex 2x2xM array, representing M two-port ABCD-parameters.
%   Z0 is the reference impedance. If not given, 50 Ohms is used. 
%   S_PARAMS is a complex 2x2xM array, representing M two-port S-parameters. 
% 
%   See also S2ABCD, ABCD2Y, ABCD2Z, ABCD2H, Y2S, Z2S, H2S.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/12 23:38:51 $

% Check the input ABCD-parameters
[n1,n2,m] = size(abcd_params);
if ~isnumeric(abcd_params)
    error('Input ABCD parameters must be a complex 2x2xM array.');
end
if (n1 ~= 2) || (n2 ~= 2)
    error('Input ABCD parameters must be a complex 2x2xM array.');
end

% Get and check the reference impedance
if nargin < 2
    z0 = 50;
elseif ~isnumeric(z0) || ~isvector(z0) || ((length(z0) ~= 1)&&(length(z0) ~= m))
    error('The reference impedance must be a scalar or vector of length M.');
end
if length(z0) == m
    z0 = reshape(z0, [1,1,m]);
end

% Get the ABCD-parameters 
[a, b, c, d] = deal(abcd_params(1,1,:), abcd_params(1,2,:) ./ z0, ...
    abcd_params(2,1,:) .* z0, abcd_params(2,2,:));

% Calculate the S-parameters
delta = a+b+c+d;
s_params = [(a+b-c-d), 2*(a.*d-b.*c); 2*ones(size(b)), (-a+b-c+d)] ./ ...
    repmat(delta, [2 2 1]);
