function [A, h] = compan (c)
%COMPAN Companion matrix.
%       COMPAN(P) is a companion matrix of P.
%       P may be a vector or a square matrix.
%
%       If P is a vector then eig(c) are the roots
%       of the polynomial whose coefficients are in P.
%
%       If P is a matrix then [1 -c(1,:)] is the characteristic
%       equation of P whose roots are the eigenvalues of P.
%       If c can be found by a similarity transform then
%       c = h*P*inv(h) when h exists.
%
%usage: [c, h] = compan(P)
%
%see also: mroots, obsv

% Paul Godfrey
% pgodfrey@intersil.com
% 06-06-2003

if min(size(c)) > 1
   n=size(c,1);
cc=c;
[q,u]=schur(c);
c=u;
   b=orth(c);
   if size(b,2)>0
      b=b(:,1).';
   else
      b=(rand(1,n)-0.5)*2;
   end
   bb=sqrt(b*b.');
   if bb<eps
      bb=1;
   end
   b=b/bb;
   h=b;
   for k=1:n-1
       h = [b ; h*c];
   end
   h=flipud(h);
   k=det(h);
   if abs(k)<=eps
      A=compan(poly(eig(c)));
      h=[];
      return
   else
      k=abs(k)^(-1/n);
      h=k*h; % make det(h) = +- 1
      A=h*c*inv(h);
      A=[A(1,:); round(A(2:end,:))];
      h=h*q';

% find c by other means
      p=poly(eig(cc));
      p=poly(mroots(p));
      A=diag(ones(1,n-1),-1);
      A(1,:)=-p(2:end);
      A(1,end)=-det(cc)*(-1)^n;
      A(1,1)=trace(cc);
   end

else
%  do vector input case
%  assume c(1) is not zero
   n = length(c);
   A = [];
   h = [];
   if n == 2, A = -c(2)/c(1); end
   if n>2
      c = c(:).';
      A = diag(ones(1,n-2),-1);
      A(1,:) = -c(2:n) ./ c(1);
   end
end

return
