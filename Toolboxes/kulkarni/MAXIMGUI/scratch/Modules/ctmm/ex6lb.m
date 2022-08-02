function R = ex6lb(l,m,D,M)

% Computes Rate matrix for Leaky Bucket
% Usage: l: packet arrival rate;
%        m: token generation  rate;
%        D: capacity of the data buffer;
%        M: token buffer size;

K = M+D ;
R = ex6fbd(l*ones(1,K), m*ones(1,K)) ;
