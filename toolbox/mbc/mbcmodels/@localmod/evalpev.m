function p= evalpev(x,L,Xfitdata,Yfitdata,individ);
% LOCALMOD/EVALPEV

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:38:57 $



if nargin<5
	individ=0;
end

[ri,s2,df]= var(L);
if isempty(ri) 
   if nargin>2
      L= pevinit(L,Xfitdata,Yfitdata);
      [ri,s2,df]= var(L);
   else
      ri=1;
   end
end


Jx= CalcJacob(L,x);
lev= Jx*ri;
p= sum(lev.*lev,2);

if individ
	% individual observation variance
   if ~isempty(L.covmodel);
      s2= diag(cov(L.covmodel,yhat,Xd)).*s2;
   end
   p= p+s2;
end

