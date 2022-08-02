function fl=iconfile(obj)
%ICONFILE  Return the filename of a bmp
%
%  FL=ICONFILE(OBJ) returns the filename of a bmp that should be used as an
%  icon for this expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 07:11:46 $

if isempty(obj)
    fl = 'cgemptytable.bmp';
else
    if all(all(get(obj,'values')==0))
        fl = 'cginittable.bmp';
    else
        fl = 'cgfulltable.bmp';
    end
end