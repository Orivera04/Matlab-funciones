function pp=mmhermite(x,y,dyl,dyr)
%MMHERMITE Cubic Hermite Spline Construction. (MM)
% MMHERMITE(X,Y,DY) returns the piecewise polynomial in pp-form
% that fits the data in X, Y, and DY. Y is a vector of data values
% at the breakpoints in X. DY is a vector of continuous slopes DY/DX
% at each breakpoint. length(DY)=length(Y)=length(X).
%
% MMHERMITE(X,Y,DYL,DYR) allows one to specify discontinuous slopes
% at the breakpoints. DYL is the slope at the left of each
% piecewise polynomial (or to the right of each breakpoint except
% the last). DYR is the slope at the right of each piecewise polynomial
% (or to the left of each breakpoint except the first).
% length(DYL)=length(DYR)=length(X)-1.
%
% See also: MMSPHELP

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 9/22/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[x,idx]=sort(x(:)); % put x in increasing order
nx=length(x);
if nx~=prod(size(y));
   error('X and Y Must Contain the Same Number of Elements.')
end
y=reshape(y(idx),size(x));
if nargin==3
   dyl=dyl(:);
   if length(dyl)~=nx
      error('DY and X Must Contain the Same Number of Elements.')
   end
   dyr=dyl(2:nx);
   dyl=dyl(1:nx-1);
elseif nargin==4
   dyl=dyl(:);
   dyr=dyr(:);
   if length(dyl)~=nx-1 | length(dyr)~=nx-1
      error('DYL and DYR Must Contain One Less Element than X.')
   end
else
   error('Incorrect Number of Input Arguments.')
end
dx=diff(x);
if any(dx==0)
   error('Breakpoints X Must be Distinct.')
end
dx2=dx.*dx;
dy=diff(y);
coef(:,4)=y(1:end-1);
coef(:,3)=dyl;
coef(:,2)=(3*dy./dx - (2*dyl+dyr))./dx;
coef(:,1)=(-2*dy./dx + (dyr+dyl))./dx2;
pp=mkpp(x,coef);