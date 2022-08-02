function OF= loadobj(OF);
%LOADOBJ Load-time actions for object
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $    $Date: 2004/02/09 06:50:26 $

if isstruct(OF)
    % Order of fields in old object is wrong too, so create new structure
    OF = struct('name', getname(OF.cgexpr), ...
        'minstr',OF.minstr, ...
        'canswitchminmax', 0, ...
        'modptr', OF.modptr, ...
        'version', 1);
end

% Enter future version updates here



if isstruct(OF)
    % Convert to object
    OF = cgobjectivefunc(OF);
end	