function out = get(value_object , property)
%GET get method.
%
%  Gets the properties of the value object.
%
%  Usage: get(value_obj , 'property_name')

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:16:14 $



%*****
%  This function is maintained for backwards compatibility.  Please use the
%  new setXYZ, getXYZ functions for accessing the fields of this object.
%*****



if nargin == 1
    out.value = 'scalar or vector double';
    out.name = 'char name of object';
    out.type = 'char description of class';
	out.descr = 'Text description of the variable';
    out.setpoint = 'the set point or nominal value';
else
    if ~ischar(property)
        error('mbc:cgvalue:InvalidPropertyName', 'Property name must be a string.');
    end
    
    switch property
        case 'range'
            out = getrange(value_object);
            
        case 'type'
            out = 'Variable';
            
        otherwise
            out = get(value_object.cgvariable, property);
            
    end
end
