function obj = pSetFlags(obj, flagname, flgs)
%PSETFLAGS Set new logical flags for design points
%
%  OBJ = PSETFLAGS(OBJ, FLAGNAME, FLAGS) sets the logical vector FLAGS as
%  the new setting for the named flag. 
%
%  See Also: PGETFLAGS.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:07:32 $ 


bitmask = uint8(0);

allflagnames = {'FIXED', 'DATA'};
bitindex = strmatch(flagname, allflagnames, 'exact');

if isempty(bitindex)
    error('mbc:xregdesign:InvalidArgument', 'Flag name must be a valid flag.');
else
    obj.designpointflags(flgs) = bitset(obj.designpointflags(flgs), bitindex, 1);
    obj.designpointflags(~flgs) = bitset(obj.designpointflags(~flgs), bitindex, 0);
end
