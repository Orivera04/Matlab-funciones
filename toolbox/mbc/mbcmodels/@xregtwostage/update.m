function TS= mleparams(TS,Bmle);
%UPDATE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:00:19 $

Models= TS.Global;
Nf= length(Models);

st=1;
for i=1:Nf
   m= Models{i};
   ind=  st:st+numParams(m)-1;
   Models{i} = UpdateParams(m,Bmle(ind));
   st= st+numParams(m);
end

if (DatumType(TS.Local)==1 | DatumType(TS.Local)==2) & ~RFstart(TS.Local);
   % datum model is also an rf
   TS.datum= Models{1};
end
TS.Global= Models;
