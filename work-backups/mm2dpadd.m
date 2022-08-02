function p=mm2dpadd(pa,pb)
%MM2DPADD 2D Polynomial Addition. (MM)
% MM2DPADD(P1,P2) adds the 2D polynomials P1 and P2.
% If P1 or P2 is a scalar it is added to the other 2D polynomial.
% If a minus sign is added to either P1 or P2, e.g., MM2DPADD(P1,-P2),
% the corresponding polynomial is subtracted.
%
% See also MM2DP2P,MM2DPCHK,MM2DPDER,MM2DPFIT,MM2DPINT,MM2DPSTR,MM2DPVAL,MM2DPXY.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 11/19/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if length(pa)==1      % take care of scalars
   p=pb;
   p(3)=p(3)+pa;
   return
elseif length(pb)==1
   p=pa;
   p(3)=p(3)+pb;
   return
end
pa(1:2)=abs(pa(1:2)); % take care of subtraction
pb(1:2)=abs(pb(1:2));

[ppa,nxa,nya,ncya,cya]=mm2dpchk(pa);
[ppb,nxb,nyb,ncyb,cyb]=mm2dpchk(pb);

nx=max(nxa,nxb); % Nx of sum
ny=max(nya,nyb); % Ny of sum
if nx>=ny        % number of columns in each power of Y
   ncy=nx+1:-1:nx-ny+1;
elseif nx<ny
   ncy=min(ny+1:-1:1,nx+1);
end
cy=[1 cumsum(ncy)+1];    % columns where powers of Y change
ncol=cy(end)-1;          % total number of coefficients
p=zeros(1,ncol);         % blank sum to fill in

for i=1:ny+1 % fill in row by row
   if i<=nya+1
      ix=cy(i):cy(i)+ncya(i)-1;
      p(ix)=ppa(cya(i):cya(i+1)-1);
   end
   if i<=nyb+1
      iy=cy(i):cy(i)+ncyb(i)-1;
      p(iy)=p(iy)+ppb(cyb(i):cyb(i+1)-1);
   end
end
p=[nx ny p];