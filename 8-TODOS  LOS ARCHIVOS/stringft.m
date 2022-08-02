function [x,t,y]=stringft(Xdat,Ydat)  
%
% Example: [x,t,y]=stringft(Xdat,Ydat)
% ~~~~~~~~~~~~~~~
% This program analyzes wave motion in a string 
% having arbitrary piecewise linear initial
% deflection. A Fourier series expansion is used
% to construct the solution
%
% Xdat,Ydat -data vectors defining the initial
%            deflections at interior points. The
%            deflections at x=0 and x=1 are set
%            to xero automatically. For example,
%            try Xdat=[.2,.3,.7,.8],
%                Ydat=[0,-1,-1,0]
% 
% x,t,y    - arrays containing the position, time
%            and deflection values
% 
% User m functions required:
%    sincof, initdefl, strvib, smotion, inputv,
%    lintrp

global xdat ydat; close 

disp(' '), disp( ...
  '  FOURIER SERIES SOLUTION FOR WAVES')
disp(....
  'IN A STRING WITH LINEARLY INTERPOLATED')
disp(...'
  '  INITIAL DEFLECTION AND FIXED ENDS')
if nargin==0
  disp(' ')
  disp(['Enter the number of interior ',...
        'data points (the fixed'])
  disp(['end point coordinates are ',...
        'added automatically)'])
  n=input('? '); if isempty(n), break, end
  xdat=zeros(n+2,1); ydat=xdat; xdat(n+2)=1;
  disp(' ')
  disp(['The string stretches between ',...
        'fixed endpoints at'])
  disp('x=zero and x=one. '),disp(' ')
  disp(['Enter ',num2str(n),...
       ' sets of x,y to specify interior'])
  disp(['initial deflections ',...
      '(one pair per line)']), disp(' ')
  for j=2:n+1,[xdat(j),ydat(j)]=inputv; end;
else
  xdat=[0;Xdat(:);1]; ydat=[0;Ydat(:);0];
end

a=sincof(@initdefl,1,1024); % sine coefficients
nx=51; x=linspace(0,1,nx);
xx=linspace(0,1,151);

while 1
  disp(' ')
  disp('Give the number of series terms')
  disp('and the maximum value of t')
  disp('(give 0,0 to stop)')
  [ntrms,tmax]=inputv;
  if isnan(ntrms)| norm([ntrms,tmax])==0
  break, end
  nt=ceil(nx*tmax); t=linspace(0,tmax,nt);
  y=strvib(a,t,x,1,ntrms); % time history
  yy=strvib(a,t,xx,1,ntrms); 
  [xo,to]=meshgrid(x,t);
  hold off; surf(xo,to,y); 
  grid on; colormap([1 1 1]);
  %colormap([127/255 1 212/255]);
  xlabel('x axis'); ylabel('time axis');
  zlabel('transverse deflection');
  title(['String Deflection as a Function ', ...
    'of Position and Time']); 
  disp(' '), disp('Press [Enter] to')
  disp('see the animation'), shg, pause  
  % print -deps strdefl
  smotion(xx,yy,'Wave Propagation in a String'); 
  disp(''); pause(1); 
end
% print -deps strwave

%=============================================

function y=initdefl(x)
%
% y=initdefl(x)
% ~~~~~~~~~~~~~
% This function defines the linearly 
% interpolated initial deflection 
% configuration.
%
% x - a vector of points at which the initial
%     deflection is to be computed
%
% y - transverse initial deflection value for
%     argument x
%
% xdat, ydat - global data vectors used for 
%              linear interpolation
%
% User m functions required:  lintrp
%----------------------------------------------

global xdat ydat
y=lintrp(xdat,ydat,x);

%=============================================

function y=strvib(a,t,x,hp,n)
%
% y=strvib(a,t,x,hp,n)
% ~~~~~~~~~~~~~~~~~~~~
% Sum the Fourier series for the string motion.
%
% a   - Fourier coefficients of initial 
%       deflection
% t,x - vectors of time and position values
% hp  - the half period for the series 
%       expansion
% n   - the number of series terms used
%
% y   - matrix with y(i,j) equal to the 
%       deflection at position x(i) and 
%       time t(j)
%
% User m functions required: none
%----------------------------------------------

w=pi/hp*(1:n); a=a(1:n); a=a(:)';
x=x(:); t=t(:)'; 
y=((a(ones(length(x),1),:).* ...
  sin(x*w))*cos(w(:)*t))';

%=============================================

function smotion(x,y,titl)
%
% smotion(x,y,titl)
% ~~~~~~~~~~~~~~~~~
% This function animates the string motion.
%
% x    - a vector of position values along the
%        string
% y    - a matrix of transverse deflection 
%        values where successive rows give
%        deflections at successive times
% titl - a title shown on the plot (optional)
%
% User m functions required: none
%----------------------------------------------

if nargin < 3, titl=' '; end
xmin=min(x); xmax=max(x);
ymin=min(y(:)); ymax=max(y(:));
[nt,nx]=size(y); clf reset; 
for j=1:nt
  plot(x,y(j,:),'k');
  axis([xmin,xmax,2*ymin,2*ymax]);
  axis('off'); title(titl);
  drawnow; figure(gcf); pause(.1)
end
  
%=============================================

function a=sincof(func,hafper,nft)
%
% a=sincof(func,hafper,nft)
% ~~~~~~~~~~~~~~~~~~~~~~~~~
% This function calculates the sine
% coefficients.
%
% func   - the name of a function  defined over
%          a half period
% hafper - the length of the half period of the
%          function
% nft    - the number of function values used 
%          in the Fourier series
%
% a      - the vector of Fourier sine series
%          coefficients
%
% User m functions required:  none
%----------------------------------------------

n2=nft/2; x=hafper/n2*(0:n2);
y=feval(func,x); y=y(:);
a=fft([y;-y(n2:-1:2)]); a=-imag(a(2:n2))/n2;

%=============================================

% function y=lintrp(xd,yd,x)
% See Appendix B

%=============================================

% function varargout=inputv(prompt)
% See Appendix B 