function [U,OK]= leastsq(U,x,y,varargin);
% xregusermod/LEASTSQ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:01:21 $

[om,optparams]= optimargs(U);


% run optimisation
x0= U.parameters;

[U,cost,OK,xf]= run(om,U,x0,x,y);
U.parameters= xf;

J= CalcJacob(U,x);
[Q,R,okqr]= xregqr(J);
if okqr
    % initialise var info
    r= y-eval(U,x);
    df= length(y)-length(xf);
    mse= sum(r.*r)/df;
    ri= inv(R);
    U= var(U,ri,mse,df);
end

