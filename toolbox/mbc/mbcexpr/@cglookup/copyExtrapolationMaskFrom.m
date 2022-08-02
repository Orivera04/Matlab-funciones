function [obj, OK] = copyExtrapolationMaskFrom(obj, table)
%COPYEXTRAPOLATIONMASKFROM Copy the extrapolation mask from another table
%
%  [OBJ, OK] = COPYEXTRAPOLATIONMASKFROM(OBJ, TABLE) copies the
%  extrapolation mask from another table so long as the other table is the
%  same size as this table.  OK is set to true if the operation is
%  successful, false otherwise.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 07:10:08 $ 

OK = false;
mask = getExtrapolationMask(table);
if all(size(mask)==size(get(obj, 'values')))
    obj = pSetExtrapolationMask(obj, mask);
    OK = true;
end