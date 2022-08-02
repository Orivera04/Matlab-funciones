function varargout = set(varargin)
%SET Cgsubexpr set method
%
%  set(s) returns list of properties which can be set.
%  s=set(s,'property',value,....) returns the object with properties reset
%  to the values given.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:53 $

if nargin == 1
    varargout{1} = i_ShowFields;
else
    sub_object = varargin{1};
    
    if nargin < 3
        error('mbc:cgsubexpr:InvalidArgument', 'Insufficient arguments.');
    end
    
    for i = 2:2:nargin
        property = varargin{i};
        new_value = varargin{i+1};
        
        if ~ischar(property)
            error('mbc:cgsubexpr:InvalidArgument', 'Property name must be a string.');
        end
        
        switch lower(property)
            case 'left'
                if isa(new_value, 'xregpointer')
                    old_inputs = getinputs(sub_object);                  
                    if sub_object.NRight>0
                        sub_object = setinputs(sub_object, [new_value(:)', old_inputs(sub_object.NLeft+1:end)]);
                    else
                        sub_object = setinputs(sub_object, new_value(:)');
                    end
                    sub_object.NLeft = length(new_value);
                else
                    error('mbc:cgsubexpr:InvalidPropertyValue', 'Left inputs must be an xregpointer.');
                end
            case 'right'
                if isa(new_value, 'xregpointer')
                    old_inputs = getinputs(sub_object);                  
                    if sub_object.NLeft>0
                        sub_object = setinputs(sub_object, [old_inputs(1:sub_object.NLeft), new_value(:)']);
                    else
                        sub_object = setinputs(sub_object, new_value(:)');
                    end
                    sub_object.NRight = length(new_value);
                else
                    error('mbc:cgsubexpr:InvalidPropertyValue', 'Right inputs must be an xregpointer.');
                end                
                
            otherwise
                error('mbc:cgsubexpr:InvalidPropertyName', 'Unknown property name.'); 
        end
    end
    
    if nargout > 0
        varargout{1} = sub_object;
    elseif ~isempty(inputname(1))
        assignin('caller' , inputname(1) , sub_object);
    end
end

function out = i_ShowFields
%Simply returns a structure, the fieldnames of which are the set-able
%fields of the Value object, and the fields contain more details.
out.left = 'Pointer to an cgexpr object';
out.right = 'Pointer to an cgexpr object';
