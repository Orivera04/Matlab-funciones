function [pn,nx,ny,ncy,cy]=mm2dpxy(p)
%MM2DPXY 2D Polynomial Variable Swap. (MM)
% Pn=MM2DPXY(P) rearranges the 2D polynomial vector P so that
% the X and Y variables are swapped. That is, so that
% MM2DPVAL(P,X,Y)=MM2DPVAL(Pn,Y,X) and
% MM2DPXY(MM2DPXY(P))=P.
%
% [PP,Nx,Ny,Ncy,Cy]=MM2DPXY(P) parses the new polynomial vector
% using MM2DPCHK.
%
% See also MM2DP2P,MM2DPADD,MM2DPCHK,MM2DPDER,MM2DPFIT,MM2DPINT,MM2DPSTR,MM2DPVAL.

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 11/19/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[pp,nx,ny,ncy,cy]=mm2dpchk(p);

k=cy(1:ny+1);
idx=k;       % find inverse indices
for i=1:nx
   k=k+1;
   idx=[idx k(k<cy(2:length(k)+1))];
end
pn=[ny nx pp(idx)];
if nargout>1
	[pn,nx,ny,ncy,cy]=mm2dpchk(pn);
end
