function objinfo = getObjectives(obj)
%GETOBJECTIVES Return information about the optimization objectives.
%   OBJINFO = GETOBJECTIVES(OPTIONS) returns a structure array of
%   information regarding the optimization objective functions.
%   OBJINFO(i).label contains the label for the i-th objective.  A string
%   defining the type of the i-th objective ('max, 'min', 'min/max' or
%   'helper') is stored in OBJINFO(i).type.
%
%   See also CGOPTIMOPTIONS/ADDOBJECTIVE, CGOPTIMOPTIONS/SETOBJECTIVESMODE,
%            CGOPTIMOPTIONS/GETOBJECTIVESMODE.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:52:47 $

objinfo = obj.objectives.details;
