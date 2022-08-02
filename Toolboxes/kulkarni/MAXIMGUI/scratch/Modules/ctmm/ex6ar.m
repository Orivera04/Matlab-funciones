function R = ex6ar(l) ;

% Computes Rate matrix for Airline Reliability
% Usage: l: engine failure rate

R = diag([l l l 2*l 2*l 2*l],-3) + diag([l 2*l 0 l 2*l 0 l 2*l],-1) ;
