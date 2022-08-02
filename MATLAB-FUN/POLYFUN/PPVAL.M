function v=ppval(pp,xx)
%PPVAL	Evaluate piecewise polynomial.
%
%	  v = ppval(pp,xx)
%
%	returns the value of the pp function  pp  at  xx.
%
%	See also MKPP, UNMKPP, SPLINE.

%	Carl de Boor 7-2-86
%	Copyright (c) 1984-94 by The MathWorks, Inc.

%  if necessary, sort  xx 
[m,n] = size(xx); v=zeros(m,n);
xs=xx(:);ix=length(xs);tosort=0;
if (max(size(find(diff(xs)<0)))>0),
   tosort=1;[xs,indx]=sort(xs);
end

%  take apart  pp
[x,c,l,k]=unmkpp(pp);

ilow=1;ixs=length(xs);
while ilow<=ixs;
   index=find(x(2:l+1)>xs(ilow));
   if max(size(index))==0,
      j=l;
   else,
      j=index(1);
   end
   if j<l;
      index=find(xs(ilow:ixs)<x(j+1));
      ihigh=ilow-1+index(max(size(index)));
   else,
      ihigh=ixs;
   end
   v(ilow:ihigh)=polyval(c(j,:),xs(ilow:ihigh)-x(j));
   ilow=ihigh+1;
end;

if tosort>0,[junk,indx]=sort(indx); v=v(indx);end
v = reshape(v,m,n);
