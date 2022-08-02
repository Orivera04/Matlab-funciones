function fl=iconfile(obj)
%ICONFILE  Return the filename of a bmp
%
%  FL=ICONFILE(OBJ) returns the filename of a bmp that should be used as an
%  icon for this expression.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 07:13:14 $

if isa(obj.model, 'cgfuncmodel')
    fl = 'functionmodel.bmp';
elseif isa(obj.model, 'cgexprmodel')
    fl = 'featuremodel.bmp';
else
    fl = 'cgmodelnode.bmp';
end