function LU = cglookup(name);
%CGLOOKUP Constructor for cglookup class
%
%  This is an abstract class and should not be instantiated except by
%  children of cglookup.


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:10:03 $


if nargin && isstruct(name)
    e = name.cgexpr;
    LU = mv_rmfield(name, 'cgexpr');
else
    LU = struct('table',[], ...
        'sizelocks', guidarray(0), ...
        'version', 3, ...
        'ExtrapolationMask', true(0), ...
        'ExtrapolationRegions', true(0));
    e = cgexpr;
    if nargin
        e = setname(e, name);
    end
end

LU = class(LU,'cglookup',e);