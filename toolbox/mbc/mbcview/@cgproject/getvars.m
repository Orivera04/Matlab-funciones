function pVars = getvars(PROJ, type)
%GETVARS Return pointers to all available variable objects in the project
%
%  PVAR = GETVARS(PROJ) returns a pointer vector containing pointers to all
%  of the shared variable-type objects which are available in the project.
%
%  PVAR = GETTABLES(PROJ, type) returns only the objects that match a
%  specified criteria.  Valid values for type are 'variable', 'constant',
%  'formula', 'nonconstant', 'all'.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $    $Date: 2004/02/09 08:28:13 $ 

ddnode = info(getdd(PROJ));
if nargin==1
    pVars = listptrs(ddnode);
else
    switch type
        case 'all'
            pVars = listptrs(ddnode);
        case 'nonconstant'
            % Do not return constants
            pVars = listptrs(ddnode, 'constant', 'exclude');
        otherwise
            % Pass on into listptrs
            pVars = listptrs(ddnode, type);
    end
end
pVars = pVars(:)';