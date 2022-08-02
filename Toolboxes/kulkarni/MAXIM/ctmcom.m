function B=ctmcom(R,t)
%B=ctmcom(R,t)
% computes the M(t) matrix for a CTMC with a given 
% R matrix, given $t$ and a tolerance $ep=.00001$
if t < 0
   msgbox('t must be positive'); y='error'; return;
else
   y=checkR(R);
   if y(1,1) ~= 'error'
ep=.00001;
q = max(sum(R'));
s=size(R);
if (q==0) 
B=t*eye(s(1));
return;
end;
P = (R + q*eye(s(1)) - diag(sum(R')))/q;
A = P; k = 0;
yek=exp(-q*t);
ygk = 1 - yek;
sumy = ygk; 
B = ygk*eye(s(1));
while sumy/q < t - ep
k=k+1;
yek = yek*q*t/k;
ygk = ygk - yek;
B = B + ygk*A;
A = A*P;
sumy = sumy + ygk;
end;
B = B/q;
end;
end;


