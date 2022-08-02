function y = ctmctc(R,c,t);

% Returns vector of total expected cost over time 0 through t, starting from i
% Usage:  R = rate matrix of a CTMC (0 diagonal entries).
%         c(i) = expected cost of visiting state i. (column vector).
%         t = time

y = ctmcom(R,t)*c;
