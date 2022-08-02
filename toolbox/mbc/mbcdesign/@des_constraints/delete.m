function c= delete(c,index);
% DES_CONSTRAINTS/DELETE delete constraints
% 
%  c= delete(c,index);
%  c= delete(c,'all');

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:45 $

if ischar(index) & strcmp(index,'all')
   % delete all constraints
   c.Constraints={};
else
   c.Constraints(index)=[];
end
% reset interior points
c= reset(c);

