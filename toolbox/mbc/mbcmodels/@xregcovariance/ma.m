function [w,bnds,A,b,nl]= MA(c,yhat,X,varargin);
% COVMODEL/ARMA Moving Average model 
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:46:23 $


if nargin==1
   w= 1;
   bnds= [-0.99 0.99];
   A=[];
   b=[];
   nl=[];
else
   ny= length(yhat);
   nx = round((X(end,1)-X(1,1))/c.Ts)+1;

   x= [1 zeros(1,nx-1)];
   b= [1 c.cparam];
   
   w= filter(b,1,x);
   w= toeplitz(w);
   
   if nx~=ny
      % get rid of missing points
      xind= round((X(:,1)-X(1,1))/c.Ts + 1);
      ok= intersect(1:nx,xind);
      w= w(ok,ok);
   end
end
