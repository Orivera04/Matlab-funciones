function nyq(A,b,c,d,npts)
%NYQ	Nyquist plot for a discrete-time system.	
%	NYQ(A,b,c,d,npts) creates a Nyquist plot for the discrete-time, 
%	single-input, single-output system with state-space description 
%	(A,b,c,d).  The plot is evaluated at npts points space logarithmically
%	around the unit circle.  If npts is omitted, it is set to 100.
%	If the system has a pole at z=1, this function will plot 
%	the resulting semi-circle of infinite radius (shown as a finite 
%	dotted semi-circle.) The program puts an `x' at zero frequency, and
%	an `o' at a higher frequency.  The unstable region is `to the right'
%	of the plot while traversing from `x' to `o'.
%
%	NYQ(num,den,npts) creates a Nyquist plot for the system with 
%	open-loop transfer function num(z)/den(z), where num and 
%	den are vectors containing the coefficients of decending 
%	powers of z.  If npts is omitted, it is set to 100.
%
%	Once the plot is displayed, the following options are available:
%
%	  zoom - use cursor  and click on lower left and upper right
%	         points to zoom in on a portion of the plot.
%	 point - use cursor to click on any part of the plot.  Magnitude,
%	         phase, and frequency of the closest calculated point are shown.
%     original - returns to the original plot
%	 cross - shows only points that were actually calculated
%	  axes - allows numerical setting of axes to see only a portion of plot.
%  unit circle - draws the unit circle on the current plot.

%     T.Flint 8/92
%     Modified   R.J. Vaccaro 10/93,11/98
%__________________________________________________________________________

clf
if nargin==4 | nargin==2
  npoints=100;
end
if nargin==5, npoints=npts; end
if  nargin==3, npoints=c; end

if nargin<4,
  N=length(b);M=length(A);
  if M > N
     error('Denominator must be higher or equal order than numerator.')
  end
  A=[zeros(1,N-M) A];
  d=A(1);
  den=b;
  b=(A(2:N)-A(1)*b(2:N))';
  c=[1 zeros(1,N-2)];
  A=[-den(2:N)' eye(N-1,N-2)];
end

% Check for pole at z=1.

if min(abs(eig(A)-1))<sqrt(eps),
  w1=logspace(-2,pi,npoints);
  w2=2*pi-logspace(.4971,-2,npoints);
  w=[w1 w2];
  z=exp(j*w);
  L2=1;
else
  w1=logspace(-3,pi,npoints);
  w2=2*pi-logspace(.4971,-3,npoints);
  w=[w1 w2];
  z=exp(j*w);
  L2=0;
end
nz = length(z);
[t,a] = balance(A);
b = t \ b;
c = c * t;
[p,a] = hess(a);
b = p' * b;
c = c * p;
g = ltifr(a,b,z);
L = c * g + d * ones(1,nz);

xmax=max(real(L));
xmin=min(real(L));
temp=0.1*(xmax-xmin);
xmin=xmin-temp;
xmax=xmax+temp;
ymax=1.1*max(abs(imag(L)));
ymin=-ymax;
x=[xmin;xmax];
y=[ymin;ymax];

if L2==1,
  theta=linspace(-pi/2,pi/2,100);
  alpha=(xmax-real(L(1)));
  beta=abs(imag(L(1)));
  L2=alpha*real(exp(j*theta))+j*beta*imag(exp(j*theta))+real(L(1));
  L1=L;
else,
  L2=0;
  L1=L;
end

% show entire plot mark w=0 with an "x".
hold off
axis([xmin xmax ymin ymax]);
plot(L1,'-');
axis([xmin xmax ymin ymax]);
hold on;
if length(L2) > 1, plot(L2,'r:'), end;
plot(L(1),'x');
I=find(abs(real(L-ones(1,length(L))*L(1)))>.1*(xmax-xmin));
plot(L(min(I)),'o');
grid
title('Discrete Nyquist Plot')
xlabel('Real(z) <low freq = x>');
ylabel('Imag(z)');
hold off;
  fprintf('\n Please enter the first letter of your menu choice\n');
  k=input('zoom, point, original, cross, axes, unit circle, quit:  ','s');
if k=='q',return,end
uflg=0;
while(k=='z'|k=='p'|k=='o'|k=='c'|k=='a'|k=='u'),

% zoom on area defined with mouse.
if (k=='z'),
  uflg=0;
  [x,y]=ginput(2);
  x=sort(x);
  y=sort(y);
  clf;
  hold off;
  axis([x' y']);
  plot(L1,'-');
  axis([x' y']);
  hold on;
  if length(L2) > 1, plot(L2,'r:'), end;
  grid;
  title('Discrete Nyquist Zoom');
  xlabel('Real(z) <low freq = x>');
  ylabel('Imag(z)');
I=find(x(1)<real(L)&real(L)<x(2)&y(1)<imag(L)&imag(L)<y(2));
    II=min(I);
      plot(L(II),'x');
     I=find(abs(real(L-ones(1,length(L))*L(II)))>.1*(x(2)-x(1)));
     J=find(I>II);
     plot(L(I(min(J))),'o');
  hold off;
  fprintf('\n Please enter the first letter of your menu choice\n');
  k=input('zoom, point, original, cross, axes, unit circle, quit:  ','s');
if k=='q',return,end
end

% add unit circle to current plot. 
if k=='u',
  uflg=1;
  hold on;
  theta=linspace(0,2*pi,100);
  temp=exp(j*theta);
  plot(temp,'--')
  hold off;
  fprintf('\n Please enter the first letter of your menu choice\n');
  k=input('zoom, point, original, cross, axes, unit circle, quit:  ','s');
if k=='q',return,end
end

% show entire plot mark w=0 with an "x" and L(20) with a "o".
if (k=='o'),
  uflg=0;
  axis('normal');
  axis([xmin xmax ymin ymax]);
  plot(L1,'-');
  axis([xmin xmax ymin ymax]);
  hold on;
  if length(L2) > 1, plot(L2,'r:'), end;
  plot(L(1),'x');
  I=find(abs(real(L-ones(1,length(L))*L(1)))>.1*(xmax-xmin));
  plot(L(min(I)),'o');
  grid
  title('Discrete Nyquist Plot')
  xlabel('Real(z) <low freq = x>');
  ylabel('Imag(z)');
  hold off;
  fprintf('\n Please enter the first letter of your menu choice\n');
  k=input('zoom, point, original, cross, axes, unit circle, quit:  ','s');
  if k=='q',return,end
end

% show plot with new axes; mark w=0 with an "x".
if (k=='a'),
  nax=input('Enter new axes in the form "[xmin xmax ymin ymax]"  ');
  if(nax(2)-nax(1)==nax(4)-nax(3)), axis('square'); end
  axis(nax);
  plot(L1,'-');
  axis(nax);
  hold on;
  if length(L2) > 1, plot(L2,'r:'), end;
    I=find(nax(1)<real(L)&real(L)<nax(2)&nax(3)<imag(L)&imag(L)<nax(4));
    II=min(I);
      plot(L(II),'x');
     I=find(abs(real(L-ones(1,length(L))*L(II)))>.1*(nax(2)-nax(1)));
     J=find(I>II);
     plot(L(I(min(J))),'o');
  if uflg==1
    plot(temp,'--')
  end
  grid
  title('Discrete Nyquist Zoom')
  xlabel('Real(z) <low freq = x>');
  ylabel('Imag(z)');
  hold off;
  fprintf('\n Please enter the first letter of your menu choice\n');
  k=input('zoom, point, original, cross, axes, unit circle, quit:  ','s');
  if k=='q',return,end
end

% get location of a point on the current plot.
if (k=='p'),
  [px,py]=ginput(1);
  pt=px+j*py;
  [delta,ipt]=min(abs(L-pt));
  fprintf('\nClosest Point is L(%g)\n',ipt);
  fprintf('%g, %g  on the z-plane (magnitude, phase (deg.) \n',abs(L(ipt)),...
        angle(L(ipt))*180/pi);
  if(ipt<=length(w)),
    fprintf('at discrete frequency %g\n',w(ipt));
  else,
    fprintf('on the semi-circle of infinite radius\n');
  end
  fprintf('\n Please enter the first letter of your menu choice\n');
  k=input('zoom, point, original, cross, axes, unit circle, quit:  ','s');
  if k=='q',return,end
end

% replot using crosses to mark actual data points.
if (k=='c'),
  temp=axis;
  axis(temp);
  plot(L,'+');
  axis(temp);
  grid
  title('Points Actually Evaluated');
  xlabel('Real(z)');
  ylabel('Imag(z)');
  hold off;
  fprintf('\n Please enter the first letter of your menu choice\n');
  k=input('zoom, point, original, cross, axes, unit circle, quit:  ','s');
  if k=='q',return,end
end

if k~='z' & k~='p' & k~='o' & k~='c' & k~='a' & k~='u'
    fprintf('\n PLEASE enter the first letter of your menu choice\n');  
  k=input('zoom, point, original, cross, axes, unit circle, quit:  ','s');
  if k=='q',return,end
 end 


end	% end while loop.

axis('normal');
return;
    
% ___________________ END OF NYQ.M ___________________________________

