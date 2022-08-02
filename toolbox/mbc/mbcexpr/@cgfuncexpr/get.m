function out = get(fun_object , property)
%GET Cgfuncexpr get method.
%
%  Gets the properties of the cgfuncexpr object.
%
%  Usage: get(fun_obj , 'property_name')

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:11:00 $

if nargin == 1
    out.ptrlist = 'List of xregpointers in FuncExpr';
    out.model = 'Inline function';
    out.func = 'Function string';
    out.inputnames = 'Cell array of names of model inputs';
    out.type = 'Description string for GUI';
    return
end

if ~ischar(property)
    error('mbc:cgfuncexpr:InvalidArgument', 'Property name must be a string.');
end

switch lower(property)   
    case 'ptrlist'
        out = getinputs(fun_object);
    case 'model'
        out = fun_object.function;
    case 'func'
        out = char(fun_object.function);
    case 'inputnames'
        out = pveceval(getinputs(fun_object), 'getname');
    case 'type'
        out = 'Function Expression';
    otherwise
        error('mbc:cgfuncexpr:InvalidPropertyName', 'Unknown property.');
        
end