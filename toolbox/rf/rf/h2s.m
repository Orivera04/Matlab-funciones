function s_params = h2s(h_params, z0)
%H2S Convert H-parameters to S-parameters.  
%   S_PARAMS = H2S(H_PARAMS, Z0) converts the hybrid parameters H_PARAMS
%   into the scattering parameters ABCD_PARAMS. 
%   
%   H_PARAMS is a complex 2x2xM array, representing M two-port H-parameters. 
%   Z0 is the reference impedance. If not given, 50 Ohms is used. 
%   S_PARAMS is a complex 2x2xM array, representing M two-port S-parameters.
%
%   See also S2H, H2Y, H2Z, H2ABCD, Y2S, Z2S, ABCD2S.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:38:57 $

% Check the input H-parameters
if ~isnumeric(h_params)
    error('Input H-parameters must be a complex 2x2xM array.');
end
[n1,n2,m] = size(h_params);
if (n1 ~= 2) || (n2 ~= 2)
    error('Input H-parameters must be a complex 2x2xM array.');
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

% Get the H-parameters 
[h11, h12, h21, h22] = deal(h_params(1,1,:)./z0, h_params(1,2,:), ...
    h_params(2,1,:), h_params(2,2,:).*z0);

% Calculate the S-parameters
delta = (h11+1).*(h22+1)-h12.*h21;
s_params = [((h11-1).*(h22+1)-h12.*h21), 2*h12; -2*h21, ...
    ((1+h11).*(1-h22)+h12.*h21)] ./ repmat(delta, [2 2 1]);
