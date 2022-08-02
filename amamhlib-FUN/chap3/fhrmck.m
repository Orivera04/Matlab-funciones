function [t,y,lam]=fhrmck(m,c,k,f1,f2,w,tlim,nt,y0,v0)
%
% [t,y,lam]=fhrmck(m,c,k,f1,f2,w,tlim,nt,y0,v0)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function uses eigenfunction analysis to solve
% the matrix differential equation
%   m*y''(t)+c*y'(t)+k*y(t)=f1*cos(w*t)+f2*sin(w*t)
% with initial conditions of y(0)=y0, y'(0)=v0
% The solution is general unless 1) a zero or repeated
% eigenvalue occurs or 2) the system is undamped and 
% the forcing function matches a natural frequency.
% If either error condition occurs, program execution
% terminates with t and y set to nan.
%
% m,c,k   - mass, damping, and stiffness matrices
% f1,f2   - amplitude vectors for the sine and cosine
%           forcing function components
% w       - frequency of the forcing function
% tlim    - a vector containing the minimum and
%           maximum time limits for evaluation of 
%           the solution
% nt      - the number of times at which the solution
%           is evaluated within the chosen limits
%           for which y(t) is computed
% y0,v0   - initial position and velocity vectors
%
% t       - vector of time values for the solution
% y       - matrix of solution values where y(i,j)
%           is the value of component j at time t(i)
% lam     - the complex natural frequencies arranged
%           in order of increasing absolute value 

if nargin==0 % Generate default data using 2 masses
  m=eye(2,2); k=[2,-1;-1,1]; c=.3*k;
  f1=[0;1]; f2=[0;0]; w=0.6; tlim=[0,100]; nt=400;
end
n=size(m,1); t=linspace(tlim(1),tlim(2),nt);
if nargin<10, y0=zeros(n,1); v0=y0; end

% Determine eigenvalues and eigenvectors for
% the homogeneous solution
A=[zeros(n,n), eye(n,n); -m\[k, c]];
[U,lam]=eig(A); [lam,j]=sort(diag(lam)); U=U(:,j);

% Check for zero or repeated eigenvalues and 
% for undamped resonance
wmin=abs(lam(1)); tol=wmin/1e6; 
[dif,J]=min(abs(lam-i*w)); lj=num2str(lam(J));
if wmin==0, disp(' ')
  disp('The homogeneous equation has a zero')
  disp('eigenvalue which is not allowed.')
  disp('Execution is terminated'), disp(' ')
  t=nan; y=nan; return
elseif any(abs(diff(lam))<tol)
  disp('A repeated eigenvalue occurred.')
  disp('Execution is terminated'),disp(' ')
  t=nan; y=nan; return  
elseif dif<tol & sum(abs(c(:)))==0
  disp('The system is undamped and the forcing')
  disp(['function resonates with ',...
        'eigenvalue ',lj])
  disp('Execution is terminated.')
  disp(' '), t=nan; y=nan; return
else  
  % Determine the particular solution 
  a=(-w^2*m+k+i*w*c)\(f1-i*f2);
  yp=real(a*exp(i*w*t));
  yp0=real(a); vp0=real(i*w*a);
end

% Scale the homogeneous solution to satisfy the
% initial conditions  
U=U*diag(U\[y0-yp0; v0-vp0]);
yh=real(U(1:n,:)*exp(lam*t));

% Combine results to obtain the total solution
t=t(:); y=[yp+yh]';

% Show data graphically only for default case
if nargin==0
  waterfall(t,(1:n),y'), xlabel('time axis')
  ylabel('mass index'), zlabel('Displacements')
  title(['DISPLACEMENT HISTORY FOR A ',...
          int2str(n),'-MASS SYSTEM'])
  colormap([1,0,0]), shg
end