function m= updateallparameters(m,b);
%XREGRBF/UPDATEALLPARAMETERS 
%
% b= [nc; size(widths); lambda; widths(:); centers(:); weights(:)];

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.6.1 $  $Date: 2004/02/09 07:57:29 $

nf= nfactors(m);
nc= b(1);
nw= b(2:3)';
lambda= b(4);
n= prod(nw)+4;
w= reshape(b(5:n),nw);
c= reshape(b(n+1:n+nc*nf),nc,nf);
n= n+nc*nf;
b= b(n+1:end);

set(m,'lambda',lambda);
m.width= w;
m.centers= c;
m= update(m,b);
% set qr algorithm up correctly
if all(lambda==0)
   m.xreglinear=set(m.xreglinear,'qr','ols');
else
   try
      switch getname(get(m.om,'CenterSelectionAlg'))
         case {'rols','wigglecenters'}
            m.xreglinear=set(m.xreglinear,'qr','rols');
         otherwise
            m.xreglinear=set(m.xreglinear,'qr','ridge');
      end         
   catch
      m.xreglinear=set(m.xreglinear,'qr','ridge');
   end
end      


