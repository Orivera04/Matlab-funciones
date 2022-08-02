function out = setpositive(h, out, product, prop, zero_included, inf_included, empty_allowed)
%SETPOSITIVE set function for positive scalar.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/12 23:35:55 $

if (empty_allowed && isempty(out));  return;  end;

if isempty(out)
    id = sprintf('%s:%s:setpositive:EmptyNotAllowed', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s should not be empty.', prop.Description, ...
        upper(prop.name));
end

l = length(out);
if ~(l == 1) || ~isnumeric(out) || isnan(out) || ~isreal(out) || out < 0 ...
    || (~zero_included && (out==0)) || (~inf_included && isinf(out))
    id = sprintf('%s:%s:setpositive:NotAPositive', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s must be a positive scalar.', prop.Description, ...
        upper(prop.name));
end