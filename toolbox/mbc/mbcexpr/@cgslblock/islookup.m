function [out] = islookup(obj,b)
%@CGSLBLOCK\ISLOOKUP - is a given block a lookuptable type
%
%  OUT = ISLOOKUP(cgslblock,blockHandle)
%  OUT - logical denoting whether the given block is a lookuptable type
%  block

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/04/04 03:27:45 $ 
[isSupported,objtype] = islibraryblock(obj,b);
if isSupported
    out = ismember(objtype,{'cglookuptwo','cgnormfunction','cglookupone','cgnormaliser'});
end