function sqrtsurf      
%
% sqrtsurf
% ~~~~~~~~
%
% This function illustrates the discontinuity 
% in the function w=sqrt(z*z-1).

xx=linspace(-2,2,41); [x,y]=meshgrid(xx,xx);
z=x+i*y; w=sqrt(z.*z-1); close
surf(x,y,imag(w)); view(-40,50);
xlabel('real axis'); ylabel('imaginary axis');
zlabel('imag( sqrt( z^2-1 ) )');
title(['Discontinuous Surface for imag( sqrt', ...
       '( z^2 - 1 ) )']);
grid on; figure(gcf);
%print -deps sqrtsurf