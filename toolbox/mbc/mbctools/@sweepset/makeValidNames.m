function ss = makeValidNames(ss)
%MAKEVALIDNAMES ensures that the variable names in a sweepset are valid
%
%  SS = MAKEVALIDNAMES(SS)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:06:36 $ 

[names, changes] = generateValidUniqueNames({ss.var.name});
% Do we need to copy back new names?
if any(changes)
    [ss.var.name] = deal(names{:});
end