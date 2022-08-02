function obj = linspace(obj, Npoints)
%LINSPACE Set value to be a linearly spaced vector
%
%  OBJ = LINSPACE(OBJ, NPOINTS) sets OBJ to have a value that is a vector
%  containing NPOINTS linearly spaced betweed the minimum and maximum of
%  OBJ's range.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:16:18 $ 

rng = getrange(obj);
vals = linspace(rng(1), rng(2), Npoints);
obj = setvalue(obj, vals);