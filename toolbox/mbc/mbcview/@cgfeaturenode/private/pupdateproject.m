function featnode = pupdateproject( featnode, newsf, e, system, oldPtrList)
%PUPDATEPROJECT
%
%  FEATNODE = PUPDATEPROJECT( FEATNODE, NEWEQ, EXPRS, SYSTEM )

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.4 $    $Date: 2004/04/04 03:33:19 $ 

sfPtr = getdata( featnode );

waitdlg = xregGui.waitdlg( 'Message', 'Updating strategy' );
waitdlg.Waitbar.Max = 8;
waitdlg.Waitbar.Value = 0;

% Find all pointers just in the current feature
if isempty(newsf)
    newPtrList=[];
    sfPtr.info=sfPtr.set('equation', [sfPtr]);
else
    sfPtr.info=sfPtr.set('equation',[sfPtr newsf]);
    newPtrList=[newsf; newsf.getptrsnosf];
end

% Find any pointers which were created but didn't make it into the
% equation - lose them now.  e will now only contain valid pointers
drool = setdiff(double(e),double(newPtrList));
if ~isempty(drool)
    freeptr(assign(xregpointer,drool));
    e = assign(e, setdiff(double(e), drool));
end

i_incrementwaitbar( waitdlg );


%------------------------------------------------------
%   (2) Rebuild tree to reflect new feature structure
%------------------------------------------------------
P = project( featnode );

% All pointers that have been removed from this feature
lostPtrs = assign(xregpointer, setdiff(double(oldPtrList),double(newPtrList)));
% All pointers that have been added to this feature
newPtrs  = assign(xregpointer, setdiff(double(newPtrList),double(oldPtrList)));
% All pointers that have been added to this feature but pre-existed in the project
reusedPtrs = assign(xregpointer, setdiff(double(newPtrs),double(e)));

% Find all FeatureNodes that contain this feature
pAllFN = findname(P, name( featnode ));
ADDITIONAL_FEATURES = (length(pAllFN)>1);

% Stage (1): Sift through current set of child nodes.  We will generate a
% vector of actions: 0 = leave alone, 1 = delete, 2 = fix normaliser (2D),
% 3 = fix normaliser (1D)
pFNChild = children( featnode );
actions = zeros(1, length(pFNChild));
for n = 1:length(actions)
    obj = pFNChild(n).getdata;
    if any(obj==lostPtrs)
        actions(n) = 1;
    elseif obj.isa('cglookup');
        if obj.isa('cglookuptwo')
            % check normalisers match the nodes
            pNormN = pFNChild(n).children;
            if any(pNormN(1).getdata==lostPtrs) | any(pNormN(2).getdata==lostPtrs)
                actions(n) = 2;
            end
        elseif obj.isa('cgnormfunction')
            % check normaliser matches the nodes
            pNormN = pFNChild(n).children;
            if any(pNormN(1).getdata==lostPtrs)
                actions(n) = 3;
            end
        end
    end
end

i_incrementwaitbar( waitdlg );


% Stage 2:  Loop over all featurenodes and apply the set of actions we've
% just worked out

% Actions== 2 and 3 also need to be applied to all table nodes that contain
% the relevant tables.  This process can be rolled together with updating
% the feature table versions.
indx = find(actions==2 | actions==3);
if ~isempty(indx)
    tbltype = cgtypes.cgtabletype;
    for n = indx
        % get table out of original feature's table entry
        tbl = pFNChild(n).getdata;
        ISLOOKUPTWO = tbl.isa('cglookuptwo');
        pUpdateNds = tbltype.filterlist(recursivesearch(P, tbl));
        for m = 1:length(pUpdateNds)
            pNormN = pUpdateNds(m).children;
            pNormN(1).setdata(tbl.get('x'));
            if ISLOOKUPTWO
                pNormN(2).setdata(tbl.get('y'));
            end
        end
    end
end
% Action== 1 only happens within the duplicate feature nodes.
indx = find(actions==1);
if ~isempty(indx)
    for n = 1:length(pAllFN)
        pChild = pAllFN(n).children;
        for m = indx
            pChild(m).delete;
        end
    end
end

i_incrementwaitbar( waitdlg );


% Stage 3:  Add reused objects to all featurenodes
for n= 1:length(reusedPtrs)
    this = reusedPtrs(n).info;
    if (isa(this, 'cglookup') & ~isa(this, 'cgnormaliser')) | isa(this, 'cgfeature')
        for m = 1:length(pAllFN)
            pAllFN(m).AddChild(cgnode(this, pAllFN(m), reusedPtrs(n), 1));
        end
    end
end

i_incrementwaitbar( waitdlg );


% Stage 4:  Add completely new objects to the project, and to all other featurenodes
for n= 1:length(e)
    this = e(n).info;
    if isa(this, 'cglookup')
        pAllFN(1).addtoproject(e(n));
        if ADDITIONAL_FEATURES & ~isa(this, 'cgnormaliser')
            for m = 2:length(pAllFN)
                pAllFN(m).AddChild(cgnode(this, pAllFN(m), e(n), 1));
            end
        end
    end
end

i_incrementwaitbar( waitdlg );


%--------------------------------
%   (3) Deal with removed items
%--------------------------------

% Stage 1:  Clean up references in items that are removed, log the removals
LostNames = '';
for n=1:length(lostPtrs)
    this = lostPtrs(n).info;
    if isa(this, 'cgfeature') | isa(this, 'cglookup') ...
            | isa(this, 'cgconstant') | isddvariable(this)
        if isa(this, 'cgnormaliser')
            normPrnt = get(this, 'flist');
            if length(normPrnt) == 1 & normPrnt.isa('cglookupone')
                % don't invert the logic above - we require the short-circuiting
            else
                % only log normalisers if they are not axes of a 1D table
                LostNames = [LostNames ', ' getname(this)];
            end
        else
            LostNames = [LostNames ', ' getname(this)];
        end
    end
    % Must update flists for lookuptwo's and normfunctions in case
    % their normalisers are still around
    if isa(this, 'cglookup')
        try
            lostPtrs(n).info = UpdateSFlist(this, sfPtr,0);
        end
    end
end
if ~isempty(LostNames)
    LostNames(1:2) = [];
else
    LostNames = 'None';
end

i_incrementwaitbar( waitdlg );


% If lostPtrs is empty then nothing will get freed anyway, so skip the
% expensive getptrs call.
if ~isempty( lostPtrs )
    % Stage 2:  Find which items are no longer needed at all and free the
    % pointers
    ptrs = preorder(P, 'getptrs');
    if iscell(ptrs)
        ptrs= [ptrs{:}];
    end
    ptrs = unique(ptrs);
    % free pointers in lostptrs that aren't in the project anymore
    freeptr( setdiff( lostPtrs, ptrs ) );
end

i_incrementwaitbar( waitdlg );


%--------------------------------
%   (4) Update history
%--------------------------------

% Get details of added items
NewNames = '';
for n = 1:length(newPtrs)
    this = newPtrs(n).info;
    if isa(this, 'cgfeature') | isa(this, 'cgconstant') ...
            | isddvariable(this) | isa(this, 'cglookup')
        if isa(this, 'cgnormaliser')
            normPrnt = get(this, 'flist');
            if length(normPrnt) == 1 & normPrnt.isa('cglookupone')
                % don't invert the logic above - we require the short-circuiting
            else
                % only log normalisers if they are not axes of a 1D table
                NewNames = [NewNames ', ' getname(this)];
            end
        else
            NewNames = [NewNames ', ' getname(this)];
        end
    end
end
if ~isempty(NewNames)
    NewNames(1:2) = [];
else
    NewNames = 'None';
end

d.sys=[];
if isempty(lostPtrs) & isempty(newPtrs)
    % Nothing happened
else
    details = {['Objects removed : ',LostNames]};
    details = [details,{['Objects added : ',NewNames]}];
    sysName = get_param(system,'Name');
    creator = get_param(system, 'Creator');
    lastmod = get_param(system,'LastModifiedDate');
    modver = get_param(system,'ModelVersion');

    if strcmp(creator,'CAGE')
        sfPtr.info = sfPtr.addhistoryitem('Strategy equation diagram created and parsed',details);
    else
        if ~isempty(creator)
            details = [details,{['Model Created by ',creator]}];
        end
        if ~isempty(lastmod)
            details = [details,{['Model last modified ',lastmod]}];
        end
        if ~isempty(modver)
            details = [details,{['Model version ',modver]}];
        end
        sfPtr.info = sfPtr.addhistoryitem(['Strategy equation parsed from diagram ',sysName],details);
    end
end

i_incrementwaitbar( waitdlg );

try
    delete(waitdlg);
catch
    lasterr('');
end


%---------------------------------------------------------------------------------------
function i_incrementwaitbar( waitdlg )
%---------------------------------------------------------------------------------------
waitdlg.Waitbar.Value = waitdlg.Waitbar.Value+1;
