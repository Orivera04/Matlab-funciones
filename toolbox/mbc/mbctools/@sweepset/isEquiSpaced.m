function ok= isEquiSpaced(X,tol);
% SWEEPSET/ISEQUISPACED checks whether first column of X is equispaced within sweeps
%
% ok= isEquiSpaced(X,tol)
% if the sweepset is equispaced the value of ok is is the spacing
% the tolerance is 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:06:26 $

s= tsizes(X);

d1= diff(X.data(:,1));

s(s<=1)=[];

% delete last element in each sweep
d1(cumsum(s(1:end-1)))=[];

if nargin<2
   tol= mean(abs(d1))*1e-4;
end

d2= diff(d1);
s(s<=2)=[];

d2(cumsum(s(1:end-1)-1))=[];

ok=  all(abs(d2-mean(d2))<tol);
if ok
   ok= mean(d1);
end