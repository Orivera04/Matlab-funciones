function out = setcomplexvector(h, out, product, prop, empty_allowed)
%SETCOMPLEXVECTOR set function for complex vector.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:35:51 $

if (empty_allowed && isempty(out));  return;  end;

if isempty(out)
    id = sprintf('%s:%s:setcomplexvector:EmptyNotAllowed', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s should not be empty.', prop.Description, ...
        upper(prop.name));
end

[row, col] = size(squeeze(out));
if ~isnumeric(out) || min([row,col])~=1 || any(isnan(out))
    id = sprintf('%s:%s:setcomplexvector:NotAComplexVector', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s must be a complex vector.', prop.Description, ...
        upper(prop.name));
end

if row == 1
    out = out(:);
end
