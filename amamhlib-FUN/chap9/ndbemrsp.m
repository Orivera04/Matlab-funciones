function [t,x,displ,mom]= ...
    ndbemrsp(w,tmin,tmax,nt,xmin,xmax,nx,ntrms)
%
% [t,x,displ,mom]=ndbemrsp(w,tmin,tmax,nt,...
%                         xmin,xmax,nx,ntrms)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function evaluates the nondimensional 
% displacement and moment in a constant 
% cross-section simply-supported beam which 
% is initially at rest when a harmonically 
% varying moment of frequency w is suddenly 
% applied at the right end. The resulting 
% time history is computed.
%
% w          - frequency of the harmonically 
%              varying end moment
% tmin,tmax  - minimum and maximum 
%              dimensionless times
% nt         - number of evenly spaced 
%              solution times
% xmin,xmax  - minimum and maximum 
%              dimensionless position 
%              coordinates. These values 
%              should lie between zero and 
%              one (x=0 and x=1 give the 
%              left and right ends).
% nx         - number of evenly spaced 
%              solution positions
% ntrms      - number of terms used in the 
%              Fourier sine series
% t          - vector of nt equally spaced 
%              time values varying from 
%              tmin to tmax
% x          - vector of nx equally spaced 
%              position values varying 
%              from xmin to xmax
% displ      - matrix of dimensionless 
%              displacements with time 
%              varying from row to row, 
%              and position varying from 
%              column to column
% mom        - matrix of dimensionless 
%              bending moments with time 
%              varying from row to row, and
%              position varying from column 
%              to column
%
% User m functions called:  sumser
%----------------------------------------------

if nargin < 8, w=0; end; nft=512; nh=nft/2;
xft=1/nh*(0:nh)'; 
x=xmin+(xmax-xmin)/(nx-1)*(0:nx-1)';
t=tmin+(tmax-tmin)/(nt-1)*(0:nt-1)'; 
cwt=cos(w*t);

% Get particular solution for nonhomogeneous 
% end condition
if w ==0 % Case for a constant end moment
  cp=[1 0 0 0; 0 0 2 0; 1 1 1 1; 0 0 2 6]\ ...
     [0;0;0;1];
  yp=[ones(x), x, x.^2, x.^3]*cp; yp=yp';
  mp=[zeros(nx,2), 2*ones(nx,1), 6*x]*cp; 
  mp=mp';
  ypft=[ones(xft), xft, xft.^2, xft.^3]*cp;

% Case where end moment oscillates 
% with frequency w
else  
  s=sqrt(w)*[1, i, -1, -i]; es=exp(s);
  cp=[ones(1,4); s.^2; es; es.*s.^2]\ ...
     [0; 0; 0; 1];
  yp=real(exp(x*s)*cp); yp=yp';
  mp=real(exp(x*s)*(cp.*s(:).^2)); mp=mp';
  ypft=real(exp(xft*s)*cp);
end

% Fourier coefficients for 
% particular solution
yft=-fft([ypft;-ypft(nh:-1:2)])/nft;

% Sine series coefficients for 
% homogeneous solution
acof=-2*imag(yft(2:ntrms+1));
ccof=pi*(1:ntrms)'; bcof=ccof.^2;

% Sum series to evaluate Fourier 
% series part of solution. Then combine 
% with the particular solution.
displ=sumser(acof,bcof,ccof,'cos','sin',...
                  tmin,tmax,nt,xmin,xmax,nx);
displ=displ+cwt*yp; acof=acof.*bcof;
mom=sumser(acof,bcof,ccof,'cos','sin',...
                 tmin,tmax,nt,xmin,xmax,nx);
mom=-mom+cwt*mp;