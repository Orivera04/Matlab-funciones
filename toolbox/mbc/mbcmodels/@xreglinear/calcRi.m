function Ri = calcRi(m, Q, R);
% xreglinear/calcRi
% 
%  Ri= calcRi(m);
%  Inputs: 
%  m - xreglinear
%  Outputs
%    Ri     matrix to compute PEV with

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:15 $

if nargin < 3
   R = m.Store.R;
   Q = m.Store.Q;
end   
   
switch m.qr
case 'ols'
   Ri = inv(R);
otherwise
   Ri = R\Q';
end   
   

