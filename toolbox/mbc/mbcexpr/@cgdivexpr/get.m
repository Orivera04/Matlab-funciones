function out = get(d , property)
%GET Standard get method
%
%  Gets the properties of the div_expr object.
%
%  Usage: get(div_obj) returns property list
%		  get(div_obj , 'property_name') returns value of property

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:09:40 $

if nargin == 1
    out.Top='ptr(s) to numerator';
    out.TopName='numerator namestring';
    out.Bottom='ptr(s) to denominator';
    out.BottomName='denominator namestring';
    out.Type='Description string for GUI';
elseif nargin==2
    
    if ~ischar(property)
        error('mbc:cgdivexpr:InvalidArgument', 'Property name must be a string.');
    end
    out='';
    switch lower(property)
        case 'top'
            inputs = getinputs(d);
            out = inputs(1:d.NTop);
        case 'topname'
            if d.NTop>0
                inputs = getinputs(d);
                subchars = pveceval(inputs(1:d.NTop), 'getname');
                out = sprintf('%s*', subchars{:});
                if d.NTop>1
                    out = ['(', out];
                    out(end) = ')';
                else
                    out = out(1:end-1);
                end
            else
                out = '';
            end
        case 'bottom'
            if d.NBottom
                inputs = getinputs(d);
                out = inputs(d.NTop+1:end);
            else
                out = null(xregpointer,0);
            end
        case 'bottomname'
            if d.NBottom>0
                inputs = getinputs(d);
                subchars = pveceval(inputs(d.NTop+1:end), 'getname');
                out = sprintf('%s*', subchars{:});
                if d.NBottom>1
                    out = ['(', out];
                    out(end) = ')';
                else
                    out = out(1:end-1);
                end
            else
                out = '';
            end            
        case 'type'
            out='Division/Product';
        otherwise
            error('mbc:cgdivexpr:InvalidPropertyName', 'Unknown property name.'); 
    end
else
    error('mbc:cgdivexpr:InvalidArgument', 'Wrong number of arguments.');
end