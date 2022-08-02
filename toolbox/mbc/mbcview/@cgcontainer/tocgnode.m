function nd = tocgnode(obj)
%TOCGNODE Convert to a cgnode object
%
%  ND = TOCGNODE(CONTAINER) returns the parent cgnode from the cgcontainer.
%  Warning: please do not use this method in an attempt to circumvent any
%  cgcontainer overloaded functionality.  This method is not intended for
%  that purpose.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:22:03 $ 

nd = obj.cgnode;
