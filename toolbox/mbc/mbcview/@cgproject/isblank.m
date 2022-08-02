function ret=isblank(PROJ)
%ISBLANK  Indicate whether a project is empty or not
%
%  RET = ISBLANK(P) returns true if the project appears to be an empty one.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:28:14 $

ret=1;
CH = children(PROJ);

% Check that only one node is present (variable dictionary)
if length(CH)~=1
   ret = 0;
   return
end

% check for items in data dictionary
D = getdd(PROJ);
if ~isempty(D.listptrs)
   ret = 0;
   return
end