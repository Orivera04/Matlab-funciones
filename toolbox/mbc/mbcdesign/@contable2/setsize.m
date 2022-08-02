function c=setsize(c,sz)
%SETSIZE  Reset number of factors for object
%
%   C=SETSIZE(C,NF)  sets C to work with NF factors
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 06:59:26 $


if sz>=3
   sznow=getsize(c);
   if sz<sznow
      if c.factors(1)>sz
         c.factors(1)=setxor(1:3,c.factors(2:3));
      end
      if c.factors(2)>sz
         c.factors(2)=setxor(1:3,c.factors([1 3]));
      end
      if c.factors(3)>sz
         c.factors(3)=setxor(1:3,c.factors(1:2));
      end
   end
else
   error('Size cannot be below 3 factors for 2D table constraints');
end
