function result = gammain(s_params, z0, zl)
%GAMMAIN Calculates the input reflection coefficient of a two port network. 
%   RESULT = GAMMAIN(S_PARAMS, Z0, ZL) calculates the input reflection coefficient ...
%   of a two port network by 
%
%       GammaIn = S11 + (S12 * S21) * GammaL / (1 - S22 * GammaL);
%       where GammaL = (ZL - Z0)/(ZL + Z0)
%
%   S_PARAMS is a complex 2x2xM array, representing M two-port S-parameters. 
%   Z0 is the reference impedance. If not given, 50 Ohms is used. 
%   ZL is the load impedance. If not given, 50 Ohms is used. 
% 
%   See also GAMMAOUT.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:38:54 $

result = [];
% Check the number of input arguments
error(nargchk(1,3,nargin));

% Check input s_params
[n1 n2 m] = size(s_params);

if (~isnumeric(s_params) || (n1 ~= 2) || (n2 ~= 2))
  error('Input S_PARAMS must be a complex 2x2xM array.');
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

% Get and check the load impedance
if nargin < 3
    zl = 50;
elseif ~isnumeric(zl) || ~isvector(zl) || ((length(zl) ~= 1)&&(length(zl) ~= m))
    error('The load impedance must be a scalar or vector of length M.');
end
if length(zl) == m
    zl = reshape(zl, [1,1,m]);
end
 
% Get the S-parameters
[s11, s12, s21, s22] = deal(s_params(1,1,:), s_params(1,2,:), ...
    s_params(2,1,:), s_params(2,2,:));

% Calculate the GAMMAIN
gammaL = (zl - z0) ./ (zl + z0);
if length(gammaL) == m
    gammaL = reshape(gammaL, [1,1,m]);
end
result = s11 + ((s12 .* s21) .* gammaL) ./ (1 - s22 .* gammaL);
result = result(:);
