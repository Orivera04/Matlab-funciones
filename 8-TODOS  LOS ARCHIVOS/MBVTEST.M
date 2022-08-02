function u=mbvtest(z,noplot)
%
% u=mbvtest(z,noplot)
% ~~~~~~~~~~~~~~~~~~~
%
% This function determines a function which is
% harmonic for abs(z)<1 and satisfies at r=1,
%   u=cos(theta), -pi/2<theta<pi/2
%   du/dr=0,       pi/2<theta<3*pi/2
% The solution only applies for points inside 
% or on the unit circle.
%
% z      - matrix of complex values where the
%          solution is computed.  
% noplot - option set to one if no plot is 
%          requested, otherwise option is not 
%          required.
% 
% u      - values of the harmonic function
%          defined inside the unit circle
%
% User m functions called:  none
%----------------------------------------------

if nargin==0
  noplot=0; 
  z=linspace(0,1,10)'* ...
    exp(i*linspace(0,2*pi,81));
end
[n,m]=size(z); z=z(:); u=1/2*ones(size(z));
k=find(abs(z)>0); Z=z(k);
U=(Z+1./Z+(1-1./Z).*sqrt(Z-i).*sqrt(Z+i))/2;
u(k)=real(U); u=reshape(u,n,m); 
if nargin==1 | noplot==0
  z=reshape(z,n,m);  
  surf(real(z),imag(z),u); xlabel('x axis');
  ylabel('y axis');
  title(['Mixed Boundary Value Problem ', ...
         'for a Circular Disk']);
  grid; figure(gcf);
  %print -deps mbvtest
end
