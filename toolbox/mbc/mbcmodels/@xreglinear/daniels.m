function daniels(m)
%DANIELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.3 $  $Date: 2004/02/09 07:49:20 $




ah= gca;

t= Terms(m);
p= parameters(m);

n= length(p);

[ps,i]=sort(abs(p));
ns= norminv(0.5+((1:n)-0.5)./(2*n-1));

plot(ns,ps,'*','linewidth',2,'parent',ah)

del= diff(get(ah,'xlim'))/100;
lab= labels(m,1,0);
lab= lab(t);
for j=1:length(lab);
	ind= i(j);
	text(ns(j)+del,ps(j),lab{ind},'clipping','on','parent',ah);
end
