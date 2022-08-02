% CLFEX91b.M  Compute and display the sinx/x function at its
%  maxima for Example 9.1
% Display a table with Heading
format compact
diary clfex91.txt
T=1		% Pulse width
A=1		% Pulse amplitude
f=[0 4.4934 7.7252 10.9041];	% Solutions of x=tan(x)
f=f+eps;		% Avoid divide by zero
fmax=f./(pi*T);	% Maxima of sin(2 pi f T/2)/(2 pi f T/2)
F=A*T*abs(sin(pi*fmax)./(pi*fmax));
sincmax=[fmax' F'];
disp('     Maxima of F(f) ')
disp('   f (hertz)   F(f)')
disp(sincmax)

