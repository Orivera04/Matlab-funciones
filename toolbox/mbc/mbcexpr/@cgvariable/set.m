function varargout = set(varargin)
%SET set method.
%
%  Sets the properties (only one at the moment) of the value object.
%
%  Usage: set(value_obj , 'property_name' , property_value)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.1 $  $Date: 2004/02/09 07:16:58 $



%*****
%  This function is maintained for backwards compatibility.  Please use the
%  new setXYZ, getXYZ functions for accessing the fields of this object.
%*****



if nargin == 1
    varargout{1} = i_ShowFields;
else
    obj = varargin{1};
    if nargin < 3
        error('mbc:cgvariable:InvalidArgument', 'Insufficient arguments.');
    end
    
    for i = 2:2:nargin
        property = varargin{i};
        new_value = varargin{i+1};
        if ~ischar(property)
            error('mbc:cgvariable:InvalidArgument', 'Property name must be a string.');
        end
        
        switch lower(property)
        case 'value'
            [obj, ok, msg] = setvalue(obj, new_value);
            if ~ok
                error('mbc:cgvariable:InvalidPropertyValue', msg);
            end
        case 'setpoint'
            if isa(new_value,'double') & length(new_value)==1
                obj = setnomvalue(obj, new_value);
            end
        case 'descr'
            if ischar(new_value) || isempty(new_value)
                obj = setdescription(obj, new_value);
            else
                error('mbc:cgvariable:InvalidPropertyValue', 'Description must be a character array.');
            end
        otherwise
            error('mbc:cgvariable:InvalidPropertyName', 'Unknown property name: %s.', property);
        end
    end
    
    %If we are out here, then we should be able to set the property of the object.
    if nargout > 0
        varargout{1} = obj;
    elseif ~isempty(inputname(1))
        assignin('caller' , inputname(1) , obj);
    end
end



function out = i_ShowFields
%Simply returns a structure, the fieldnames of which are the set-able
%fields of the Value object, and the fields contain more details.

out.name = 'Char';
out.value= 'Double';
