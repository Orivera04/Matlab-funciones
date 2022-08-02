function [mout,OK]= leastsq(m,x,y,Wc);
% xreglinear/LEASTSQ least squares estimate of model

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:55 $

if nargin<4
   Wc=[];
end
   
[m,OK]= InitModel(m,x,y,Wc);
if OK
   % Calculate coefficients
   Store = get(m,'Store');
   % pad y
   y = [Store.y; zeros(size(Store.Q,1) - size(Store.X,1),1)];
   Beta = zeros(size(Store.X,2),1);
   Beta(Terms(m))= Store.R\(Store.Q'*y);
   m = update(m,Beta);
   fitalg=get(m,'fitalg');
   if ischar(fitalg) && strcmp(fitalg,'leastsq')
       % if this is not being computed elsewhere....
		 cost = log10(calcGCV(m));%
		 setFitOpt(m,'cost',cost);
   end
   mout=m;
else
   mout=m;
end   
