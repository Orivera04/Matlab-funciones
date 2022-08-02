function [ti,type]= TypeIndex(c,index);
%TYPEINDEX

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:01:39 $



if index<= size(c.A,1)
   ti= index;
   type= 1;
elseif index<= size(c.A,1)+length(c.Table)
   ti= index- size(c.A,1);
   type= 2;
elseif index<= size(c.A,1)+length(c.Table)+length(c.Ellipsoid)
   ti = index - size(c.A,1)-length(c.Table);
   type=3;
else
   ti = index - size(c.A,1)-length(c.Table)-length(c.Ellipsoid);
   type=4;
end
