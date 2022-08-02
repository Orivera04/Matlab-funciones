function [ss, lChanges, nameMap] = pUpdateToValidNames(ss, nameMap)
%PUPDATETOVALIDNAMES ensures that the variable names in a sweepset are valid
%
%  [SS, CHANGES, NAMEMAP] = PUPDATETOVALIDNAMES(SS)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:06:41 $ 

if nargin > 1
    % Make any requested changes to the name map
    [names, lChanges] = pUpdateToValidNames({ss.var.name}, nameMap);
    if lChanges
        [ss.var.name] = deal(names{:});
    end
else
    [names, lChanges, nameMap] = generateValidUniqueNames({ss.var.name});
    % Do we need to copy back new names?
    if any(lChanges)
        [ss.var.name] = deal(names{:});
    end
    % Flag any changes to the sweepset
    lChanges = any(lChanges);
end
