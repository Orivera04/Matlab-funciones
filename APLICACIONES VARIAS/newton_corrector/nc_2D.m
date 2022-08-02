function y=nc_2D(fun,y0,N,n,y_init)
%2006/03/21 newton corrector method for 2D case
%    modified from test_2D_new.m
%Usage: y = nc_2D(fun,N,n)
%        fun: the D(x) , still not work for D(x,y) case
%        y0: Initial value of y -> two 
%        N:   number of x
%        n:   number of points for polynomial fitting
%   y_init:  The initial value of first n-1 y, which doesn't count the
%            first point y0

iterate=100; % # of iterate for Newton's method.
if length(y0) ~=2
  error('The length of y0 is not for 2D case');
end
if nargin==2
  N=200; % # of points
  n=10; %number of points for polynomial fitting
end
y_old=zeros(2*(n-1),1);
y=zeros(N,2);
y(1,1)=y0(1);y(1,2)=y0(2);
%% ///// Create the inital n points \\\\ %%
%///// Predictor region \\\\\%
%1. provide initial value
%y(1,1)=1;
%y(1,2)=0;
%2. provide D
D=sparse(2*(n-1),2*(n-1));
%//// Create a big D \\\\%
D0=feval(fun,1);%[0 -0.05;1 0]; %operator of D(y(0))
for i0=1:(n-1)
  D_buf=feval(fun,i0+1);
  D(i0,i0)=D_buf(1,1);
  D(i0,i0+n-1)=D_buf(1,2);
  D(i0+n-1,i0)=D_buf(2,1);
  D(i0+n-1,i0+n-1)=D_buf(2,2);
end
%\\\\ Create a big D ////%
%3. get E
[E_each,E0]=E_op_begin(n);
E=[E_each zeros(n-1);zeros(n-1) E_each];
E=sparse(E);
%4. initialize y
py=D0*[y(1,1);y(1,2)];
if (nargin<5)
  y_old(1:(n-1))=py(1)*[1:(n-1)]'+y(1,1);
  y_old(n:2*(n-1))=py(2)*[1:(n-1)]'+y(1,2);
E0yp0y0=[E0*py(1);E0*py(2)]+[y(1,1)*ones(n-1,1);y(1,2)*ones(n-1,1)];
%\\\\\ Predictor region /////%
%///// Corrector region \\\\\%
for i0=1:iterate
  %5. -(ED-1)y_n \equiv dy
  dy=y_old-( E*D*y_old+ E0yp0y0);
  ddy=dy./(y_old-dy);
  if sqrt(ddy'*ddy) < 100*eps, break; end
%  if sqrt(dy'*dy) < 10*eps, break; end
  %6. DD = \delta E / \delta D * \delta D / \delta y -1 
  DD=E*D-eye(2*(n-1)); %Here, D should \delta D
  y_old=inv(DD)*dy+y_old;
end
if i0==iterate, warning('too many times iterate for begining Newton-Corrector');end
%\\\\\ Corrector region /////%
else  % When I don't wanna do the fitting
  y_old=y_init;   % Input the first few points.
end   % When I don't wanna do the fitting
y(2:n,1)=y_old(1:n-1);y(2:n,2)=y_old(n:2*(n-1));
%% \\\\\ Create the inital n points ///// %%

%% ///// Fit the higher points \\\\\ %%
py_buf=D*y_old;
py=[py_buf(1:n-1) py_buf(n:2*(n-1))];
E=E_op(n);
E0=E(1:n-1);E1=E(n);
clear y_old D DD
y_old=zeros(2,1);
for i0=(n+1):N
  D0=feval(fun,i0);
  E0yp0y0=E0*py+y(i0-1,:);
  y_old=(D0+eye(2))*y(i0-1,:).';  %initial the y value
  for i1=1:iterate
    dy=y_old-( E1*D0*y_old+E0yp0y0.' );
    ddy=dy./(y_old-dy);
    if sqrt(ddy'*ddy) < 10*eps, break;end
%    if sqrt(dy'*dy) < 10*eps, break;end
    DD=E1*D0-eye(2); %Here, D0 should be \delta D0
    dyDD=DD\dy;
    y_old=y_old+dyDD;
  end
  if i1==iterate, warning(['too many times iterate for ',num2str(i0),'th Newton-Corrector']);end
  y(i0,1)=y_old(1);y(i0,2)=y_old(2);
  %/// Renew py \\\%
  py_buf=py;
  py(1:n-2,:)=py_buf(2:n-1,:);
  py(n-1,:)=y(i0,:)*D0.';
  %\\\ Renew py ///%
end
%% \\\\\ Fit the higher points ///// %%