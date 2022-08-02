function out = get(m , property)
%GET cgmswitchexpr get method
%
%  Gets the properties of the cgMSwitch_expr object.
%
%  Usage: get(MSwitch_obj)	returns property list
%		  get(MSwitch_obj , 'property_name') returns value of property

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:13:33 $

if nargin == 1
    out.Input='ptr to input';
    out.List='vector of xregpointers for the switch inputs';
    out.Type='Description string for GUI';
elseif nargin==2
    
    if ~ischar(property)
        error('mbc:cgmswitchexpr:InvalidArgument', 'Property name must be a string.');
    end
    out='';
    switch lower(property)
        case 'input'
            inputs = getinputs(m);
            out = inputs(1);
        case 'list'
            inputs = getinputs(m);
            if length(inputs)>1
                out = inputs(2:end);
            else
                out = null(xregpointer, 0);
            end
        case 'type'
            out='Multi Port Switch';
        otherwise
            error('mbc:cgmswitchexpr:InvalidPropertyName', ['Unknown property name: ''' property '''.']);
    end
else
    error('mbc:cgmswitchexpr:InvalidArgument', 'Wrong number of inputs.');
end
