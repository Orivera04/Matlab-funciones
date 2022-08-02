function M = dtmcot(P,n)
%M = dtmcot(P,n)
% computes the occupancy times matrix M(n) of the DTMC with one step
%probability transition matrix P.
if n < 0 | n - fix(n) ~= 0
   msgbox('invalid entry for n'); y='error'; return;
else
   y=checkP(P);
   if y(1,1) ~= 'error'  
m=size(P);
A=eye(m);
M=A;
for r=1:n
A = A*P; M = M+A;
end;
end;
end;
