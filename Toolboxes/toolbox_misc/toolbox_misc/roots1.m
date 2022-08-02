function r = roots(c)
%ROOTS  Find polynomial roots.
%   ROOTS(C) computes the roots of the polynomial whose coefficients
%   are the elements of the vector C. If C has N+1 components,
%   the polynomial is C(1)*X^N + ... + C(N)*X + C(N+1).
%
%   See also POLY, RESIDUE, FZERO.

%   J.N. Little 3-17-86
%   Copyright 1984-2001 The MathWorks, Inc.
%   $Revision: 5.11 $  $Date: 2001/04/15 11:59:14 $
% ROOTS finds the eigenvalues of the associated companion matrix.
%
%   Revised by Prof D Xue, NEU, China
%   where for the order less or equal than 4, direct method used.

if size(c,1)>1 & size(c,2)>1
    error('Must be a vector.')
end
c = c(:).';
n = size(c,2);
r = zeros(0,1);

inz = find(c);
if isempty(inz),
    % All elements are zero
    return
end

% Strip leading zeros and throw away.  
% Strip trailing zeros, but remember them as roots at zero.
nnz = length(inz);
c = c(inz(1):inz(nnz));
r = zeros(n-inz(nnz),1);

% Polynomial roots via a companion matrix
n = length(c); 
c=c./c(1); r1=[];
if norm(imag(c))<=eps
   switch n-1
   case 1
      r1=-c(2); 
   case 2
      r1=[0.5*(-c(2)+sqrt(c(2)*c(2)-4*c(3))); 
          0.5*(-c(2)-sqrt(c(2)*c(2)-4*c(3)))]; 
   case 3
      p=-c(2)*c(2)/9+c(3)/3;
      q=2*c(2)^3/27-c(2)*c(3)/3+c(4);
      rr=roots1([1 q -p^3]);
      u=rr(1)^(1/3); 
      v=rr(2)^(1/3); 
      r1=[u+v-c(2)/3;
          -0.5*(u+v)-c(2)/3+0.5*sqrt(-3)*(u-v);
          -0.5*(u+v)-c(2)/3-0.5*sqrt(-3)*(u-v)];
  case 4
      p=-3*c(2)*c(2)/8+c(3);
      q=c(2)^3/8-0.5*c(2)*c(3)+c(4);
      s=-3*c(2)^4/256+c(2)*c(2)*c(3)/16-0.25*c(2)*c(4)+c(5);
      if abs(q)>=eps
         rr=roots1([1,0.5*p,(p*p-4*s)/16,-q*q/64]);
         k=find(abs(rr)>eps); 
         A=2*sqrt(rr(k(1))); 
         r1=[roots1([1,-A,0.5*(p+A*A+q/A)]);
             roots1([1,A,0.5*(p+A*A-q/A)])]-0.25*c(2);
      else
         u=roots1([1,p,s]); 
         r1=[sqrt(u); -sqrt(u)]-0.25*c(2);
      end
   end    
   r=[r; r1];
end
if norm(imag(c))>eps | n>5
   a = diag(ones(1,n-2),-1);
   a(1,:) = -c(2:n);
   r=[r; eig(a)];
end
