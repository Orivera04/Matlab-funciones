function MP= loadobj(MP);
% MDEVPROJECT/LOADOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.4 $  $Date: 2004/04/04 03:31:25 $

if isstruct(MP) && ~isfield(MP,'ProjectVersion')
    % version 1
    MP = rmfield(MP,'Username');   % Current user is now part of MBC environment
    % update History so that it contains user objects
    hist = MP.History;
    for n = 1:length(hist)
        hist(n).User = setusername(mbcuser,hist(n).User);
    end
    MP.History = hist;
    MP.ProjectVersion = 2;
end

DO_DATA_UPDATE = false;
if MP.ProjectVersion<3
    % Schedule updates to guids
    DO_DATA_UPDATE = true;
    MP.ProjectVersion = 3;
end

if MP.ProjectVersion<4
    MP.SavedMBCVersion = 'Pre-2.0';
    MP.SavedAddonVersions = cell(0,2);
    MP.ProjectVersion = 4;
end

if MP.ProjectVersion<5
    % Add a loadstart object at the beginning of the structure to help make
    % future loads safer
    cMP = [{mbcloadstart}; struct2cell(MP)];
    sMP = [{'loader'}; fieldnames(MP)];
    MP = cell2struct(cMP, sMP, 1);
    % The temporary variables could be large because of the heap.  Keeping
    % them might cause two copies later on in the loadobj process
    clear('sMP', 'cMP');
    MP.ProjectVersion = 5;
end

if isstruct(MP)
    MP = mdevproject(MP);
end

if ~isempty(MP.heap)
    % there is some dynamic heap attached to this object
    
    heap= MP.heap;
    MP.heap= [];
    
    heap.info = [{MP}, heap.info];
    heap.ptrs = [address(MP)   heap.ptrs];
    
    try
        % copy old heap onto new location
        [NewPtrs,NewMap]= copy(heap.ptrs,heap.info);
    catch
        MP = [];
        mbcloadrecorder('clear');
        return
    end
    
    MP= info(NewPtrs(1));
    % play back any captured commands in recorder
    try
        recobj = mbcloadrecorder('current');
        recobj.mapptr(NewMap);
        recobj.playback(':',address(MP),[]);
        % post-load operations might update the  project
        MP = info(address(MP));
    catch
        try
            % delete new tree and continue
            delete(MP);
        end
        MP= [];
    end
    mbcloadrecorder('clear');
    % check models are OK
    if ~isempty(MP)
        try  
            % check we have valid model objects
            preorder(MP,@checkmodel);
            if DO_DATA_UPDATE
                % update guids in test plans to trace back to original data
                children(MP,@upgradeGuids);
                % Make sure that the Testplan DataLink field is upgraded to
                % a TSSF as pUPdateToValidNames assumes this
                children(MP,'cacheTSSF');
                % The upgrade might have changed the internals of MP so get
                % a new copy
                MP = info(MP);
                % update sweepset variable names
                MP= pUpdateToValidNames(MP);
            end
            % Make sure that the cache is totally up-to-date
            children(MP,'cacheTSSF');
            MP= info(MP);
        catch
            try
                % delete new tree and continue
                delete(MP);
            end
            MP= [];
        end
    end
end
