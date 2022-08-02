function L=getlevel(T)
% GETLEVEL return the level of a tree node
%
%  L=GETLEVEL(T) returns the level of the tree node T.
%  The root node has level=0, it's children have level=1
%  and so on.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:48 $

% Created 23/8/00


if isvalid(T.Parent)
   % pass up a level
   L=getlevel(T.Parent.info)+1;
else
   % assume we're root
   L=0;
end
