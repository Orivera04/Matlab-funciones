function obj = remapkeys(obj, oldkeys, newkeys)
%REMAPKEYS Map values from old keys to new ones
%
%  OBJ = REMAPKEYS(OBJ, OLDKEYS, NEWKEYS) moves any data that is stored
%  against a key in OLDKEYS and moves it to being stored against the
%  corresponding key in NEWKEYS. 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 06:45:31 $ 

for n = 1:length(obj.KeyList)
    keymatched = (obj.KeyList(n)==oldkeys);
    if any(keymatched)
        obj.KeyList(n) = newkeys(keymatched);
    end
end