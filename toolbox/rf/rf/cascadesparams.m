function s_params = cascadedsparams(varargin)
%CASCADEDSPARAMS Cascade S-parameters.  
%   S_PARAMS = CASCADEDSPARAMS(S1_PARAMS, S2_PARAMS, ..., SN_PARAMS)
%   cascades the scattering parameters: S1_PARAMS, S2_PARAMS, ...,
%   SN_PARAMS. Each of the inputs must be a 2x2xM array for two port
%   network, and has the same reference impedance. 
%   
%   S1_PARAMS must be a 2x2xM array, the S-parameters of the 1st network.
%   S2_PARAMS must be a 2x2xM array, the S-parameters of the 2nd network.
%   SN_PARAMS must be a 2x2xM array, the S-parameters of the n-th network.
%   S_PARAMS is a 2x2xM array, the S-parameters of the cascaded network.
%
%   See also T2S, S2T, DEEMBEDSPARAMS.

%   Copyright 2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/03/30 13:12:00 $

error(nargchk(1,Inf,nargin))

% Set the default
s_params = [];

% Get the 1st S-parameters
s1_params = varargin{1};
% Check the S-parameters
if ~isnumeric(s1_params) 
    error('Each input must be a complex 2x2xM array.');
end
[n1,n2,m1] = size(s1_params);
if (n1 ~= 2) || (n2 ~= 2)
    error('Each input must be a complex 2x2xM array.');
end
    
if nargin > 1
    t_params = s2t(s1_params);
    % Calculate the cascaded S-parameters
    for i = 2:nargin
        % Get the 2nd S-parameters
        s2_params = varargin{i};
        % Check the 2nd S-parameters
        if ~isequal(size(s1_params),size(s2_params))
            error('Array size of each input must be same.');
        end
        % Get the 1st T-parameters
        t1_params = t_params;
        % Get the 2nd T-parameters
        t2_params = s2t(s2_params);
        % Cascaded T-parameters
        t_params = zeros(2,2,m1);
        for k=1:m1
            t_params(:,:,k) = t1_params(:,:,k)*t2_params(:,:,k);
        end
    end

    % Convert to S-parameters
    s_params = t2s(t_params);
else
    s_params = s1_params;
end
