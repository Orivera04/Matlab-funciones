function c = ex6gmscost(l,m,N,M,r,dc,rc);
%c = ex6gmscost(l,m,N,M,r,dc,rc)
%l = repair rate;
%m = failure rate;
%N = number of machines;
%M = number of repair persons;
%r = revenue per unit time from a working machine;
%dc = cost of downtime per machine per unit time;
%rc = repairtiem cost per unit time;
%output: c(i)=cost rate when i machines are working.
if  (l < 0)
msgbox('invalid entry for l'); R='error'; return; 
elseif  (m < 0)
msgbox('invalid entry for m');R='error'; return; 
elseif  N < 0 | (N - fix(N) ~= 0)
msgbox('invalid entry for N');R='error'; return; 
elseif  M < 0 | (M - fix(M) ~= 0)
msgbox('invalid entry for M'); R='error'; return;
else

c = zeros(N+1,1);
for i=0:N
c(i+1) = rc*min(N-i,M)-i*r + (N-i)*dc;
end;
end;
