function [SRmat,quad,err] = adapt(f,a,b,tol)
%---------------------------------------------------------------------------
%ADAPT   Adaptive quadrature using Simpson's rule
% Sample call
%   [SRmat,quad,err] = adapt('f',a,b,tol)
% Inputs
%   f       name of the function
%   a       left  endpoint of [a,b]
%   b       right endpoint of [a,b]
%   toler   convergence tolerance
% Return
%   SRmat   matrix of adaptive Simpson quadrature values
%   quad    adaptive Simpson quadrature
%   err     error estimate
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
% Algorithm 7.5 (Adaptive Quadrature Using Simpson's Rule).
% Section	7.4, Adaptive Quadrature, Page 389
%---------------------------------------------------------------------------

SRmat = zeros(30,6);
iterating = 0;
done = 1;
SRvec = zeros(6);
SRvec = srule('f',a,b,tol);
SRmat(1,1:6) = SRvec;
m = 1;
state = iterating;
while (state == iterating)
  n = m;
  for j=n:-1:1,
    p = j;
    SR0vec = SRmat(p,:);
    err = SR0vec(5);
    tol = SR0vec(6);
    if  (tol <= err),
      state = done;
      SR1vec = SR0vec;
      SR2vec = SR0vec;
      a = SR0vec(1);
      b = SR0vec(2);
      c = (a + b)/2;
      err = SR0vec(5);
      tol = SR0vec(6);
      tol2 = tol/2;
      SR1vec = srule('f',a,c,tol2);
      SR2vec = srule('f',c,b,tol2);
      err = abs(SR0vec(3)-SR1vec(3)-SR2vec(3))/10;
      if  (err < tol),
        SRmat(p,:) = SR0vec;
        SRmat(p,4) = SR1vec(3) + SR2vec(3);
        SRmat(p,5) = err;
      else
        SRmat(p+1:m+1,:) = SRmat(p:m,:);
        m = m+1;
        SRmat(p,:) = SR1vec;
        SRmat(p+1,:) = SR2vec;
        state = iterating;
      end
    end
  end
end
quad = sum(SRmat(:,4));
err = sum(abs(SRmat(:,5)));
SRmat = SRmat(1:m,1:6);
