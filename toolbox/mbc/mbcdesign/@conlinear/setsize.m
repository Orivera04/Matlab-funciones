function c=setsize(c,sz)
%SETSIZE  Reset number of factors for object
%
%   C=SETSIZE(C,NF)  sets C to work with NF factors
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:58:28 $

sznow=getsize(c);

if sz<sznow
   c.A=c.A(1:sz);
elseif sz>sznow
   c.A=[c.A ones(1,sz-sznow)];
end