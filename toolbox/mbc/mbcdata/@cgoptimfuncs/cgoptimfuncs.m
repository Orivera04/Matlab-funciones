function obj = cgoptimfuncs
%CGOPTIMFUNCS Interface to registered optimization functions
%
%  OBJ = CGOPTIMFUNCS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:50 $ 

s = struct('FunctionNames', {{}}, ...
    'FunctionFound', false(0,0));

obj = class(s, 'cgoptimfuncs');

obj = initfromprefs(obj);
obj = locatefunctions(obj);