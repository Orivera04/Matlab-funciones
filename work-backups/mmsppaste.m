function pp=mmsppaste(pp1,pp2)
%MMSPPASTE Paste Spline Piecewise Polynomial. (MM)
% MMSPPASTE(PP1,PP2) pastes spline piecewise polynomial PP2 into PP1
% returning the combined piecewise polynomial.
% If the range of PP1 and PP2 do not overlap, a connecting piecewise
% polynomial if formed to fill the gap.
% If the range of PP1 and PP2 overlap, PP2 replaces PP1 in the overlap
% area. Where end breakpoints in PP2 do not coincide with breakpoints
% in PP1, a connecting piecewise polynomial is formed from the end 
% breakpoint in PP2 and the nearest nonoverlapping breakpoint in PP1.
% PP1 and PP2 must be monotonic increasing and be 1-D splines.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 8/23/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin~=2
   error('Two Input Arguments are Required.')
end
[brk1,coef1,np1,nc1,dim1]=unmkpp(pp1);
[brk2,coef2,np2,nc2,dim2]=unmkpp(pp2);
if dim2>1 | dim1>1
   error('PP1 and PP2 Must be 1-D Splines.')
elseif (brk1(2)<brk1(1)) | (brk1(2)<brk1(1))
   error('PP1 and PP2 Must be Monotonic Increasing.')
end
nc=max(nc1,nc2);
if nc1~=nc2 % make sure both splines have the same order
   coef1=[zeros(np1,nc-nc1) coef1];
   coef2=[zeros(np2,nc-nc2) coef2];
end
[br,ibr]=sort([brk1(1) brk1(end) brk2(1) brk2(end)])
pos=find([isequal(ibr,[1 2 3 4])   %1 PP2 on right of PP1
   isequal(ibr,[1 3 2 4])   %2 PP2 overlaps right edge of PP1
   isequal(ibr,[1 3 4 2])   %3 PP2 is contained in PP1
   isequal(ibr,[3 1 4 2])   %4 PP2 overlaps left edge of PP1
   isequal(ibr,[3 4 1 2])   %5 PP2 to left of PP1
   isequal(ibr,[3 1 2 4])]) %6 PP2 contains PP1
tol=eps*max(abs(br));
dbr=abs(diff(br))<=tol

if (pos==1 & dbr(2)) | (pos==2 & dbr(2)) % PP2 starts at end of PP1
   coef=[coef1;coef2];
   brk=[brk1(1:end-1) brk2];
elseif pos==1 % PP2 is to the right of PP1, connect them
   x=[brk1(end) brk2(1)];
   y=[mmppval(pp1,x(1)) mmppval(pp2,x(2))];
   yp=[mmspder(pp1,x(1)) mmspder(pp2,x(2))];
   p=[zeros(nc-4,1) local_chic(x,y,yp)];
   coef=[coef1;p;coef2];
   brk=[brk1 brk2];
elseif (pos==2 & dbr(1))| (pos==4 & dbr(3))...
      | (pos==3 & dbr(1) & dbr(3)) | pos==6 % PP2 encloses PP1
   coef=coef2;
   brk=brk2;
elseif pos==2 % PP2 overlaps PP1 on right
   idx=find(brk1<=brk2(1))
   if abs(brk1(idx(end))-brk2(1))<tol % breakpoints are aligned
      coef=[coef1(idx(1:end-1),:);coef2];
      brk=[brk1(idx(1:end-1)) brk2];
   else % connect them
      x=[brk1(idx(end)) brk2(1)];
      y=[mmppval(pp1,x(1)) mmppval(pp2,x(2))];
      yp=[mmspder(pp1,x(1)) mmspder(pp2,x(2))];
      p=[zeros(nc-4,1) local_chic(x,y,yp)];
      coef=[coef1(1:idx(end)-1,:);p;coef2];
      brk=[brk1(idx) brk2];
   end
elseif pos==3 % PP2 is within PP1 but does not cover it
   idx=find(brk1<=brk2(1));
   if abs(brk1(idx(end))-brk2(1))<tol % breakpoints align on left
      coef2=[coef1(idx(1:end-1),:);coef2];
      brk2=[brk1(idx(1:end-1)) brk2];
   else % connect them
      x=[brk1(idx(end)) brk2(1)];
      y=[mmppval(pp1,x(1)) mmppval(pp2,x(2))];
      yp=[mmspder(pp1,x(1)) mmspder(pp2,x(2))];
      p=[zeros(nc-4,1) local_chic(x,y,yp)];
      coef2=[coef1(1:idx(end)-1,:);p;coef2];
      brk2=[brk1(idx) brk2];
   end
   idx=find(brk1>=brk2(end));
   if abs(brk1(idx(1))-brk2(end))<tol % breakpoints align on right
      coef=[coef2; coef1(idx(1):end,:)];
      brk=[brk2 brk1(idx(1)+1:end)];
   else % connect them
      x=[brk2(end) brk1(idx(1))];
      y=[mmppval(pp2,x(1)) mmppval(pp1,x(2))];
      yp=[mmspder(pp2,x(1)) mmspder(pp1,x(2))];
      p=[zeros(nc-4,1) local_chic(x,y,yp)];
      coef=[coef2;p;coef1(idx(1):end,:)];
      brk=[brk2 brk1(idx)];
   end
   
elseif (pos==4 & dbr(2)) | (pos==5 & dbr(2)) % PP2 ends at start of PP1
   coef=[coef2;coef1];
   brk=[brk2 brk1(2:end)];
elseif pos==5 % PP2 is to the left of PP1 connect them
   x=[brk2(end) brk1(1)];
   y=[mmppval(pp2,x(1)) mmppval(pp1,x(2))];
   yp=[mmspder(pp2,x(1)) mmspder(pp1,x(2))];
   p=[zeros(nc-4,1) local_chic(x,y,yp)];
   coef=[coef2;p;coef1];
   brk=[brk2 brk1];
elseif pos==4 % PP2 overlaps PP1 on left
   idx=find(brk1>=brk2(end));
   if abs(brk1(idx(1))-brk2(end))<tol % breakpoints are aligned
      coef=[coef2; coef1(idx(1):end,:)];
      brk=[brk2 brk1(idx(1)+1:end)];
   else % connect them
      x=[brk2(end) brk1(idx(1))];
      y=[mmppval(pp2,x(1)) mmppval(pp1,x(2))];
      yp=[mmspder(pp2,x(1)) mmspder(pp1,x(2))];
      p=[zeros(nc-4,1) local_chic(x,y,yp)];
      coef=[coef2;p;coef1(idx(1):end,:)];
      brk=[brk2 brk1(idx)];
   end
end
pp=mkpp(brk,coef);
%-------------------------------
function p=local_chic(x,y,yp)
%cubic hermite polynomial computation

dx=diff(x);
dx2=dx*dx;
dy=diff(y);
p=[(-2*dy/dx+yp(1)+yp(2))/dx2 (3*dy/dx-2*yp(1)-yp(2))/dx yp(1) y(1)];

