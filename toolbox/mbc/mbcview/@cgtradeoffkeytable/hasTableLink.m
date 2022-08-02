function ret = hasTableLink(obj, Index)
%HASTABLELINK Check whether table entries have table links
%
%  HASTABLELINK(OBJ) returns a logical vector the same length as the length
%  of the datakey table, containing true where the corresponding entry in
%  the datakey table has a valid table link.
%
%  HASTABLELINK(OBJ, INDEX) returns a vector the same length as INDEX.
%  Valid table links are checked only for the datakey entries specified in
%  INDEX.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:24 $ 

if nargin<2
    Index = 1:length(obj);
end
ret = obj.DataKeyTable(Index, 1)>0;
