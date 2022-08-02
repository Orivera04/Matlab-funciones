function out = setcomplex(h, out, product, prop, empty_allowed)
%SETCOMPLEX set function for complex scalar.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:35:49 $

if (empty_allowed && isempty(out));  return;  end;

if isempty(out)
    id = sprintf('%s:%s:setcomplex:EmptyNotAllowed', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s should not be empty.', prop.Description, ...
        upper(prop.name));
end

l = length(out);
if ~(l == 1) || ~isnumeric(out) || isnan(out)
    id = sprintf('%s:%s:setcomplex:NotAComplex', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s must be a complex scalar.', prop.Description, ...
        upper(prop.name));
end
