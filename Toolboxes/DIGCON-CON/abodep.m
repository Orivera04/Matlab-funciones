function abodep(A,b,c,d,F)
% ABODEP Analog (continuous-time) Bode plot.
%	ABODEP(A,b,c,d,F) creates a Bode plot for an analog (continuous-
%	time) system with state-space description (A,b,c,d).  
%	F is a 2-element vector which specifies the frequency axis.
%	The frequency axis is 10^F(1) to 10^F(2) rad/sec.
%	If F is omitted, the default frequency axis is 0.1 to 100 rad/sec.
%
%	ABODEP(num,den,F) creates a Bode plot of a system with transfer 
%	function H(s)=num(s)/den(s), where num and den contain the polynomial 
%	coefficients in descending powers of s. The first coefficient in den
%	must be unity.  For example, if num=[b0 b1  ... bn] and
%	den=[1 a1 a2 ... an], then 
%       H(s) = (b0s^n  + b1s^(n-1) + ... + bn)/(s^n + a1s^(n-1) + ... + an). 
%       Any zero-valued leading numerator coefficients can be omitted from num.
%	If F is omitted, the default frequency axis is 0.1 to 100 rad/sec.

%     T.Flint 8/92
%     Modified   R.J. Vaccaro 1/94,2/95,11/98
%______________________________________________________________________________

if nargin==4,
  d1=-1;
  d2=2;
end
if nargin==5
  d1=F(1);d2=F(2);
end
if nargin==3 | nargin==2
  if nargin==3
    d1=c(1);d2=c(2);
  else
    d1=-1;d2=2;
  end
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
  npoints=round((d2-d1)*400);
  w=logspace(d1,d2,npoints);
z=j*w;

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
clf
hold off
subplot(211);
semilogx(w,M,'-');
grid
title('Magnitude Response');
xlabel('Frequency (rad/sec)');
ylabel('db');
subplot(212)
semilogx(w,P,'-');
title('Phase Response')
xlabel('Frequency (rad/sec)');
ylabel('deg');
grid;
fprintf('\nmagnitude, phase, both, or quit?')
k=input('(Enter first letter to choose a plot or quit) ','s');
if k=='q',return,end

while(k=='m'|k=='p'|k=='b'),

% show magnitude and phase.
if (k=='b'),
  clf
  hold off
  subplot(211);
  semilogx(w,M,'-');
  grid
  title('Magnitude Response');
  xlabel('Frequency (rad/sec)');
  ylabel('db');
  subplot(212)
  semilogx(w,P,'-');
  title('Phase Response')
  xlabel('Frequency (rad/sec)');
  ylabel('deg');
  grid;
fprintf('\nmagnitude, phase, both, or quit?')
k=input('(Enter first letter to choose a plot or quit) ','s');
if k=='q',return,end
end

% show magnitude only.
if (k=='m'),
  clf
  hold off
  subplot(111);
  semilogx(w,M,'-');
  grid
  title('Magnitude Response');
  xlabel('Frequency (rad/sec)');
  ylabel('db');
fprintf('\nmagnitude, phase, both, or quit?')
k=input('(Enter first letter to choose a plot or quit) ','s');
if k=='q',return,end
end

% show phase only.
if (k=='p'),
  clf
  hold off
  subplot(111);
  semilogx(w,P,'-');
  title('Phase Response')
  xlabel('Frequency (rad/sec)');
  ylabel('deg');
  grid;
fprintf('\nmagnitude, phase, both, or quit?')
k=input('(Enter first letter to choose a plot or quit) ','s');
if k=='q',return,end
end

if k~='m' & k~= 'p' & k~='b' 
   fprintf('\nmagnitude, phase, both, axes, or quit?')
k=input('(Please enter first letter to choose a plot or quit) ','s');
if k=='q',return,end
end

end     % end while loop.
return

%_______________________ END OF ABODEP.M _______________________________
