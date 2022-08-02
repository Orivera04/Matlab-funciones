function property_value = get(obj, property_name);
% cgobjectivefunc/get 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:20 $

if nargin==1
    % just return structure
    property_value = struct(obj);
else
    switch upper(property_name)
    case 'NAME'
        property_value = getname(obj);
    case 'MINSTR'
        property_value = obj.minstr;
    case 'CANSWITCHMINMAX'
        property_value = obj.canswitchminmax;
    case 'MODPTR'
        property_value = obj.modptr;
    otherwise
        error('Unknown property name');
    end
end
