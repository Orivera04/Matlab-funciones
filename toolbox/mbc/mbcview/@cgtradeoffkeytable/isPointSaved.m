function ret = isPointSaved(obj, Index)
%ISPOINTSAVED Check whether a datakey point has been saved
%
%  ISPOINTSAVED(OBJ) returns a logical vector the same length as the length
%  of the datakey table, containing true where the corresponding entry in
%  the datakey table has a SaveCounter value of greater than 0. 
%
%  ISPOINTSAVED(OBJ, INDEX) returns a vector the same length as INDEX.
%  SaveCounter values are checked only for the datakey entries specified in
%  INDEX.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:26 $ 

if nargin<2
    Index = 1:length(obj);
end
ret = obj.DataKeyTable(Index, 3)>0;
