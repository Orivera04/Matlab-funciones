function [y,x,g]=ex8ont(l,m,K,Ct,Cw)
%y=ex8ont(l,m,K,Ct,Cw)
%l = arrival rate in customers per hour.
%m = service rate in customers per hour.
%Ct = Teller cost in dollars per teller per hour.
%Cw = Waiting cost in dollars per customer per hour.
%K =  Capacity, number of customers.
r = l/m;g=[]; 
for s = 0:K
   if l >= s*m
      g=[g s*Ct + Cw*K];
      else
   y=mmsk(l,m,s,K);
   g=[g s*Ct+Cw*y{1}];
   end;
  end;
  [x1,x2]=min(g);
  y=[x1,x2(1)-1];
  x=[0:K];

