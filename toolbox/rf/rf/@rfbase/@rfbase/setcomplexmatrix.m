function out = setcomplexmatrix(h, out, product, prop, empty_allowed)
%SETCOMPLEXMATRIX set function for complex matrix.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/12 23:35:50 $

if (empty_allowed && isempty(out));  return;  end;

if isempty(out)
    id = sprintf('%s:%s:setcomplexmatrix:EmptyNotAllowed', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s should not be empty.', prop.Description, ...
        upper(prop.name));
end

if ~isnumeric(out) 
    id = sprintf('%s:%s:setcomplexmatrix:NotAComplexMatrix', product, ...
        strrep(class(h),'.',':'));
    error(id,'%s %s must be a complex matrix.', prop.Description, ...
        upper(prop.name));
end
[m1, m2, m3] = size(out);
if (m1~=m2) 
    id = sprintf('rf:%s:setcomplexmatrix:NotARightMatrix', ...
        strrep(class(h),'.',':'));
    error(id,'%s %s must be a comlex NxNxM array.', prop.Description, ...
        upper(prop.name));
end
