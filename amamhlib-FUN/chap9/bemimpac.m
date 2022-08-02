function bemimpac      
% Example: bemimpac
% ~~~~~~~~~~~~~~~~~
% This program analyzes an impact dynamics 
% problem for an elastic Euler beam of 
% constant cross section which is simply 
% supported at each end. The beam is initially 
% at rest when a harmonically varying moment 
% m0*cos(w0*t) is applied to the right end. 
% The resulting transverse displacement and 
% bending moment are computed.  The 
% displacement and moment are plotted as 
% functions of x for the three time values. 
% Animated plots of the entire displacement
% and moment history are also given.
%
% User m functions required: 
%    beamresp, beamanim, sumser, ndbemrsp

fprintf('\nDYNAMICS OF A BEAM WITH AN ');
fprintf('OSCILLATING END MOMENT\n');
ei=1; arho=1; len=1; m0=1; w0=.90*pi^2;
tmin=0; tmax=5; nt=101;
xmin=0; xmax=len; nx=151; ntrms=200;
[t,x,displ,mom]=beamresp(ei,arho,len,m0,w0,...
             tmin,tmax,nt,xmin,xmax,nx,ntrms);
disp(' ')
disp('Press [Enter] to see the deflection') 
disp('for three positions'), pause

np=[3 5 8]; close; pltsave=0;
dip=displ(np,:); mop=mom(np,:);
plot(x,dip(1,:),'-k',x,dip(2,:),':b',...
     x,dip(3,:),'--r'); 
xlabel('x axis'); ylabel('displacement');
hh=gca; 
r(1:2)=get(hh,'XLim'); r(3:4)=get(hh,'YLim'); 
xp=r(1)+(r(2)-r(1))/10;
dp=r(4)-(r(4)-r(3))/10;
tstr=['Displacement for Nearly Resonant' ...
      ' Moment Acting at Right End'];
title(tstr);
text(xp,dp,['Number of series terms ' ...
            'used = ',int2str(ntrms)]);
legend('t=0.10','t=0.20','t=0.35',3)        
disp(' ')
disp('Press [Enter] to the bending moment') 
disp('for three positions')
shg; pause  
if pltsave, print -deps 3positns, end 

close; 
plot(x,mop(1,:),'-k',x,mop(2,:),':b',...
     x,mop(3,:),'--r'); 
h=gca; 
r(1:2)=get(h,'XLim'); r(3:4)=get(h,'YLim'); 
mp=r(3)+(r(4)-r(3))/10;
xlabel('x axis'); ylabel('moment');
tstr=['Bending Moment for Nearly Resonant' ...
      ' Moment Acting at Right End'];
title(tstr);
text(xp,mp,['Number of series terms ' ...
            'used = ',int2str(ntrms)]);
legend('t=0.10','t=0.20','t=0.35',2),
disp(' '), disp(...
'Press [Enter] to see the deflections surface') 
shg, pause
if pltsave, print -deps 3moments, end

inct=2; incx=2; 
ht=0.75; it=1:inct:.8*nt; ix=1:incx:nx;
tt=t(it); xx=x(ix); 
dd=displ(it,ix); mm=mom(it,ix);
a=surf(xx,tt,dd);
tstr=['Transverse Deflection as a ' ...
      'Function of Time and Position'];
title(tstr);
xlabel('x axis'); ylabel('time'); 
zlabel('transverse deflection');
disp(' '), disp(['Press [Enter] to ',...
'see the bending moment surface']) 
shg, pause
if pltsave, print -deps bdeflsrf, end

a=surf(xx,tt,mm);
title(['Bending Moment as a Function ' ...
       'of Time and Position'])
xlabel('x axis'); ylabel('time'); 
zlabel('bending moment'); disp(' ')
disp('Press [Enter] to see animation of');
disp('the beam deflection'), shg, pause 
if pltsave, print -deps bmomsrf, end
beamanim(x,displ,.1,'Transverse Deflection', ...
        'x axis','deflection'), disp(' ') 
disp('Press [Enter] to see animation');
disp('of the bending moment'); pause
beamanim(x,mom,.1,'Bending Moment History', ...
        'x axis','moment'); 
fprintf('\nAll Done\n'); close;

%=============================================

function [t,x,displ,mom]= ...
      beamresp(ei,arho,len,m0,w0,tmin,tmax, ...
               nt,xmin,xmax,nx,ntrms)
%
% [t,x,displ,mom]=beamresp(ei,arho,len,m0, ...
%           w0,tmin,tmax,nt,xmin,xmax,nx,ntrms)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function evaluates the time dependent 
% displacement and moment in a constant 
% cross section, simply supported beam which 
% is initially at rest when a harmonically 
% varying moment is suddenly applied at the 
% right end.  The resulting time histories of 
% displacement and moment are computed.
%
% ei        - modulus of elasticity times 
%             moment of inertia
% arho      - mass per unit length of the 
%             beam
% len       - beam length
% m0,w0     - amplitude and frequency of the 
%             harmonically varying right end 
%             moment
% tmin,tmax - minimum and maximum times for
%             the solution
% nt        - number of evenly spaced 
%             solution times
% xmin,xmax - minimum and maximum position 
%             coordinates for the solution. 
%             These values should lie between 
%             zero and len (x=0 and x=len at 
%             the left and right ends).
% nx        - number of evenly spaced solution 
%             positions
% ntrms     - number of terms used in the 
%             Fourier sine series
% t         - vector of nt equally spaced time 
%             values varying from tmin to tmax
% x         - vector of nx equally spaced 
%             position values varying from 
%             xmin to xmax
% displ     - matrix of transverse 
%             displacements with time varying 
%             from row to row, and position 
%             varying from column to column
% mom       - matrix of bending moments with 
%             time varying from row to row, 
%             and position varying from column 
%             to column
%
% User m functions called:  ndbemrsp
%----------------------------------------------

tcof=sqrt(arho/ei)*len^2; dcof=m0*len^2/ei;
tmin=tmin/tcof; tmax=tmax/tcof; w=w0*tcof;
xmin=xmin/len; xmax=xmax/len;
[t,x,displ,mom]=...
ndbemrsp(w,tmin,tmax,nt,xmin,xmax,nx,ntrms);
t=t*tcof; x=x*len; 
displ=displ*dcof; mom=mom*m0;

%=============================================

function beamanim(x,u,tpause,titl,xlabl,ylabl)
%
% beamanim(x,u,tpause,titl,xlabl,ylabl,save)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function draws an animated plot of data 
% values stored in array u.  The different 
% columns of u correspond to position values 
% in vector x.  The successive rows of u 
% correspond to different times. Parameter 
% tpause controls the speed of animation.
%
%  u      - matrix of values to animate plots 
%           of u versus x
%  x      - spatial positions for different 
%           columns of u
%  tpause - clock seconds between output of 
%           frames. The default is .1 secs 
%           when tpause is left out. When 
%           tpause=0, a new frame appears 
%           when the user presses any key.
%  titl   - graph title
%  xlabl  - label for horizontal axis
%  ylabl  - label for vertical axis
%
% User m functions called:  none
%----------------------------------------------
 
if nargin<6, ylabl=''; end; 
if nargin<5, xlabl=''; end
if nargin<4, titl=''; end; 
if nargin<3, tpause=.1; end;

[ntime,nxpts]=size(u); 
umin=min(u(:)); umax=max(u(:));
udif=umax-umin; uavg=.5*(umin+umax); 
xmin=min(x); xmax=max(x); 
xdif=xmax-xmin; xavg=.5*(xmin+xmax);
xwmin=xavg-.55*xdif; xwmax=xavg+.55*xdif;
uwmin=uavg-.55*udif; uwmax=uavg+.55*udif; close;
axis([xwmin,xwmax,uwmin,uwmax]); title(titl);
xlabel(xlabl); ylabel(ylabl); hold on;

for j=1:ntime
  ut=u(j,:); 
  plot(x,ut,'-'); axis('off'); figure(gcf);
  if tpause==0 
    pause; 
  else 
    pause(tpause); 
  end
  if j==ntime, break, else, cla; end
end
% print -deps cntltrac
hold off; close;

%=============================================

function [u,t,x] = sumser(a,b,c,funt,funx, ...
                   tmin,tmax,nt,xmin,xmax,nx)
%
% [u,t,x] = sumser(a,b,c,funt,funx,tmin, ...
%                  tmax,nt,xmin,xmax,nx)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function evaluates a function U(t,x) 
% which is defined by a finite series. The 
% series is evaluated for t and x values taken 
% on a rectangular grid network. The matrix u 
% has elements specified by the following 
% series summation:
%
% u(i,j)  =   sum(  a(k)*funt(t(i)*b(k))*...
%           k=1:nsum
%                          funx(c(k)*x(j))
%
% where nsum is the length of each of the 
% vectors a, b, and c.
%
% a,b,c        - vectors of coefficients in 
%                the series
% funt,funx    - handles of functions accepting 
%                matrix argument.  funt is 
%                evaluated for an argument of 
%                the form funt(t*b) where t is 
%                a column and b is a row. funx
%                is evaluated for an argument 
%                of the form funx(c*x) where 
%                c is a column and x is a row.
% tmin,tmax,nt - produces vector t with nt 
%                evenly spaced values between 
%                tmin and tmax
% xmin,xmax,nx - produces vector x with nx 
%                evenly spaced values between 
%                xmin and xmax
% u            - the nt by nx matrix 
%                containing values of the 
%                series evaluated at t(i),x(j),
%                for i=1:nt and j=1:nx
% t,x          - column vectors containing t 
%                and x values. These output 
%                values are optional.
%
% User m functions called:  none.
%----------------------------------------------

tt=(tmin:(tmax-tmin)/(nt-1):tmax)';
xx=(xmin:(xmax-xmin)/(nx-1):xmax); a=a(:).';
u=a(ones(nt,1),:).*feval(funt,tt*b(:).')*...
  feval(funx,c(:)*xx);
if nargout>1, t=tt; x=xx'; end

%=============================================

function [t,x,displ,mom]= ...
    ndbemrsp(w,tmin,tmax,nt,xmin,xmax,nx,ntrms)
%
% [t,x,displ,mom]=ndbemrsp(w,tmin,tmax,nt,...
%                         xmin,xmax,nx,ntrms)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function evaluates the nondimensional 
% displacement and moment in a constant 
% cross section, simply supported beam which 
% is initially at rest when a harmonically 
% varying moment of frequency w is suddenly 
% applied at the right end. The resulting 
% time history is computed.
%
% w          - frequency of the harmonically 
%              varying end moment
% tmin,tmax  - minimum and maximum 
%              dimensionless times
% nt         - number of evenly spaced 
%              solution times
% xmin,xmax  - minimum and maximum 
%              dimensionless position 
%              coordinates. These values 
%              should lie between zero and 
%              one (x=0 and x=1 give the 
%              left and right ends).
% nx         - number of evenly spaced 
%              solution positions
% ntrms      - number of terms used in the 
%              Fourier sine series
% t          - vector of nt equally spaced 
%              time values varying from 
%              tmin to tmax
% x          - vector of nx equally spaced 
%              position values varying 
%              from xmin to xmax
% displ      - matrix of dimensionless 
%              displacements with time 
%              varying from row to row, 
%              and position varying from 
%              column to column
% mom        - matrix of dimensionless 
%              bending moments with time 
%              varying from row to row, and
%              position varying from column 
%              to column
%
% User m functions called:  sumser
%----------------------------------------------

if nargin < 8, w=0; end; nft=512; nh=nft/2;
xft=1/nh*(0:nh)'; 
x=xmin+(xmax-xmin)/(nx-1)*(0:nx-1)';
t=tmin+(tmax-tmin)/(nt-1)*(0:nt-1)'; 
cwt=cos(w*t);

% Get particular solution for nonhomogeneous 
% end condition
if w ==0 % Case for a constant end moment
  cp=[1 0 0 0; 0 0 2 0; 1 1 1 1; 0 0 2 6]\ ...
     [0;0;0;1];
  yp=[ones(size(x)), x, x.^2, x.^3]*cp; yp=yp';
  mp=[zeros(nx,2), 2*ones(nx,1), 6*x]*cp; 
  mp=mp';
  ypft=[ones(size(xft)), xft, xft.^2, xft.^3]*cp;

% Case where end moment oscillates 
% with frequency w
else  
  s=sqrt(w)*[1, i, -1, -i]; es=exp(s);
  cp=[ones(1,4); s.^2; es; es.*s.^2]\ ...
     [0; 0; 0; 1];
  yp=real(exp(x*s)*cp); yp=yp';
  mp=real(exp(x*s)*(cp.*s(:).^2)); mp=mp';
  ypft=real(exp(xft*s)*cp);
end

% Fourier coefficients for 
% particular solution
yft=-fft([ypft;-ypft(nh:-1:2)])/nft;

% Sine series coefficients for 
% homogeneous solution
acof=-2*imag(yft(2:ntrms+1));
ccof=pi*(1:ntrms)'; bcof=ccof.^2;

% Sum series to evaluate Fourier 
% series part of solution. Then combine 
% with the particular solution.
displ=sumser(acof,bcof,ccof,@cos,@sin,...
                  tmin,tmax,nt,xmin,xmax,nx);
displ=displ+cwt*yp; acof=acof.*bcof;
mom=sumser(acof,bcof,ccof,'cos','sin',...
                 tmin,tmax,nt,xmin,xmax,nx);
mom=-mom+cwt*mp;
