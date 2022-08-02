function [dx,dy]=mm2dpder(p,s)
%MM2DPDER 2D Polynomial Derivative. (MM)
% [DX,DY]=MM2DPDER(P) differentiates the 2D polynomial P
% with respect to X and Y returning the resulting 2D polynomials
% in DX and DY respectively. P must be a 2D polynomial such as
% that output by MM2DPFIT.
% MM2DPDER(P,'x') returns DX only. MM2DPDER(P,'y') returns DY only.
%
% See also MM2DP2P,MM2DPADD,MM2DPCHK,MM2DPFIT,MM2DPINT,MM2DPSTR,MM2DPVAL,MM2DPXY.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 11/19/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[pp,nx,ny,ncy,cy]=mm2dpchk(p);
if nargin==1
   dox=1; doy=1;
elseif nargin==2 & ischar(s)
   s=lower(s(1));
   dox=(s=='x');
   doy=(s=='y');
else
   error('Unknown Input Arguments.')
end
if dox
   if nx>0
      ncydx=ncy(1:end-(nx-1<ny))-1;% number of columns in each power of Y in dx
      cydx=[1 cumsum(ncydx)+1];    % columns where power of Y change in dx
      dx=zeros(1,cydx(end)-1);     % find dx coefficients
      for i=1:length(ncydx)
         id=cy(i)+1:cy(i)+ncydx(i);
         dx(cydx(i):cydx(i+1)-1)=pp(id).*(1:length(id));
      end
      dx=[nx-1 ny-(nx<=ny) dx];
   else
      dx=[0 0 0];
   end
end

if doy
   if ny>0
      ncydy=ncy(2:end);         % number of columns in each power of Y in dy
      cydy=[1 cumsum(ncydy)+1]; % columns where power of Y change in dy
      ncy=cydy(end)-1;          % total number of coefficients in dy
      dy=zeros(1,ncy);          % find dy coefficients
      for i=1:length(ncydy)
         dy(cydy(i):cydy(i+1)-1)=pp(cy(i+1):cy(i+2)-1)*i;
      end
      dy=[nx-(nx>=ny) ny-1 dy];
   else
      dy=[0 0 0];
   end
   if ~dox, dx=dy; end
end