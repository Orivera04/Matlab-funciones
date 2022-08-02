function [FOUND, objtype] = islibraryblock(obj,b)
%CGSLBLOCK\isLibraryBlock - is a given block recognized by CAGE
%
%  [OUT,OBJTYPE] = ISLIBRARYBLOCK(cgslblock,blockHandle)
%  blockHandle - Simulink block handle
%  OUT - logical denoting whether the block is recognized by CAGE
%  OBJTYPE - optional output, MBCEXPR which represents this block

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:15:41 $ 

[FOUND, index] = pfind( obj, b );
objtype = '';
if nargout==2 && FOUND
    objtype = obj(index).expr;
end
