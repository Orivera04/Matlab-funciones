function y = dtmclrc(P,c);

% Returns long-run cost rate
% Usage:  P = transition probability matrix of an irreducible DTMC.
%         c(i) = expected cost of visiting state i. (column vector).

y = dtmcod(P)*c ;
