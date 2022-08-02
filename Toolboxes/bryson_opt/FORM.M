function [a1,a2,a3]=form(b1,b2,b3)
%FORM - Forms (S,Q,R) matrices into vectors or vice-versa
% [a1,a2,a3]=form(b1,b2,b3)
% The vectors and matrices are associated with the 2nd-order gradient method.
% Hence, it uses the fact that the 1st (S) and the 3rd (Q) matrices are
% symmetric.
%---------------------------------------------------------------------------
% Written by Sun H. Hur 12/1/92

[n1,n2]=size(b1);

% Check if the single input parameter is a scalar
if n1==1 & n2==1;
  a1=b1;

% Form matrix S (and R, Q) from a vector
elseif n2==1
  w=b1; n=sqrt(2*n1+1/4)-1/2;  % (n=b2 in Hur's code)?
  S=zeros(n,n);
  for i=1:n
    im=(i-1)*(2*n+2-i)/2+1;
    ii=i*(2*n+1-i)/2;
    S(i,i:n)=w(im:ii)';
  end
  for i=2:n,for j=1:i-1,
    S(i,j)=S(j,i);
  end,end
  if(nargin<3) a1=S; return; end
  q=b3;
  R=zeros(n,q);Q=zeros(q,q);
  for i=1:n
    jj=ii+i*q;
    R(i,1:q)=w(ii+q*(i-1)+1:jj)';
  end
  for i=1:q
    im=jj+(i-1)*(2*q+2-i)/2+1;
    ii=jj+i*(2*q+1-i)/2;
    Q(i,i:q)=w(im:ii)';
  end
  for i=2:q,for j=1:i-1,
    Q(i,j)=Q(j,i);
  end,end
  a1=S;a2=R;a3=Q;

% Form vector from S (and R, Q)
else
  S=b1;
  [n,n]=size(S);
  if(nargin<3),
    q=0;
  else 
    R=b2;Q=b3;
    [n,q]=size(R);
  end
  w=zeros(n*(n+1)/2+n*q+q*(q+1)/2,1);
  for i=1:n
    im=(i-1)*(2*n+2-i)/2+1;
    ii=i*(2*n+1-i)/2;
    w(im:ii)=S(i,i:n)';
  end
  if(q==0),a1=w;return;end
  for i=1:n
    jj=ii+i*q;
    w(ii+q*(i-1)+1:jj)=R(i,1:q)';
  end
  for i=1:q
    im=jj+(i-1)*(2*q+2-i)/2+1;
    ii=jj+i*(2*q+1-i)/2;
    w(im:ii)=Q(i,i:q)';
  end
  a1=w;
end
