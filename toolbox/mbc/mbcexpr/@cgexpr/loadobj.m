function E= loadobj(E)
%LOADOBJ Load-time actions
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:09:06 $

if isstruct(E)
    if ~isfield(E, 'version')
        % Old object upgrade.  Inputstore, outputstore and units have been
        % removed.  An inputs field is added for simple exprs to use.
        if isfield(E, 'unit')
            E = rmfield(E, 'unit');
        end
        if isfield(E,'formatstring')
            E = rmfield(E, 'formatstring');
        end
        if isfield(E,'inputstore')
            E = rmfield(E, 'inputstore');
            E = rmfield(E, 'outputstore');
        end
        E.Inputs = null(xregpointer,0);
        E.Version = 2;
    end
end

if isstruct(E)
    E = cgexpr(E);
end