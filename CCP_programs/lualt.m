function [L,U]=lualt(A)
% Function finds the LU decomposition of an m by n
% matrix A.  No partial pivoting is used, unlike the
% lu function built into MATLAB

m=size(A,1);
U=A; L=eye(m);p=1:m;

for i=1:m-1
    if U(i,i)==0 
       % Search for non-zero element in column i
       nonz=find( U(i+1:m, i) )
       if ~isempty(nonz) 
         k=nonz(1)+i;
         % Exchange rows i and k
         save1=U(i,:); save2=L(i, 1:i-1); s3=p(i);
         U(i,:)=U(k,:); L(i, 1:i-1)=L(k, 1:i-1); p(i)=p(k);
         U(k,:)=save1; L(k, 1:i-1)=save2; p(k)=s3; 
       end
    else
       piv = U(i,i);
       for k=i+1:m
          mult = U(k,i)/piv;
          U(k,:) = -mult*U(i,:) + U(k,:);
          L(k,i) = mult;
       end
    end
end

% Reorder rows of L so that L*U=A.
P=eye(m);
Q=P(p,:);  % Permute rows of identity matrix
L=inv(Q)*L;  % Since Q*A=L*U, A=inv(Q)*L*U