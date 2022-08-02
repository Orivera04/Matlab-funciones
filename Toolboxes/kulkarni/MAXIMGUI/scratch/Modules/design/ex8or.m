function [y,x,g]=ex8or(C,D,dist_called,par)
%y=ex8or(C,D,k,l,x)
%C =  Cost of planned replacement.
%D =  Additional cost of unplanned replacement.
switch dist_called
case 2
   k=par(1);
   l=par(2);
if k ~=1
   m=k/l;
   T=m;
   [y,yy,yyy] = erl(k,l,T);%y=g(T), yy=G(T), yyy = int_0^T(1-G(t))dt
   while D*y*yyy > (C + D*yy)*(1-yy)
      T=T/2;
      [y,yy,yyy] = erl(k,l,T);
   end
   Tmin=T;
   T=m;
   [y,yy,yyy] = erl(k,l,T);
   while D*y*yyy < (C+D*yy)*(1-yy)
      T=2*T;
      [y,yy,yyy]=erl(k,l,T);
   end;
   Tmax=T;
   TL=Tmin; TU=Tmax;
   while TU-TL >=.001
      T=(TL+TU)/2.0;
      [y,yy,yyy]=erl(k,l,T);
      if D*y*yyy > (C+D*yy)*(1-yy)
         TU=T;
      elseif D*y*yyy < (C+D*yy)*(1-yy)
         TL = T;
      else
         TL=T;TU=T;
      end;
   end;
   y=[(C+D*yy)/yyy T];
   x=[Tmin:(Tmax-Tmin)/25:Tmax+.001];
   g=[]
   for i=1:size(x,2)
      [a,aa,aaa]=erl(k,l,x(i));
      g=[g (C+D*aa)/aaa];
   end
else
   y=[l*(C+D), Inf];
   x=[.25/l:.1/l:2.75/l];
   g=[];
   for i=1:size(x,2)
      g=[g l*(C+D*(1-exp(-l*x(i))))/(1-exp(-l*x(i)))];
   end;
   
end;



case 8
   GT=par(1);IGT=0;g=[];
   for i=2:size(par,2)
      IGT = IGT + 1-GT;
      GT=GT+par(i);
      g=[g (C+D*GT)/IGT];
   end;
   [gmin,i]=min(g);
   y=[gmin,i(1)]
   x=[1:size(par,2)-1];
end %switch


