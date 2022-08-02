% imped.m - mutual impedance between two parallel standing-wave dipoles
%
% Usage: [Z21,Z21m] = imped(L2,L1,d,b)  (mutual impedance of dipole 2 due to dipole 1)
%        [Z21,Z21m] = imped(L2,L1,d)    (equivalent to b=0, side-by-side arrangement)
%            [Z,Zm] = imped(L,a)        (self-impedance of length-L dipole of radius a)
%                                                                                                                    
% L2,L1 = lengths of dipoles (in wavelengths)                         
% d     = side-by-side distance between dipoles (in wavelengths)               
% b     = collinear offset between dipole centers (default, b=0)    
% L     = length of dipole (in wavelengths) 
% a     = radius of dipole (in wavelengths)            
%
% Z21 = mutual impedance of dipole 2 due to dipole 1 referred to the input currents
% Z21m = mutual impedance of dipole 2 due to dipole 1 referred to maximum currents
%
% notes: the relationship between Z21 and Z21m is Z21m = Z21 * sin(pi*L1) * sin(pi*L2)
%        Z21 is infinite if L1,L2 are integral multiples of lambda
%
%        b=0, side-by-side arrangement
%        d=0, collinear arrangement, if s = distance between dipoles, then b=s+L1/2+L2/2
%
%        uses Gauss-Legendre QUADR to perform the numerical integrations; for improved
%        accuracy around z=0, the interval [-L2/2,L2/2] is split into the subintervals
%        [-L2/2,-delta], [-delta,delta], [delta,L2/2], where delta = L2/500
%
%        self-impedance of a single dipole of length L and radius a (in wavelengths) is
%        Z = imped(L,a); self-impedance calculations are accurate for a > 0.0005 
%        for a half-wave dipole with a=0, we have Z = imped(0.5,0) = 73.079 + 42.515j
%        1st resonant length with a=0: L = 0.48574823,  Z =  67.184
%        2nd resonant length with a=0: L = 1.48338445,  Z = 100.314

% S. J. Orfanidis - 1999 - www.ece.rutgers.edu/~orfanidi/ewa

function [Z21,Z21m] = imped(L2,L1,d,b)

if nargin==0, help imped; return; end
if nargin==3, b=0; end
if nargin==2, b=0; d=L1; L1=L2; end         

eta = etac(1);                              % eta = 376.7303 ohm

delta = L2/500;                             % refined integration near z=0

N = 16;                                     % number of quadrature weights

[w1,z1] = quadr(-L2/2, -delta, N);          % integration interval [-L2/2, -delta]
[w2,z2] = quadr(-delta, delta, N);          % integration interval [-delta, delta]
z3 = -flipud(z1);                           % integration interval [delta, L2/2]

F1 = F(z1, L2, L1, d, b);                   % evaluate integrand at Gauss-Legendre points              
F2 = F(z2, L2, L1, d, b);
F3 = F(z3, L2, L1, d, b);                   
                                            % sum integrals over the three subintervals
Int = w1'*F1 + w2'*F2 + w1'*F3;             % note w3 = w1 by symmetry

Z21m = j * eta * Int / (4*pi);   
Z21 = Z21m / (sin(pi*L1) * sin(pi*L2));   


% function to be integrated ------------------------------------------------------

function y = F(z, L2, L1, d, b)

k = 2*pi;

R1 = sqrt(d^2 + (z + b - L1/2).^2);    
R2 = sqrt(d^2 + (z + b + L1/2).^2);    
R0 = sqrt(d^2 + (z + b).^2);  

G1 = exp(-j*k*R1)./R1;  
G2 = exp(-j*k*R2)./R2;       
G0 = exp(-j*k*R0)./R0;

y = (G1 + G2 - 2*cos(k*L1/2) * G0) .* sin(k*(L2/2-abs(z)));








