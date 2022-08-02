function c=setsize(c,sz)
%SETSIZE  Reset number of factors for object
%
%   C=SETSIZE(C,NF)  sets C to work with NF factors
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:26:29 $


if sz>=2
   sznow=getsize(c);
   if sz<sznow
      if c.factors(1)>sz
         if c.factors(2)~=1
            c.factors(1)=1;
         else
            c.factors(1)=2;
         end
      end
      if c.factors(2)>sz
         if c.factors(1)~=1
            c.factors(2)=1;
         else
            c.factors(2)=2;
         end   
      end
   end
else
   error('Size cannot be below 2 factors for 1D table constraints');
end
