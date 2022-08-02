% Example:  rkdestab      
% ~~~~~~~~~~~~~~~~~~
% This program plots the boundary of the region
% of the complex plane governing the maximum 
% step size which may be used for stability of 
% a Runge-Kutta integrator of arbitrary order.
%
% npts  - a value determining the number of 
%         points computed on the stability 
%         boundary of an explicit Runge-Kutta 
%         integrator.
% xrang - controls the square window within 
%         which the diagram is drawn. 
%         [ -3, 3, -3, 3] is appropriate for 
%         the fourth order integrator.
%
% User m functions required: none

hold off; close;
fprintf('\nSTABILITY REGION FOR AN ');
fprintf('EXPLICIT RUNGE-KUTTA');
fprintf('\n     INTEGRATOR OF ARBITRARY ');
fprintf('ORDER\n\n');
while 1
disp(' ')
nordr=input('Give the integrator order ? > ');
if isempty(nordr) | nordr==0, break; end
% fprintf('\nInput the number of points ');
% fprintf('used to define\n');
% npts=input('the boundary (100 is typical) ? > ');
npts=100;
r=zeros(npts,nordr); v=1./gamma(nordr+1:-1:2);
d=2*pi/(npts-1); i=sqrt(-1);

% Generate polynomial roots to define the 
% stability boundary
for j=1:npts
  % polynomial coefficients
  v(nordr+1)=1-exp(i*(j-1)*d); 
  % complex roots
  t=roots(v); r(j,:)=t(:).';
end

% Plot the boundary
rel=real(r(:)); img=imag(r(:)); 
w=1.1*max(abs([rel;img]));
zoom on; plot(rel,img,'.','markersize',4); 
axis([-w,w,-w,w]); axis('square');
xlabel('real part of h*\lambda');
ylabel('imaginary part of h*\lambda'); 
ns=int2str(nordr);
st=['Stability Zone for Explicit ' ...
    'Integrator of Order ',ns];
title(st); grid on; figure(gcf);
% print -deps rkdestab
end

disp(' '); disp('All Done');