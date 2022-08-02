function R = ex6tel(l,m,K)

% Computes the Rate matrix for the CTMC in Example ex6:tel (Telephone Switch)
% Usage: l: call arrival rate lambda;
%        m: call completion rate mu;
%        K: switch capacity K; 

R = zeros(K+1,K+1) ;
R(1,2) = l ;
R(K+1,K) = K*m ;

for i = 2:K
  R(i,i-1) = (i-1)*m ;
  R(i,i+1) = l ;
end