function flgs = pGetFlags(obj, flagname)
%PGETFLAGS Return logical design point flags
%
%  FLAGS = PGETFLAGS(OBJ, FLAGNAME) returns the flags-per-design point that
%  are requested.  FLAGNAME can be one of 'FIXED' or 'DATA'.  FLG is a
%  logical vector the same length as the design indicating which points are
%  marked as true for the requested flag.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:07:31 $ 

bitmask = uint8(0);

allflagnames = {'FIXED', 'DATA'};
bitindex = strmatch(flagname, allflagnames, 'exact');

if isempty(bitindex)
    error('mbc:xregdesign:InvalidArgument', 'Flag name must be a valid flag.');
else
    bitmask = bitset(bitmask, bitindex);
    flgs = bitand(obj.designpointflags, bitmask)>0;
end
