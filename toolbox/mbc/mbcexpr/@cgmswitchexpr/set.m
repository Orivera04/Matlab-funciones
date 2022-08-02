function varargout = set(varargin)
%SET Cgmswitchexpr set method
%
%	SET(d) returns list of properties which can be set.
%	d=SET(d,'property',value,....) returns the object with properties reset
%	to the values given.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:13:37 $

if nargin == 1 
    varargout{1} = i_ShowFields; 
else
    obj = varargin{1};
    
    if nargin < 3
        error('mbc:cgmswitchexpr:InvalidArgument', 'Insufficient arguments.');
    end
    
    for i = 2:2:nargin
        property = varargin{i};
        new_value = varargin{i+1};
        
        if ~ischar(property)
            error('mbc:cgmswitchexpr:InvalidArgument', 'Property name must be a string.');
        end
        
        switch lower(property)
            case 'input'
                obj = setinputs(obj,new_value,1);
            case 'list'
                inp = getinputs(obj);
                obj = setinputs(obj, [inp(1), new_value(:)']);
            otherwise
                error('mbc:cgmswitchexpr:InvalidPropertyName', ['Unknown property name: ''' property '''.']);
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
out.Input = 'xregpointer to input expression';
out.List = 'Vector of xregpointers to Switch input expressions';
