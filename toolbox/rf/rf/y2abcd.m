function abcd_params = y2abcd(y_params)
%Y2ABCD Convert Y-parameters to ABCD-parameters.  
%   ABCD_PARAMS = Y2ABCD(Y_PARAMS) converts the admittance parameters Y_PARAMS 
%   into the ABCD parameters ABCD_PARAMS. 
%   
%   Y_PARAMS is a complex 2x2xM array, representing M two-port Y-parameters.
%   ABCD_PARAMS is a complex 2x2xM array, representing M two-port ABCD-parameters. 
%
%   See also ABCD2Y, Y2S, Y2Z, Y2H, S2ABCD, Z2ABCD, H2ABCD.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:39:09 $

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

% Calculate the ABCD-parameters
delta = y11 .* y22 - y12 .* y21;
abcd_params = [-y22, -ones(size(y12)); -delta, -y11] ./ repmat(y21, [2 2 1]);
