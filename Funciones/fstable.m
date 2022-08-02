function kn=fstable(f,n,p1,p2)
%FSTABLE Fourier Series Table. (MM)
% FSTABLE(FUN,N,P1,P2) returns a Fourier Series vector of
% the function FUN having N positive harmonics and OPTIONAL
% parameters P1 and P2.
% The zero-to-peak value of the function is 1.
%
%   FUN        Description
% 'square'    square wave, odd symmetry, zero mean,
%             P1='smooth' windows the result to minimize Gibb's.
% 'trap'      trapezoidal wave, odd symmetry, zero mean,
%             P1=fractional duty cycle, i.e., 0 < P1 < 1, default=2/3.
% 'sawtooth'  sawtooth, positive slope, odd symmetry, zero mean,
%             P1='smooth' windows the result to minimize Gibb's, or
%             P1=fractional fall time, i.e., 0 < P1 < 0.5.
% 'rsawtooth' reversed sawtooth, same as 'sawtooth' but negative slope
%             P1='smooth' windows the result to minimize Gibb's, or
%             P1=fractional fall time, i.e., 0 < P1 < 0.5.
% 'triangle'  triangle, even symmetry, zero mean.
% 'pulse'     pulse train, positive valued, even symmetry
%             P1=fractional duty cycle, i.e., 0 < P1 < 1, default=1/2,
%             P2='smooth' windows the result to minimize Gibb's or
%             for finite rise and fall times, P2=fractional rise time,
%             i.e., 0 < P2 < (1-P1)/2. Pulse is high P1 of the period.
% 'bipolar'   bipolar pulse train, odd symmetry, zero mean,
%             P1=fractional duty cycle, i.e., 0 < P1 < 1, default=2/3,
%             P2='smooth' windows the result to minimize Gibb's or
%             for finite rise and fall times, P2=fractional rise time,
%             i.e., 0 < P2 < (1-P1)/4.
% 'full'      full wave rectified sine wave, period is two humps
% 'half'      half wave rectified sine wave.
% 'sine'      sine wave, P1 = harmonic number, default=1.
% 'cosine'    cosine wave, P1 = harmonic number, default=1.
% 'dc'        constant or dc value equal to 1.
%
% If N is an integer it is the number of desired positive harmonics.
% If N is a Fourier Series vector, the returned vector will have
% the same number of harmonics as N.
%
% If requested, smoothing is accomplished by windowing with an
% exact Blackman window, i.e., Kn.*MMWINDOW('BLX',Kn)
%
% See also FSHELP, MMWINDOW.

% Calls: fssize, fsformat, mmwindow, fsfind

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 4/11/96, 5/28/96, v5: 1/14/97, 4/19/98, 10/26/99, 4/19/01
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

dosm=logical(0);
if length(n)==1,N=n;
else,           N=fssize(n);
end
if nargin==3, p2=[]; end
if nargin>2
   if ischar(p1)
      dosm=lower(p1(1))=='s';
      p=[];
   else
      p=p1;
      dosm=logical(0);
      if ischar(p2)
         dosm=lower(p2(1))=='s';
         p2=[];
      end
   end
else
   p1=[];
   p=[];
end
lkn=2*N+1;
kn=zeros(1,lkn);
f=lower(f(isletter(f)));
if strncmp(f,'sq',2)                        % squarewave
   kn(N+2:2:lkn)=-2j*(((1:2:N)*pi).^(-1));
   kn(1:N)=conj(kn(lkn:-1:N+2));
   if dosm, kn=kn.*mmwindow('blx',kn); end
elseif strncmp(f,'sa',2)                    % sawtooth
   if isempty(p)  % ideal sawtooth
      kn(N+2:lkn)=2j*(((1:N)*2*pi).^(-1));
      kn(1:N)=conj(kn(lkn:-1:N+2));
      if dosm, kn=kn.*mmwindow('blx',kn); end
   else  % finite fall time sawtooth
      a=min(.4999,p1);
      if a~=p1
         warning('Specified Fall Time Too Long.')
      end
      t=[0 a .5 1-a 1];
      f=[0 -1 0  1  0];
      kn=fsfind(t,f,N,max(N,64));
   end   
elseif strncmp(f,'rs',2)                    % reversed sawtooth
   kn=fstable('saw',n,p1);
   kn=kn(end:-1:1);
elseif strncmp(f,'tri',3)                   % triangle
   kn(N+2:2:lkn)=4*(((1:2:N)*pi).^(-2));
   kn(1:N)=conj(kn(lkn:-1:N+2));
elseif strncmp(f,'p',1)                     % pulsetrain
   if isempty(p), p=1/2; end
   p=min(abs(p),.999);
   if isempty(p2)|(p2==0) % ideal zero rise time pulse
      kn(N+1)=p;
      arg=pi*p*(1:N);
      kn(N+2:lkn)=p*sin(arg)./(arg+eps);
      kn(1:N)=conj(kn(lkn:-1:N+2));
      if dosm, kn=kn.*mmwindow('blx',kn); end
   else           % finite rise time pulse
      r=min((1-p)/2-10*eps,abs(p2));
      if r~=p2
         warning('Specified Rise Time Too Long.')
      end
      a=p/2;
      t=[0 a a+r 0.5 1-a-r 1-a 1];
      f=[1 1  0   0    0    1  1];
      kn=fsfind(t,f,N,max(N,64));
   end      
elseif strncmp(f,'tra',3)                   % trapezoid
   if isempty(p), p=2/3; end
   p=min(abs(p),.999);
   a=(1-p)/2; b=1-a;
   npi=(1:2:N)*pi;
   jnpia=j*a*npi;
   jnpib=j*b*npi;
   kn(N+2:2:lkn)=(( (1+j*a*npi).*exp(-jnpia)...
      - (1+jnpib).*exp(jnpia)...
      + j*npi).*(npi.^(-2))./a...
      + ( (1/a-1)*exp(jnpia)...
      - exp(-jnpia) -1/a)*j./npi);
   kn(1:N)=conj(kn(lkn:-1:N+2));
elseif strncmp(f,'b',1)                     % bipolar pulsetrain
   if isempty(p), p=2/3; end
   p=min(abs(p),.999);
   if isempty(p2)|(p2==0) % ideal zero rise time pulsetrain
      a=(1-p)/2; b=1-a;
      jnpi=(1:2:N)*pi*j;
      kn(N+2:2:lkn)=(exp(-jnpi*b)-exp(-jnpi*a))./(-jnpi);
      kn(1:N)=conj(kn(lkn:-1:N+2));
      if dosm, kn=kn.*mmwindow('blx',kn); end
   else           % finite rise time pulse
      r=min((1-p)/4-10*eps,abs(p2));
      if r~=p2
         warning('Specified Rise Time Too Long.')
      end
      a=p/4;
      b=.25; c=.75;
      t=[0 b-a-r b-a b+a b+a+r 0.5 c-a-r c-a c+a c+a+r 1];
      f=[0   0    1   1    0    0    0    -1  -1   0   0];
      kn=fsfind(t,f,N,max(N,64));
   end      
elseif strncmp(f,'h',1)                     % half wave rectified sine
   kn(N+1)=1/pi;
   kn(N+2)=-j/4;
   n=2:2:N;
   kn(N+3:2:lkn)=1./(pi*(1-n.^2));
   kn(1:N)=conj(kn(lkn:-1:N+2));
elseif strncmp(f,'f',1)                     % full wave rectified sine
   kn(N+1)=2/pi;
   n=2:2:N;    
   kn(N+3:2:lkn)=2./(pi*(1-n.^2));
   kn(1:N)=conj(kn(lkn:-1:N+2));
elseif strncmp(f,'si',2)                    % sine wave
   if isempty(p), p=1; end
   p=round(abs(p(1)));
   if p<1 | p>N
      error('0 < D <= N Required.')
   end
   s=zeros(1,N);
   s(p)=1;
   kn=fsformat(zeros(1,N),s,0);
elseif strncmp(f,'c',1)                     % cosine wave
   if isempty(p), p=1; end
   p=round(abs(p(1)));
   if p<1 | p>N
      error('0 < D <= N Required.')
   end
   s=zeros(1,N);
   s(p)=1;
   kn=fsformat(s,zeros(1,N),0);              % dc value
elseif strncmp(f,'dc',2)
   kn(N+1)=1;
else
   error('Unknown Function Requested')
end
