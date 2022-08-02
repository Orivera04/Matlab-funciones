function y=ex8ont(l,m,K,Ct,Cw)
%y=ex8ont(l,m,K,Ct,Cw)
%l = arrival rate in customers per hour.
%m = service rate in customers per hour.
%Ct = Teller cost in dollars per teller per hour.
%Cw = Waiting cost in dollars per customer per hour.
%K =  Capacity, number of customers.
y='error';
if l < 0 
   msgbox('invalid entry for l'); return;
elseif m < 0
   msgbox('invalid entry for m'); return;
else
r = l/m;g=[]; 
for s = 0:K
   y=mmsk(l,m,s,K,1);
   if y(1,1) ~= 'error'
      g=[g s*Ct+Cw*y];
   end;
end;
y=g;
plot(g)
end;

