function mbvprun(nser,nf,ng,neval)    
% Example:  mbvprun(nser,nf,ng,neval)
% ~~~~~~~~~~~~~~~~~
% Mixed boundary value problem for a function 
% harmonic inside a circle.

% User m functions required: 
%   mbvp

close, disp('Calculating')

% Set data for series term and boundary 
% condition points
if nargin==0
  nser=80; nf=100; ng=100; neval=500;
end

% Compute the series coefficients
[cof,y]=mbvp('cos',pi/2,nser,nf,ng,neval);

% Evaluate the exact solution for comparison
thp=linspace(0,pi,neval)'; 
y=cos(thp*(0:nser-1))*cof;
ye=cos(thp)+sin(thp/2).* ...
   sqrt(2*abs(cos(thp))).*(thp>=pi/2);

% Plot results showing the accuracy of the 
% least square solution
thp=thp*180/pi; plot(thp,y,'-',thp,y-ye,'--');
xlabel('polar angle'); 
ylabel('function value and error')
title(['Mixed Boundary Value Problem ', ...
      'Solution for ',int2str(nser),' Terms']);
legend('Function value','Solution Error');
figure(gcf); % print -deps mbvp

%==============================================

function [cof,y]= ...
         mbvp(func,alp,nser,nf,ng,neval)
%
% [cof,y]=mbvp(func,alp,nser,nf,ng,neval)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function solves approximately a mixed 
% boundary value problem for a function which
% is harmonic inside the unit disk, symmetric
% about the x axis, and has boundary conditions 
% involving function values on one part of the 
% boundary and zero gradient elsewhere. 
%
% func      - function specifying the function 
%             value between zero and alp 
%             radians
% alp       - angle between zero and pi which 
%             specifies the point where 
%             boundary conditions change from 
%             function value to zero gradient 
% nser      - number of series terms used
% nf        - number of function values 
%             specified from zero to alp
% ng        - number of points from alp to pi 
%             where zero normal derivative is 
%             specified
% neval     - number of boundary points where 
%             the solution is evaluated
% cof       - coefficients in the series 
%             solution
% y         - function values for the solution 
%
%----------------------------------------------

% Create evenly spaced points to impose 
% boundary conditions
th1=linspace(0,alp,nf); 
th2=linspace(alp,pi,ng+1); th2(1)=[];

% Form an overdetermined system based on the 
% boundary conditions
yv=feval(func,th1); 
cmat=cos([th1(:);th2(:)]*(0:nser-1)); 
[nr,nc]=size(cmat);
cmat(nf+1:nr,:)=...
  (ones(ng,1)*(0:nser-1)).*cmat(nf+1:nr,:);
cof=cmat\[yv(:);zeros(ng,1)];

% Evaluate the solution on the boundary
thp=linspace(0,pi,neval)'; 
y=cos(thp*(0:nser-1))*cof;
