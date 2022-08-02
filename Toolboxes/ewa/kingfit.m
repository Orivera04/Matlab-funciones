% kingfit.m - fits a sampled current to King's 2-term sinusoidal approximation
%
% Usage: A = kingfit(L,I,z,terms)
%        A = kingfit(L,I,z)       (equivalent to terms=2)
%
% L     = antenna length in wavelengths
% I     = length-(2M+1) vector of current samples, I = [I(-M),...,I(0),...,I(M)]
% z     = length-(2M+1) vector of sampled z-points at which I is measured
% terms = 2,3 number of terms in King's approximation (default is 2)
%
% A   = coefficients of the sinusoidal terms, A = [A1,A2] or [A1,A2,A3]  
%
% notes: I = [I(-M),...,I(0),...,I(M)] is the solution of the discretized Hallen equation
%        at the equally-spaced  points along the antenna: z(m)=m*Dz, m=-M:M, and is obtained
%        by [I,z,cnd] = hallen(L,a,M). HALLEN2, HALLEN3, and HALLEN4 an also be used.
%
%        the samples I(m) are fitted by a least-squares fit to King's 2-term or 3-term 
%        sinusoidal approximation, that is, with A = [A1,A2,A3] and h=L/2:
%
%        I(z) = A1*sin(k(h-z)) + A2*(cos(kz)-cos(kh)) + A3*(cos(kz/2)-cos(kh/2)), or,
%        I(z) = A1*(sin(kz)-sin(kh)) + A2*(cos(kz)-cos(kh)) + A3*(cos(kz/2)-cos(kh/2))
%
%        the second expression is used if L is an odd-multiple of lambda/2
%    
%        the input impedance is Zin = 1/I(z=0), assuming unity gap input voltage V0 = 1
%
%        see also KINGEVAL for evaluating I(z) at any vector of z's

% S. J. Orfanidis - 1999 - www.ece.rutgers.edu/~orfanidi/ewa

function A = kingfit(L,I,z,terms)

if nargin==0, help kingfit; return; end
if nargin==3, terms=2; end

I = I(:);
z = z(:);

eta = etac(1);                          % eta = 376.7303, approximately eta=120*pi
k = 2*pi;                               % k = 2*pi/lambda, (lambda=1 in units of lambda)

h = L/2;                                % antenna half-length

if rem(2*L,2)==1,                       % L is an odd-multiple of half-wavelength        
  S =  [sin(k*abs(z))-sin(k*h), cos(k*z)-cos(k*h)];
else
  S =  [sin(k*(h-abs(z))), cos(k*z)-cos(k*h)];
end

if terms==3,                            
  S =  [S, cos(k*z/2)-cos(k*h/2)];      % append third column
end

A = S\I;                                % least-squares min-norm solution of S*A=I


