function varargout = set(varargin)
%SET Standard set method
%
%	SET(d) returns list of properties which can be set.
%	d = SET(d,'property',value,....) returns the object with properties
%	reset to the values given.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:09:43 $


if nargin == 1 
    varargout{1} = i_ShowFields; 
else
    
    div_object = varargin{1};
    
    if nargin < 3
        error('mbc:cgdivexpr:InvalidArgument', 'Insufficient arguments.');
    end
    
    for i = 2:2:nargin
        
        property = varargin{i};
        new_value = varargin{i+1};
        
        if ~ischar(property)
            error('mbc:cgdivexpr:InvalidArgument', 'Property name must be a string.');
        end
        
        switch lower(property)
            case 'top'
                if isa(new_value, 'xregpointer')
                    old_inputs = getinputs(div_object);                  
                    if div_object.NBottom>0
                        div_object = setinputs(div_object, [new_value(:)', old_inputs(div_object.NTop+1:end)]);
                    else
                        div_object = setinputs(div_object, new_value(:)');
                    end
                    div_object.NTop = length(new_value);
                else
                    error('mbc:cgdivexpr:InvalidPropertyValue', 'Top inputs must be an xregpointer.');
                end
            case 'bottom'
                if isa(new_value, 'xregpointer')
                    old_inputs = getinputs(div_object);                  
                    if div_object.NTop>0
                        div_object = setinputs(div_object, [old_inputs(1:div_object.NTop), new_value(:)']);
                    else
                        div_object = setinputs(div_object, new_value(:)');
                    end
                    div_object.NBottom = length(new_value);
                else
                    error('mbc:cgdivexpr:InvalidPropertyValue', 'Bottom inputs must be an xregpointer.');
                end                

            otherwise
                error('mbc:cgdivexpr:InvalidPropertyName', 'Unknown property name.'); 
        end
    end
    
    if nargout > 0
        varargout{1} = div_object;
    elseif ~isempty(inputname(1))
        assignin('caller' , inputname(1) , div_object);
    end
    
end

function out = i_ShowFields
%Simply returns a structure, the fieldnames of which are the set-able
%fields of the object, and the fields contain more details.
out.top = 'xregpointer(s) to cgexpr objects';
out.bottom = 'xregpointer(s) to cgexpr objects';
