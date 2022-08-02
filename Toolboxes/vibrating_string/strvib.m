function y=strvib(a,t,x,hp,n)
%
% y=strvib(a,t,x,hp,n)
% ~~~~~~~~~~~~~~~~~~~~
% Sum the Fourier series for the string motion.
%
% a   - Fourier coefficients of initial 
%       deflection
% t,x - vectors of time and position values
% hp  - the half period for the series 
%       expansion
% n   - the number of series terms used
%
% y   - matrix with y(i,j) equal to the 
%       deflection at position x(i) and 
%       time t(j)
%
% User m functions required: none
%----------------------------------------------

w=pi/hp*(1:n); 
a=a(1:n);
a=a(:)';
x=x(:);
t=t(:)'; 
y=((a(ones(length(x),1),:).*sin(x*w))*cos(w(:)*t))';