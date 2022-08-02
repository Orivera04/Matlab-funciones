function y=newton_corrector(fun,y0,N,n)
%2006/03/21 newton corrector method for ordinary differential equation
%    modified from y' = D*y
%Usage: y = newton_corrector(fun,y0,N,n)
%        fun(char): the D(x) , still not work for D(x,y) case
%        y0(mx1 or 1xm):  Initial value of y, where m is the dimension of y
%        N(1x1):   number of x
%        n(1x1):   number of points for polynomial fitting

iterate=100; % # of iterate for Newton's method.
m=length(y0);
logic_f=(1~=1);
if nargin==2
  N=300; % # of points
  n=9; %number of points for polynomial fitting
end
y_old=zeros(2*(n-1),1);
%1. provide initial value
y=zeros(N,m);
for i0=1:m,y(1,i0)=y0(i0);end % Put y0 into result y.
if (length(y0(1,:))~=1), y0=y0.'; end %Force y0 be nx1 formula
%% ///// Create the inital n points \\\\ %%
%///// Predictor region \\\\\%
%2. provide D
D=sparse(m*(n-1),m*(n-1));
E=D;
%//// Create a big D \\\\%
D0=feval(fun,1);
for i0=1:(n-1)
  D_buf=feval(fun,i0+1);
  for i1=1:m, for i2=1:m
      D(m*(i0-1)+i1,m*(i0-1)+i2)=D_buf(i1,i2); %D=D1 (+) D2 (+) .... Dn
  end,end
end
%\\\\ Create a big D ////%
%3. get E
[E_each,E0]=E_op_begin(n);
for i1=1:(n-1), for i2=1:(n-1)
  for i0=1:m,E(m*(i1-1)+i0,m*(i2-1)+i0)=E_each(i1,i2);end % Generate E (X) I_m
end,end
%4. initialize y
py=D0*y0;
y_buf=py*[1:(n-1)]+y0*ones(1,n-1); %Just linear guess.
y_old=y_buf(:);
E0yp0y0=[];
for i0=1:n-1
  E_buf=E0(i0)*py+y0;
  E0yp0y0=[E0yp0y0;E_buf];
end
  %\\\\\ Predictor region /////%
  %///// Corrector region \\\\\%
  for i0=1:iterate
    %5. -(ED-1)y_n \equiv dy
    dy=y_old-( E*D*y_old+ E0yp0y0);
      if sqrt(dy'*dy/((y_old-dy)'*(y_old-dy))) < 10*eps, break; end
    %6. DD = \delta E / \delta D * \delta D / \delta y -1 
    DD=E*D-eye(m*(n-1)); %Here, D should \delta D
    y_old=inv(DD)*dy+y_old;
  end
  if i0==iterate, warning('too many times iterate for begining Newton-Corrector');end
  %\\\\\ Corrector region /////%
for i0=2:n, for i1=1:m
  y(i0,i1)=y_old(i1+m*(i0-2));
end,end
%% \\\\\ Create the inital n points ///// %%

%% ///// Fit the higher points \\\\\ %%
py=D*y_old;
E=E_op(n);
E0=[]; for i0=1:(n-1),E0=[E0 E(i0)*eye(m)];end % E0 => E0 (X) I_m
E1=E(n);
clear y_old D DD
y_old=zeros(m,1);
for i0=(n+1):N
  D0=feval(fun,i0);
  E0yp0y0=E0*py+y(i0-1,:)';
  y_old=(D0+eye(m))*y(i0-1,:).';  %initial the y value
  for i1=1:iterate
    dy=y_old-( E1*D0*y_old+E0yp0y0 ); % ( I - E*D )
     if sqrt(dy'*dy/((y_old-dy)'*(y_old-dy))) < 10*eps, break;end
    DD=E1*D0-eye(m); %Here, D0 should be \delta D0. DD=\delta E/\delta y -1
    dyDD=DD\dy;
    y_old=y_old+dyDD;
  end
  if i1==iterate, warning(['too many times iterate for ',num2str(i0),'th Newton-Corrector']);end
  for i1=1:m, y(i0,i1)=y_old(i1);end
  %/// Renew py \\\%
  py_buf=py;
  py(1:m*(n-2))=py_buf((m+1):m*(n-1));
  py_buf=D0*y_old;
  for i1=1:m, py(m*(n-2)+i1)=py_buf(i1);end
  %\\\ Renew py ///%
end
%% \\\\\ Fit the higher points ///// %%