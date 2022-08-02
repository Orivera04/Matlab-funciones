function brachist      
% Example: brachist
% ~~~~~~~~~~~~~~~~~
% This program determines the shape of a 
% smooth curve down which a particle can slide 
% in minimum possible time. The analysis 
% employs a piecewise cubic spline to define
% the curve by interpolation using a fixed set 
% of base point positions. The curve shape 
% becomes a function of the heights chosen at 
% the base points. These heights are determined 
% by computing the descent time as a function
% of the heights and minimizing the descent 
% time by use of an optimization program. The 
% Nelder and Mead unconstrained search 
% procedure is used to compute the minimum.
%
% User m functions called:  
%      chbpts, brfaltim, fltim, gcquad, 
%      bracifun, splined

global cbp cwf cofs n xc yc a b b_over_a ...
       grav nparts nquad nfcls 

fprintf(...
'\nBRACHISTOCHRONE DETERMINATION BY NONLINEAR');
fprintf('\n         OPTIMIZATION SEARCH \n');
fprintf(['\nPlease wait. The ',...
  'calculation takes a while.\n']);

% Initialize
a=30; b=10; grav=32.2; nparts=1; nquad=50; 
tol=1e-4; n=6; b_over_a = b/a;

[dummy,cbp,cwf]=gcquad('',0,1,nquad,nparts);
xc=chbpts(0,1,n); xc=xc(:);
y0=5*sin(pi*xc); xc=[0;xc;1];

% Calculate results from the exact solution
[texact,xexact,yexact]=brfaltim(a,b,grav,100);

% Perform minimization search for 
% approximate solution
opts=optimset('tolx',tol,'tolfun',tol);
[yfmin,fmin,flag,outp] =...
                   fminsearch(@fltim,y0,opts);

% Evaluate final position and approximate 
% descent time
Xfmin=xc; Yfmin=Xfmin+[0;yfmin(:);0];
% tfmin=a/sqrt(2*grav*b)*fltim(yfmin(:));
tfmin=a/sqrt(2*grav*b)*fmin;
nfcls=1+outp.funcCount;

% Summary of calculations
fprintf('\nBrachistochrone Summary');
fprintf('\n-----------------------');
fprintf('\nNumber of function calls:   ');
fprintf('%g',nfcls);
fprintf('\nDescent time:   ');
fprintf('%g',tfmin), fprintf('\n')

% Plot results comparing the approximate 
% and exact solutions
xplot=linspace(0,1,100); close
yplot=spline(Xfmin,Yfmin,xplot); 
plot(xplot,-yplot,'-',Xfmin,-Yfmin,'o', ...
     xexact/a,-yexact/b,'--');
xlabel('x/a'); ylabel('y/b'); % grid
title(['Brachistochrone Curve for ', ...
       'a/b = ',num2str(a/b)]);
text(.5,-.1,   'Descent time    (secs)')
text(.5,-.175,['Approximate: ',num2str(tfmin)])
text(.5,-.25, ['Exact:       ',num2str(texact)]);
text(.5,-.325, ...
  sprintf('Error tolerance:    %g',tol));
legend('Approximate Curve', ...
       'Computed Points','Exact Curve',3); 
figure(gcf); 
print -deps brachist

%=============================================

function [tfall,xbrac,ybrac]=brfaltim ...
                             (a,b,grav,npts)
%
% 
% [tfall,xbrac,ybrac]=brfaltim(a,b,grav,npts)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% 
% This function determines the descent time 
% and a set of points on the brachistochrone 
% curve passing through (0,0) and (a,b). 
% The curve is a cycloid expressible in 
% parametric form as
%
%    x=k*(th-sin(th)), 
%    y=k*(1-cos(th))    for 0<=th<=thf
%
% where thf is found by solving the equation
%
%    b/a=(1-cos(thf))/(thf-sin(thf)). 
%
% Once thf is known then k is found from 
%
%    k=a/(th-sin(th)). 
%
% The exact value of the descent time is given 
% by
%
%    tfall=sqrt(k/g)*thf
%  
% a,b   - final values of (x,y) on the curve
% grav  - the gravity constant
% npts  - the number of points computed on 
%         the curve
%
% tfall - the time required for a smooth 
%         particle to slide along the curve 
%         from (0,0) to (a,b)
% xbrac - x points on the curve with x 
%         increasing to the right
% ybrac - y points on the curve with y 
%         increasing downward           
%
% User m functions called: none
%----------------------------------------------

brfn=inline('cos(th)-1+cof*(th-sin(th))','th','cof');
 
ba=b/a; [th,fval,flag]=fzero(...
                 brfn,[.01,10],optimset('fzero'),ba);

k=a/(th-sin(th)); tfall=sqrt(k/grav)*th;
if nargin==4
  thvec=(0:npts-1)'*(th/(npts-1));
  xbrac=k*(thvec-sin(thvec)); 
  ybrac=k*(1-cos(thvec));
end

%=============================================

function x=chbpts(xmin,xmax,n)
%
% x=chbpts(xmin,xmax,n)
% ~~~~~~~~~~~~~~~~~~~~~
% Determine n points with Chebyshev spacing 
% between xmin and xmax.
%
% User m functions called:  none
%----------------------------------------------

x=(xmin+xmax)/2+((xmin-xmax)/2)* ...
  cos(pi/n*((0:n-1)'+.5));

%=============================================

function t=fltim(y)
%
% t=fltim(y)
% ~~~~~~~~~~
%
% This function evaluates the time descent 
% integral for a spline curve having heights 
% stored in y.
%
% y - vector defining the curve heights at 
%     interior points corresponding to base 
%     positions in xc
%
% t - the numerically integrated time descent 
%     integral evaluated by use of base points 
%     cbp and weight factors cwf passed as 
%     global variables
%
% User m functions called: splined
%----------------------------------------------

global xc cofs nparts bp wf nfcls cbp cwf ...
       b_over_a

nfcls=nfcls+1; x=cbp;

% Generate coefficients used in spline 
% interpolation
yc=[0;y(:);0];
y=spline(xc,yc,x); yp=splined(xc,yc,x);

% Evaluate the integrand 
f=(1+(b_over_a*(1+yp)).^2)./(x+y); f=sqrt(f);

% Evaluate the integral
t=cwf(:)'*f(:);

%==============================================

% function [val,bp,wf]=gcquad(func,xlow,...
%                    xhigh,nquad,mparts,varargin)
% See Appendix B

%==============================================

% function val=splined(xd,yd,x,if2)
% See Appendix B 
