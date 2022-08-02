function v = loadobj(oldV)
%LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:16:19 $

if isstruct(oldV)
    if ~isfield(oldV, 'version')
        % Versions before 2
        v = cgvalue;
        v = setname(v,getname(oldV.cgexpr));
        if isfield(oldV,'value')
            v = setvalue(v,oldV.value);
        end
        if isfield(oldV,'bounds')
            v.bounds = oldV.bounds;
        else
            if isempty(oldV.value)
                v.bounds = [-1 1];
            else
                v.bounds = [min(oldV.value),max(oldV.value)];
            end
        end
        if isfield(oldV,'descr')
            v = setdescription(v, oldV.descr);
        end
        if isfield(oldV,'setpt')
            v = setnomvalue(v, oldV.setpt);
        elseif ~isempty(oldV.value)
            v = setnomvalue(v, oldV.value(1));
        end
    else
        % Insert future updates (upwards from version 2) here
        v = cgvalue(oldV);
    end
else
    v = oldV;
end

% Check for old objects with invalid bounds fields
if isempty(v.bounds)
    v.bounds = [-1 1];
end
