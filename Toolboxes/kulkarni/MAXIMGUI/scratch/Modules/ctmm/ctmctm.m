function B = ctmctm(R,t)

% Computes P(t) matrix for a CTMC with rate matrix R (0 diagonal entries).
% Uses uniformization algorithm with error tolerance .00001.

ep = .00001;
q = max(sum(R'));
s = size(R);
con = exp(-q*t);
if con < 10^-250
   e=msgbox('t is too large. Result may not be accurate');
   uiwait(e);
   B = ones(s(1),1)*ctmcod(R);
   return
end

c = con; 
B = c*eye(s(1));

if (q == 0)
  return; 
end;

P = (R + q*eye(s(1)) - diag(sum(R')))/q;
A = P;
sumc = c; 
k = 1;

while (sumc < 1 - ep)
  c = c*q*t/k;
  B = B + c*A;
  A = A*P;
  sumc = sumc + c;
  k = k+1;
end;
