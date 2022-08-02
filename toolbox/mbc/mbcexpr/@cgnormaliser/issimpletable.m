function ret = issimpletable(T)
%ISSIMPLETABLE Check if table is simply connected
%
%  OUT = ISSIMPLETABLE(T) returns true if the table is simply connected to
%  an input value.  False is returned if there are any more complex
%  expressions connected downstream.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:14:08 $ 

xval = get(T, 'x');

if xval.isddvariable
    ret = true;
else
    ret = false;
end