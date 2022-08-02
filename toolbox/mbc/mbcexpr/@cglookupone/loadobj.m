function LT = loadobj(LT)
%LOADOBJ  Load time actions for cglookupone
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:12:27 $

if isa(LT,'struct')
    if isfield(LT, 'lookup')
        % Note that making cglookupone inherit from cgnormfunction has confused
        % Jos so he hasn't changed lookup to cglookup
        l = LT.lookup;
    else
        l = LT.cglookup;
    end
    name = getname(l);
    L = cglookupone;
    L = setname(L, name);
    
    if ~isfield(LT,'Version') % if we have the old style < June 2001
        % create a dummy normaliser
        Norm = cgnormaliser;
        Norm = setname(Norm,['Axis_' name]);
        Norm = set(Norm, 'Matrix',[LT.Breakpoints [0:length(LT.Breakpoints)-1]']); 
        % set the Xexpr in the normaliser. 
        % Cannot do checks as LT.Xexpr is not a valid pointer at loadobj stage
        Norm = setXnochecks(Norm, LT.Xexpr);
        if isfield(LT,'Extrapolate')
            Norm = set(Norm, 'Extrapolate', LT.Extrapolate);
        end
        L.cgnormfunction = set(L.cgnormfunction,'values', LT.Values); 
        L = set(L,'VLocks', LT.VLocks);
        NormMemory = cell(1,length(LT.Memory));
        LMemory = cell(1,length(LT.Memory));
        for i =1:length(LT.Memory);
            % put the breakpoint history into the normaliser memory
            NormMemory{i}.Breakpoints = LT.Memory{i}.Breakpoints;
            NormMemory{i}.Values = [0:length(LT.Memory{i}.Breakpoints)-1]';
            NormMemory{i}.Information = LT.Memory{i}.Information;
            if isfield(LT.Memory{i}, 'Date')
                NormMemory{i}.Date = LT.Memory{i}.Date;
            end
            Norm = set(Norm, 'memory', NormMemory);
            LMemory{i}.Breakpoints = [0:length(LT.Memory{i}.Breakpoints)-1]';
            % put the values history into the table memory
            LMemory{i}.Values = LT.Memory{i}.Values;
            LMemory{i}.Information = LT.Memory{i}.Information;
            if isfield(LT.Memory{i}, 'Date')
                LMemory{i}.Date = LT.Memory{i}.Date;
            end
            L = set(L, 'memory', LMemory);
        end
        L = set(L,'Clips', LT.Clips);
        for i = 1:length(LT.SFlist)
            % add each pointer to the list in L
            p = LT.SFlist(i);
            L = UpdateSFlist(L,p,1); 
            Norm = UpdateSFlist(Norm,p,1);
        end  
        L = set(L,'weights', LT.Weights);
        if ~isfield(LT, 'Description')
            L = set(L, 'Description', []);
        else
            L = set(L, 'Description', LT.Description);
        end
        if ~isfield(LT,'Input')
            L = set(L, 'Input', []);
        else 
            L = set(L, 'Input', LT.Input);
        end
        if ~isfield(LT,'Precision')
            L = set(L, 'Precision', cgprecfloat('double'));
        elseif isempty(LT.Precision)
            L = set(L, 'Precision', cgprecfloat('double'));
        elseif ~isa(LT.Precision,'cgprec')
            L = set(L, 'Precision', precconvert(LT.Precision,LT.Range));
        else
            L = set(L, 'Precision', LT.Precision);
        end
        if ~isfield(LT,'Range')
            L = set(L, 'Range', []);
        else
            L = set(L, 'Range', LT.Range);
        end
        if isfield(LT,'ExtrapolationMask')
            idx = find(LT.ExtrapolationMask);
            L = addToExtrapolationMask(L, idx);
        end 
        
        % Schedule a post-load action to put a pointer in for the normaliser
        % field.  Due to the setup of expressions in general, this needs to
        % be done as a project-level operation, checking all pointers.
        % Note that this may never occur; I am unsure whether files in this
        % state are all pre version 1 and thus can't be loaded for other
        % reasons?
        h = mbcloadrecorder('current');
        h.add({@i_updatelookupones}, '24-Oct-2002')
        L = setXnochecks(L, Norm);         
    end  
    LT = L;
end




function i_updatelookupones(pPROJ, evt);
PROJ = pPROJ.info;
% get all pointers and update lookupones
ptrs = preorder(PROJ, @getptrs);
if ~isempty(ptrs)
    if iscell(ptrs)
        ptrs = [ptrs{:}];
    end
    ptrs = unique(ptrs);
    is1dtable = pveceval(ptrs, @isa, 'cglookupone');
    is1dtable = [is1dtable{:}];
    if any(is1dtable)
        ptrs = ptrs(is1dtable);
        for n = 1:length(ptrs)
            ptrs(n).info = ptrs(n).fixXexpr;
        end
    end
end