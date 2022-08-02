function pi=mm2dpint(p,s)
%MM2DPINT 2D Polynomial Integral. (MM)
% MM2DPINT(P) integrates the 2D polynomial P with respect to X and Y
% returning the resulting 2D polynomial. P must be a 2D polynomial such
% as that output by MM2DPFIT.
%
% MM2DPINT(P,'x') integrates with respect to X only.
% MM2DPINT(P,'y') integrates with respect to Y only.
%
% See also MM2DP2P,MM2DPADD,MM2DPCHK,MM2DPDER,MM2DPFIT,MM2DPSTR,MM2DPVAL,MM2DPXY.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 11/20/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1
   dox=1; doy=1;
elseif nargin==2 & ischar(s)
   s=lower(s(1));
   dox=(s=='x');
   doy=(s=='y');
else
   error('Unknown Input Arguments.')
end
[pp,nx,ny,ncy,cy]=mm2dpchk(p);

if dox
   nxi=nx+1;                 % Nx of integral
   nyi=ny+1;                 % Ny of integral
   if nxi>=nyi               % number of columns in each power of Y
      ncyi=nxi+1:-1:nxi-nyi+1;
   elseif nxi<nyi
      ncyi=min(nyi+1:-1:1,nxi+1);
   end
   cyi=[1 cumsum(ncyi)+1];   % columns where powers of Y change
   ncol=cyi(end)-1;          % total number of coefficients
   pi=zeros(1,ncol);         % blank polynomial to fill in
   m=(1:nxi+1);
   for i=1:ny+1 % fill in row by row
      ix=cyi(i)+1:cyi(i)+ncy(i); % index of ith row in pi
      pi(ix)=pp(cy(i):cy(i+1)-1)./m(1:ncy(i));
   end
   pi=[nxi nyi pi];
end

if doy
   if dox, p=pi; end
   pi=mm2dpint(mm2dpxy(p),'x');
   pi=mm2dpxy(pi);
end
