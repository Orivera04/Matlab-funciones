function property_value = get(obj, property_name);
% cgobjectivefunc/get 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:50:38 $

if nargin==1
    % just return structure
    property_value = struct(obj);
else
    switch upper(property_name)
    case 'NAME'
        property_value = getname(obj);
    case 'MINSTR'
        property_value = get(obj.cgobjectivefunc, 'minstr');
    case 'CANSWITCHMINMAX'
        property_value = get(obj.cgobjectivefunc,'canswitchminmax');
    case 'MODPTR'
        property_value = get(obj.cgobjectivefunc,'modptr');
    case 'OPPOINT'
        property_value = obj.oppoint;
    case 'WEIGHTS'
        property_value = obj.weights;
    otherwise
        error('Unknown property name');
    end
end
