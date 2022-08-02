function out = setpositivevector(h, out, product, prop, zero_included, inf_included, empty_allowed)
%SETPOSITIVEVECTOR set function for positive real vector.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:35:56 $

if (empty_allowed && isempty(out));  return;  end;

if isempty(out)
    id = sprintf('%s:%s:setpositivevector:EmptyNotAllowed', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s should not be empty.', prop.Description, ...
        upper(prop.name));
end

[row, col] = size(squeeze(out));
if ~isnumeric(out) || min([row,col])~=1 || any(isnan(out)) || any(~isreal(out)) || any(out < 0) ...
    || (~zero_included && any(out == 0)) || (~inf_included && any(isinf(out)))
    id = sprintf('%s:%s:setpositivevector:NotAPositiveVector', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s must be a positive vector.', prop.Description, ...
        upper(prop.name));
end

if row == 1
    out = out(:);
end
