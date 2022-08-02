function out = setrealvector(h, out, product, prop, empty_allowed)
%SETREALVECTOR set function for real vector.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:35:57 $

if (empty_allowed && isempty(out));  return;  end;

if isempty(out)
    id = sprintf('%s:%s:setrealvector:EmptyNotAllowed', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s should not be empty.', prop.Description, ...
        upper(prop.name));
end

[row, col] = size(squeeze(out));
if ~isnumeric(out) || min([row,col])~=1 || any(isnan(out)) || any(~isreal(out))
    id = sprintf('%s:%s:setrealvector:NotARealVector', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s must be a real vector.', prop.Description, ...
        upper(prop.name));
end

if row == 1
    out = out(:);
end
