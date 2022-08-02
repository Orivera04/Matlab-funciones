function q=diff(p,m);
% POLYNOM/DIFF  Differentiate polynomial

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:40:19 $



q=p;
c=double(q)';
if nargin<2
   m=1;
end

for i=1:m
   if length(c)>1
      n= length(c)-1:-1:1;
      c= n.*c(1:end-1);
   else
      c=0;
   end
end
q.xreglinear= update(q.xreglinear,c(:));
