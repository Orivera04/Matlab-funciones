function laplarec      
% Example:  laplarec
% ~~~~~~~~~~~~~~~~~~
% This program uses Fourier series methods to
% solve Laplace's equation inside a rectangle.
% Boundary conditions are defined by piecewise
% linear interpolation of boundary data. The 
% program can easily be changed to deal with 
% problems where the boundary conditions are 
% expressed by analytically defined functions.
% Surface and contour plots of the solution 
% are also provided.
%
% User m functions required: 
%    setup, ulbc, sinfft, laprec, fbot, gtop, 
%    plft, qrht, lintrp

clear
global a_ b_ xbot_ ubot_ xtop_ utop_ 
global ylft_ ulft_ yrht_ urht_
global u1_ u2_

a_=3; b_=2; % Rectangle side lengths

a=a_; b=b_;
xd=linspace(0,a,101)'; yd=linspace(0,b,101)';
fb=[xd,1+2*(xd/a)+sin(4*pi/a*xd)/2]; % cos(5*pi/a*xd)];
ft=[a*[0;.3;.4;.6;.7;1],[2;2;3;3;2;2.5]];
fl=[[0;b/2;b],[1;2;2]]; fr=[[0;b/5;b],[3;3;2.5]];
xtop_=ft(:,1); utop_=ft(:,2); ntop=length(xtop_);
xbot_=fb(:,1); ubot_=fb(:,2); nbot=length(xbot_);
ylft_=fl(:,1); ulft_=fl(:,2); nlft=length(ylft_);
yrht_=fr(:,1); urht_=fr(:,2); nrht=length(yrht_);

% Data for piecewise linear boundary conditions
while 0
xtop_=[0;    3];    utop_=  [0;    2]; 
ntop=length(xtop_);
xbot_=[0;1;2;3];    ubot_=[2;-1;-1;2]; 
nbot=length(xbot_);
ylft_=[0;0.6;0.6;2]; ulft_=[2;2;4;-2];  
nlft=length(ylft_);
yrht_=[0;1;1.1;2];  urht_=[2;4;-2; 0]; 
nrht=length(ylft_);
end

% Create the constants needed in function ulbc
cc=setup; 

% Adjust boundary data to give zero 
% end conditions
for k=1:nbot
  ubot_(k)=ubot_(k)-ulbc(cc,xbot_(k),0);end
for k=1:ntop
  utop_(k)=utop_(k)-ulbc(cc,xtop_(k),b_);end
for k=1:nlft
  ulft_(k)=ulft_(k)-ulbc(cc,0,ylft_(k));end
for k=1:nrht
  urht_(k)=urht_(k)-ulbc(cc,a_,yrht_(k));end

% Generate Fourier coefficients for the 
% modified boundary conditions
sbot=sinfft('fbot',a_,9); stop=sinfft('gtop',a_,9);
slft=sinfft('plft',b_,9); srht=sinfft('qrht',b_,9);

% Generate a grid of interior points 
% for solution evaluation
nin=51; ntrms=50;
xin=linspace(0,a_,nin); yin=linspace(0,b_,nin);

% Evaluate the solution having zero 
% corner values
uin=laprec(...
    sbot,stop,slft,srht,a_,b_,xin,yin,ntrms);

% Correct results for nonzero corner values

uin=uin+ulbc(cc,xin,yin); uin=flipud(uin');

% Display surfaces showing function 
% values on the grid

clf; surfc(xin,yin,flipud(uin)); 
xlabel('x axis'); ylabel('y axis');
zlabel('function value');
title('Surface Plot'); axis equal, figure(gcf);
dumy=input('Press [Enter] to continue','s');
print -deps lapsrfac 

clf; contour(xin,yin,flipud(uin),30);
title('Contour Plot');
xlabel('x direction'); ylabel('y direction'); 
figure(gcf), print -deps contur
disp('All Done');

%=============================================

function cc=setup
%
% cc=setup
% ~~~~~~~~
% cc - coefficients used to define the 
%      particular solution to satisfy 
%      corner conditions
%
% User m functions called:  
%    fbot, qrht, plft, gtop
%----------------------------------------------

global  a_ b_

s=(a_+b_)/1e10;
c1=(fbot(s)+plft(s))/2; 
c2=(fbot(a_-s)+qrht(s))/2;
c3=(plft(b_-s)+gtop(s))/2; 
c4=(gtop(a_-s)+qrht(b_-s))/2;
mat=[[1,0,0,0];[1,a_,0,0];
     [1,0,b_,0];[1,a_,b_,a_*b_]];
vec=[c1;c2;c3;c4]; cc=mat\vec;

%=============================================

function u=ulbc(c,x,y)
%
% u=ulbc(c,x,y)
% ~~~~~~~~~~~~~
% This function determines a harmonic function 
% satisfying boundary conditions which vary 
% linearly on the sides of a rectangle.
%
% User m functions called:  none
%----------------------------------------------

x=x(:); y=y(:)'; nx=length(x); ny=length(y); 
x=x*ones(1,ny); y=ones(nx,1)*y;
u=c(1)*ones(nx,ny)+c(2)*x+c(3)*y+c(4)*x.*y;
function sincof = sinfft(fun,hafper,powr2)
%
% sincof = sinfft(fun,hafper,powr2)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines coefficients in 
% the Fourier sine series of a general real 
% valued function.
%
%  hafper - the half  period over which the 
%           expansion applies
%  fun    - the real valued function being 
%           expanded. This function must be 
%           defined for vector arguments with 
%           components between zero 
%           and hafper.
%  powr2  - the power of 2 determining the 
%           number of function values used 
%           in the FFT (number of 
%           values = 2^powr2).  When powr2 
%           is 9, then 512 function values 
%           are used and 255 Fourier 
%           coefficients are computed.
%
% User m functions called:  none
%----------------------------------------------

n=2^powr2; period=2*hafper; n2=n/2; 
x=(period/n)*(0:n2);
fval=feval(fun,x); 
fval=fval(:); fval=[fval;-fval(n2:-1:2)];
foucof=fft(fval); 
sincof=-(2/n)*imag(foucof(2:n2));

%=============================================

function u=laprec(f,g,p,q,a,b,x,y,ntrms)
%
% u=laprec(f,g,p,q,x,y,ntrms)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function sums the series which solves 
% Laplace's equation in a rectangle.
%
%  f,g,p,q - Fourier sine series coefficients 
%            for the boundary conditions on 
%            the bottom, top, left, and 
%            right sides
%   a,b    - the horizontal and vertical 
%            side lengths
%   x,y    - vectors containing coordinates 
%            of points defining a rectangular 
%            grid on which the solution is 
%            to be evaluated.
%   ntrms  - number of series terms used (not 
%            exceeding length(f));
%
% User m functions called:  none
%----------------------------------------------

nt=length(f); 
if nargin==8, ntrms=nt; end; 
ntrms=min(nt,ntrms);
x=x(:); y=y(:)'; 
n=1:ntrms; nx=length(x); ny=length(y);
if nt>ntrms 
  f=f(n); g=g(n); p=p(n); q=q(n);
end
a2=2*a; b2=2*b; na=(pi/a)*n; nb=(pi/b)*n;
denomx=1-exp(-b2*na(:));
f=f(:)./denomx; g=g(:)./denomx;
denomy=1-exp(-a2*nb(:)'); 
p=p(:)'./denomy; q=q(:)'./denomy;

u1_=(f*ones(1,ny)).* ...
    (exp(-na'*y)-exp(-na'*(b2-y)));
u2_=(g*ones(1,ny)).* ...
    (exp(-na'*(b-y))-exp(-na'*(b+y)));
u=sin(x*na)*( u1_+u2_ );
u3_=(exp(-x*nb)-exp(-(a2-x)*nb)).* ...
    (ones(nx,1)*p);
u4_=(exp(-(a-x)*nb)-exp(-(a+x)*nb)).* ...
    (ones(nx,1)*q);
u=u+(u3_+u4_)*sin(nb'*y);

%=============================================

function ubot=fbot(x)
%
% ubot=fbot(x)
% ~~~~~~~~~~~~
% x    - vector argument
% ubot - function value on bottom side
%
% User m functions called:  lintrp
%----------------------------------------------

global xbot_ ubot_

ubot=lintrp(xbot_,ubot_,x);

%=============================================

function utop=gtop(x)
%
% utop=gbot(x)
% ~~~~~~~~~~~~
% x    - vector argument
% gtop - function value on top side
%
% User m functions called:  lintrp
%----------------------------------------------

global xtop_ utop_

utop=lintrp(xtop_,utop_,x);

%=============================================

function ulft=plft(y)
%
% ulft=plft(y)
% ~~~~~~~~~~~~
% y    - vector argument
% ulft - function value on left side
%
% User m functions called:  lintrp
%----------------------------------------------

global ylft_ ulft_

ulft=lintrp(ylft_,ulft_,y);

%=============================================

function urht=qrht(y)
%
% urht=qrht(y)
% ~~~~~~~~~~~~
% y    - vector argument
% urht - function value on right side
%
% User m functions called:  lintrp
%----------------------------------------------

global yrht_ urht_

urht=lintrp(yrht_,urht_,y);