function y_params = abcd2y(abcd_params)
%ABCD2Y Convert ABCD-parameters to Y-parameters.  
%   Y_PARAMS = ABCD2Y(ABCD_PARAMS) converts the ABCD-parameters ABCD_PARAMS
%   into the admittance parameters Y_PARAMS. 
%   
%   ABCD_PARAMS is a complex 2x2xM array, representing M two-port ABCD-parameters.
%   Y_PARAMS is a complex 2x2xM array, representing M two-port Y-parameters. 
% 
%   See also Y2ABCD, ABCD2S, ABCD2Z, ABCD2H, S2Y, Z2Y, H2Y.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:52 $

% Check the input ABCD-parameters
if ~isnumeric(abcd_params)
    error('Input ABCD parameters must be a complex 2x2xM array.');
end
[n1,n2,m] = size(abcd_params);
if (n1 ~= 2) || (n2 ~= 2)
    error('Input ABCD parameters must be a complex 2x2xM array.');
end

% Get the ABCD-parameters 
[a, b, c, d] = deal(abcd_params(1,1,:), abcd_params(1,2,:), ...
    abcd_params(2,1,:), abcd_params(2,2,:));

% Calculate the Y-parameters
delta = a.*d - b.*c;
y_params = [d, -delta; -ones(size(b)), a] ./ repmat(b, [2 2 1]);
