function [U,I]=invjor(A)

% [U,I]=invjor(A)
% Given an invertible matrix A, finds its inverse (I)

[m,n]=size(A);
L=eye(m);
I=eye(m);
k=1;
while k<n,
   if A(k,k)==0,			% Pivot
      disp('Ecuations swapping needed')
      k=n;					% To exit
   else
      for i=k+1:m
         L(i,k)=A(i,k)/A(k,k);			% Multiplier
         A(i,:)=A(i,:)-L(i,k)*A(k,:);	% Erase
         I(i,:)=I(i,:)-L(i,k)*I(k,:);
      end
      k=k+1;
   end
end
U=A(:,1:n);					% Upper triangular matrix

Z=eye(m);
k=1;
while k<n,
   if U(k,k)==0,			% Pivot
      disp('Ecuations swapping needed')
      k=n;					% To exit
   else
      for i=k+1:m
         Z(k,i)=U(k,i)/U(i,i);			% Multiplier
         U(k,:)=U(k,:)-Z(k,i)*U(i,:);	% Erase
         I(k,:)=I(k,:)-Z(k,i)*I(i,:);
      end
      k=k+1;
   end
end

d=(diag(U))';
for j=1:n
   if d(j)==1;
      j=j+1;
   else
      I(j,:)=I(j,:)/d(j);
      j=j+1;
   end
end

   







