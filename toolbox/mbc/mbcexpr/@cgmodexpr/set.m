function varargout = set(varargin)
%SET cgmodexpr set method
%
%  Sets the properties of the model expression object.
%
%  Usage: M = SET(M , 'property_name' , property_value)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:26 $

if nargin == 1
    varargout{1} = i_ShowFields;   
else
    mod_object = varargin{1};
    if nargin < 3
        error('mbc:cgmodexpr:InvalidArgument', 'Insufficient arguments.');
    end
    
    for n = 2:2:nargin
        property = varargin{n};
        new_value = varargin{n+1};
        
        if ~ischar(property)
            error('mbc:cgmodexpr:InvalidArgument', 'Property name must be a string.');
        end
        
        switch lower(property)
            case 'expression'
                %The new expression must be a cell array containing an index
                %and a xregpointer to a new expression.
                s = size(new_value);
                if ~iscell(new_value) | (prod(s) ~= 2)
                    error('mbc:cgmodexpr:InvalidPropertyValue', 'Error in expression cell.');
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
                    error('mbc:cgmodexpr:InvalidPropertyValue', 'Incorrect data type in expression cell.');
                end
                
                %Now, check that the xregpointer is an xregpointer to an expression.
                if ~isa(exp_ptr.info , 'cgexpr')
                    error('mbc:cgmodexpr:InvalidPropertyValue', 'Xregpointer in cell array does not point to an expression object.');
                end
                
                if index > nfactors(mod_object)
                    error('mbc:cgmodexpr:InvalidPropertyValue', 'Attempting to set an expression outside of the number of required inputs.')
                end
                                
                mod_object = setinputs(mod_object, exp_ptr, index);
                
            case 'ptrlist'
                if ~isa(new_value , 'xregpointer')
                    error('mbc:cgmodexpr:InvalidPropertyValue', 'Cannot set a non-xregpointer to be the xregpointer list in a cgmodexpr');
                else
                    mod_object = setinputs(mod_object, new_value(:)');
                end
                
            case 'model'     
                %The new_value variable has to be an xregExportModel.
                if isa(new_value,'xregpointer')
                    mod_object.model = new_value.info;
                else
                    mod_object.model = new_value;
                end      
                
            case 'clips'
                if isa(new_value,'double') & length(new_value) == 2
                    if new_value(1) <=  new_value(2)
                        mod_object.clips = new_value;
                    end
                end        
            otherwise
                error('mbc:cgmodexpr:InvalidPropertyName', ['Unknown property name: ''' property '''.']);
        end
    end
    
    if nargout > 0
        varargout{1} = mod_object;
    elseif ~isempty(inputname(1))
        assignin('caller' , inputname(1) , mod_object);
    end
end



function out = i_ShowFields
%Simply returns a structure, the fieldnames of which are the set-able
%fields of the Value object, and the fields contain more details.
out.expression = '{1x2} cell array containing 1.Index to xregpointer list 2.cgexpr xregpointer.';
out.model = 'An xregExportModel object.';
out.ptrlist = 'A list of xregpointers to input expressions';
