function y=fsresp(num,den,un,t)
%FSRESP Fourier Series Linear System Response. (MM)
% FSRESP(N,D,Un,T) returns the Fourier Series response
% of a linear system when the input is given by a FS, Un.
%
% N and D are the numerator and denominator coefficients
% respectively of the system transfer function.
% Un is the Fourier Series of the system input.
% T is the period associated with the input signal Un.
% If T is not given, T=2*pi is assumed.
%
% See also FSHELP.

% Calls: fssize

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 1/12/95, revised 4/2/96, 8/16/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<4, t=2*pi; end
wo=2*pi/t;
N=fssize(un);
jNwo=sqrt(-1)*(-N:N)*wo;
y=(polyval(num,jNwo)./polyval(den,jNwo)).*un;
