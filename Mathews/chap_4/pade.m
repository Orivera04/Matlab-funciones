function [P,Q] = pade(C,n,m)
%---------------------------------------------------------------------------
%PADE  Construction of the coefficient lists for Pn(x) and Qm(x)
%      for the Pade approximation.  
%       Some combinations of n and m are incompatible.
% Sample call
%   [P,Q] = pade(C,n,m)
% Inputs
%   C   list of Maclaurin coefficients for function
%   n   degree of numerator polynomial Pn(x)
%   m   degree of denominator polynomial Qm(x)
% Return
%   P   coefficient list for Pn(x)
%   Q   coefficient list for Qm(x)
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address:      in%"mathews@fullerton.edu"
%
% Algorithm 4.p (Pade rational Approximation).
% Section	4.6, Pade Approximations, Page 249
%---------------------------------------------------------------------------

C = flipud(C);
A = C(1:n+m+1);
% First solve an  m x m  system for the Q's
Mq = zeros(m,m);
for j = 1:m,
  for k = 1:m,
    Mq(j,k) = C(j+k);
  end
end
for j = 1:m,
  B(j) = - C(n+j+1);
end
if m > 0, Q = Mq\B'; end
Q = [Q;1]';
% Second solve an  n+1 x n+1  system for the P's.
for j=1:n+1,
  P(j) = A(j);
  kmin = max(1,j-m);
  for k=j-1:-1:kmin,
    P(j) = P(j) + Q(m-(j-k)+1)*A(k);
  end
end
P = fliplr(P);
