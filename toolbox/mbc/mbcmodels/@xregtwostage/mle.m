function TS= mle(TS,Bmle);
%MLE

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:59:50 $

Models= TS.Global;
Nf= length(Models);

st=1;
for i=1:Nf
   m= Models{i};
   b= double(m);
   Tin= Terms(m);
   b(Tin) = Bmle(st:st+sum(Tin)-1);
   Models{i} = update(m,b);
   st= st+sum(Tin);
end

if (DatumType(TS.Local)==1 | DatumType(TS.Local)==2) & ~RFstart(TS.Local);
   TS.datum= Models{1};
end
TS.Global= Models;
