function s2_params = deembedsparams(s_params, s1_params, s3_params)
%DEEMBEDSPARAMS De-embed S-parameters.  
%   S2_PARAMS = DEEMBEDSPARAMS(S_PARAMS, S1_PARAMS, S3_PARAMS) de-embeds
%   the scattering parameters S_PARAMS by removing the effects of S1_PARAMS
%   and S3_PARAMS. Each of the network must be a 2x2xM array for two port
%   network, and has the same reference impedance. 
%   
%   S2_PARAMS is a 2x2xM array, the de-embedded S-parameters.
%   S1_PARAMS must be a 2x2xM array, the S-parameters of the 1st network.
%   S3_PARAMS must be a 2x2xM array, the S-parameters of the 3rd network.
%   S_PARAMS must be a 2x2xM array, the S-parameters of the cascaded
%   network of S1_PARAMS, S2_PARAMS and S3_PARAMS. 
%
%   See also T2S, S2T, CASCADESPARAMS.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/03/30 13:12:01 $

error(nargchk(3,3,nargin))

% Set the default
s2_params = [];

% Check the S-parameters
if ~isnumeric(s_params) || ~isnumeric(s1_params) || ~isnumeric(s3_params)
    error('Input must be a complex 2x2xM array.');
end
[n,k,m] = size(s_params);
[n1,k1,m1] = size(s1_params);
[n3,k3,m3] = size(s3_params);
if (n ~= 2) || (k ~= 2) || (n1 ~= 2) || (k1 ~= 2) || (n3 ~= 2) || (k3 ~= 2)
    error('Input must be a complex 2x2xM array.');
end
if (m ~= m1) || (m ~= m3)
    error('Array size of each input must be same.');
end
    
% Calculate the T-parameters
t_params = s2t(s_params);
t1_params = s2t(s1_params);
t3_params = s2t(s3_params);

% Calculate the de-embedded T-parameters
for k=1:m
    t2_params(:,:,k) = inv(t1_params(:,:,k)) * t_params(:,:,k) * inv(t3_params(:,:,k));
end

% Convert to S-parameters
s2_params = t2s(t2_params);