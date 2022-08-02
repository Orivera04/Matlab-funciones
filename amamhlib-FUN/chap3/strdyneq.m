function [t,y,lam]=strdyneq
%
% [t,y,lam]=strdyneq
% ~~~~~~~~~~~~~~~~~~
% This program integrates the structural dynamics
% equation characterized by a general second order
% matrix differential equation having a harmonic
% forcing function. Input involves mass, stiffness,
% and damping matrices as well as force magnitudes,
% a forcing frequency, and initial conditions. Data
% parameters for the program are created in a user
% supplied function provided by the user. (For an 
% example, see function threemass shown below.)

titl=['\nSOLUTION OF THE DIFFERENTIAL EQUATION\n',...
'M*Y''''+C*Y''+K*Y=F1*COS(W*T)+F2*SIN(W*T)\n\n'];
fprintf(titl);
disp(...
'Give the name of a function to create data values')
disp('(Try threemass as an example)')
name=input('>? ','s'); 
eval(['[m,c,k,f1,f2,w,nt,y0,v0]=',name,';']); jj=1;
while 1 
  fprintf('\nInput coordinate number, tmin and tmax')
  fprintf('\n(only press return to stop execution)')
  [j,t1,t2]=inputv('>? '); 
  if isnan(j), break; end; J=int2str(j);
  [t,y,lam]=fhrmck(m,c,k,f1,f2,w,[t1,t2],nt,y0,v0); 
  if isnan(t), return, end
  [dif,h]=min(abs(lam-i*w)); lj=num2str(lam(h));
  if jj==1, jj=jj+1; disp(' ')
    disp(['The value of i*w is at distance ',...
        num2str(dif)])
    disp(['from the eigenvalue ',lj])
  end
  close; plot(t,y(:,j),'k-'), xlabel('time')
  ylabel(['y(',J,')'])
  title(['RESPONSE VARIABLE NUMBER ',J])
  grid on, shg, dumy=input(' ','s'); 
end
fprintf('\nThe system eigenvalues are:\n')
display(lam)
fprintf(...
'Range of solution values for final times is:\n')
maxy=max(y); miny=min(y); display(maxy)
display(miny), fprintf('All done\n')

%================================================

function [m,c,k,f1,f2,w,nt,y0,v0]=threemass
%
% [m,c,k,f1,f2,w,nt,y0,v0]=threemass
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function creates data for a three mass
% system. The name of the function should be 
% changed to specify different problems. However,
% the output variable list should remain unchanged
% for compatibility with the data input program. 

m=eye(3,3); k=[2,-1,0;-1,2,-1;0,-1,2]; c=.05*k;

% Data to excite the highest mode
f1=[-1;0;1]; f2=[0;0;0]; w=1.413; nt=1000;

% Data to excite the lowest mode
% f1=[1;1;1]; f2=[0;0;0]; w=.7652; nt=1000;

% Homogeneous initial conditions
y0=[-.5;0;.5]; v0=zeros(3,1); y0=0*y0;

%================================================

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
