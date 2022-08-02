function ptrs = getsolutionitems(optim)
%GETSOLUTIONITEMS Return pointers to items that solutions are defined at
%
%  PTRS = GETSOLUTIONITEMS(OPTIM) returns a pointer array containing
%  pointers to the items that the solution data is being given for.  There
%  is an item for each column of data returned by GETSOLUTION and
%  GETPARETOSOLUTION.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:33 $ 

ptrs = optim.outputColumns;