function out = setnegativevector(h, out, product, prop, zero_included, inf_included, empty_allowed)
%SETNEGATIVEVECTOR set function for negative real vector.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:35:54 $

if (empty_allowed && isempty(out));  return;  end;

if isempty(out)
    id = sprintf('%s:%s:setnegativevector:EmptyNotAllowed', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s should not be empty.', prop.Description, ...
        upper(prop.name));
end

[row, col] = size(squeeze(out));
if ~isnumeric(out) || min([row,col])~=1 || any(isnan(out)) || any(~isreal(out)) || any(out > 0) ...
    || (~zero_included && any(out == 0)) || (~inf_included && any(isinf(out)))
    id = sprintf('%s:%s:setnegativevector:NotANegativeVector', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s must be a negative vector.', prop.Description, ...
        upper(prop.name));
end

if row == 1
    out = out(:);
end
