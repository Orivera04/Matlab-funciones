function [x,y]=separate(x,delt);
%SEPARATE   Ensure identical rows are separated
%
%   X=SEPARATE(X) checks the matrix X for identical rows and if it finds
%   them, separates them geometrically so that their separation is
%   4*sqrt(eps). The algorithm is designed for 2-column data, ie it spreads
%   points in the first two dimensions.
%   X=SEPARATE(X,DIST) provides a distance to separate points by.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:19:59 $

% first sort 
[x i]=sortrows(x);

if nargin==1
   delt=4*sqrt(eps);
end
srchdelt=4*sqrt(eps);
fnd=x(2:end,:)-x(1:end-1,:);
fnd(fnd<srchdelt)=0;
fnd(fnd>=srchdelt)=1;
fnd=sum(~fnd,2);

% put to 0 any rows that aren't identical in each component
fnd(fnd<size(x,2))=0;

pos=1;
while pos<=size(fnd,1)
   if fnd(pos)
      pt=x(pos,:);
      % look for consecutive replicates
      go=1;
      cnt=1;
      while go & (pos+cnt)<=size(fnd,1)
         if fnd(pos+cnt)
            cnt=cnt+1;
         else
            go=0;
         end
      end
      % include original point
      cnt=cnt+1;
      % decide splitting geometry
      if cnt==2
         % special case
         xc=[pt(1)-delt/2 pt(1)+delt/2];
         yc=[pt(2) pt(2)];
      else
         theta=-pi:2*pi/cnt:(pi-srchdelt);
         divth=2*sin(2*pi/cnt);
         xc=(delt*cos(theta))./(divth);
         yc=(delt*sin(theta))./(divth);
         xc=xc+pt(1);
         yc=yc+pt(2);
      end
      x(pos:pos+cnt-1,[1 2])=[xc' yc'];
      pos=pos+cnt-1;
   else
      pos=pos+1;
   end  
end
% re-sort x back to original state
x(i,:)=x;
if nargout>1
   y=x(:,2:end);
   x=x(:,1);
end

return