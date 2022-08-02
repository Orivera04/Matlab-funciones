function out = get(c , property)
%GET cgclipexpr get method
%
%  Gets the properties of the cgclipexpr object.
%
%  Usage: get(c , 'property_name')

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:08:08 $


if nargin == 1
    out.input = 'Input xregpointer';
    out.bounds = '[min max]';
    out.type = 'Object description for GUI';
    return
end

if ~ischar(property)
    error('mbc:cgclipexpr:InvalidArgument', 'Property name must be a string.');
end
switch property
    case 'input'
        out = getinputs(c);
    case 'bounds'
        out = c.bound;
    case 'type'
        out = 'cgclipexpr';
    otherwise
        error('mbc:cgclipexpr:InvalidPropertyName', ['Unknown property name: ''' property '''.']);
end