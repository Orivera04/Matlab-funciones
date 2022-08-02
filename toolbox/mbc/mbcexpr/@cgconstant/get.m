function out = get(c, property)
%GET Cgconstant get method.
%
%  Gets the properties of the constant object.
%
%  Usage: get(c , 'property_name')

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:08:13 $

if nargin == 1
    out = get(c.cgvalue);
    out.prec = 'Instance of @cgprec';
else
    if ~ischar(property)
        error('mbc:cgconstant:InvalidArgument', 'Property name must be a string.');
    end
    switch lower(property)
        case 'values'
            out = get(c,'value');
        case 'type'
            out = 'Scalar Constant';
        case 'precision'
            out = c.prec;
        case 'setpoint'
            out = get(c,'value');
            out = out(1);
        otherwise
            try
                out=get(c.cgvalue,property);
            catch
                error('mbc:cgconstant:InvalidPropertyName', 'Unknown property name.'); 
            end
    end
end
