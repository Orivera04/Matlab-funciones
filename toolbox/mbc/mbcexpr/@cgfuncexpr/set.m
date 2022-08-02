function varargout = set(varargin)
%SET Cgfuncexpr set method
%
%  Sets the properties of the function expression objects.
%
%  Usage: set(funcexpr_obj , 'property_name' , property_value)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:11:05 $

if nargin == 1
    varargout{1} = i_ShowFields;   
else
    func_object = varargin{1};
    if nargin < 3
        error('mbc:cgfuncexpr:InvalidArgument', 'Insufficient arguments.');
    end
    
    for i = 2:2:nargin
        
        property = varargin{i};
        new_value = varargin{i+1};
        
        if ~ischar(property)
            error('mbc:cgfuncexpr:InvalidArgument', 'Property name must be a string.');
        end
        
        switch lower(property)
            case 'expression'
                %The new expression must be a cell array containing an index
                %and a xregpointer to a new expression.
                s = size(new_value);
                if ~iscell(new_value) || (prod(s) ~= 2)
                    error('mbc:cgfuncexpr:InvalidPropertyValue', 'Error in expression cell.');
                end
                
                t1 = new_value{1};
                t2 = new_value{2};
                
                if isa(t1 , 'double') & isa(t2 , 'xregpointer')
                    index = t1;
                    exp_ptr = t2;
                elseif isa(t1 , 'xregpointer') & isa(t2 , 'double')
                    index = t2;
                    exp_ptr = t1;
                else
                    error('mbc:cgfuncexpr:InvalidPropertyValue', 'Incorrect data type in expression cell.');
                end
                
                if index > nfactors(func_object)
                    error('mbc:cgfuncexpr:InvalidIndex', ...
                        'Attempting to set an expression outside of the number of required inputs.')
                end
                
                func_object = setinputs(func_object, exp_ptr, index);
                
            case 'ptrlist'
                if isa(new_value , 'xregpointer')
                    func_object = setinpute(func_object, new_value);
                else
                    error('mbc:cgfuncexpr:InvalidPropertyValue', 'Inputs must be an xregpointer.');
                end
                
            case 'function'
                %The new_value variable has to be a funcmod.
                if isa(new_value , 'cgfuncmodel')
                    func_object.function = new_value;
                else
                    error('mbc:cgfuncexpr:InvalidPropertyValue', 'Function must be a cgfuncmodel object.');
                end
            otherwise
                error('mbc:cgfuncexpr:InvalidPropertyName', 'Unknown property name.');
        end
    end
    
    %If we are out here, then we should be able to set the property of the object.
    if nargout > 0
        varargout{1} = func_object;
    elseif ~isempty(inputname(1))
        assignin('caller' , inputname(1) , func_object);
    end
    
end

function out = i_ShowFields
%Simply returns a structure, the fieldnames of which are the set-able
%fields of the Value object, and the fields contain more details.
out.expression = '{1x2} cell array containing 1.Index to xregpointer list 2.cgexpr xregpointer.';
out.model = 'An function cgexpr object.';
