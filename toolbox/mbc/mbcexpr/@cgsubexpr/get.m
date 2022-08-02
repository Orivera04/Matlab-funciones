function out = get(s , property)
%GET Cgsubexpr get method
%
%  Gets the properties of the subexpr object.
%
%  Usage: get(add_obj , 'property_name')

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:15:50 $

if nargin==1
    out.Left = 'Pointer to an cgexpr object';
    out.LeftName = 'name of the left cgexpr';
    out.Right = 'Pointer to an cgexpr object';
    out.RightName = 'name of the right cgexpr';
    out.type = 'Description string for GUI';
elseif nargin == 2
    if ~ischar(property)
        error('mbc:cgsubexpr:InvalidArgument', 'Property name must be a string.');
    end
    out='';
    switch lower(property)
        case 'left'
            inputs = getinputs(s);
            out = inputs(1:s.NLeft);
        case 'leftname'
            if s.NLeft>0
                inputs = getinputs(s);
                subchars = pveceval(inputs(1:s.NLeft), 'getname');
                out = sprintf('%s+', subchars{:});
                if s.NLeft>1
                    out = ['(', out];
                    out(end) = ')';
                else
                    out = out(1:end-1);
                end
            else
                out = '';
            end
        case 'right'
            if s.NRight
                inputs = getinputs(s);
                out = inputs(s.NLeft+1:end);
            else
                out = null(xregpointer,0);
            end
        case 'rightname'
            if s.NRight>0
                inputs = getinputs(s);
                subchars = pveceval(inputs(s.NLeft+1:end), 'getname');
                out = sprintf('%s+', subchars{:});
                if s.NRight>1
                    out = ['(', out];
                    out(end) = ')';
                else
                    out = out(1:end-1);
                end
            else
                out = '';
            end 
        case 'type'
            out = 'Addition/Subtraction';
        otherwise
            error('mbc:cgsubexpr:InvalidPropertyName', 'Unknown property name.');
    end
else
    error('mbc:cgsubexpr:InvalidArgument', 'Wrong number of arguments.');
end
