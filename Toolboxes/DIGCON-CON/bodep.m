function bodep(A,b,c,d,T)
%BODEP	Bode plot for discrete-time system.
%	BODEP(A,b,c,d,T) creates a Bode plot of a discrete-time system with 
%	state-space description (A,b,c,d) and sampling period T.  
%
%	BODEP(num,den,T) creates a Bode plot of a system with transfer 
%	function H(z)=num(z)/den(z) and sampling period T, where num and 
%	den are row vectors containing the polynomial coefficients in 
%	descending powers of z. The first coefficient in den must be unity. 
%	For example, if num=[b0 b1  ... bn] and den=[1 a1 a2 ... an], then
%	H(z) = (b0z^n  + b1z^(n-1) + ... + bn)/(z^n + a1z^(n-1) + ... + an).
%	Any zero-valued leading numerator coefficients can be omitted from num.
%	The transfer function is evaluated at 300 points spaced logarithmically
%	around the unit circle from e^j*0.01 to e^j*pi.  The frequency axis is 
%	in radians per second; magnitude is plotted in dB, and phase is plotted 
%	in degrees.

%     T.Flint 8/92
%     Modified   R.J. Vaccaro 1/94, 2/95,11/98
%______________________________________________________________________________
npoints=300;
if nargin==3,
  T=c;
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
  w=logspace(-4,pi,npoints);

z=exp(j*w);

% Evaluate L(z) over the frequencies in z vector.

nz = length(z);
[t,a] = balance(A);
b = t \ b;
c = c * t;
[p,a] = hess(a); 
b = p' * b;
c = c * p;
[n,m]=size(b);
  g = ltifr(a,b,z);
for k=1:nz
  L(k)=(c*g(:,k)+d);
end
%
M=8.6858*log(abs(L));           % Magnitude in db.
P=57.2958*unwrap(angle(L));     % Phase in deg.
% show magnitude and phase plots separate windows.
k1='b';
clf
hold off
subplot(211);
semilogx(w/T,M,'-');
grid
title('Magnitude Response');
xlabel('Frequency (rad/sec)');
ylabel('db');
subplot(212)
semilogx(w/T,P,'-');
title('Phase Response')
xlabel('Frequency (rad/sec)');
ylabel('deg');
grid;
subplot(111);
fprintf('\nmagnitude, phase, both, axes, or quit?')
k=input('(Enter first letter to choose a plot or quit) ','s');
if k=='q',return,end

while(k=='m'|k=='p'|k=='b'|k=='a'),

% show magnitude and phase.
if (k=='b'),
  k1='b';
  
  clf
  hold off
  subplot(211);
  semilogx(w/T,M,'-');
  grid
  title('Magnitude Response');
  xlabel('Frequency (rad/sec)');
  ylabel('db');
  subplot(212)
  semilogx(w/T,P,'-');
  title('Phase Response')
  xlabel('Frequency (rad/sec)');
  ylabel('deg');
  grid;
  subplot(111);
fprintf('\nmagnitude, phase, both, axes, or quit?')
k=input('(Enter first letter to choose a plot or quit) ','s');
if k=='q',return,end
end

% show magnitude only.
if (k=='m'),
  k1='m';
  clf
  hold off
  subplot(111);
  semilogx(w/T,M,'-');
  grid
  title('Magnitude Response');
  xlabel('Frequency (rad/sec)');
  ylabel('db');
fprintf('\nmagnitude, phase, both, axes, or quit?')
k=input('(Enter first letter to choose a plot or quit) ','s');
if k=='q',return,end
end

% show phase only.
if (k=='p'),
  k1='p';
  clf
  hold off
  subplot(111);
  semilogx(w/T,P,'-');
  title('Phase Response')
  xlabel('Frequency (rad/sec)');
  ylabel('deg');
  grid;
fprintf('\nmagnitude, phase, both, axes, or quit?')
k=input('(Enter first letter to choose a plot or quit) ','s');
if k=='q',return,end
end

if k=='a'
   if k1~='m' & k1~='p'
      fprintf('\nChoose either mag or phase plot before changing frequency axis')
      fprintf('\n\nmagnitude, phase, or quit?')
      k=input('(Enter first letter to choose plot or quit) ','s');
      if k=='q',return,end   
   else
      nax=input('Enter new frequency axis in the form "[min_freq max_freq]"  ');
      k='x';
      v=axis;
      nax=[nax v(3:4)];
      axis(nax);
   end
end

if k~='m' & k~= 'p' & k~='b' & k~='a'
   fprintf('\nmagnitude, phase, both, axes, or quit?')
k=input('(Please enter first letter to choose a plot or quit) ','s');
if k=='q',return,end
end

end     % end while loop.
return

%_____________________ END OF BODEP.M _________________________
