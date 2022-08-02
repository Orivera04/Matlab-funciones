function [res,J,YHAT]= gls_costB(B,L,DATA,Wc)
% localpspline/GLS_COSTB

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:41:13 $

if nargin<4
   Wc=[];
end
[res,B,J,YHAT]= costknot(B(1,:),L,DATA,Wc);
