function y = smpod(P,w)

% Computes the occupancy distribution of an SMP with  one step
% probability transition matrix P, and sojourn time (column) vector w.

pi = dtmcod(P);
y = pi.*w';
y = y/sum(y);
    