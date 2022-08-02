function [t,ys,ys0,vs0,as]=...
    shkbftss(m,c,k,ybase,prd,nft,nsum, ...
             tmin,tmax,ntimes)
%
% [t,ys,ys0,vs0,as]=...
%   shkbftss(m,c,k,ybase,prd,nft,nsum, ...
%            tmin,tmax,ntimes) 
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% This function determines the steady state 
% solution of the scalar differential equation 
%
%    m*y''(t) + c*y'(t) + k*y(t) = 
%                  k*ybase(t) + c*ybase'(t) 
%
% where ybase is a function of period prd 
% which is expandable in a Fourier series
%
% m,c,k     - Mass, damping coefficient, and 
%             spring stiffness
% ybase     - Function or vector of 
%             displacements equally spaced in 
%             time which describes the base 
%             motion over a period
% prd       - Period used to expand xbase in a 
%             Fourier series
% nft       - The number of components used 
%             in the FFT (should be a power 
%             of two). If nft is input as 
%             zero, then ybase must be a 
%             vector and nft is set to 
%             length(ybase)
% nsum      - The number of terms to be used 
%             to sum the Fourier series 
%             expansion of ybase. This should 
%             not exceed nft/2.
% tmin,tmax - The minimum and maximum times 
%             for which the solution is to 
%             be computed 
% t         - A vector of times at which 
%             the solution is computed
% ys        - Vector of steady state solution 
%             values
% ys0,vs0   - Position and velocity at t=0
% as        - Acceleration ys''(t), if this 
%             quantity is required
%
% User m functions called:  none.
%----------------------------------------------

if nft==0
   nft=length(ybase); ybft=ybase(:)
else
   tbft=prd/nft*(0:nft-1); 
   ybft=fft(feval(ybase,tbft))/nft;
   ybft=ybft(:);
end
nsum=min(nsum,fix(nft/2)); ybft=ybft(1:nsum); 
w=2*pi/prd*(0:nsum-1); 
t=tmin+(tmax-tmin)/(ntimes-1)*(0:ntimes-1)'; 
etw=exp(i*t*w); w=w(:);
ysft=ybft.*(k+i*c*w)./(k+w.*(i*c-m*w)); 
ysft(1)=ysft(1)/2; 
ys=2*real(etw*ysft); ys0=2*real(sum(ysft));
vs0=2*real(sum(i*w.*ysft));
if nargout > 4 
  ysft=-ysft.*w.^2; as=2*real(etw*ysft); 
end