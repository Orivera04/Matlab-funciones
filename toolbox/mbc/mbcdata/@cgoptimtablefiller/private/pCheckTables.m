function [ok, msg] = pCheckTables(tables)
%PCHECKTABLES
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:54:33 $

ok = false;
msg='';
try
    fillstat = pveceval(tables, 'isfill');
    fillstat = [fillstat{:}];
catch
    fillstat = false(1, length(tables));
end
if ~all(isa(tables, 'xregpointer')) | ~all(isvalid(tables)) | ~all(fillstat)
    msg = 'PTABS must be a vector of tables that can be filled';
else
    ok = true;
end
