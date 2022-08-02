function dg= delrf(u,i)
%DELRF

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:43:42 $


[rf,dg]= rfvals(u.userdefined);
dg= dg(i,:);