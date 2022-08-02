function y = ctmctd(a,R,t);

% Computes Transient Distribution for a CTMM
% Output y(i) = P(X(t) = i) 
% Usage: a: initial distribution
%        R: rate matrix R (zero diagonal entries),  
%        t: non-negative real number (time)

y = a*ctmctm(R,t);
