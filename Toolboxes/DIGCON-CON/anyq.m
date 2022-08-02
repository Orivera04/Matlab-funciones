function anyq(A,b,c,d)
%ANYQ	Nyquist plot for analog (continuous-time) system.
%       ANYQ(A,b,c,d) creates a Nyquist plot for the continuous-time
%       system with state-space description (A,b,c,d).  
%       If the system has a pole at s=0, this function will plot
%       the resulting semi-circle of infinite radius (shown as a finite
%       dotted semi-circle.) The program puts an `x' at zero frequency, and
%       an `o' at a higher frequency.  The unstable region is `to the right'
%       of the plot while traversing from `x' to `o'.
%
%       ANYQ(num,den) creates a Nyquist plot for the system with
%       open-loop transfer function num(s)/den(s), where num and
%       den are vectors containing the coefficients of decending
%       powers of s. 
%
%       Once the plot is displayed, the following options are available:
%
%         zoom - use cursor  and click on lower left and upper right
%                points to zoom in on a portion of the plot.
%        point - use cursor to click on any part of the plot.  Magnitude,
%                phase, and frequency of the closest calculated point are shown.
%     original - returns to the original plot
%        cross - shows only points that were actually calculated
%         axes - allows numerical setting of axes to see only a portion of plot.
%  unit circle - draws the unit circle on the current plot.

%     T.Flint 8/92
%     Modified   R.J. Vaccaro 10/93,11/98
%__________________________________________________________________________

if nargin==2
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
d1=-2;
ea=eig(A);
mf=max(imag(ea));
mr=max(-real(ea));
d21=0;d22=0;
if mf>0;d21=ceil(log10(mf));end
if mr>0;d22=ceil(log10(mr));end
d2=max(d21,d22)+2;
npoints=round(d2-d1+1)*80;

% Check for pole at s=0.


if min(abs(eig(A)))<sqrt(eps),
  L2=1;
else
  L2=0;
end
w1=logspace(d1,d2,npoints);
if L2==0,w1=[0 w1];npoints=npoints+1;end
w2=-w1(length(w1):-1:1);
w=[w1 w2];
s=j*w;

ns = length(s);
[t,a] = balance(A);
b = t \ b;
c = c * t;
[p,a] = hess(a);
b = p' * b;
c = c * p;
g = ltifr(a,b,s);
L = c * g + d * ones(1,ns);
L=[L(1:npoints) d L(npoints+1:2*npoints)];
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
  theta=linspace(-pi/2,pi/2,npoints);
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
if length(L2) > 1, plot(L2,'r:') , end;
plot(L(2),'x');
I=find(abs(real(L-ones(size(L))*L(1)))>.1*(xmax-xmin));
  plot(L(min(I)),'o');
grid
title('Analog Nyquist Plot')
xlabel('Real(s) <low freq = x>');
ylabel('Imag(s)');
hold off;

  fprintf('\n Please enter the first letter of your menu choice\n');
  k=input('zoom, point, original, cross, axes, unit circle, quit:  ','s');
  if k=='q',return,end
uflg=0;
while 1

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
  hold off
  grid;
  title('Analog Nyquist Zoom');
  xlabel('Real(s) <low freq = x>');
  ylabel('Imag(s)');
hold on;
I=find(x(1)<real(L)&real(L)<x(2)&y(1)<imag(L)&imag(L)<y(2));
    II=min(I);
      plot(L(II),'x');
     I=find(abs(real(L-ones(size(L))*L(II)))>.1*(x(2)-x(1)));
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

% show entire plot mark w=0 with an "x".
if (k=='o'),
  uflg=0;
  axis('normal');
  axis([xmin xmax ymin ymax]);
  plot(L1,'-');
  axis([xmin xmax ymin ymax]);
  hold on;
  if length(L2) > 1, plot(L2,'r:'), end;
  plot(L(1),'x');
  plot(L(20),'o');
  grid
  title('Analog Nyquist Plot')
  xlabel('Real(s) <low freq = x>');
  ylabel('Imag(s)');
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
  if length(L2)>1, plot(L2,'r:'), end;
  I=find(nax(1)<real(L)&real(L)<nax(2)&nax(3)<imag(L)&imag(L)<nax(4));
    II=min(I);
      plot(L(II),'x');
     I=find(abs(real(L-ones(size(L))*L(II)))>.1*(nax(2)-nax(1)));
     J=find(I>II);
     plot(L(I(min(J))),'o');
  if uflg==1
    plot(temp,'--')
  end
  grid
  title('Analog Nyquist Zoom')
  xlabel('Real(s) <low freq = x>');
  ylabel('Imag(s)');
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
  fprintf('%g, %g  on the s-plane (magnitude, phase (deg.) \n',abs(L(ipt)),...
        angle(L(ipt))*180/pi);
  if(ipt<=length(w)),
    fprintf('at frequency %g\n',w(ipt));
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
  xlabel('Real(s)');
  ylabel('Imag(s)');
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
    
% ___________________ END OF ANYQ.M ___________________________________

