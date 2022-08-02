function y = ctmclrc(R,c);

% Returns Long-run cost rate per unit time for a CTMM
% Usage:  R = rate matrix of an irreducible CTMC.
%         c(i) = expected cost of visiting state i. (column vector).

y = ctmcod(R)*c ;
