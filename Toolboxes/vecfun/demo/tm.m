function [E,H,fc]=TM(E_0,m,n,a,b,l,mu,epsilon,f)
%TM  Transverse Magnetic modes vector generator.
%
%   [E]      = TM(E0,m,n,a,b,l,mu,epsilon,f)
%   [E,H]    = TM(-"-)
%   [E,H,fc] = TM(-"-)
%
%   E0 : the magnitude of the electric field,
%   m, n : the modes for the TM-wave in x and y direction respectively,
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
Ez=E_0*sin(A*x)*sin(B*y)*exp(-gamma*z);
E=[-real(gamma/h^2*pdiff(Ez,'x')) real(gamma/h^2*pdiff(Ez,'y')) real(expand(Ez))];
E=setrange(E,[0 a],[0 b],[0 l]);
if nargout>1
   H=[real(j*omega*epsilon/h^2*pdiff(Ez,'y')) -real(j*omega*epsilon/h^2*pdiff(Ez,'x')) 0];
   H=setrange(H,[0 a],[0 b],[0 l]);
end
if nargout>2
   fc=h/(2*pi*sqrt(mu*epsilon));
   fc=fc(0,0,0);
end
