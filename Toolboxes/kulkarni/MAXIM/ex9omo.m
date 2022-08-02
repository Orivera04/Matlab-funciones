function P = ex9omo(x,aa)
%P = ex9omo(x,aa)
% returns the sojourn time matrix if aa = -2, cost matrix if aa = -1,
% and the tr. pr. P(aa-1) otherwise for the machine operation example.
% h = holding cost per hour per item.
% c = operating cost of the machine per hour.
% K = capacity of the warehouse.
% s = cost of turning the machine on.
% m = arrival rate per hour.
% t = mean production time for one item (hours).
% r = revenue from a satisfied demand.
P='error';
[mx nx] = size(x);
if mx > 1 | nx ~= 7
   msgbox('x must be a row vector of length 7'); return;
elseif x(3) < 1 | fix(x(3)) - x(3) ~= 0
   msgbox('x(3) must be a positive integer'); return;
elseif x(4) < 0
   msgbox('x(4) must be positive'); return;
elseif x(5) < 0
   msgbox('x(5) must be positive'); return;
else
   h=x(1); s=x(2); K=x(3); l=x(4); m=x(5); r=x(6); c=x(7);

if aa== -2
% P returns the sojourn time matrix.
P = zeros(2*K+2, 2);
P(:,2) = (1/(l+m))*ones(2*K+2,1);
P(:,1) = (1/m)*ones(2*K+2,1);

elseif aa == -1
% P returns the cost matrix.
P = zeros(2*K+2, 2);
P(1,1)=0; P(1,2)=s+c/(l+m);
for i=1:K
   P(i+1,1)= -r+h*i/m;
   P(i+1,2)= s+(c+h*i-r*m)/(l+m);
end;
P(K+2,1)=0;P(K+2,2)=c/(l+m);
for i=1:K
   P(K+i+2,1)=-r+h*i/m;
   P(K+i+2,2)=(c+h*i-r*m)/(l+m);
end;
   
elseif aa == 1
% P returns P(0)
P = zeros(2*K+2, 2*K+2);
P(1,1)=1;
for i = 1:K
   P(i+1,i)=1;
end;
P(K+2,1)=1;
for i=1:K
   P(K+i+2,i)=1;
end;


elseif aa == 2
% P eturns P(1)
P=zeros(2*K+2,2*K+2);
P(1,K+2)=m/(l+m);P(1,K+3)=l/(l+m);
for i=1:K-1
   P(i+1,K+i+3)=l/(l+m);
   P(i+1,K+i+1)=m/(l+m);
end;
P(K+1,2*K+2)=l/(l+m);
P(K+1,2*K+1)=m/(l+m);
P(K+2,K+2)=m/(l+m);
P(K+2,K+3)=l/(l+m);
for i=1:K-1
   P(K+i+2,K+i+3)=l/(l+m);
   P(K+i+2,K+i+1)=m/(l+m);
end;
P(2*K+2,2*K+2)=l/(l+m);
P(2*K+2,2*K+1)=m/(l+m);
else
   msgbox('invalid entry for aa');return;
end;
end;
