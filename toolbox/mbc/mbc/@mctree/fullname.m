function fname=fullname(T);
%FULLNAME

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:46 $

fname=name(T);

p= T.Parent;
while p~=0
   T= p.info;
   fname = [name(T),'/',fname];
   p= T.Parent;
end