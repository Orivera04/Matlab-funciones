function opptinfo = getOperatingPointSets(obj)
%GETOPERATINGPOINTSETS Return information about the optimization operating point sets.
%   GETOPERATINGPOINTSETS(OPTIONS) returns a structure array of information
%   regarding the optimization operating point sets.  The structure has two
%   fields, label and vars.  See the help for ADDOPERATINGPOINTSET for more
%   information on these fields.
%
%   See also CGOPTIMOPTIONS/ADDOPERATINGPOINTSET, 
%            CGOPTIMOPTIONS/SETOPERATINGPOINTSMODE, 
%            CGOPTIMOPTIONS/GETOPERATINGPOINTSMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.5.6.1 $    $Date: 2004/02/09 06:52:49 $

opptinfo = obj.operatingpoints.details;