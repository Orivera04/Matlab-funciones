function ok=isuniquename(prj,rt)
%ISUNIQUENAME Check a string for being a valid node name
%
% OK = ISUNIQUENAME(PROJ, NAME) checks if NAME is already in use in the
% project.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/02/09 08:28:19 $

prj=address(prj);

used_nm = prj.preorder(@name);
if ~iscell(used_nm)
    used_nm={used_nm};
end

% always add the data dictionary
DD = prj.getdd;
used_nm = [used_nm; DD.listnames(true)];
used_nm = unique(used_nm);

if ~any(strcmp(rt,used_nm))
    ok=1;
else
    ok=0;
end