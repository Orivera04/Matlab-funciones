function [P,w] = ex7ser(N,v,tau);

% Computes Transition probability matrix and sojourn time vector for a Gen. Markov Model
% Usage:  N: number of components.
%         v: column vector of length N; v(i)=1/mean up time of component i.
%         tau: column vector of length N; tau(i)=mean down time of component i.

P = zeros(N+1,N+1);
P(1,2:N+1) = v'/sum(v);
P(2:N+1,1) = ones(N,1);
w = [1/sum(v); tau];
