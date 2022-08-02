function T= AssignChildren(T,ch);
% MCTREE/ASSIGNCHILDREN

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:47:30 $

T.Children= ch;
xregpointer(T);
