function paraminfo = getParameters(obj)
%GETPARAMETERS Return information about the optimization parameters.
%   GETPARAMETERS(OPTIONS) returns a structure array containing information
%   about the parameters that have been defined for the optimization.
%   Parameter information is returned in a structure with fields label,
%   typestr and value.  See the help for ADDPARAMETER for more information
%   on these fields.
%
%   See also CGOPTIMOPTIONS/ADDPARAMETER, CGOPTIMSTORE/GETPARAM.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:52:51 $

paraminfo = obj.parameters;