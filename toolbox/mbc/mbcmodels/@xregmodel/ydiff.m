function dy= ydiff(m,y)
% MODEL/YDIFF derivative of y transformation wrt y

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:28 $

if ~isempty(m.ytrans)
   yt= sym(m.ytrans);
   yvar= findsym(yt);
   gdy= diff(yt,yvar);
   gdy= inline(gdy);
   if nargin==2
      dy= gdy(y);
   else
      dy= gdy;
   end
else
   dy= ones(length(y),1);
end
      