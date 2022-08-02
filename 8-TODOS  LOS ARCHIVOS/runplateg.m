function runplate(WhichProblem)      
% Example: runplate(WhichProblem)
% ~~~~~~~~~~~~~~~~~
%
% Example to compute stresses around a
% circular hole in a plate using the
% Kolosov-Muskhelishvili method.
%
% User m functions required:
%    platecrc, strfun, cartstrs,
%    rec2polr, polflip, lintrp

if nargin==0
  titl=['Stress Concentration Around a ', ...
        'Circular Hole in a Plate'];
  N=0; T=0; ti=[0,1,0]; kapa=2; np=50; 
  Nn='N = 0'; Tt='T = 0';
  rz=linspace(1,3,20)'; tz=linspace(0,2*pi,81);
  z=rz*exp(i*tz); x=real(z); y=imag(z);
  viewpnt=[-40,10];
else
  titl=['Harmonic Loading on a Circular', ...
        ' Hole in a Plate'];
  th=linspace(0,2*pi,81)'; 
  N=[cos(4*th),180/pi*th];
  Nn='N = cos(4*theta)'; Tt='T = 0';
  T=0; ti=[0,0,0]; kapa=2; np=10;
  rz=linspace(1,2,10)'; tz=linspace(0,2*pi,81);
  z=rz*exp(i*tz); x=real(z); y=imag(z);
  viewpnt=[-20,20];
end

fprintf('\nSTRESSES IN A PLATE WITH A ')
fprintf('CIRCULAR HOLE')
fprintf('\n\nStress components at infinity ')
fprintf('are: '); fprintf('%g ',ti);
fprintf('\nNormal stresses on the hole are ')
fprintf(['defined by ',Nn]);
fprintf('\nTangential stresses on the hole ')
fprintf(['are defined by ',Tt])
fprintf('\nElastic constant kappa equals: ')
fprintf('%s',num2str(kapa));
fprintf('\nHighest harmonic order used is: ')
fprintf('%s',num2str(np));

[a,b,c]=platecrc(N,T,ti,kapa,np);

fprintf('\n');
fprintf('\nThe Kolosov-Muskhelishvili stress ');
fprintf('functions have\nthe series forms:');
fprintf('\nPhi=sum(a(k)*z^(-k+1), k=1:np+1)');
fprintf('\nPsi=sum(b(k)*z^(-k+1), k=1:np+3)');
fprintf('\n');
fprintf('\nCoefficients defining stress ');
fprintf('function Phi are:\n');
disp(a(:));
fprintf('Coefficients defining stress ');
fprintf('function Psi are:\n');
disp(b(:));

% Evaluate the stress functions
[Phi,Psi,Phip]=strfun(a,b,z);

% Compute the Cartesian stresses and the
% principal stresses
[tx,ty,txy,pt1,pt2]=cartstrs(z,Phi,Psi,Phip);
theta=angle(z./abs(z)); x=real(z); y=imag(z);
[tr,tt,trt]=rec2polr(tx,ty,txy,theta);
pmin=num2str(min([pt1(:);pt2(:)]));
pmax=num2str(max([pt1(:);pt2(:)]));

disp(...
['Minimum Principal Stress = ',num2str(pmin)]);
disp(...
['Maximum Principal Stress = ',num2str(pmax)]);
fprintf('\nPress [Enter] for a surface ');
fprintf('plot of the\ncircumferential stress ');
fprintf('in the plate\n'); input('','s'); clf; 
close; %colormap('hsv'); 
surf(x,y,tt); xlabel('x axis'); ylabel('y axis');
zlabel('Circumferential Stress');
title(titl); grid on; view(viewpnt); 
gra(.6), figure(gcf);
if nargin==0, print -deps strconc1
else, print -deps strconc2; end
fprintf('All Done\n');

%=============================================

function [a,b,c]=platecrc(N,T,ti,kapa,np)
%
% [a,b,c]=platecrc(N,T,ti,kapa,np)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function computes coefficients in the 
% series expansions that define the Kolosov-
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
%        to be the same as as those used to
%        specify N. Input a single constant 
%        when T is constant on the boundary.
% ti   - vector of Cartesian stress components 
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

%=============================================

function [Phi,Psi,Phip]=strfun(a,b,z)
%
% [Phi,Psi,Phip]=strfun(a,b,z)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function evaluates the complex
% stress functions Phi(z) and Psi(z)
% as well as the derivative function Phi'(z)
% using series coefficients determined from
% function platecrc. The calculation also
% uses a function polflip defined such that
% polflip(a,z)=polyval(flipud(a(:)),z). 
%
% a,b     - series coefficients defining Phi
%           and Psi
% z       - matrix of complex values
%
% Phi,Psi - complex stress function values
% Phip    - derivative Phi'(z)
%
% User m functions called: polflip
%----------------------------------------------

zi=1./z; np=length(a); a=a(:);
Phi=polflip(a,zi); Psi=polflip(b,zi);
Phip=-polflip((1:np-1)'.*a(2:np),zi)./z.^2;

%==============================================

function [tx,ty,txy,tp1,tp2]= ...
                       cartstrs(z,Phi,Psi,Phip)
%
% [tx,ty,txy,tp1,tp2]=cartstrs(z,Phi,Psi,Phip)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function uses values of the complex 
% stress functions to evaluate Cartesian stress 
% components relative to the x,y axes.
%
% z         - matrix of complex values where 
%             stresses are required
% Phi,Psi   - matrices containing complex stress 
%             function values
% Phip      - values of  Phi'(z)
%
% tx,ty,txy - values of the Cartesian stress 
%             components for the x,y axes
% tp1,tp2   - values of maximum and minimum 
%             principal stresses
%
% User m functions called:  none
%----------------------------------------------

A=2*real(Phi); B=conj(z).*Phip+Psi; 
C=A-B; R=abs(B); 
tx=real(C); ty=2*A-tx; txy=-imag(C); 
tp1=A+R; tp2=A-R;

%==============================================

function [tr,tt,trt]=rec2polr(tx,ty,txy,theta)
%
% [tr,tt,trt]=rec2polr(tx,ty,txy,theta)
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%
% This function transforms Cartesian stress 
% components tx,ty,txy to polar coordinate 
% stresses tr,tt,trt.
%
% tx,ty,txy - matrices of Cartesian stress 
%             components
% theta     - a matrix of polar coordinate 
%             values.  This can also be a 
%             single value if all stress 
%             components are rotated by the
%             same angle.
%
% tr,tt,trt - matrices of polar coordinate 
%             stresses
%
% User m functions called:  none
%----------------------------------------------

if length(theta(:))==1
  theta=theta*ones(size(tx)); end
a=(tx+ty)/2; 
b=((tx-ty)/2-i*txy).*exp(2*i*theta);
c=a+b; tr=real(c); tt=2*a-tr; trt=-imag(c);

%=============================================

function y=polflip(a,x)
%
% y=polflip(a,x)
% ~~~~~~~~~~~~~~
%
% This function evaluates polyval(a,x) with 
% the order of the elements reversed.
%
%----------------------------------------------

y=polyval(a(end:-1:1),x);

%=============================================

% function y=lintrp(xd,yd,x)
% See Appendix B
