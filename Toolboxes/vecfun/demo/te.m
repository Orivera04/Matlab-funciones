function [H,E,fc]=TE(H_0,m,n,a,b,l,mu,epsilon,f)
%TE  Transverse Electric modes vector generator.
%
%   [H]      = TE(H0,m,n,a,b,l,mu,epsilon,f)
%   [H,E]    = TE(-"-)
%   [H,E,fc] = TE(-"-)
%
%   H0 : the magnitude of the magnetic field,
%   m, n : the modes for the TE-wave in x and y direction respectively,
%   a, b, l : the waveguide dimensions in x, y and z directions respectively,
%   mu, epsilon : dielectric constants for the medium inside the waveguide,
%   f : specific frequency of the traveling waves inside the waveguide.

x=scalar('x');y=scalar('y');z=scalar('z');
A=scalar(m*pi/a);
B=scalar(n*pi/b);
omega=scalar(2*pi*f);
h=sqrt(A^2+B^2);
k=omega*sqrt(mu*epsilon);
gamma=sqrt(h^2-k^2);
Hz=H_0*cos(A*x)*cos(B*y)*exp(-(gamma*z));
H=[-real(gamma/h^2*pdiff(Hz,'x')) -real(gamma/h^2*pdiff(Hz,'y')) real(expand(Hz))];
H=setrange(H,[0 a],[0 b],[0 l]);
if nargout>1
   E=[-real(j*omega*mu/h^2*pdiff(Hz,'y')) real(j*omega*mu/h^2*pdiff(Hz,'x')) 0];
   E=setrange(E,[0 a],[0 b],[0 l]);
end
if nargout>2
   fc=h/(2*pi*sqrt(mu*epsilon));
   fc=fc(0,0,0);
end
