function [R,T,N,B,kappa]=crvprpsp(Rd,n)
%
% [R,T,N,B,kappa]=crvprpsp(Rd,n)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes spline interpolated 
% values for coordinates, base vectors and 
% curvature obtained by passing a spline curve 
% through data values given in Rd. 
%
% Rd    - a matrix containing x,y and z values 
%         in rows 1, 2 and 3.
% n     - the number of points at which 
%         properties are to be evaluated along 
%         the curve
%
% R     - a 3 by n matrix with columns 
%         containing coordinates of interpolated
%         points on the curve
% T,N,B - matrices of dimension 3 by n with 
%         columns containing components of the 
%         unit tangent, unit normal, and unit 
%         binormal vectors
% kappa - a vector of curvature values
%
% User m functions called: 
%         splined, crvprp3d
%----------------------------------------------

% Create a spline curve through the data points, 
% and evaluate the derivatives of R.
nd=size(Rd,2); td=0:nd-1; t=linspace(0,nd-1,n); 
ud=Rd(1,:)+i*Rd(2,:); u=spline(td,ud,t);
u1=splined(td,ud,t); u2=splined(td,ud,t,2);
ud3=Rd(3,:); z=spline(td,ud3,t);
z1=splined(td,ud3,t); z2=splined(td,ud3,t,2);
R=[real(u);imag(u);z]; R1=[real(u1);imag(u1);z1]; 
R2=[real(u2);imag(u2);z2];

% Get curve properties from crvprp3d
[T,N,B,kappa]=crvprp3d(R1,R2);