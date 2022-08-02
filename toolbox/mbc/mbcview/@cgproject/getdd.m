function p=getdd(proj)
%GETDD  Return pointer to data dictionary node
%
%  P_DD=GETDD(PROJ)
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:28:08 $

proj=address(proj);

tp=cgtypes.cgddtype;

ch=proj.children;
found=0;
n=1;
while ~found & n<=length(ch);
   if matchtype(ch(n).typeobject,tp)
      found=1;
   else
      n=n+1;
   end
end

if n<=length(ch);
   p=ch(n);
else
   p=[];
end
