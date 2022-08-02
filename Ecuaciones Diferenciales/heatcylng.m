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

global ubdry besjrt

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

close, colormap('default'), surf(x,y,uinit)
title('INITIAL TEMPERATURE DISTRIBUTION')
xlabel('x axis'), ylabel('y axis')
zlabel('temperature'), axis(range), disp(' ')
colormap(gray), brighten(.7)
disp('Press [Enter] to see the steady')
disp('state temperature distribution')
shg, pause, disp(' ')
print -deps tempinit

surf(x,y,usteady)
title('STEADY STATE TEMPERATURE DISTRIBUTION')
xlabel('x axis'), ylabel('y axis')
zlabel('temperature'), axis(range)
colormap(gray), brighten(.7), shg
print -deps tempstdy

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
  [dumy,k2]=min(abs(t-.02)); [dumy,k5]=min(abs(t-.05));
  for j=1:nt
    utotal=usteady+u(:,:,j);
    surf(x,y,utotal)
    titl=sprintf(['Temperature at time =',...
      '%6.3f'],t(j)); title(titl)
    xlabel('x axis'), ylabel('y axis')
    zlabel('temperature'), axis(range);
    colormap(gray), brighten(.7)
    drawnow; shg, pause(.3) 
    if j==k2, print -deps tempat02, pause, end
    if j==k5, print -deps tempat05, pause, end            
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
% r=besjtabl(nordr,nrts)
% ~~~~~~~~~~~~~~~~~~~~~
% This function contains a table for roots of 
% besselj(n,x)=0 accurate to about five digits.
% r(k,:) contains the first 20 positive roots of
% besselj(k-1,x)=0; for k=1:21
% nordr - a vector of function orders with components
%         of nordr lying between 0 and 20
% nrts  - the highest root order of each Bessel 
%         function up to the twentieth positive root

if nargin==0, nordr=0:20; nrts=20; end
if max(nordr)>20 | nrts>20, r=nan; return; end
r=[...
  2.4048 31.6501 38.6843 44.7220 50.2453 55.4405 60.4033
  3.8317 32.8218 39.9526 46.0655 51.6533 56.9052 61.9193
  5.1356 33.9887 41.2135 47.4003 53.0504 58.3579 63.4221
  6.3801 11.7916 42.4678 48.7265 54.4378 59.7991 64.9128
  7.5883 13.3237 43.7155 50.0446 55.8157 61.2302 66.3913
  8.7715 14.7960 44.9577 51.3552 57.1850 62.6513 67.8594
  9.9362 16.2234 21.2117 52.6589 58.5458 64.0629 69.3172
 11.0864 17.6159 22.7601 53.9559 59.8990 65.4659 70.7653
 12.2251 18.9801 24.2702 55.2466 61.2448 66.8607 72.2044
 13.3543 20.3208 25.7482 30.6346 62.5840 68.2474 73.6347
 14.4755 21.6415 27.1990 32.1897 63.9158 69.6268 75.0567
 15.5898 22.9452 28.6266 33.7166 65.2418 70.9988 76.4710
 16.6983 24.2339 30.0337 35.2187 40.0584 72.3637 77.8779
 17.8014 25.5094 31.4228 36.6990 41.6171 73.7235 79.2776
 18.9000 26.7733 32.7958 38.1598 43.1535 75.0763 80.6706
 19.9944 28.0267 34.1543 39.6032 44.6698 49.4826 82.0570
 21.0852 29.2706 35.4999 41.0308 46.1679 51.0436 83.4373
 22.1725 30.5060 36.8336 42.4439 47.6493 52.5861 84.8116
 23.2568 31.7334 38.1563 43.8439 49.1157 54.1117 58.9070
 24.3383 32.9537 39.4692 45.2315 50.5681 55.6217 60.4695
 25.4171 34.1672 40.7729 46.6081 52.0077 57.1174 62.0162
  5.5201 35.3747 42.0679 47.9743 53.4352 58.5996 63.5484
  7.0156 36.5764 43.3551 49.3308 54.8517 60.0694 65.0671
  8.4173 37.7729 44.6349 50.6782 56.2576 61.5277 66.5730
  9.7611 14.9309 45.9076 52.0172 57.6538 62.9751 68.0665
 11.0647 16.4707 47.1740 53.3483 59.0409 64.4123 69.5496
 12.3385 17.9599 48.4345 54.6719 60.4194 65.8399 71.0219
 13.5893 19.4094 24.3525 55.9885 61.7893 67.2577 72.4843
 14.8213 20.8269 25.9037 57.2984 63.1524 68.6681 73.9369
 16.0378 22.2178 27.4206 58.6020 64.5084 70.0699 75.3814
 17.2412 23.5861 28.9084 33.7758 65.8564 71.4639 76.8170
 18.4335 24.9350 30.3710 35.3323 67.1982 72.8506 78.2440
 19.6160 26.2668 31.8117 36.8629 68.5339 74.2302 79.6643
 20.7899 27.5839 33.2330 38.3705 43.1998 75.6032 81.0769
 21.9563 28.8874 34.6371 39.8577 44.7593 76.9699 82.4825
 23.1158 30.1790 36.0257 41.3263 46.2980 78.3305 83.8815
 24.2692 31.4600 37.4001 42.7784 47.8178 52.6241 85.2738
 25.4170 32.7310 38.7618 44.2154 49.3204 54.1856 86.6603
 26.5598 33.9932 40.1118 45.6384 50.8072 55.7297 88.0408
 27.6979 35.2471 41.4511 47.0487 52.2794 57.2577 62.0485
 28.8317 36.4934 42.7804 48.4475 53.7383 58.7709 63.6114
 29.9616 37.7327 44.1006 49.8346 55.1847 60.2703 65.1593
  8.6537 38.9654 45.4122 51.2120 56.6196 61.7567 66.6933
 10.1735 40.1921 46.7158 52.5798 58.0436 63.2313 68.2142
 11.6199 41.4131 48.0122 53.9382 59.4575 64.6947 69.7230
 13.0152 18.0711 49.3012 55.2892 60.8617 66.1476 71.2205
 14.3726 19.6159 50.5836 56.6319 62.2572 67.5905 72.7065
 15.7002 21.1170 51.8600 57.9672 63.6441 69.0240 74.1827
 17.0037 22.5828 27.4935 59.2953 65.0231 70.4486 75.6493
 18.2876 24.0190 29.0469 60.6170 66.3943 71.8648 77.1067
 19.5546 25.4303 30.5692 61.9323 67.7586 73.2731 78.5555
 20.8070 26.8202 32.0649 36.9171 69.1159 74.6738 79.9960
 22.0470 28.1912 33.5372 38.4748 70.4668 76.0673 81.4291
 23.2758 29.5456 34.9887 40.0085 71.8113 77.4536 82.8535
 24.4949 30.8854 36.4220 41.5208 46.3412 78.8337 84.2714
 25.7051 32.2119 37.8387 43.0138 47.9015 80.2071 85.6825
 26.9074 33.5265 39.2405 44.4893 49.4422 81.5752 87.0870
 28.1024 34.8300 40.6286 45.9489 50.9651 55.7655 88.4846
 29.2909 36.1237 42.0041 47.3941 52.4716 57.3275 89.8772
 30.4733 37.4081 43.3684 48.8259 53.9631 58.8730 91.2635];
r=reshape(r(:),21,20); r=r(1+nordr,1:nrts); 

%=============================================

% function [val,bp,wf]=gcquad(func,xlow,...
%                     xhigh,nquad,mparts,varargin)
% See Appendix B