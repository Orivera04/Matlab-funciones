function [mlist,name]= buildmodels(m,nobs)
% BUILDMODELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.



%   $Revision: 1.7.2.2 $  $Date: 2004/02/09 07:55:15 $

N=get(m,'nmodels');
mlist= cell(1,N);

for i = 1:N;
   set(m,'currentindex',i);
   mlist{i}= m;
end
name= 'Multiple Linear';
