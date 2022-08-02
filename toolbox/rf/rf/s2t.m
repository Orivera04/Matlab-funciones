function t_params = s2t(s_params)
%S2T Convert S-parameters to T-parameters.  
%   T_PARAMS = S2T(S_PARAMS) converts the scattering parameters S_PARAMS 
%   into the chain scattering parameters T_PARAMS. 
%   
%   S_PARAMS is a complex 2x2xM array, representing M two-port S-parameters.  
%   T_PARAMS is a complex 2x2xM array, representing M two-port T-parameters.
%
%   See also S2ABCD, S2Y, S2Z, S2H, T2S.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:39:03 $

% Check the input S-parameters
if ~isnumeric(s_params)
    error('Input S-parameters must be a complex 2x2xM array.');
end
[n1,n2,m] = size(s_params);
if (n1 ~= 2) || (n2 ~= 2)
    error('Input S-parameters must be a complex 2x2xM array.');
end

% Get the S-parameters
[s11, s12, s21, s22] = deal(s_params(1,1,:), s_params(1,2,:), ...
    s_params(2,1,:), s_params(2,2,:));

% Calculate the T-parameters
delta = (s11.*s22-s12.*s21);
t_params = [1./s21, -s22./s21; s11./s21, -delta./s21];
