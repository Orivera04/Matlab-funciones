function [w,b]=squarmap(m,r1,r2,nr,t1,t2,nt)
%
% [w,b]=squarmap(m,r1,r2,nr,t1,t2,nt)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function evaluates the conformal mapping
% produced by the Schwarz-Christoffel 
% transformation w(z) mapping abs(z)<=1 inside 
% a square having a side length of two.  The 
% transfomation is approximated in series form 
% which converges very slowly near the corners.
%
% m        - number of series terms used
% r1,r2,nr - abs(z) varies from r1 to r2 in 
%            nr steps
% t1,t2,nt - arg(z) varies from t1 to t2 in 
%            nt steps (t1 and t2 are measured 
%            in degrees)
% w        - points approximating the square
% b        - coefficients in the truncated 
%            series expansion which has the 
%            form
%
%            w(z)=sum({j=1:m},b(j)*z*(4*j-3))
%
% User m functions called:  cubrange
%----------------------------------------------

% Generate polar coordinate grid points for the
% map.  Function linspace generates vectors 
% with equally spaced components.
r=linspace(r1,r2,nr)'; 
t=pi/180*linspace(t1,t2,nt);
z=(r*ones(1,nt)).*(ones(nr,1)*exp(i*t));

% Use high point resolution for the 
% outer contour
touter=pi/180*linspace(t1,t2,10*nt);
zouter=r2*exp(i*touter);

% Compute the series coefficients and 
% evaluate the series
k=1:m-1; 
b=cumprod([1,-(k-.75).*(k-.5)./(k.*(k+.25))]);
b=b/sum(b); w=z.*polyval(b(m:-1:1),z.^4);
wouter=zouter.*polyval(b(m:-1:1),zouter.^4);

% Determine square window limits for plotting
uu=real([w(:);wouter(:)]); 
vv=imag([w(:);wouter(:)]);
rng=cubrange([uu,vv],1.1);
axis('square'); axis(rng); hold on 

% Plot orthogonal grid lines which represent 
% the mapping of circles and radial lines
x=real(w); y=imag(w); 
xo=real(wouter); yo=imag(wouter);
plot(x,y,'-k',x(1:end-1,:)',y(1:end-1,:)',...
	'-k',xo,yo,'-k')

% Add a title and axis labels
title(['Mapping of a Square Using a ', ...
       num2str(m),'-term Polynomial'])
xlabel('x axis'); ylabel('y axis')
figure(gcf); hold off;