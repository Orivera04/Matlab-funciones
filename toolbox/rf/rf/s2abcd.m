function abcd_params = s2abcd(s_params, z0)
%S2ABCD Convert S-parameters to ABCD-parameters.  
%   ABCD_PARAMS = S2ABCD(S_PARAMS, Z0) converts the scattering parameters
%   S_PARAMS into the ABCD parameters ABCD_PARAMS. 
%   
%   S_PARAMS is a complex 2x2xM array, representing M two-port S-parameters. 
%   Z0 is the reference impedance. If not given, 50 Ohms is used. 
%   ABCD_PARAMS is a complex 2x2xM array, representing M two-port ABCD-parameters.
%
%   See also ABCD2S, S2Y, S2Z, S2H, Y2ABCD, Z2ABCD, H2ABCD.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:39:00 $

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

% Calculate the ABCD-parameters
temp1 = 1 - s11;        temp2 = 1 + s11;
temp3 = 1 - s22;        temp4 = 1 + s22;
s12s21 = s12 .* s21;

abcd_params = [temp2 .* temp3 + s12s21, (temp2 .* temp4 - s12s21) .* z0; ...
   (temp1 .* temp3 - s12s21) ./ z0, temp1 .* temp4 + s12s21] ./ ...
   repmat(2 * s21, [2 2 1]);
