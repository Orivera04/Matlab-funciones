function varargout = set(varargin)
%SET Standard set method
%
%  Sets the properties of the cgclipexpr object.
%
%  Usage: out = set(c , 'property_name', value)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:11 $

if nargin == 1
    varargout{1} = i_ShowFields;
else
    if nargin < 3
        error('mbc:cgclipexpr:InvalidArgument', 'Insufficient arguments.');
    end
    
    c = varargin{1};        
    for n = 2:2:nargin
        property = varargin{n};
        new_value = varargin{n+1};
        
        if ~ischar(property)
            error('mbc:cgclipexpr:InvalidArgument', 'Property name must be a string.');
        end
        
        switch lower(property)
            case 'bound'
                if ~isa(new_value , 'double')
                    error('mbc:cgclipexpr:InvalidPropertyValue', 'Bounds must be a double vector [min max].');
                end
                L = numel(new_value);
                if L~=2
                    error('mbc:cgclipexpr:InvalidPropertyValue', 'Bounds must be a double vector [min max].');
                end
                c.bound = new_value;
            case 'input'
                if isa(new_value,'xregpointer')
                    c = setinputs(c, new_value(1));
                else
                    error('mbc:cgclipexpr:InvalidPropertyValue', 'Input must be an xregpointer.');
                end
            otherwise
                error('mbc:cgclipexpr:InvalidPropertyName', ['Unknown property name: ''' property '''.']); 
        end
    end
    
    %If we are out here, then we should be able to set the property of the object.
    if nargout > 0
        varargout{1} = c;
    elseif ~isempty(inputname(1))
        assignin('caller' , inputname(1) , c);
    end    
end



function out = i_ShowFields
%Simply returns a structure, the fieldnames of which are the set-able
%fields of the Value object, and the fields contain more details.
out.bounds = 'double [min max]';
out.input = 'pointer to cgexpr';