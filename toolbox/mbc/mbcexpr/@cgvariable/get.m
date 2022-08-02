function out = get(obj , property)
%GET get method.
%
%  Gets the properties of the object.
%
%  Usage: get(value_obj , 'property_name')

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.6.1 $  $Date: 2004/02/09 07:16:35 $



%*****
%  This function is maintained for backwards compatibility.  Please use the
%  new setXYZ, getXYZ functions for accessing the fields of this object.
%*****



if ~isa(property , 'char')
    error('mbc:cgvariable:InvalidPropertyName', 'Property name must be a string.');
end

switch property
case {'value','values'}
    out = getvalue(obj);
    
case 'type'
    out = 'Parameter';
    
case 'descr'
    out = getdescription(obj);
    
case 'setpoint'
    out = getnomvalue(obj);
    
case 'range'
    % Backwards compatibility addition
    out = repmat(getnomvalue(obj), 1,2);
    
otherwise
    error('mbc:cgvariable:InvalidPropertyName', 'Unknown property name: %s.', property);
    
end