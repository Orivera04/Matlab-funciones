function [a,b,c]=platecrc(N,T,ti,kapa,np)
%
% [a,b,c]=platecrc(N,T,ti,kapa,np)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes coefficients in the 
% series expansions which define the Kolosov-
% Muskhelishvili stress functions for a plate
% having a circular hole of unit radius. The 
% plate is uniformly stressed at infinity. On 
% the surface of the hole, normal and tangential 
% stress distributions N and T defined as 
% piecewise linear functions are applied.
%
% N    - a two column matrix with each row 
%        containing a value of normal stress 
%        and polar angle in degrees used to
%        specify N as a piecewise linear 
%        function of the polar angle. Step 
%        discontinuities can be included by 
%        using successive values of N with the 
%        same polar angle values.  The data 
%        should cover the range of theta from 
%        0 to 360.  N represents boundary values
%        of the polar coordinate radial stress. 
%        A single constant value can be input 
%        when N is constant (including zero 
%        if desired).
% T    - a two column matrix defining values of 
%        the polar coordinate shear stress on 
%        the hole defined as a piecewise linear 
%        function. The points where function
%        values of T are specified do not need 
%        not need be the same as as those used 
%        to specify N. Input a single constant 
%        when T is constant on the boundary.
% ti   - vector of cartesian stress components 
%        [tx,ty,txy] at infinity.
% kapa - a constant depending on Poisson's ratio 
%        nu. 
%            kapa=3-4*nu for plane strain 
%            kapa=(3-nu)/(1+nu) for plane stress
%        When the resultant force on the hole 
%        is zero, then kapa has no effect on 
%        the solution. 
% np   - the highest power of exp(i*theta) used 
%        in the series expansion of N+i*T. This 
%        should not exceed 255. 
%
% a    - coefficients in the series expansion 
%        defining the stress function
%            Phi=sum(a(k)*z^(-k+1), k=1:np+1)
% b    - coefficients in the series expansion 
%        defining the stress function
%            Psi=sum(b(k)*z^(-k+1), k=1:np+3)
%
% User m functions called:  lintrp
%----------------------------------------------

% Handle case of constant boundary stresses
if length(N(:))==1; N=[N,0;N,360]; end
if length(T(:))==1; T=[T,0;T,360]; end

% Expand the boundary stresses in a Fourier 
% series
f=pi/180; nft=512; np=min(np,nft/2-1);
thta=linspace(0,2*pi*(nft-1)/nft,nft); 

% Interpolate linearly for values at the 
% Fourier points
Nft=lintrp(f*N(:,2),N(:,1),thta);
Tft=lintrp(f*T(:,2),T(:,1),thta); 
c=fft(Nft(:)+i*Tft(:))/nft;

% Evaluate auxiliary parameters in the 
% series solutions
alp=(ti(1)+ti(2))/4; bet=-kapa*c(nft)/(1+kapa);
sig=(-ti(1)+ti(2)-2*i*ti(3))/2;

% Generate a and b coefficients using the 
% Fourier coefficients of N+i*T.
a=zeros(np+1,1); b=zeros(np+3,1); j=(1:np)';
a(j+1)=c(nft+1-j); a(1)=alp; 
a(2)=bet+c(nft); a(3)=sig+c(nft-1);
j=(3:np+2)'; b(j+1)=(j-1).*a(j-1)-conj(c(j-1));
b(1)=conj(sig); b(2)=conj(bet); 
b(3)=alp+a(1)-conj(c(1));

% Discard any negligibly small high order 
% coefficients.
tol=max(abs([N(:);T(:);ti(:)]))/1e4;
ka=max(find(abs(a)>tol));
if isempty(ka), a=0; else, a(ka+1:np+1)=[]; end
kb=max(find(abs(b)>tol));
if isempty(kb), b=0; else, b(kb+1:np+3)=[]; end