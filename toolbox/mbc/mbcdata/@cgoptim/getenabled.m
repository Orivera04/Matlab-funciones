function en = getenabled(obj)
%GETENABLED Get the current enabled status for the optimization
%
%  EN = GETENABLED(OBJ) returns whether this optimization is available to
%  be run.  The enable status of an optimization is set by the script
%  itself.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:53:20 $

en = obj.isenabled;