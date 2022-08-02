function [dy,sdy] = yinvdiff(m,y)
% MODEL/YINFDIFF derivative of y-inverse transformation wrt y

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:31 $

if ~isempty(m.yinv)
   yi= sym(m.yinv);
   yvar= findsym(yi);
   sdy= diff(yi,yvar);
   gdy= inline(sdy);
   if nargin==2
      dy= gdy(y);
   else
      dy= gdy;
   end
else
   dy= ones(length(y),1);
   sdy = '1';
end
