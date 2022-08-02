function z_params = abcd2z(abcd_params)
%ABCD2Z Convert ABCD-parameters to Z-parameters.  
%   Z_PARAMS = ABCD2Z(ABCD_PARAMS) converts the ABCD-parameters ABCD_PARAMS
%   into  the impedance parameters Z_PARAMS. 
%   
%   ABCD_PARAMS is a complex 2x2xM array, representing M two-port ABCD-parameters.
%   Z_PARAMS is a complex 2x2xM array, representing M two-port Z-parameters. 
% 
%   See also Z2ABCD, ABCD2S, ABCD2Y, ABCD2H, S2Z, Y2Z, H2Y.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:38:53 $

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

% Calculate the Z-parameters
delta = a.*d - b.*c;
z_params = [a, delta; ones(size(b)), d] ./ repmat(c, [2 2 1]);
