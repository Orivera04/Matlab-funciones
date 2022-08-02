function [u,r,th]=lapcrcl ...
                  (bvtyp,bvdat,rvec,thvec,nsum)
% 
% [u,r,th]=lapcrcl(bvtyp,bvdat,rvec,thvec,nsum)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function solves Laplace's equation 
% inside a circle of unit radius. Either a 
% Dirichlet problem or a Neumann problem can be 
% analyzed using boundary values defined by 
% piecewise linear interpolation of data 
% specified in terms of the polar angle.
%
% bvtyp      - parameter determining what type 
%              of boundary value problem is 
%              solved. If bvtyp equals one,
%              boundary data specify function 
%              values and a Dirichlet problem 
%              is solved. Otherwise, the 
%              boundary data specify values 
%              of normal gradient, and a Neumann 
%              problem is solved if, in accord 
%              with the existence conditions for 
%              this problem, the average value 
%              of gradient on the boundary is 
%              zero (negligibly small in an
%              approximate solution).
% bvdat      - a matrix of boundary data. Each 
%              bvdat(j,:) gives a function value 
%              and polar angle (in degrees) of 
%              a data point used by function 
%              lintrp to linearly interpolate
%              for all other boundary values 
%              needed to generate the solution.
% rvec,thvec - vectors of radii and polar 
%              coordinate values used to form a 
%              polar coordinate grid of points 
%              inside the unit circle. No values 
%              of r exceeding unity are allowed.
% nsum       - the number of terms summed in the 
%              series expansion of the analytic 
%              function which has u as its real 
%              part. Typically, no more than one 
%              hundred terms are needed to 
%              produce a good solution.
%
% u          - values of the harmonic function 
%              evaluated at a set of points on 
%              a polar coordinate grid inside 
%              the unit circle.
% r,th       - the grid of polar coordinate 
%              values in which the function is 
%              evaluated
%
% User m functions called:  lintrp

% Default test case solves a Dirichlet problem 
% for a function having the following exact 
% solution:
%
% -1/2+imag(log((z-i)/(z+i))/pi)+real(z^16)/10
%
if nargin ==0 
  bvtyp=1; th=linspace(0,2*pi,201)';
  bv=1-(th>pi/2)+(th>3*pi/2)+cos(16*th)/10;
  bvdat=[bv,180/pi*th]; 
  rvec=linspace(1,0,10); 
  thvec=linspace(0,360,161); nsum=200; 
end

close; nft=512; 
thfft=linspace(0,2*pi*(nft-1)/nft,nft);
if nargin<5, nsum=200; end; 
nsum=min(nsum,nft/2-1);
fbv=bvdat(:,1); thbv=pi/180*bvdat(:,2); 
nev=size(bvdat,1); nr=length(rvec); 
nth=length(thvec); neval=nr*nth;
[R,Th]=meshgrid(rvec,pi/180*thvec); 
r=R(:); th=Th(:); 

% Check for any erroneous points outside the 
% unit circle
rvec=rvec(:); 
kout=find(rvec>1); nout=length(kout);
if length(kout)>0
  print('Input data are incorrect. The ');
  print('following r values lie outside the ');
  print('unit circle:'); disp(rvec(kout)'); 
  return
end

if bvtyp==1 % Solve a Dirichlet problem 
  % Check for points on the boundary where 
  % function values are known. Interpolate 
  % these directly
  konbd=find(r==1); onbndry=length(konbd);
  if onbndry > 0 
    u(konbd)=lintrp(thbv,fbv,th(konbd));
  end

  % Evaluate the series solution
  kinsid=find(r<1); inside=length(kinsid);
 
  if inside > 0
    a=fft(lintrp(thbv,fbv,thfft)); 
    a=a(1:nsum)/(nft/2);
    a(1)=a(1)/2; Z=r(kinsid).*exp(i*th(kinsid));
    u(kinsid)=real(polyval(flipud(a(:)),Z)); 
  end

  titl= ...
  'Dirichlet Problem Inside the Unit Circle';

else % Solve a Neumann problem
  gbv=lintrp(thbv,fbv,thfft); 
  a=fft(gbv)/(nft/2);
  erchek=abs(a(1))/sum(abs(gbv));
  if erchek>1e-3 
    disp(' ');
    disp('ERROR DUE TO NONZERO AVERAGE VALUE');
    disp('OF NORMAL GRADIENT ON THE BOUNDARY.');
    disp('CORRECT THE INPUT DATA AND RERUN.');
    disp(' '); u=[]; r=[]; th=[]; return;
  end
  a=a(2:nsum)./(1:nsum-1)'; z=r.*exp(i*th);
  u=real(polyval(flipud([0;a(:)]),z));
  titl='Neumann Problem Inside the Unit Circle';
end   

u=reshape(u,nth,nr); r=R; th=Th;
surf(r.*cos(th),r.*sin(th),u); 
xlabel('x axis'); ylabel('y axis');
zlabel('function u'); title(titl); 
colormap('default'); 
grid on; figure(gcf);
% print -deps dirich

%=============================================

% function y=lintrp(xd,yd,x)
% See Appendix B
