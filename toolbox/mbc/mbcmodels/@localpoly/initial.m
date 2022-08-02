function  [B,MINB,MAXB,OK] = initial(poly,Xs,Ys);
%INITIAL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:40:28 $

B= zeros(size(poly,1),1);
[B,yhat,res,J,OK] = gls_fitB(poly,B,{[Xs Ys]});

MINB=[];
MAXB=[];