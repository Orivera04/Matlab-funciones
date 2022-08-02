function y = smplrc(P,w,c,d)

% Returns long-run cost rate for an SMP
% Input: P = transition probability matrix of an irreducible SMP.
%        w = sojourn time vector of an SMP.
%        c(i) = cost rate in state i. (column vector)
%        d(i) = expected cost of visiting state i. (column vector).
y = smpod(P,w) ;
y = y*(c+d./w) ;

