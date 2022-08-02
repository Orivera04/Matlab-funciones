function varargout = set(varargin)
%SET Cgconstant set method.
%
%  Sets the properties (only one at the moment) of the Constant object.
%
%  Usage: set(c , 'property_name' , property_value)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:23 $

if nargin == 1 
    varargout{1} = set(cgvalue);
else 
    c = varargin{1}; 
    if nargin < 3
        error('mbc:cgconstant:InvalidArgument', 'Insufficient arguments.');
    end
    for n = 2:2:nargin 
        property = varargin{n};
        new_value = varargin{n+1};
        if ~ischar(property)
            error('mbc:cgconstant:InvalidArgument', 'Property name must be a string.');
        end
        switch lower(property)
            case 'value'
                if ~isa(new_value,'double')
                    error('mbc:cgconstant:InvalidPropertyValue', 'Constant must be a scalar double.');
                else
                    new_value = resolve(c.prec,new_value);
                    c.cgvalue = set(c.cgvalue,property,new_value);
                end
            case 'precision'
                if ~isa(new_value,'cgprec')
                    error('mbc:cgconstant:InvalidPropertyValue', 'Precision must be an instance of @precision.');
                else
                    c.prec = new_value;
                end
            otherwise
                try
                    c.cgvalue=set(c.cgvalue,property,new_value);
                catch
                    error('mbc:cgconstant:InvalidPropertyName', 'Unknown property name.'); 
                end
        end
    end
    if nargout > 0
        varargout{1} = c;
    elseif ~isempty(inputname(1))
        assignin('caller' , inputname(1) , c);
    end
end
