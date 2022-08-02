function fl=iconfile(obj)
%ICONFILE  return the filename of a bmp
%
%  FL=ICONFILE(OBJ) returns the filename of a bmp that should
%  be used as an icon for this node.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:24:27 $

fl = iconfile(info(getdata(obj)));