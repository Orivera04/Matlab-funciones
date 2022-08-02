function u=isintv(z)
% inverse sine transform, assume that size(z)=[nx,ny]=[2^k-1,ny]
% 
% C. T. Kelley, May 1994
%
% This code comes with no guarantee or warranty of any kind.
%
[nx,ny]=size(z);
ww=ifft([zeros(ny,1), z']',2*nx+2);
u=imag(ww(2:nx+1,:));
