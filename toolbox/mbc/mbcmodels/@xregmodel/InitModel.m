function [m,OK]= InitModel(m,x,y,Wc,IsCoded,varargin);
%XREGMODEL/INITMODEL default initmodel method (initialises pev)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:08 $

if nargin>4 & ~IsCoded
	% raw data used
   [x,y,DataOK]= checkdata(m,x,y);
else
   DataOK= isfinite(y);
end

if 0
    J= CalcJacob(m,x);
    [Q,R,okqr]= xregqr(J);
    
    r= y-eval(m,x);
    df= length(y)-numParams(m);
    mse= sum(r.*r)/df;
    ri=1;
    if okqr
        ri= inv(R);
    end
    m= var(m,ri,mse,df);
end
OK=1;