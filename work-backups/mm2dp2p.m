function p1=mm2dp2p(p,s,v)
%MM2DP2P 2D Polynomial To 1D Polynomial. (MM)
% MM2DP2P(P,'x',Val) evaluates the 2D polynomial P at x=Val
% and returns the resulting 1D polynomial in Y in standard form.
%
% MM2DP2P(P,'y',Val) evaluates the 2D polynomial P at y=Val
% and returns the resulting 1D polynomial in X in standard form.
%
% See also MM2DPADD,MM2DPCHK,MM2DPDER,MM2DPFIT,MM2DPINT,MM2DPSTR,MM2DPVAL,MM2DPXY.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 11/19/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[pp,nx,ny,ncy,cy]=mm2dpchk(p);
if ~ischar(s)|((s(1)~='x')&(s(1)~='y'))
   error('Second Argument Must be ''x'' or ''y''.')
end
if ~isnumeric(v)|length(v)~=1
   error('Val Must be a Scalar.')
end
if s(1)=='y' % swap arguments to make things easy
   [pp,nx,ny,ncy,cy]=mm2dpxy(p);
end
nc=ny+1;
p1=zeros(1,nc);
for i=nc:-1:1
   p1(nc+1-i)=polyval(pp(cy(i+1)-1:-1:cy(i)),v);
end