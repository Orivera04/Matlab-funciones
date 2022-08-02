function [c,phi,stres,z]=...
  recstrs(a,nsega,b,nsegb,ntrms,nxout,nyout)
%
% [c,phi,stres,z]=...
%   recstrs(a,nsega,b,nsegb,ntrms,nxout,nyout)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function uses least square fitting to
% obtain an approximate solution for torsional 
% stresses in a Saint Venant beam having a 
% rectangular cross section. The complex stress 
% function is analytic inside the rectangle 
% and has its real part equal to abs(z*z)/2 on 
% the boundary. The problem is solved 
% approximately using a polynomial stress 
% function which fits the boundary condition 
% in the least square sense. The beam is 2*a 
% wide along the x axis and 2*b deep along 
% the y axis. The shear stresses in the beam 
% are given by the complex stress formula:
%
% (tauzx-i*tauzy)/(mu*alpha) = -i*conj(z)+f'(z)  
%
% where
%
%   f(z)=i*sum( c(j)*z^(2*j-2), j=1:ntrms ) 
%
% and c(j) are real.
%
% a,b     - half the side lengths of the 
%             horizontal and vertical sides
% nsega,  - numbers of subintervals used in 
% nsegb       formation of least square 
%             equations
% ntrms   - number of polynomial terms used in 
%             polynomial stress function
% nxout,  - number of grid points used to
% nyout       evaluate output
% c       - coefficeints defining the stress 
%             function
% phi     - values of the membrane function
% stres   - array of complex stress values
% z       - complex point array at which 
%             stresses are found
%
% User m functions called:  none
%----------------------------------------------

% Generate vector zbdry of boundary points 
% for point matching.
zbdry=[a+i*b/nsega*(0:nsega-1)';
       i*b+a/nsegb*(nsegb:-1:0)'];
 
% Determine a scaling parameter used to 
% prevent occurrence of large numbers when 
% high powers of z are used
s=max(a,b);

% Form the least square equations to impose 
% the boundary conditions.
neq=length(zbdry); amat=ones(neq,ntrms);
ztmp=(zbdry/s).^2; bvec=.5*abs(zbdry).^2;
for j=2:ntrms 
  amat(:,j)=amat(:,j-1).*ztmp;
end

% Solve the least square equations.
amat=real(amat); c=pinv(amat)*bvec;

% Generate grid points to evaluate 
% the solution.
xsid=linspace(-a,a,nxout); 
ysid=linspace(-b,b,nyout);
[xg,yg]=meshgrid(xsid,ysid); 
z=xg+i*yg; zz=(z/s).^2; 

% Evaluate the warping function
phi=-imag(polyval(flipud(c),zz));

% Evaluate stresses and plot results
cc=(2*(1:ntrms)-2)'.*c;
stres=-i*conj(z)+i* ...
      polyval(flipud(cc),zz)./(z+eps*(z==0));
am=num2str(-a);ap=num2str(a); 
bm=num2str(-b);bp=num2str(b);

% Plot results
disp(' '), disp('Press [Enter] to plot')
disp('the warping surface'), pause 
[pa,k]=max(abs(phi(:)));
Phi=a/4*sign(phi(k))/phi(k)*phi;
close, colormap('default') 
surfc(xg,yg,Phi)
title('Warping of the Cross Section')
xlabel('x axis'), ylabel('y axis')        
zlabel('transverse warping'); axis('equal')
shg, disp(' ')
disp('Press [[Enter]] to plot the')
disp('total stress surface'), pause
% print -deps warpsurf

surfc(xg,yg,abs(stres));
title('Total Shear Stress Surface')
xlabel('x axis'); ylabel('y axis')
zlabel('total stress'), axis('equal'), shg
disp(' '), disp('Press [Enter] to plot the')
disp('stress contours'), pause 
% print -deps rectorst

contour(xg,yg,abs(stres),20); colorbar
title('Total Stress Contours');
xlabel('x axis'); ylabel('y axis')
shg, disp(' ')
disp('Press [Enter] to plot the maximum')
disp('stress on a rectangle side'), pause
% print -deps torcontu 
  
plot(xsid,abs(stres(1,:)),'k');
grid; ylabel('tangential stress');
xlabel('position on a horizontal side');
title('Stress for y = b/2'); shg
% print -deps torstsid 