function k=fssym(kn,t,b)
%FSSYM Enforce Symmetry in Fourier Series. (MM)
% FSSYM(Kn,TYPE) enforces the symmetry condition given
% by TYPE on the complex exponential Fourier series Kn:
%
% TYPE		Symmetry
% 'even'    sets all imaginary components to zero.
% 'odd'     sets all real components (except DC) to zero.
% 'half'    sets all even harmonics (except DC) to zero.
% 'triple'  sets all multiples of 3rd harmonic to zero.
% 'nodc'    sets the DC term to zero.
%
% FSSYM(Kn,TYPEA,TYPEB) enforces the two symmmetry conditions
% given by TYPEA and TYPEB.
%
% See also FSHELP.

% Calls: fssize

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 3/22/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1, error('No Symmetry Type Selected.'), end
if nargin==2, b=''; else, b=b(1); end
t=[t(1) b];
lkn=length(kn);
nh=fssize(kn);	% number of harmonics
ndc=nh+1;		% index of DC term

kdc=kn(ndc);	% DC term
k=kn;			% copy to output
for tt=t
   
   if tt=='e'
      k=real(k);
   elseif tt=='o'
      k=j*imag(k);
      k(ndc)=kdc;
   elseif tt=='h'
      mask=1+rem(nh,2):2:lkn;
      mask(mask==ndc)=[];
      k(mask)=zeros(size(mask));	
   elseif tt=='t'
      mask=[ndc-3:-3:1  ndc+3:3:lkn];
      k(mask)=zeros(size(mask));
   elseif tt=='n'
      k(ndc)=0;kdc=0;
   else
      error('Unknown Symmetry Type Selected.')
   end
end
