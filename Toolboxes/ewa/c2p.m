% c2p.m - complex number to phasor form
% 
% Usage: p = c2p(z)
%
% z = vector of complex numbers
%
% p = [abs(z), angle(z)*180/pi]

% S. J. Orfanidis - 1999 - www.ece.rutgers.edu/~orfanidi/ewa

function p = c2p(z)

if nargin==0, help c2p; return; end

p = [abs(z), angle(z)*180/pi];


