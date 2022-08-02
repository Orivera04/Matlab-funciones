function a=formm(b,d)
%FORMM - Forms a matrix from a vector or vice-versa
%a=formm(b,d)
% If b is a matrix, a=(row,column) vector for d=('r','c'),
% if b is a (row,column) vector, a=matrix with d (columns,rows);
%                              Sun H. Hur 11/91, rev. AEB 8/7/97
%
if nargin<2,error('Not enough input parameters'); end
[m,n]=size(b);
if d=='c', a=zeros(m*n,1);
 for i=1:n, a(m*(i-1)+1:m*i)=b(:,i); end
elseif d=='r', a=zeros(1,m*n);
 for i=1:m, a(n*(i-1)+1:n*i)=b(i,:); end
elseif n==1, od=length(b)/d; a=zeros(d,od);
 for i=1:od, a(:,i)=b(d*(i-1)+1:d*i); end
elseif m==1, od=length(b)/d; a=zeros(od,d);
 for i=1:od, a(i,:)=b(d*(i-1)+1:d*i); end
end




