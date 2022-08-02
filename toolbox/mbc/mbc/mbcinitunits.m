function mbcinitunits
%MBCINITUNITS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.4.2 $  $Date: 2004/02/09 06:48:55 $

%MBCINITUNITS  Set the default namespace and units database.

% Set namespace location
namespace = strrep([xregrespath '/namespace'], filesep, '/');
if ispc
    namespace = ['file:///' namespace];
end
junit('SET-UNITNS', namespace);

% Set XML location
F = getpref(mbcprefs('mbc'), 'UnitsDB');
if isempty(F)
    F = fullfile(xregrespath, 'mbcunit.xml');
end
UnitDB = strrep(F, filesep, '/');
if ispc
    UnitDB = ['file:///' UnitDB];
end
junit('SET-UNITDB', UnitDB);