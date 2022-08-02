% multidiel2.m - reflection response of lossy isotropic multilayer dielectric structures
%
%          na | n1 | n2 | ... | nM | nb
% left medium | l1 | l2 | ... | lM | right medium 
%   interface 1    2    3     M   M+1
%
% Usage: [Gamma,Z] = multidiel2(n,l,f,theta,pol)
%        [Gamma,Z] = multidiel2(n,l,f,theta)       (equivalent to pol='te')
%        [Gamma,Z] = multidiel2(n,l,f)             (equivalent to theta=0)
%
% f     = N-dimensional vector of frequencies in units of f0, f = [f(1), f(2),..., f(N)]
% n     = Nx(M+2) matrix of complex refractive indices,  
%         i-th row represents the refractive indices at the i-th frequency f(i), 
%         that is, n(i,:) =  [na(i),n1(i),n2(i),...,nM(i),nb(i)]
% l     = M-dimensional vector of physical lengths of layers in units of la0, l = [l(1),...,l(M)]
% theta = incidence angle from left medium (in degrees)
% pol   = 'tm' or 'te', for parallel/perpendicular polarizations
%
% Gamma = reflection response (at interface 1) evaluated at the N frequencies
% Z     = input impedance at interface-1 in units of eta_a (left medium)
%
% notes: M is the number of layers (must be >=0)
%        it assumes isotropic layers
%
%        f is in units of some f0, i.e. f/f0
%        physical (not optical) layer thicknesses are in units of la0=c0/f0, i.e., l/la0

% S. J. Orfanidis - 2003 - www.ece.rutgers.edu/~orfanidi/ewa

function [Gamma,Z] = multidiel2(n,l,f,theta,pol)

if nargin==0, help multidiel2; return; end
if nargin<=4, pol='te'; end
if nargin==3, theta=0; end

M = size(n,2)-2;                                    % number of layers
theta = theta * pi/180;

for i=1:length(f),                                  % frequency loop
   nf = n(i,:);                                     % complex refractive indices at i-th frequency   

   costh = sqrt(1 - (nf(1)*sin(theta)./nf).^2);     % nf(1) is na

   if pol=='te' | pol=='TE',
      nT = nf .* costh;                             % transverse refractive indices
   else
      nT = nf ./ costh;                             % TM case, bombs at 90 deg for left medium
   end

   r = -diff(nT) ./ (diff(nT) + 2*nT(1:M+1));       % transverse reflection coefficients

   Gamma1 = r(M+1);                                 % initialize Gamma at right-most interface

   for m = M:-1:1,
      delta = 2*pi*f(i)*l(m) * sqrt(nf(m)^2 - nf(1)^2*sin(th)^2);    % phase thickness in m-th layer
      z = exp(-2*j*delta);                                        
      Gamma1 = (r(m) + Gamma1.*z) ./ (1 + r(m)*Gamma1.*z);           % backward recursion
   end

   Gamma(i) = Gamma1;                               % reflection response at i-th frequency    
   Z(i) = (1 + Gamma1) ./ (1 - Gamma1);
end  






