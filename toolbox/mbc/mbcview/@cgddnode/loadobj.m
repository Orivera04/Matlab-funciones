function obj = loadobj(obj)
%LOADOBJ Load-time fixing of object
%
%  OBJ = LOADOBJ(OBJ)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.6.2 $    $Date: 2004/02/09 08:23:36 $ 

if isstruct(obj)
    if ~isfield(obj, 'version')
        % Upgrade from version 1
        obj.ptrlist = unique(obj.aliasind);
        obj.numsymvars = length(obj.eqnlist);
        
        % Register a post-load action to upgrade the value objects
        h = mbcloadrecorder('current');
        h.add({@i_update_to_v2, address(obj.cgcontainer), ...
            obj.alias, obj.aliasind, obj.eqnlist}, ...
            '01-Aug-2002');
        
        % Remove old fields
        obj = mv_rmfield(obj, 'alias');
        obj = mv_rmfield(obj, 'aliasind');
        obj = mv_rmfield(obj, 'eqnlist');
         
        obj.version = 2;
    end
    
    obj = cgddnode(obj);
end




function i_update_to_v2(src, evt, pDD, sAlias, pAlias, sEqnList)

% Several update actions required
% (1) Put aliases into the value objects
% (2) Convert "constant" values into cgconstvalue's
% (3) Fix the cgsymvalues to work correctly

nAlias = length(pAlias);
pSyms = [];
for n = 1:nAlias
    valobj = pAlias(n).info;
    valobj = pAlias(n).addalias(sAlias{n});
    if issymvalue(valobj)
        % Register for fixing after all constants have been made
        pSyms = [pSyms, pAlias(n)];
    elseif ~isconstant(valobj)
        % Check the value isn't a constant really
        rng = getrange(valobj);
        if (rng(2)-rng(1)) == 0
            % Construct a constant object in this value's place
            const = cgconstvalue;
            valobj = copybaseinfo(valobj, const);
        end
    end
    pAlias(n).info = valobj;
end

% Fix formulae
for n = 1:length(pSyms)
    valobj = pSyms(n).info;
    % Fix the formulae
    symind = getequation(valobj);
    sEqn = sEqnList{symind};
    [nul, sEqn] = strtok(sEqn, '=');
    sEqn = sEqn(2:end);
    valobj = setequation(valobj, sEqn, pDD);
    pSyms(n).info = valobj;
end

% Force node name to be "Variable dictionary"
dd = pDD.info;
dd.cgcontainer = name(dd.cgcontainer, 'Variable Dictionary');
xregpointer(dd);