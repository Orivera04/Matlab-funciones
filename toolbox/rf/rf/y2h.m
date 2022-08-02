function h_params = y2h(y_params)
%Y2H Convert Y-parameters to H-parameters.  
%   H_PARAMS = Y2H(Y_PARAMS) converts the admittance parameters Y_PARAMS 
%   into the hybrid parameters H_PARAMS. 
%   
%   Y_PARAMS is a complex 2x2xM array, representing M two-port Y-parameters.
%   H_PARAMS is a complex 2x2xM array, representing M two-port H-parameters. 
%
%   See also H2Y, Y2S, Y2Z, Y2ABCD, S2H, Z2H, ABCD2H.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:39:10 $

% Check the input Y-parameters
if ~isnumeric(y_params)
    error('Input Y-parameters must be a complex 2x2xM array.');
end
[n1,n2,m] = size(y_params);
if (n1 ~= 2) || (n2 ~= 2)
    error('Input Y-parameters must be a complex 2x2xM array.');
end

% Get the Y-parameters
[y11, y12, y21, y22] = deal(y_params(1,1,:), y_params(1,2,:), ...
    y_params(2,1,:), y_params(2,2,:));

% Calculate the H-parameters
delta = y11 .* y22 - y12 .* y21;
h_params = [ones(size(y11)), -y12; y21, delta] ./ repmat(y11, [2 2 1]);
