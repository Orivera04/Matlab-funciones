function [ctop,cbot]=makratsq      
% Example:  [ctop,cbot]=makratsq
% ~~~~~~~~~~~~~~~~~~
% Create a rational function map of a unit disk 
% onto a square.
%
% User m functions required: 
%    sqmp, ratcof, raterp

disp(' '); 
disp('RATIONAL FUNCTION MAPPING OF A CIRCULAR');
disp('        DISK ONTO A SQUARE'); disp(' ');
disp('Calculating'); disp(' ');

% Generate boundary points given by the 
% Schwarz-Christoffel transformation
nsc=501; np=401; ntop=10; nbot=10;
z=exp(i*linspace(0,pi/4,np)); 
w=sqmp(nsc,1,1,1,0,45,np);
w=mean(real(w))+i*imag(w); 
z=[z,conj(z)]; w=[w,conj(w)];

% Compute the series coefficients for a 
% rational function fit to the boundary data
[ctop,cbot]=ratcof(z.^4,w./z,ntop,nbot);
ctop=real(ctop); cbot=real(cbot);

% The above calculations produce the following 
% coefficients
% [top,bot]=
%           1.0787    1.4948
%           1.5045    0.1406
%           0.0353   -0.1594
%          -0.1458    0.1751
%           0.1910   -0.1513
%          -0.1797    0.0253
%           0.0489    0.2516
%           0.2595    0.1069
%           0.0945    0.0102
%           0.0068    0.0001

% Generate a polar coordinate grid to describe
% the mapping near the corner of the square. 
% Then evaluate the mapping function.
r1=.95; r2=1; nr=12;
t1=.9*pi/4; t2=1.1*pi/4; nt=101;
[r,th]=meshgrid(linspace(r1,r2,nr), ...
         linspace(t1,t2,nt));
z=r.*exp(i*th); w=z.*raterp(ctop,cbot,z.^4);

% Plot the mapped geometry
close; u=real(w); v=imag(w);
plot(u,v,'k',u',v','k'), axis equal
title('Rational Function Map Close to a Corner');
xlabel('real axis'); ylabel('imaginary axis');
figure(gcf); % print -deps ratsqmap

%==============================================

function [w,b]=sqmp(m,r1,r2,nr,t1,t2,nt)
%
% [w,b]=sqmp(m,r1,r2,nr,t1,t2,nt)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function evaluates the conformal 
% mapping produced by the Schwarz-Christoffel 
% transformation w(z) mapping abs(z)<=1 inside
% a square having a side length of two.  The 
% transformation is approximated in series form 
% which converges very slowly near the corners.
% This function is the same as squarmap of
% chapter 2 with no plotting.
%
% m        - number of series terms used
% r1,r2,nr - abs(z) varies from r1 to r2 in 
%            nr steps
% t1,t2,nt - arg(z) varies from t1 to t2 in 
%            nt steps (t1 and t2 are 
%            measured in degrees)
% w        - points approximating the square
% b        - coefficients in the truncated 
%            series expansion which has 
%            the form
%
%            w(z)=sum({j=1:m},b(j)*z*(4*j-3))
%
% User m functions called:  none.
%----------------------------------------------

% Generate polar coordinate grid points for the 
% map. Function linspace generates vectors with 
% equally spaced components.
r=linspace(r1,r2,nr)'; 
t=pi/180*linspace(t1,t2,nt);
z=(r*ones(1,nt)).*(ones(nr,1)*exp(i*t));

% Compute the series coefficients and evaluate 
% the series
k=1:m-1; 
b=cumprod([1,-(k-.75).*(k-.5)./(k.*(k+.25))]);
b=b/sum(b); w=z.*polyval(b(m:-1:1),z.^4);

%==============================================

function [a,b]=ratcof(xdata,ydata,ntop,nbot)
%
% [a,b]=ratcof(xdata,ydata,ntop,nbot)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% Determine a and b to approximate ydata as 
% a rational function of the variable xdata. 
% The function has the form:
%
%    y(x) = sum(1=>ntop) ( a(j)*x^(j-1) ) /
%         ( 1 + sum(1=>nbot) ( b(j)*x^(j)) )
%
% xdata,ydata - input data vectors (real or 
%               complex)
% ntop,nbot   - number of series terms used in 
%               the numerator and the 
%               denominator.
%
% User m functions called: none
%----------------------------------------------

ydata=ydata(:); xdata=xdata(:); 
m=length(ydata);
if nargin==3, nbot=ntop; end;
x=ones(m,ntop+nbot); x(:,ntop+1)=-ydata.*xdata;
for i=2:ntop, x(:,i)=xdata.*x(:,i-1); end
for i=2:nbot 
  x(:,i+ntop)=xdata.*x(:,i+ntop-1); 
end
ab=pinv(x)*ydata; %ab=x\ydata; 
a=ab(1:ntop); b=ab(ntop+1:ntop+nbot);

%==============================================

function y=raterp(a,b,x)
%
% y=raterp(a,b,x) 
% ~~~~~~~~~~~~~~~
% This function interpolates using coefficients
% from function ratcof.
%
% a,b - polynomial coefficients from function 
%       ratcof
% x   - argument at which function is evaluated
% y   - computed rational function values
%
% User m functions called:  none.
%----------------------------------------------

a=flipud(a(:)); b=flipud(b(:));
y=polyval(a,x)./(1+x.*polyval(b,x));