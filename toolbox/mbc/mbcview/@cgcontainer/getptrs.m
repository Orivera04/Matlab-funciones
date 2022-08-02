function p= getptrs(nd);
% CGCONTAINER/GETPTRS list of internal pointers 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:21:57 $


p=getptrs(nd.cgnode);
if isa(nd.data,'xregpointer');
   p= [p, nd.data, getptrs(info(nd.data)).'];
else
   p= [p, getptrs(nd.data).'];
end