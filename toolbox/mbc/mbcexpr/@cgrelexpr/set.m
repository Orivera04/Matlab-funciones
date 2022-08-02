function varargout = set(varargin)
%SET Standard set method
%
%  Sets the properties of the if expression object.
%
%  Usage: set(relexp , 'property_name' , property_value)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.1 $  $Date: 2004/02/09 07:15:21 $

if nargin == 1
    varargout{1} = i_ShowFields;   
else
    relexp = varargin{1};
    if nargin < 3
        error('mbc:cgrelexpr:InvalidArgument', 'Insufficient arguments.');
    end
    
    for n = 2:2:nargin
        property = varargin{n};
        new_value = varargin{n+1};
        
        if ~ischar(property)
            error('mbc:cgrelexpr:InvalidArgument', 'Property name must be a string.');
        end
        
        switch lower(property)
            case 'left'
                %Check to see that the new name is a xregpointer to an expression.
                if ~isa(new_value , 'xregpointer')
                    error('mbc:cgrelexpr:InvalidPropertyValue', 'Input must be an xregpointer.');
                end
                relexp = setinputs(relexp, new_value, 1);
                
            case 'right'
                %Check to see that the new name is a xregpointer to a value.
                if ~isa(new_value , 'xregpointer')
                    error('mbc:cgrelexpr:InvalidPropertyValue', 'Input must be an xregpointer.');
                end
                relexp = setinputs(relexp, new_value, 2);
                
            case 'rel'
                %Check to see that the new name is a xregpointer to a value.
                if ~ischar(new_value)
                    error('mbc:cgrelexpr:InvalidPropertyValue', 'The relation must be a string.');
                end
                if isempty(strmatch(new_value,{'==','~=','>','<','>=','<='}))
                    error('mbc:cgrelexpr:InvalidPropertyValue', 'The relation must be one of ==, ~=, >, <, >=, <=.');
                end
                relexp.rel = new_value;    
                
            otherwise
                error('mbc:cgrelexpr:InvalidPropertyName', ['Unknown property name: ''' property '''.']);
        end
    end
    
    %If we are out here, then we should be able to set the property of the object.
    if nargout > 0
        varargout{1} = relexp;
    elseif ~isempty(inputname(1))
        assignin('caller' , inputname(1) , relexp);
    end
end

function out = i_ShowFields
%Simply returns a structure, the fieldnames of which are the set-able
%fields of the Value object, and the fields contain more details.
out.left = 'Left hand side argument';
out.right = 'Right hand side argument';
out.rel = 'One of ==,~=,>,<,>=,<=';
