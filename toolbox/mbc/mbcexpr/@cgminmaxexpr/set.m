function varargout = set(varargin)
%SET Cgminmaxexpr set method
%
%  OBJ = SET(OBJ, PROP, VAL...)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:12:52 $

if nargin == 1
    varargout{1} = i_ShowFields;
else
    m = varargin{1};
    
    if nargin < 3
        error('mbc:cgminmaxexpr:InvalidArgument', 'Insufficient arguments.');
    end
    
    for i = 2:2:nargin
        property = varargin{i};
        new_value = varargin{i+1};
        
        if ~ischar(property)
            error('mbc:cgminmaxexpr:InvalidArgument', 'Property name must be a string.');
        end
        
        switch lower(property)
            case 'ptrlist'
                if isa(new_value,'xregpointer')
                    m = setinputs(m, new_value);
                else
                    error('mbc:cgminmaxexpr:InvalidPropertyValue', 'Inputs must be an xregpointer.');
                end
            case 'type'
                if isnumeric(new_value) || islogical(new_value)
                    m.min = logical(new_value);
                else
                    error('mbc:cgminmaxexpr:InvalidPropertyValue', 'Type must be a numeric: 1 for min or 0 for max.');
                end
            otherwise
                error('mbc:cgminmaxexpr:InvalidPropertyName', ['Unknown property name: ''' property '''.']); 
        end
    end
    
    %If we are out here, then we should be able to set the property of the object.
    if nargout > 0
        varargout{1} = m;
    elseif ~isempty(inputname(1))
        assignin('caller' , inputname(1) , m);
    end
end

function out = i_ShowFields
%Simply returns a structure, the fieldnames of which are the set-able
%fields of the Value object, and the fields contain more details.
out.ptrlist = 'Vector of xregpointers to expressions';
out.type = 'numeric: 1 for min or 0 for max';
