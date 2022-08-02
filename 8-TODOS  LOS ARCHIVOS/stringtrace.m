function [Y,X,T]=stringtrace(xd,yd,tmax,nt,len,a)
if nargin==0
  xd=[0,.33,.5,.67,1]; yd=[0,0,-1,0,0];
  len=1; a=1; tmax=len/a/4; nt=5;
  t=0:tmax/nt:tmax; x=0:len/100:len; 
end
%[Y,X,T]=strngwav(xd,yd,x,t,len,a);
[Y,X,T]=strngwav(xd,yd,x,t); plot3(X',T',Y','k'); 
h=max(abs(Y(:))); axis([0,len,0,tmax,-h,h]);
axis off; colormap([1,1,1]); view([0,0]); shg

%===============================================

function [Y,X,T]=strngwav(xd,yd,x,t,len,a)
% [Y,X,T]=strngwav(xd,yd,x,t,len,a)
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
Y=(sign(xp).*interp1(xd,yd,rem(abs(xp),p))...
   +sign(xm).*interp1(xd,yd,rem(abs(xm),p)))/2;
Y=reshape(Y,shape);

%===============================================

function animate(x,y,titl,tim,trace)
% animsmpl(x,y,titl,tim,trace)
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