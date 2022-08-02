function [c,e,m,crat]=findifco(k,a)
%
% [c,e,m,crat]=findifco(k,a)
% ~~~~~~~~~~~~~~~~~~~~~~~~~
% This function approximates the k'th derivative
% of a function using function values at n 
% interpolation points. Let f(x) be a general
% function having its k'th derivative denoted
% by F(x,k). The finite difference approximation
% for the k'th derivative employing a stepsize h
% is given by:
% F(x,k)=Sum(c(j)*f(x+a(j)*h), j=1:n)/h^k +
%        TruncationError
% with m=n-k being the order of truncation
% error which decreases like h^m and 
% TruncationError=(h^m)*(e(1)*F(x,n)+...
% e(2)*F(x,n+1)*h+e(3)*F(x,n+2)*h^2+O(h^3))
% 
% a    - a vector of length n defining the
%        interpolation points x+a(j)*h where
%        x is an arbitrary parameter point
% k    - order of derivative evaluated at x
% c    - the weighting coeffients in the 
%        difference formula above. c(j) is 
%        the multiplier for value f(x+a(j)*h)
% e    - error component vector in the above
%        difference formula
% m    - order of truncation order in the 
%        formula. The relation m=n-k applies.
% crat - a matrix of integers such that c is
%        approximated by crat(1,:)./crat(2,:)

a=a(:); n=length(a); m=n-k; mat=ones(n,n+4); 
for j=2:n+4; mat(:,j)=a/(j-1).*mat(:,j-1); end
A=pinv(mat(:,1:n)); ec=-A*mat(:,n+1:n+4);
c=A(k+1,:); e=-ec(k+1,:);
[ctop,cbot]=rat(c,1e-8); crat=[ctop(:)';cbot(:)'];