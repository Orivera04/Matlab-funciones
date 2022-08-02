function featnode = clearstrategy( featnode )
%CLEARSTRATEGY Clears Strategy from feature
%
%  FEATNODE = CLEARSTRATEGY( FEATNODE )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/02/09 08:22:41 $ 

pF = getdata(featnode);
pEq = pF.get('equation');

if ~isempty(pEq)
    % Clear feature of equation
    pF.info = pF.set('equation',pF);

    % Get all pointers that are involved in equation and therefore might need
    % to be deleted
    EqPtrs = unique([pEq; pEq.getptrs]);

    % Delete all child table nodes
    Children = infoarray(children(featnode));
    for n = 1:length(Children)
        delete(Children{n});
    end
    featnode = info(featnode);
    
    % Get all pointers in project and delete equation pointers that are not
    % being used elsewhere
    PROJ = project(featnode);
    ProjectPtrs = preorder(PROJ, @getptrs);
    if iscell(ProjectPtrs)
        ProjectPtrs = [ProjectPtrs{:}];
    end
    ProjectPtrs = unique(ProjectPtrs);
    ToDel = ~ismember(EqPtrs, ProjectPtrs);
    freeptr(EqPtrs(ToDel));
end

pF.info = pF.addhistoryitem('Strategy equation cleared','');
