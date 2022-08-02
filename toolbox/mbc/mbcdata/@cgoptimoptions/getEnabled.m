function en = getEnabled(obj)
%GETENABLED Get the current enabled status for the optimization.
%   EN = GETENABLED(OPTIONS) returns whether this user-defined optimization
%   is available to be run. EN will be set to true or false.  When an
%   optimization is disabled, the user will still be able to register it
%   with CAGE but will not be allowed to create new optimizations using it.
%
%   See also CGOPTIMOPTIONS/SETENABLED.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:52:41 $

en = obj.enabled;