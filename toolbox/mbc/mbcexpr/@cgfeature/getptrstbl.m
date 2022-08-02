function p = getptrstbl(f)
%GETPTRSTBL  Get table pointers
%
%  PLIST=GETPTRSTBL(F) returns a list of pointers to tables and subfeatures
%  that are part of the feature F.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:10:41 $

if ~isempty(f.eqexpr)
   all_p = [f.eqexpr; getptrsnosf(f.eqexpr.info)];   
   istbl = pveceval(all_p, 'istable');
   isfeat = pveceval(all_p, 'isfeature');
   p = all_p([istbl{:}] | [isfeat{:}]);
else
   p=[];
end