function [pp,nx,ny,ncy,cy]=mm2dpchk(p)
%MM2DPCHK 2D Polynomial Vector Check and Parse. (MM)
% [PP,Nx,Ny,Ncy,Cy]=MM2DPCHK(P) checks the format and parses
% the 2D polynomial vector P. Output variables are:
% PP = polynomial coefficient vector.
% Nx = X-dimension polynomial order.
% Ny = Y-dimemsion polynomial order.
% Ncy = vector of number of columns in each power of Y.
% Cy = vector of columns in PP where powers of Y change.
%
% A 2D polynomial vector is formed using the following rules:
% The polynomial contains terms up to X^Nx and Y^Ny and all
% possible crossproduct terms X^iY^j where i<=Nx, j<=Ny and
% i+j<=max(Nx,Ny). This corresponds to terms in the Taylor series
% expansion of a function of two variables.
% Example: Nx=2, Ny=2, gives the quadratic form:
% p(1) + p(2)X + p(3)X^2 + p(4)Y + p(5)XY + p(6)Y^2
%
% Nx=3, Ny=4 gives:
% Y^0 terms:  p(1)     + p(2)X     + p(3)X^2     + p(4)X^3 +
% Y^1 terms:  p(5)Y    + p(6)XY    + p(7)X^2Y    + p(8)X^3Y +
% Y^2 terms:  p(9)Y^2  + p(10)XY^2 + p(11)X^2Y^2 + 
% Y^3 terms:  p(12)Y^3 + p(13)XY^3
% Y^4 terms:  p(14)Y^4
%
% For the above: PP=p(1:14), Ncy=[4 4 3 2 1], Cy=[1 5 9 12 14 15]
%
% See also MM2DP2P,MM2DPADD,MM2DPDER,MM2DPFIT,MM2DPINT,MM2DPSTR,MM2DPVAL,MM2DPXY.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 11/19/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

nx=p(1);  % extract data from p
ny=p(2);
pp=p(3:end);
pp=pp(:).';

if nx==0 & ny==0 % handle zero order exception
	ncy=1;
	cy=[1 2];
	return
end
if nx>=ny  % number of columns in each power of Y
	ncy=nx+1:-1:nx-ny+1;
elseif nx<ny
	ncy=min(ny+1:-1:1,nx+1);
end
cy=[1 cumsum(ncy)+1];    % columns where powers of Y change
ncol=cy(end)-1;          % total number of coefficients

if (length(pp)~=ncol) | (nx<0) | (ny<0)
	error('P is Not a Valid 2-D Polynomial Vector.')
end
