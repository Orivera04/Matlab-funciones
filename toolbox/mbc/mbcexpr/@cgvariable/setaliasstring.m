function [obj, nAdded, nRemoved] = setaliasstring(obj, str, pDD)
%SETALIASSTRING Set aliases from a comma-separated list
%
%  OBJ = SETALIASSTRING(OBJ, STR) resets the obejct's alias list to match
%  the entries contained in the comma-separated list STR.
%
%  OBJ = SETALIASSTRING(OBJ, STR, P_DD) allows you to provide a pointer to
%  a Variable Dictionary.  This will ensure that all new aliases are
%  correctly unique in the project.
%
%  [OBJ, NUMADDED, NUMREMOVED] = SETALIASSTRING(...) also returns the
%  numbers of alias strings that have been added and removed.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 07:16:59 $ 

if nargin>2
    PROJ = pDD.project;
    DD_PRESENT = true;
else
    DD_PRESENT = false;
end

nAdded = 0;

old_alias = getaliaslist(obj);
objold = obj;
obj = clearallalias(obj);
vars = symvar(str);
for n = 1:length(vars)
    if isalias(objold, vars{n})
        % Add old aliases without asking questions
        obj = addalias(obj, vars{n});
        nAdded = nAdded + 1;
    elseif DD_PRESENT
        if isuniquename(PROJ, vars{n})
            obj = addalias(obj, vars{n});
            nAdded = nAdded + 1;
        end
    else
        obj = addalias(obj, vars{n});
        nAdded = nAdded + 1;
    end
end

% Check whether any old aliases need to be removed.
if nargout>2
    nRemoved = 0;
    for n = 1:length(old_alias)
        if ~isalias(obj, old_alias{n});
            nRemoved = nRemoved + 1;
        end
    end
end