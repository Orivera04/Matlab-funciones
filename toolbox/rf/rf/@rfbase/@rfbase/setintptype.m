function out = setintptype(h, out, product, prop, empty_allowed)
%SETINTPTYPE set function for interpolation type.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:35:52 $

if (empty_allowed && isempty(out));  return;  end;

if isempty(out)
    id = sprintf('%s:%s:setintptype:EmptyNotAllowed', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s must be linear, cubic, or spline.', prop.Description, ...
        upper(prop.name));
end

if ~isa(out, 'char')
    id = sprintf('%s:%s:setintptype:NotAString', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s must be linear, cubic, or spline.', prop.Description, ...
        upper(prop.name));
end
out = lower(out);
if ~strcmp(out, 'linear') && ~strcmp(out, 'cubic') && ~strcmp(out, 'spline')
    id = sprintf('%s:%s:setintptype:WrongType', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s must be linear, cubic, or spline.', prop.Description, ...
        upper(prop.name));
end