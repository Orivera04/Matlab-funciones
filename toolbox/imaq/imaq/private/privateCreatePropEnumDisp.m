function enumDispStr = privateCreatePropEnumDisp(propertyName, enums, default)
% PRIVATECREATEENUMDISP Create a display string for a property's enums.
%   
%    PRIVATECREATEENUMDISP(NAME, ENUMS, DEFAULT) creates a display of 
%    all the enumerated values, ENUMS, for property name NAME in the 
%    following format:
%
%                 [ enum1 | enum2 | {enum3} ]
%
%    The default enum value, DEFAULT is indicated by {} braces.
%
%    If property NAME does not have a fixed set of property values, a 
%    message indicating this is returned instead.
%
%    NAME is assumed to be the fully qualified property name. Therefore, the 
%    property name is case sensitive and name completion is not performed.
%  

%    CP 1-20-2002
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:06:09 $

Nenums = length(enums);
if Nenums==0,
    % No enums available.
    % Return the appropriate text.
    if isempty(findstr('Fcn ', [propertyName ' '])),
        enumDispStr = ['The ''', propertyName, ...
                ''' property does not have a fixed set of property values.'];
    else
        enumDispStr = 'string -or- function handle -or- cell array';
    end
else
    % Create body: "[ append | index | overwrite |"
    % Then replace | with end bracket: "[ append | index | overwrite ]"
    % The add {} brackets around default value.
    enumDispStr = ['[' sprintf(' %s |', enums{:}) ];
    enumDispStr(end) = ']';    
    enumDispStr = strrep(enumDispStr, [' ' default ' '], [' {' default '} ']);
end