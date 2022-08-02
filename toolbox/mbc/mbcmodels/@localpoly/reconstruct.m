function [y,p]= reconstruct(m,Yrf,x,dat);
%RECONSTRUCT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:40:42 $

p= Yrf/delG(m)';

y= zeros(size(Yrf,1),1);
if size(p,1)==size(x,1)
   for i= 1:size(y,1) 
      y(i) = polyval_mex(p(i,:), x(i) ) ;
   end
else
   y = polyval_mex(p, x ) ;
end
