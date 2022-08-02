function NF = fixxexpr(NF)
%FIXXEXPR Fix the Xexpr field
%
%  NF = FIXXEXPR(NF) makes sure that the input of the lookup table is a
%  pointer.  It may be an object if the lookup table has been loaded from
%  an older file.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 07:14:41 $ 

if isa(NF.Xexpr, 'cgnormaliser')
    NF.Xexpr = xregpointer(NF.Xexpr);
end