function out = parsefunc(obj,b)
%@CGSLBLOCK\PARSEFUNC - return a handle to the parsing function for a block
%
%  OUT = CGSLBLOCK(cgslblock,blockHandle)
%  OUT - a function handle to a parsing function

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:15:43 $ 


[FOUND, index] = pfind( obj, b );

if FOUND
    out = obj(index).parsefunc;
else
    out = [];
end
    