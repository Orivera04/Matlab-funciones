function obj = linkDatakeyToTable(obj, datakey, varargin)
%LINKDATAKEYTOTABLE Add a table link to the specified datakeys
%
%  OBJ = LINKDATAKEYTOTABLE(OBJ, DATAKEY, R, C) links the specified vector
%  of datakeys to a specified list of table cells defined by (R, C).

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:38:28 $ 

L = uint32(sub2ind(obj.TableSize, varargin{:}));
idx = getIndexFromDatakey(obj, datakey);
Exists = (idx > 0);
obj.DataKeyTable(idx(Exists), 1) = L(Exists);
