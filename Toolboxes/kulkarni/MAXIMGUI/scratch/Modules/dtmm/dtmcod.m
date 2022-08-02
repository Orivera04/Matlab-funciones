function y = dtmcod(P)

% Returns the limiting distribution/occupancy distribution of the one step
% probability transition matrix P.

m = size(P, 1) ;
P = eye(m) - P ;
P(:,1) = ones(m(1),1) ;
y = [1 zeros(1,m(1)-1)]/P ;
