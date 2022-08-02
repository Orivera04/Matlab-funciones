function portptrs = getsource(obj)
%GETSOURCE Return the source items of an expression
%
%  OUT = GETSOURCE(IN) returns the items which are sources of values and
%  have no inputs.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:08:51 $ 

portptrs = recursivefind(obj, @issource);