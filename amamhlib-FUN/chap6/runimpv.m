function runimpv      
% Example:  runimpv
% ~~~~~~~~~~~~~~~~~
% This is a driver program for the 
% earthquake example.
%
% User m functions required: 
%    fouaprox, imptp, hsmck, 
%    shkbftss, lintrp

% Make the undamped period about one 
% second long
m=1; k=36;           

% Use damping equal to 5 percent of critical
c=.05*(2*sqrt(m*k)); 

% Choose a period equal to length of 
% Imperial Valley earthquake data 
prd=53.8;            

nft=1024; tmin=0; tmax=prd; 
ntimes=200; nsum=80; % ntimes=501; nsum=200;
tplt=linspace(0,prd,ntimes); 
y20trm=fouaprox('imptp',prd,tplt,20); close
plot(tplt,y20trm,'-',tplt,imptp(tplt),'--'); 
xlabel('time, seconds');
ylabel('unitized displacement'); 
title('Result from a 20-Term Fourier Series')
figure(gcf);
disp('Press [Enter] to continue'); 
dumy=input('','s');  
% print -deps 20trmplt

% Show how magnitudes of Fourier coefficients 
% decrease with increasing harmonic order

fcof=fft(imptp((0:1023)/1024,1))/1024; 
clf; plot(abs(fcof(1:100))); 
xlabel('harmonic order');
ylabel('coefficient magnitude'); 
title(['Coefficient Magnitude in Base ' ...
       'Motion Expansion']); figure(gcf);
disp('Press [Enter] to continue');
dumy=input('','s');  
% print -deps coefsize

% Compute forced response
[t,ys,ys0,vs0,as]= ...
  shkbftss(m,c,k,'imptp',prd,nft,nsum, ...
           tmin,tmax,ntimes);

% Compute homogeneous solution
[t,yh,ah]= ...
  hsmck(m,c,k,-ys0,-vs0,tmin,tmax,ntimes);

% Obtain the combined solution
y=ys(:)+yh(:); a=as(:)+ah(:);
clf; plot(t,y,'-',t,yh,'--'); 
xlabel('time'); ylabel('displacement');
title('Total and Homogeneous Response'); 
legend('Total response','Homogeneous response');
figure(gcf);
disp('Press [Enter] to continue');
dumy=input('','s');  
print -deps displac;

clf; plot(t,a,'-'); 
xlabel('time'); ylabel('acceleration') 
title('Acceleration Due to Base Oscillation') 
figure(gcf); print -deps accel

%=============================================

function y=fouaprox(func,per,t,nsum,nft)
% 
% y=fouaprox(func,per,t,nsum,nft)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Approximation of a function by a Fourier 
% series.
%
% func   - function being expanded
% per    - period of the function
% t      - vector of times at which the series
%          is to be evaluated
% nsum   - number of terms summed in the series
% nft    - number of function values used to 
%          compute Fourier coefficients. This 
%          should be an integer power of 2. 
%          The default is 1024
%
% User m functions called:  none.
%----------------------------------------------

if nargin<5, nft=1024; end; 
nsum=min(nsum,fix(nft/2));
c=fft(feval(func,per/nft*(0:nft-1)))/nft; 
c(1)=c(1)/2; c=c(:); c=c(1:nsum); 
w=2*pi/per*(0:nsum-1); 
y=2*real(exp(i*t(:)*w)*c);

%=============================================

function ybase=imptp(t,period) 
%
% ybase=imptp(t,period)
% ~~~~~~~~~~~~~~~~~~~~~
% This function defines a piecewise linear 
% function resembling the ground motion of 
% the earthquake which occurred in 1940 in 
% the Imperial Valley of California. The 
% maximum amplitude of base motion is 
% normalized to equal unity.
%
% period - period of the motion 
%          (optional argument)
% t      - vector of times between 
%          tmin and tmax
% ybase  - piecewise linearly interpolated 
%          base motion
%
% User m functions called:  lintrp
%----------------------------------------------

tft=[ ...
  0.00    1.26    2.64    4.01    5.10 ...
  5.79    7.74;   8.65    9.74   10.77 ...
 13.06   15.07   21.60   25.49;  27.38 ...
 31.56   34.94   36.66   38.03   40.67 ...
 41.87;  48.40   51.04   53.80    0    ...
  0       0       0 ]'; 
yft=[ ...
  0       0.92   -0.25    1.00   -0.29 ...
  0.46   -0.16;  -0.97   -0.49   -0.83 ...
  0.95    0.86   -0.76    0.85;  -0.55 ...
  0.36   -0.52   -0.38    0.02   -0.19 ...
  0.08;  -0.26    0.24    0.00    0    ...
  0       0       0 ]';
tft=tft(:); yft=yft(:); 
tft=tft(1:24); yft=yft(1:24);
if nargin == 2 
  tft=tft*period/max(tft); 
end
ybase=lintrp(tft,yft,t);

%=============================================

function [t,ys,ys0,vs0,as]=...
    shkbftss(m,c,k,ybase,prd,nft,nsum, ...
             tmin,tmax,ntimes)
%
% [t,ys,ys0,vs0,as]=...
%   shkbftss(m,c,k,ybase,prd,nft,nsum, ...
%            tmin,tmax,ntimes) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines the steady-state 
% solution of the scalar differential equation 
%
%    m*y''(t) + c*y'(t) + k*y(t) = 
%                  k*ybase(t) + c*ybase'(t) 
%
% where ybase is a function of period prd 
% which is expandable in a Fourier series
%
% m,c,k     - Mass, damping coefficient, and 
%             spring stiffness
% ybase     - Function or vector of 
%             displacements equally spaced in 
%             time which describes the base 
%             motion over a period
% prd       - Period used to expand xbase in a 
%             Fourier series
% nft       - The number of components used 
%             in the FFT (should be a power 
%             of two). If nft is input as 
%             zero, then ybase must be a 
%             vector and nft is set to 
%             length(ybase)
% nsum      - The number of terms to be used 
%             to sum the Fourier series 
%             expansion of ybase. This should 
%             not exceed nft/2.
% tmin,tmax - The minimum and maximum times 
%             for which the solution is to 
%             be computed 
% t         - A vector of times at which 
%             the solution is computed
% ys        - Vector of steady-state solution 
%             values
% ys0,vs0   - Position and velocity at t=0
% as        - Acceleration ys''(t), if this 
%             quantity is required
%
% User m functions called:  none.
%----------------------------------------------

if nft==0
   nft=length(ybase); ybft=ybase(:)
else
   tbft=prd/nft*(0:nft-1); 
   ybft=fft(feval(ybase,tbft))/nft;
   ybft=ybft(:);
end
nsum=min(nsum,fix(nft/2)); ybft=ybft(1:nsum); 
w=2*pi/prd*(0:nsum-1); 
t=tmin+(tmax-tmin)/(ntimes-1)*(0:ntimes-1)'; 
etw=exp(i*t*w); w=w(:);
ysft=ybft.*(k+i*c*w)./(k+w.*(i*c-m*w)); 
ysft(1)=ysft(1)/2; 
ys=2*real(etw*ysft); ys0=2*real(sum(ysft));
vs0=2*real(sum(i*w.*ysft));
if nargout > 4 
  ysft=-ysft.*w.^2; as=2*real(etw*ysft); 
end

%=============================================

function [t,yh,ah]= ...
         hsmck(m,c,k,y0,v0,tmin,tmax,ntimes)
%
% [t,yh,ah]=hsmck(m,c,k,y0,v0,tmin,tmax,ntimes)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Solution of 
%     m*yh''(t) + c*yh'(t) + k*yh(t) = 0
% subject to initial conditions of 
%     yh(0) = y0 and yh'(0) = v0
%
% m,c,k      -  mass, damping and spring 
%               constants
% y0,v0      -  initial position and velocity
% tmin,tmax  -  minimum and maximum times
% ntimes     -  number of times to evaluate 
%               solution
% t          -  vector of times
% yh         -  displacements for the 
%               homogeneous solution
% ah         -  accelerations for the 
%               homogeneous solution
%
% User m functions called:  none.
%----------------------------------------------

t=tmin+(tmax-tmin)/(ntimes-1)*(0:ntimes-1); 
r=sqrt(c*c-4*m*k);
if r~=0
  s1=(-c+r)/(2*m); s2=(-c-r)/(2*m); 
  g=[1,1;s1,s2]\[y0;v0];
  yh=real(g(1)*exp(s1*t)+g(2)*exp(s2*t));
  if nargout > 2
    ah=real(s1*s1*g(1)*exp(s1*t)+ ...
       s2*s2*g(2)*exp(s2*t));
  end 
else
  s=-c/(2*m); 
  g1=y0; g2=v0-s*g1; yh=(g1+g2*t).*exp(s*t);
  if nargout > 2
    ah=real(s*(2*g2+s*g1+s*g2*t).*exp(s*t));
  end
end

%=============================================

% function y=lintrp(xd,yd,x)
% See Appendix B
