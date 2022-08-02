function R = ex6gms(l,m,N,M);
%R = ex6gms(l,m,N,M)
%l = repair rate;
%m = failure rate;
%N = number of machines;
%M = number of repair persons;
%R = output rate matrix.
if  (l < 0)
msgbox('invalid entry for l'); R='error'; return; 
elseif  (m < 0)
msgbox('invalid entry for m');R='error'; return; 
elseif  N < 0 | (N - fix(N) ~= 0)
msgbox('invalid entry for N');R='error'; return; 
elseif  M < 0 | (M - fix(M) ~= 0)
msgbox('invalid entry for M'); R='error'; return;
else

R = zeros(N+1,N+1);
for i=0:N-1
R(i+1,i+2) = l*min(N-i,M);
end;
for i=1:N
R(i+1,i) = i*m;
end;
end;
