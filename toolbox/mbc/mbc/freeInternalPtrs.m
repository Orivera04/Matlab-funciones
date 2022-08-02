function obj = freeInternalPtrs(obj)
%FREEINTERNALPTRS free all internal resources contained an object
%
%  FREEINTERNALPTRS(OBJ)
%  
%  This method allows resources to be freed that might not be freed by
%  freeptrs. Currently this is only used by sweepsetfilter, but may be
%  expanded in the future.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:48:28 $ 

