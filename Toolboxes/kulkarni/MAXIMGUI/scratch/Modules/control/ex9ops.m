function P = ex9ops(x,aa)
%P = ex9ops(x,aa)
% returns the sojourn time matrix if aa = -2, cost matrix if aa = -1,
% and the tr. pr. P(aa-1) otherwise for the processor sharing example.
% h = holding cost per hour per customer.
% s = operating cost per hour per server.
% K = capacity of the waiting room.
% A = Maximum number of servers.
% l = arrival rate per hour.
% m = service rate per server per hour.
% r = cost of turning a customer away.
P='error';
[mx nx] = size(x);
if mx > 1 | nx ~= 7
   msgbox('x must be a row vector of length 7'); return;
elseif x(3) < 1 | fix(x(3)) - x(3) ~= 0
   msgbox('x(3) must be a positive integer'); return;
elseif x(4) < 1 | fix(x(4)) - x(4) ~= 0
   msgbox('x(4) must be a positive integer'); return;
elseif x(5) < 0
   msgbox('x(5) must be positive'); return;
elseif x(6) < 0
   msgbox('x(6) must be positive'); return;
else
   h=x(1); s=x(2); A=x(3);K=x(4); l=x(5); m=x(6); r=x(7); 
if aa == -2
P = zeros(K+1,A+1);
for i=1:K+1
for a = 1:A+1
P(i,a) = 1/(l + min(i-1,a-1)*m);
end;
end;
elseif aa == -1
P = zeros(K+1,A+1);
for i=1:K
for a=1:A+1
P(i,a) = ((a-1)*s + (i-1)*h)/(l + min(i-1,a-1)*m);
end;
end;
for a=1:A+1
P(K+1,a) = ((a-1)*s + K*h +l*r)/(l + (a-1)*m);
end;
elseif 1 <= aa & aa <= A+1 & fix(aa) -aa ==0
P = zeros(K+1,K+1);
for i=2:K
P(i,i+1) = l/(l + min(i-1,aa-1)*m);
P(i,i-1) = min(i-1,aa-1)*m/(l + min(i-1,aa-1)*m);
end;
P(1,2) = 1;
P(K+1,K+1) = l/(l+(aa-1)*m);
P(K+1,K) = (aa-1)*m/(l+(aa-1)*m);
else
   msgbox('invalid entry for aa'); return;
end;
end;