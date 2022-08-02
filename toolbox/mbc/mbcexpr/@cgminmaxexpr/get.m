function out = get(m , property)
%GET Cgminmaxexpr get method
%
%  Gets the properties of the cgminmaxexpr object.
%
%  Usage: get(cgminmaxexpr , 'property_name')

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.3 $  $Date: 2004/04/04 03:27:38 $

if nargin == 1
   out.ptrlist = 'List of xregpointers in cgminmaxexpr';
   out.names = 'Cell Array of Names of expressions in ptrlist';
   out.type = '1 = Min or 0 = Max';
   return
end

if ~ischar(property)
    error('mbc:cgminmaxexpr:InvalidArgument', 'Property name must be a string.');
end

switch property
    case 'ptrlist'
        out = getinputs(m); 
    case 'names'
        inp = getinputs(m);
        if length(inp) == 0
            out = '';
        else
            out = pveceval(inp, 'getname');
        end
    case 'type'
        out = m.min;
    otherwise
        error('mbc:cgminmaxexpr:InvalidPropertyName', ['Unknown property name: ''' property '''.']);
end