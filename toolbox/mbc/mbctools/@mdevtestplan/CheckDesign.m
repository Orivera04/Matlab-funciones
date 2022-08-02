function OK=CheckDesign(T,X,m);
%CHECKDESIGN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:01 $

nf= length(T.Factors);
if nargin>2
   nfin=length(get(m,'order'));
else
   nfin=size(X,2);
end

if nfin~=nf
   OK= 0;
else
   OK=1;
   T.Design.info= T.Design.factorsettings(X);
   if nargin>2
      T.Design.info= T.Design.model(m);
      T=model(T,m);
   end
   p= pointer(T);
end
