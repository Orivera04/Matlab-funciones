function h_params = s2h(s_params, z0)
%S2H Convert S-parameters to H-parameters.  
%   H_PARAMS = S2H(S_PARAMS, Z0) converts the scattering parameters S_PARAMS 
%   into the hybrid parameters H_PARAMS. 
%   
%   S_PARAMS is a complex 2x2xM array, representing M two-port S-parameters. 
%   Z0 is the reference impedance. If not given, 50 Ohms is used. 
%   H_PARAMS is a complex 2x2xM array, representing M two-port H-parameters.
%
%   See also H2S, S2Y, S2Z, S2ABCD, Y2H, Z2H, ABCD2H.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:39:01 $

% Check the input S-parameters
if ~isnumeric(s_params)
    error('Input S-parameters must be a complex 2x2xM array.');
end
[n1,n2,m] = size(s_params);
if (n1 ~= 2) || (n2 ~= 2)
    error('Input S-parameters must be a complex 2x2xM array.');
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

% Get the S-parameters
[s11, s12, s21, s22] = deal(s_params(1,1,:), s_params(1,2,:), ...
    s_params(2,1,:), s_params(2,2,:));

% Calculate the H-parameters
delta = (1-s11).*(1+s22)+s12.*s21;
h_params = [z0.*((1+s11).*(1+s22)-s12.*s21),2*s12; -2*s21, ...
    (((1-s11).*(1-s22)-s12.*s21))./z0] ./ repmat(delta, [2 2 1]);
