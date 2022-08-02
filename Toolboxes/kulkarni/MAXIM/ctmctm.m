function B=ctmctm(R,t)
%B=ctmctm(R,t)
%computes P(t) matrix for a CTMC with rate matrix R (0 diagonal entries).
%Uses uniformaization algorithm with error tolerance .00001.
if t < 0
   msgbox(' t must be a positive number'); B='error'; return;
else
   
y=checkR(R);
if y(1,1) ~= 'error'
   
ep=.00001;
q = max(sum(R'));
s=size(R);
con=exp(-q*t);
c = con; 
B = c*eye(s(1));
if (q==0) return; end;
P = (R + q*eye(s(1)) - diag(sum(R')))/q;
A = P;
sumc = c; k = 1;
while sumc < 1 - ep
c = c*q*t/k;
B = B + c*A;
A = A*P;
sumc = sumc + c;
k=k+1;
end;
end;
end;
