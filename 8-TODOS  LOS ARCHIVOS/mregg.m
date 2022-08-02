function b=mregg(Xd,con,ar,lab)
% Multiple linear regression, using least squares.
%
% Example call: b=mregg(Xd,con,ar,lab)
%
% Fits data to y = b0 + b1*x1 + b2*x2 + ... bp*xp
% Xd is a data array. Each column of X is a set of data.
% Xd(1,:)=x1(:), Xd(2,:)=x2(:), ... Xd(p+1,:)=y(:).
% Xd has n columns corresponding to n data points and p+1 rows.
% If con=0, no constant is used, if con~=0, constant term is used.
% If ar=0, no analysis of residuals provided,
% if ar~0, analysis of residuals provided.
% lab is a set of user defined labels for explanatory variables;
% Each label must be 15 characters long, including spaces.
% X has n columns corresponding to n data points and p+1 rows.
% Function returns vector of coefficients b.
%
if con==0
  cst=0;
else
  cst=1;
end
[p1,n]=size(Xd); p=p1-1; pc=p+cst;
y=Xd(p1,:)';
if cst==1
  w=ones(n,1);
  X=[w Xd(1:p,:)'];
else
  X=Xd(1:p,:)';
end
% If user labels supplied, these are used, otherwise default labels are used.
a=zeros(pc,15);
if nargin==3
  if cst==1
    a(1,:)='Constant      :';
  end
  for i=1+cst:pc
    a(i,:)=strcat('Parameter',num2str(i-cst,2),' :');
  end
else
  if cst==1
    a=['Constant      :';lab];
  else
    a=lab;
  end
end
% Compute coefficients b, the hat matrix H and the Student t-ratio.
C=inv(X'*X);
b=C*X'*y;
H=X*C*X';
SSE=y'*(eye(n)-H)*y;
s_sqd=SSE/(n-pc);
Z=(1/n)*ones(n);
num=y'*(H-Z)*y;
denom=y'*(eye(n)-Z)*y;
R_sqd=num/denom;
Cov=s_sqd*C;
SE=sqrt(diag(Cov));
t=b./SE;
% Compute correlation matrix
V(:,1)=(eye(n)-Z)*y;
for j=1:p
  V(:,j+1)=(eye(n)-Z)*X(:,j+cst);
end
SS=V'*V;
D=zeros(p+1,p+1);
for j=1:p+1
  D(j,j)=1/sqrt(SS(j,j));
end
Corr_mtrx=D*SS*D;
% Compute VIF
for j=1+cst:pc
  ym=X(:,j);
  if cst==1
    Xm=X(:,[1 2:j-1,j+1:p+1]);
  else
    Xm=X(:,[1:j-1,j+1:p]);
  end
  Cm=inv(Xm'*Xm);
  Hm=Xm*Cm*Xm';
  num=ym'*(Hm-Z)*ym;
  denom=ym'*(eye(n)-Z)*ym;
  R_sqr(j-cst)=num/denom;
end
VIF=1./(1-R_sqr);
% Print out of statistics
if cst==1
  fprintf('\nError variance = %8.4f R_squared = %6.4f\',s_sqd,R_sqd)
  fprintf('\n\')
  fprintf('\n                       coeff     SE           t-ratio         VIF\')
else
  fprintf('\nError variance = %8.4f\',s_sqd)
  fprintf('\n\')
  fprintf('\n                       coeff     SE           t-ratio\')
end
if cst==1
  fprintf('\n%12s %12.4f %8.4f %14.2f\',a(1,:),b(1),SE(1),t(1))
end
for j=1+cst:pc
  fprintf('\n%12s %12.4f %8.4f %14.2f',a(j,:),b(j),SE(j),t(j))
  if cst==1
    fprintf('%14.2f\', VIF(j-cst))
  end
end
fprintf('\n\')
Corr_mtrx
% Analysis of residuals
if ar~=0
  ee=(eye(n)-H)*y;
  s=sqrt(s_sqd);
  sr=ee./(s*sqrt(1-diag(H)));
  cd=(1/(pc))*(1/s^2)*ee.^2.*(diag(H)./((1-diag(H)).^2));
  fprintf('\n y Residual St residual Cook dist.\')
  for i=1:n
    fprintf('\n %12.4f %10.4f %10.4f %10.4f',y(i),ee(i),sr(i),cd(i))
  end
  fprintf('\n\')
end
