function P = ex9inv(x,aa)
%P = ex9inv(x,aa)
% returns the cost matrix if aa = -1, and the tr. pr. P(aa-1) otherwise for the inventory example.
% h = holding cost per week per item.
% p = selling price per item.
% c = purchase price of an item.
% d = delivery cost.
% B = storage capacity.
% l = demand is P(l) each week.
   h=x(1); p=x(2); c=x(3); d=x(4); B=x(5); l=x(6);
   al = poissoncdf(l,B);
if aa == -1
P = d*[zeros(B+1,1) ones(B+1,B)] + c*ones(B+1,1)*[0:B] + h*[0:B]'*ones(1,B+1);
ed = zeros(B+1,1);
for i = 2:B+1
ed(i) = ed(i-1) + 1-al(i-1);
end;
P(:,1) = P(:,1) - p*ed;
for i = 1:B+1
for a = 2:B+1
P(i,a) = P(i,a) - p*ed(min(i-1+a-1,B)+1); 
end;
end;
elseif (1 <= aa)&(aa<=B+1)
P = zeros(B+1,B+1);
for i=1:B+1
for j=2:min(i+aa-2,B)
P(i,j) = al(min(i+aa-2,B)+2-j)-al(min(i+aa-2,B)+1-j);
end;
P(i,min(i+aa-2,B)+1) = al(1);
end;
P(:,1) = ones(B+1,1) - sum(P(:,2:B+1)')';
end;
