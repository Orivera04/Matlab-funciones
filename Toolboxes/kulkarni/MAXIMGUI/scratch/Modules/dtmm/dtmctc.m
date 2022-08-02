function y = dtmctc(P,c,n);

% Returns vector of total expected cost over time 0 through n, starting from i.
% Usage:  P = transition matrix of a DTMC.
%         c(i) = expected cost of visiting state i. (column vector).

y = (dtmcot(P,n)) * c ;
