function varargout = set(varargin)
%SET set method.
%
%  Sets the properties (only one at the moment) of the value object.
%
%  Usage: set(value_obj , 'property_name' , property_value)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.2 $  $Date: 2004/02/09 07:16:20 $



%*****
%  This function is maintained for backwards compatibility.  Please use the
%  new setXYZ, getXYZ functions for accessing the fields of this object.
%*****



if nargin == 1
    varargout{1} = i_ShowFields;   
else
    value_object = varargin{1};
    if nargin < 3
        error('mbc:cgvalue:InvalidArgument', 'Insufficient arguments.');
    end
    
    for i = 2:2:nargin
        
        property = varargin{i};
        new_value = varargin{i+1};
        
        if ~ischar(property)
            error('mbc:cgvalue:InvalidArgument', 'Property name must be a string.');
        end
        
        switch lower(property)
        case 'range'
            value_object = setrange(value_object, new_value);            
            
        otherwise
            value_object.cgvariable = set(value_object.cgvariable, property, new_value);
            
        end
    end
    
    %If we are out here, then we should be able to set the property of the object.
    if nargout > 0
        varargout{1} = value_object;
    elseif ~isempty(inputname(1))
        assignin('caller' , inputname(1) , value_object);
    end
    
end

function out = i_ShowFields

%Simply returns a structure, the fieldnames of which are the set-able
%fields of the Value object, and the fields contain more details.

out.name = 'Char';
out.value= 'Double';
