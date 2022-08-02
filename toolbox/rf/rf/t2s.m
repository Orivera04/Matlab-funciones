function s_params = t2s(t_params)
%T2S Convert T-parameters to S-parameters.  
%   S_PARAMS = T2S(T_PARAMS) converts the chain scattering parameters
%   T_PARAMS into the scattering parameters S_PARAMS.
%   
%   S_PARAMS is a complex 2x2xM array, representing M two-port S-parameters.  
%   T_PARAMS is a complex 2x2xM array, representing M two-port T-parameters.
%
%   See also ABCD2S, Y2S, Z2S, H2S, S2T.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:39:07 $

% Check the input T-parameters
if ~isnumeric(t_params)
    error('Input T parameters must be a complex 2x2xM array.');
end
[n1,n2,m] = size(t_params);
if (n1 ~= 2) || (n2 ~= 2)
    error('Input T parameters must be a complex 2x2xM array.');
end

% Get the T-parameters 
[t11, t12, t21, t22] = deal(t_params(1,1,:), t_params(1,2,:), ...
    t_params(2,1,:), t_params(2,2,:));

% Calculate the S-parameters
delta = t11.*t22-t21.*t12;
s_params = [t21./t11, delta./t11; 1./t11, -t12./t11];
