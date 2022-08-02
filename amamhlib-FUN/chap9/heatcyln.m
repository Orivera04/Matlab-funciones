function heatcyln
%
% heatcyln
% ~~~~~~~~
% This program analyzes the time varying temperature
% history in a circular cylinder which initially has
% a radially symmetric temperature varying para-
% bolically. Then a spatially varying but constant 
% boundary temperature distribution is imposed. The 
% total solution is composed of a harmonic steady 
% state solution plus a transient component given by
% a Fourier-Bessel series.
% User functions called: 
%     besjtabl, tempinit, tempstdy, foubesco,
%     tempsum,  tempdif,  gcquad

global ubdry besjrt; close

% Obtain Bessel function roots needed in the 
% transient solution
besjrt=besjtabl(0:20,20);

% Define the steady state temperature imposed
% on the outer boundary for t>0
th=linspace(0,pi,100)';
ud=cos(2*th).*(th<=pi/2)+...
(-3+4/pi*th).*(th>pi/2&th<3*pi/4);
ud=[ud;ud(end-1:-1:1)];
ubdry=[linspace(0,360,199)',ud];
theta=linspace(0,2*pi,65);
r=linspace(0,1,15);

% Compute and plot the initial and final
% temperature fields
[uinit,z]=tempinit(theta,r);
[usteady,z]=tempstdy(theta,r);
umin=min([usteady(:);uinit(:)]);
umax=max([usteady(:);uinit(:)]);
range=[-1,1,-1,1,umin,umax];
x=real(z); y=imag(z);

surf(x,y,uinit), colormap('default')
title('INITIAL TEMPERATURE DISTRIBUTION')
xlabel('x axis'), ylabel('y axis')
zlabel('temperature'), axis(range), disp(' ')
disp('Press [Enter] to see the steady')
disp('state temperature distribution')
shg, pause, disp(' ')
% print -deps tempinit

surf(x,y,usteady)
title('STEADY STATE TEMPERATURE DISTRIBUTION')
xlabel('x axis'), ylabel('y axis')
zlabel('temperature'), axis(range), shg
% print -deps tempstdy

% Compute coefficients used in the Fourier-
% Bessel series for the transient solution
[c,lam,cptim]=foubesco(@tempdif,20,20,40,128);

% Set a time interval sufficient to nearly 
% reach steady state
tmax=.4; nt=81; t=linspace(0,tmax,nt);

% Evaluate the transient solution
[u,tsum]=tempsum(c,theta,r,t,lam);
u(:,:,1)=uinit-usteady;

% Plot time history for the total solution
while 1
  disp('Press [Enter] to see the animation')
  disp('or enter 0 to stop'), v=input('> ? ');
  if isempty(v), v=1; end
  if v~=1, break, end
  for j=1:nt
    utotal=usteady+u(:,:,j);
    surf(x,y,utotal)
    titl=sprintf(['Temperature at time =',...
      '%6.3f'],t(j)); title(titl)
    xlabel('x axis'), ylabel('y axis')
    zlabel('temperature'), axis(range);
    drawnow; shg, pause(.3) 
  end
end

%=============================================

function [u,z]=tempstdy(theta,r)
%
% [u,z]=tempstdy(theta,r)
% ~~~~~~~~~~~~~~~~~~~~~~
% Steady state temperature distribution in a 
% circular cylinder of unit radius with 
% piecewise linear boundary values 
% described in global array ubdry. 
global ubdry

thft=2*pi/(1024)*(0:1023); n=100; 
ufft=interp1(pi/180*ubdry(:,1),...
             ubdry(:,2)/1024,thft);
c=fft(ufft); z=exp(i*theta(:))*r(:)';
u=-real(c(1))+2*real(...
   polyval(c(n:-1:1),z)); 

%=============================================

function [u,z]=tempinit(theta,r)
%
% [u,z]=tempinit(theta,r)
% ~~~~~~~~~~~~~~~~~~~~~~
% Initial temperature varying parabolically
% with the radius
theta=theta(:); r=r(:)'; z=exp(i*theta)*r;
u=ones(length(theta),1)*(1-r.^2);

%=============================================

function [u,z]=tempdif(theta,r)
%
% [u,z]=tempdif(theta,r)
% ~~~~~~~~~~~~~~~~~~~~~
% Difference between the steady state temp-
% erature and the initial temperature
u1=tempstdy(theta,r); [u2,z]=tempinit(theta,r);
u=u2-u1;

%=============================================

function [c,lam,cptim]=foubesco(...
                         f,nord,nrts,nrquad,nft)
%                       
% [c,lam,cptim]=foubesco(f,nord,nrts,nrquad,nft)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Fourier-Bessel coefficients computed using the
% FFT
global besjrt
if nargin<5, nft=128; end
if nargin<4, nrquad=50; end
if nargin<3, nrts=10; end
if nargin<2, nord=10; end
if nargin==0, f='fbes'; end 
tic; lam=besjrt(1:nord,1:nrts);
c=zeros(nord,nrts);
[dummy,r,w]=gcquad([],0,1,nrquad,1);
r=r(:)'; w=w(:)'; th=2*pi/nft*(0:nft-1)';
fmat=fft(feval(f,th,r));
fmat=fmat(1:nord,:).*repmat(r.*w,nord,1);
for n=1:nord
  for k=1:nrts
    lnk=lam(n,k);
    v=sum(fmat(n,:).*besselj(n-1,lnk*r));
    c(n,k)=4*v/nft/besselj(n,lnk).^2;
  end
end
c(1,:)=c(1,:)/2; cptim=toc;

%=============================================

function [u,tcpu]=tempsum(c,th,r,t,lam)
%
% [u,tsum]=tempsum(c,th,r,t,lam)
%
% This function sums a Fourier-Bessel series
% for transient temperature history in a circular
% cylinder with given initial conditions and
% zero temperature at the boundary. The series
% has the form
% u(theta,r,t)=sum({n=0:nord-1),k=1:nrts},...
% besselj(n,lam(n+1,k)*r)*real(...
% c(n+1,k)*exp(i*(n+1)*theta))*...
% exp(-lam(n+1,k)^2*t), where
% besselj(n-1,lam(n,k))=0 and 
% [nord,nrts]=size(c)
% 
% c    - the series coefficients for the initial
%        temperature distribution obtained using
%        function foubesco
% th   - vector or theta values between
%        zero and 2*pi
% r    - vector of radius values between
%        zero and one
% lam  - matrix of bessel function roots.
%        If this argument is omitted, then
%        function besjroot is called to
%        compute the roots
% u    - a three-dimensional array of function
%        values where u(i,j,k) contains the 
%        temperature for theta(i), r(j), t(k)
% tcpu - computation time in seconds

tic; [nord,nrts]=size(c); 
if nargin<5, lam=besjroot(0:nord-1,nrts); end
th=th(:); nth=length(th); r=r(:)'; nr=length(r);
nt=length(t); N=repmat((0:nord-1)',1,nrts);
N=N(:)'; c=c(:).'; lam=lam(:); lam2=-(lam.^2)';
u=zeros(nth,nr,nt); thmat=exp(i*th*N);
besmat=besselj(repmat(N',1,nr),lam*r);
for I=1:nt
  C=c.*exp(lam2*t(I));
  u(:,:,I)=real(thmat.*repmat(C,nth,1))*besmat;
end
tcpu=toc;

%=============================================

function r=besjtabl(nordr,nrts)
%
% r=besjtable(nordr,nrts)
% ~~~~~~~~~~~~~~~~~~~~~
% This function returns a table for roots of 
% besselj(n,x)=0 accurate to about five digits.
% r(k,:) - contains the first 20 positive roots of
%          besselj(k-1,x)=0; for k=1:21
% nordr  - a vector of function orders lying
%          between 0 and 20
% nrts   - the highest root order not to exceed
%          the twentieth positive root

if nargin==0, nordr=0:20; nrts=20; end
if max(nordr)>20 | nrts>20, r=nan; return; end
r=[2.4048 21.6415 40.7729 33.7758 53.7383 73.2731
   3.8317 22.9452 42.0679 35.3323 55.1847 74.6738
   5.1356 24.2339 43.3551 36.8629 56.6196 76.0673
   6.3801 25.5094 44.6349 38.3705 58.0436 77.4536
   7.5883 26.7733 45.9076 39.8577 59.4575 78.8337
   8.7715 28.0267 47.1740 41.3263 60.8617 80.2071
   9.9362 29.2706 48.4345 42.7784 62.2572 81.5752
  11.0864 30.5060 24.3525 44.2154 63.6441 55.7655
  12.2251 31.7334 25.9037 45.6384 65.0231 57.3275
  13.3543 32.9537 27.4206 47.0487 66.3943 58.8730
  14.4755 34.1672 28.9084 48.4475 67.7586 60.4033
  15.5898 35.3747 30.3710 49.8346 69.1159 61.9193
  16.6983 36.5764 31.8117 51.2120 70.4668 63.4221
  17.8014 37.7729 33.2330 52.5798 71.8113 64.9128
  18.9000 14.9309 34.6371 53.9382 46.3412 66.3913
  19.9944 16.4707 36.0257 55.2892 47.9015 67.8594
  21.0852 17.9599 37.4001 56.6319 49.4422 69.3172
  22.1725 19.4094 38.7618 57.9672 50.9651 70.7653
  23.2568 20.8269 40.1118 59.2953 52.4716 72.2044
  24.3383 22.2178 41.4511 60.6170 53.9631 73.6347
  25.4171 23.5861 42.7804 61.9323 55.4405 75.0567
   5.5201 24.9350 44.1006 36.9171 56.9052 76.4710
   7.0156 26.2668 45.4122 38.4748 58.3579 77.8779
   8.4173 27.5839 46.7158 40.0085 59.7991 79.2776
   9.7611 28.8874 48.0122 41.5208 61.2302 80.6706
  11.0647 30.1790 49.3012 43.0138 62.6513 82.0570
  12.3385 31.4600 50.5836 44.4893 64.0629 83.4373
  13.5893 32.7310 51.8600 45.9489 65.4659 84.8116
  14.8213 33.9932 27.4935 47.3941 66.8607 58.9070
  16.0378 35.2471 29.0469 48.8259 68.2474 60.4695
  17.2412 36.4934 30.5692 50.2453 69.6268 62.0162
  18.4335 37.7327 32.0649 51.6533 70.9988 63.5484
  19.6160 38.9654 33.5372 53.0504 72.3637 65.0671
  20.7899 40.1921 34.9887 54.4378 73.7235 66.5730
  21.9563 41.4131 36.4220 55.8157 75.0763 68.0665
  23.1158 18.0711 37.8387 57.1850 49.4826 69.5496
  24.2692 19.6159 39.2405 58.5458 51.0436 71.0219
  25.4170 21.1170 40.6286 59.8990 52.5861 72.4843
  26.5598 22.5828 42.0041 61.2448 54.1117 73.9369
  27.6979 24.0190 43.3684 62.5840 55.6217 75.3814
  28.8317 25.4303 44.7220 63.9158 57.1174 76.8170
  29.9616 26.8202 46.0655 65.2418 58.5996 78.2440
   8.6537 28.1912 47.4003 40.0584 60.0694 79.6643
  10.1735 29.5456 48.7265 41.6171 61.5277 81.0769
  11.6199 30.8854 50.0446 43.1535 62.9751 82.4825
  13.0152 32.2119 51.3552 44.6698 64.4123 83.8815
  14.3726 33.5265 52.6589 46.1679 65.8399 85.2738
  15.7002 34.8300 53.9559 47.6493 67.2577 86.6603
  17.0037 36.1237 55.2466 49.1157 68.6681 88.0408
  18.2876 37.4081 30.6346 50.5681 70.0699 62.0485
  19.5546 38.6843 32.1897 52.0077 71.4639 63.6114
  20.8070 39.9526 33.7166 53.4352 72.8506 65.1593
  22.0470 41.2135 35.2187 54.8517 74.2302 66.6933
  23.2758 42.4678 36.6990 56.2576 75.6032 68.2142
  24.4949 43.7155 38.1598 57.6538 76.9699 69.7230
  25.7051 44.9577 39.6032 59.0409 78.3305 71.2205
  26.9074 21.2117 41.0308 60.4194 52.6241 72.7065
  28.1024 22.7601 42.4439 61.7893 54.1856 74.1827
  29.2909 24.2702 43.8439 63.1524 55.7297 75.6493
  30.4733 25.7482 45.2315 64.5084 57.2577 77.1067
  31.6501 27.1990 46.6081 65.8564 58.7709 78.5555
  32.8218 28.6266 47.9743 67.1982 60.2703 79.9960
  33.9887 30.0337 49.3308 68.5339 61.7567 81.4291
  11.7916 31.4228 50.6782 43.1998 63.2313 82.8535
  13.3237 32.7958 52.0172 44.7593 64.6947 84.2714
  14.7960 34.1543 53.3483 46.2980 66.1476 85.6825
  16.2234 35.4999 54.6719 47.8178 67.5905 87.0870
  17.6159 36.8336 55.9885 49.3204 69.0240 88.4846
  18.9801 38.1563 57.2984 50.8072 70.4486 89.8772
  20.3208 39.4692 58.6020 52.2794 71.8648 91.2635];
r=reshape(r(:),21,20); r=r(1+nordr,1:nrts);

%=============================================

% function [val,bp,wf]=gcquad(func,xlow,...
%                     xhigh,nquad,mparts,varargin)
% See Appendix B