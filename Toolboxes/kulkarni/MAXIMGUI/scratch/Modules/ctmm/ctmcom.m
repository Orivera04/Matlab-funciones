function B = ctmcom(R,t)

% Computes the matrix of Occupancy Times for a CTMC
% Uses uniformization algorithm with error tolerance .00001
% Usage: R: NxN rate matrix with zeros on the diagonal
%        t: non-negative real number (time)

ep = .00001;
q = max(sum(R'));
s = size(R);

if (q==0) 
  B = t*eye(s(1));
  return;
end;
P = (R + q*eye(s(1)) - diag(sum(R')))/q;
A = P; 
k = 0;
if q*t > 580
   e=msgbox('t is too large. Result may not be accurate');
   uiwait(e);
   t1 = t-580/q;
   t=580/q;
else
   t1=0;
end;

yek = exp(-q*t);
ygk = 1 - yek;
sumy = ygk; 
B = ygk*eye(s(1));

while sumy/q < t - ep
  k = k+1;
  yek = yek*q*t/k;
  ygk = ygk - yek;
  B = B + ygk*A;
  A = A*P;
  sumy = sumy + ygk;
end;

B = B/q +t1*ones(s(1),1)*ctmcod(R);

