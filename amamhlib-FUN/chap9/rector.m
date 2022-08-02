function rector      
% Example:  rector
% ~~~~~~~~~~~~~~~~
% This program uses point matching to obtain an
% approximate solution for torsional stresses
% in a Saint Venant beam having a rectangular
% cross section. The complex stress function is
% analytic inside the rectangle and has its
% real part equal to abs(z*z)/2 on the  
% boundary. The problem is solved approximately 
% using a polynomial stress function which fits 
% the boundary condition in the least square 
% sense. Surfaces and contour curves describing 
% the stress and deformation pattern in the 
% beam cross section are drawn.
%
% User m functions required: recstrs

clear; close
fprintf('\n===  TORSIONAL STRESS CALCULATION');
fprintf(' IN A RECTANGULAR  ===');
fprintf('\n===      BEAM USING LEAST SQUARE ');
fprintf('APPROXIMATION      ===\n');
fprintf('\nInput the lengths of the ');
fprintf('horizontal and the vertical sides\n');
fprintf('(make the long side horizontal)\n');
u=input('> ? ','s'); u=eval(['[',u,']']);
a=u(1)/2; b=u(2)/2;

% The boundary conditions are approximated in
% terms of the number of least square points
% used along the sides
nsegb=100; nsega=ceil(a/b*nsegb);
nsega=fix(nsega/2); nsegb=fix(nsegb/2);
fprintf('\nInput the number of terms ');
fprintf('used in the stress function');
fprintf('\n(30 terms is usually enough)\n'); 
ntrms=input('> ? ');

% Define a grid for evaluation of stresses.
% Include the middle of each side.
nx=41; ny=fix(b/a*nx); ny=ny+1-rem(ny,2);

[c,phi,stres,z] = ...
  recstrs(a,nsega,b,nsegb,ntrms,nx,ny);
[smax,k]=max(abs(stres(:))); zmax=z(:);
zmax=zmax(k); xmax=abs(real(zmax));
ymax=abs(imag(zmax));
disp(' '), disp(['The Maximum Shear ',...
                 'Stress is ',num2str(smax)]);
disp(['at x = ',num2str(xmax),' and y = ',...
                  num2str(ymax)]);
disp(' '); disp('All Done');

%=============================================

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
% wide parallel to the x axis and 2*b deep 
% parallel to the y axis. The shear stresses 
% in the beam are given by the stress formula:
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
%           horizontal and vertical sides
% nsega,  - numbers of subintervals used to 
% nsegb     form the least square equations
% ntrms   - number of terms used in the
%           polynomial stress function
% nxout,  - number of grid points used to
% nyout     evaluate output
% c       - coefficients defining the stress 
%           function
% phi     - values of the membrane function
% stres   - array of complex stress values
% z       - complex point array at which 
%           stresses are found
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
