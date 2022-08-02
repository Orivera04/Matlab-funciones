function y = dtmctd(a,P,n)

% Compute Transient Distribution
% Output: y(i) = P(Xn = i), 1<=i<=N, where {Xn,n>=0} is a DTMC with transition
% probability matrix P and initial distribution a.

y = a*P^n ;
