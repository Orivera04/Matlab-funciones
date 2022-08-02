function tnorm = tsc(a, b, p)
% TSC Schweizer T-norm using parameter p. 

% J.-S. Roger Jang, 1993

tnorm = max(0, (a.^(-p) + b.^(-p) - 1)).^(-1/p);
