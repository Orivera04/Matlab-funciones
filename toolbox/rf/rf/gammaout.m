function result = gammaout(s_params, z0, zs)
%GAMMAOUT Calculates the output reflection coefficient of a two port network. 
%   RESULT = GAMMAOUT(S_PARAMS, Z0, ZS) calculates the output reflection coefficient ...
%   of a two port network by 
%
%       GammaOut = s22 + (S12 * S21) * GammaS / (1 - S11 * GammaS)
%       where GammaS =  (ZS - Z0)/(ZS + Z0)
%
%   S_PARAMS is a complex 2x2xM array, representing M two-port S-parameters. 
%   Z0 is the reference impedance. If not given, 50 Ohms is used. 
%   ZS is the source impedance. If not given, 50 Ohms is used. 
% 
%   See also GAMMAIN.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $  $Date: 2004/04/12 23:38:55 $

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

% Get and check the source impedance
if nargin < 3
    zs = 50;
elseif ~isnumeric(zs) || ~isvector(zs) || ((length(zs) ~= 1)&&(length(zs) ~= m))
    error('The source impedance must be a scalar or vector of length M.');
end
if length(zs) == m
    zs = reshape(zs, [1,1,m]);
end
 
% Get the S-parameters
[s11, s12, s21, s22] = deal(s_params(1,1,:), s_params(1,2,:), ...
    s_params(2,1,:), s_params(2,2,:));

% Calculate the GAMMAOUT
gammaS = (zs - z0) ./ (zs + z0);
if length(gammaS) == m
    gammaS = reshape(gammaS, [1,1,m]);
end
result = s22 + ((s12 .* s21) .* gammaS) ./ (1 - s11 .* gammaS);
result = result(:);
