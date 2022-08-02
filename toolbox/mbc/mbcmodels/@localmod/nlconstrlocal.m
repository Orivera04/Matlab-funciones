function [c,ceq]= nlconstrlocal(B,L,DATA,Wc,Scale,c0,varargin);
% LOCALMOD/NLCONSTRLOCAL nlonlinear constraints for local regression

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:39:28 $


B= reshape(B,size(L,1),size(DATA,3));
if nargin>4
   B= Scale*B;
end

c= cell(size(DATA,3),1);
for i=1:size(DATA,3);
   d= DATA{i};
   Xs= d(:,1:end-1);
   Ys= d(:,end);
   L= update(L,B(:,i));   
   c{i}= nlconstraints(L,Xs,Ys,varargin{:});
end
c= cat(1,c{:});
ceq=[];