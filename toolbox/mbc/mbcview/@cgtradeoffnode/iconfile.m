function fl=iconfile(obj)
%ICONFILE Return the filename of a bmp
%
%  FL=ICONFILE(OBJ) returns the filename of a bmp that should
%  be used as an icon for this node.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:37:51 $

if isempty(obj.Tables)
    fl = 'cgemptytradeoff.bmp';
else
    fl = 'cgfulltradeoff.bmp';
end