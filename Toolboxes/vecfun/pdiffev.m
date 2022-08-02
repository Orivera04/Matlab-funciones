function D=pdiffev(xi,yi,zi,F,dim,order)
%PDIFFEV  Partial differentiation evaluator.
%   Evaluation of PDIFF.

% Copyright (c) 2001-04-18, B. Rasmus Anthin.

minx=min(xi,[],2);miny=min(yi,[],1);minz=min(zi,[],3);
minx=minx(1);miny=miny(1);minz=minz(1);
maxx=max(xi,[],2);maxy=max(yi,[],1);maxz=max(zi,[],3);
maxx=maxx(1);maxy=maxy(1);maxz=maxz(1);
siz=size(xi);siz=siz([2 1 3]);
Hx=(maxx-minx)/siz(1);
Hy=(maxy-miny)/siz(2);
Hz=(maxz-minz)/siz(3);
if length(F)==1, F=F*ones(size(xi));end
if order>0
   [Gx Gy Gz]=gradient(F,Hx,Hy,Hz);
   switch(dim)
   case 1
      D=Gx;
   case 2
      D=Gy;
   case 3
      D=Gz;
   end
else
   D=F;
end
if order>1
   D=pdiffev(xi,yi,zi,D,dim,order-1);
end
