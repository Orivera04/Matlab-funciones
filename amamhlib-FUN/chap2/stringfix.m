function strngrun(rundemo)
%
% strngrun(rundemo)
% ~~~~~~~~~~~~~~~~
% This function illustrates propagation of
% waves in a tightly stretched string having
% given initial deflection. Calling strngrun
% with no input argument causes data to be
% read interactively. Otherwise, strngrun(1)
% executes a sample data case.
%
% User m functions called: strngwav animate

pltsav=0; % flag to save or not save graphs

disp(' ')
disp('WAVE PROPAGATION IN A STRING'), disp(' ')
if nargin==0 % Input data interactively
  [a,len]=inputv(['Input wave speed (a) and ',...
			'string length (len) > ? ']);
  disp(' ')
  disp(['Enter the number of interior ',...
        'data points (the fixed'])
  disp(['end point coordinates are ',...
        'added automatically)'])
  n=input('? '); if isempty(n), return, end
  xd=zeros(n+2,1); xd(n+2)=len; 
  yd=zeros(n+2,1); disp(' ')
  disp(['The string stretches between ',...
        'fixed endpoints at'])
  disp(['x=0 and x=',num2str(len),'.']),disp(' ')
  disp(['Enter ',num2str(n),...
       ' sets of x,y to specify interior'])
  disp(['initial deflections ',...
      '(one pair per line)'])
  for j=2:n+1,[xd(j),yd(j)]=inputv; end;
  k=find(diff(xd)==0); tiny=len/1e6;
  if length(k)>0, xd(k)=xd(k)+tiny; end
	disp(' ') 
	disp('Input tmax and the number of time steps')
	[tmax,nt]=inputv('(Try len/a and 40) > ? ');
  disp(' ')
	disp('Specify position x=x0 where the time')
	x0=input(...
    'history is to be evaluated (try len/4) > ? ');
	disp(' ')
	disp('Specify time t=t0 when the deflection')	
	t0=input('curve is to be plotted > ? ');
	disp(' ')
	titl=input('Input a graph title > ? ','s');
	
else % Example for triangular initial deflection
	a=1; len=1; tmax=len/a; nt=40;
	xd=[0,.33,.5,.67,1]*len; yd=[0,0,-1,0,0];
	
	% Different example for a truncated sine curve
	% xd=linspace(0,len,351); yd=sin(3*pi/len*xd);
	% k=find(yd<=0); xd=xd(k); yd=yd(k);
	
	x0=0.25*len; t0=0.33*len/a;
	titl='TRANSLATING WAVE OVER HALF A PERIOD';
end

nx=80; x=0:len/nx:len; t=0:tmax/nt:tmax;  

h=max(abs(yd)); xplot=linspace(0,len,201); 
tplot=linspace(0,max(t),251)';

[Y,X,T]=strngwav(xd,yd,x,t,len,a);
plot3(X',T',Y','k'); xlabel('x axis')
ylabel('time'), zlabel('y(x,t)'), title(titl)
if pltsav, print(gcf,'-deps','strngplot3'); end
drawnow, shg, disp(' ')

disp('Press return to see the deflection')
disp(['when t = ',num2str(t0)]), pause

[yt0,xx,tt]=strngwav(xd,yd,xplot,t0,len,a);
close; plot(xx(:),yt0(:),'k')
xlabel('x axis'), ylabel('y(x,t0)')
title(['DEFLECTION WHEN T = ',num2str(t0)])
axis([min(xx),max(xx),-h,h])
if pltsav, print(gcf,'-deps','strngyxt0'); end
drawnow, shg
	
disp(' ')	
disp('Press return to see the deflection history')
disp(['at x = ',num2str(x0)]), pause

yx0=strngwav(xd,yd,x0,tplot,len,a);
plot(tplot,yx0,'k')
xlabel('time'), ylabel('y(x0,t)')
title(...
	['DEFLECTION HISTORY AT X = ',num2str(x0)]) 
axis([0,max(t),-h,h])
if pltsav, print(gcf,'-deps','strngyx0t'); end
drawnow, shg

disp(' ')
disp('Press return to see the animation')
disp('over two periods of motion'), pause
x=linspace(0,len,81); t=linspace(0,4*len/a,121); 
[Y,X,T]=strngwav(xd,yd,x,t,len,a); 
titl='MOTION OVER TWO PERIODS';
animate(X(1,:),Y',titl,.1), pause(2)

if pltsav, print(gcf,'-deps','strnganim'); end

disp(' '), disp('All Done')

%===============================================

function [Y,X,T]=strngwav(xd,yd,x,t,len,a)
%
% [Y,X,T]=strngwav(xd,yd,x,t,len,a)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% xd,yd - data vectors defining the initial 
%         deflection as a piecewise linear
%         function. xd values should be increasing
%         and lie between 0 and len
% x,t   - position and time vectors for which the
%         solution is evaluated
% len,a - string length and wave speed

if nargin<6, a=1; end; if nargin <5, len=1; end
xd=xd(:); yd=yd(:);  p=2*len; 

% If end values are not zero, add these points
if xd(end)~=len, xd=[xd;len]; yd=[yd;0]; end
if xd(1)~=0, xd=[0;xd]; yd=[0;yd]; end
nd=length(xd);

% Extend the data definition for len < x < 2*len
xd=[xd;p-xd(nd-1:-1:1)]; yd=[yd;-yd(nd-1:-1:1)];
[X,T]=meshgrid(x,t); xp=X+a*T; xm=X-a*T;
shape=size(xp); xp=xp(:); xm=xm(:); 

% Compute the general solution for a piecewise
% linear initial deflection
Y=(sign(xp).*interp1(xd,yd,rem(abs(xp),p),...
  'linear','extrap')+sign(xm).*interp1(xd,yd,...
   rem(abs(xm),p),'linear','extrap'))/2;
Y=reshape(Y,shape);

%===============================================

function animate(x,y,titl,tim,trace)
%
% animate(x,y,titl,tim,trace)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function performs animation of a 2D curve
% x,y - arrays with columns containing curve positions
%       for successive times. x can also be a single
%       vector if x values do not change. The animation
%       is done by plotting (x(:,j),y(:,j)) for
%       j=1:size(y,2).
% titl- title for the graph
% tim - the time in seconds between successive plots

if nargin<5, trace=0; else, trace=1; end;
if nargin<4, tim=.05; end
if nargin<3, trac=''; end; [np,nt]=size(y);
if min(size(x))==1, j=ones(1,nt); x=x(:);
else, j=1:nt; end; ax=newplot; 
if trace, XOR='none'; else, XOR='xor'; end
r=[min(x(:)),max(x(:)),min(y(:)),max(y(:))];
%axis('equal') % Needed for an undistorted plot
axis(r), % axis('off')
curve = line('color','k','linestyle','-',...
	'erase',XOR, 'xdata',[],'ydata',[]);
xlabel('x axis'), ylabel('y axis'), title(titl)
for k = 1:nt   
   set(curve,'xdata',x(:,j(k)),'ydata',y(:,k))
   if tim>0, pause(tim), end, drawnow, shg
end