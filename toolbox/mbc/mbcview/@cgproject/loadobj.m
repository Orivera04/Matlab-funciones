function PROJ= loadobj(PROJ);
%LOADOBJ Upgrade old versions of object
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/02/09 08:28:22 $


if PROJ.version<2
    PROJ.beingdel=0;
end

if PROJ.version<3
    PROJ.modified=0;
end

if PROJ.version<4
    PROJ.SavedMBCVersion = 'Pre-2.0';
    PROJ.SavedAddonVersions = cell(0,2);
end

if PROJ.version<5
    % Add a loadstart object at the beginning of the structure to help make
    % future loads safer
    cPROJ = [{mbcloadstart}; struct2cell(PROJ)];
    sPROJ = [{'loader'}; fieldnames(PROJ)];
    PROJ = cell2struct(cPROJ, sPROJ, 1);
    % The temporary variables could be large because of the heap.  Keeping
    % them might cause two copies later on in the loadobj process
    clear('sPROJ', 'cPROJ');
end

PROJ.version = 5;

if isstruct(PROJ)
   PROJ=cgproject(PROJ);
end

if ~isempty(PROJ.heap)
    % there is some dynamic heap attached to this object
    heap= PROJ.heap;
    PROJ.heap= [];
    
    heap.info = [{PROJ}, heap.info];
    heap.ptrs = [address(PROJ)   heap.ptrs];
    
    try
        % copy old heap onto new location
        [NewPtrs,NewMap]= copy(heap.ptrs,heap.info);
    catch
        PROJ = [];
        mbcloadrecorder('clear');
        return
    end
    
    PROJ= info(NewPtrs(1));
    % play back any captured commands in recorder
    try
        recobj = mbcloadrecorder('current');
        recobj.mapptr(NewMap);
        recobj.playback(':',address(PROJ),[]);
        % post-load operations might update the  project
        PROJ= info(address(PROJ));
    catch
        try
            % delete new tree and continue
            deleteproject(PROJ);
        end
        PROJ = [];
    end
    mbcloadrecorder('clear');
    
    if ~isempty(PROJ)
        try 
            preorder(PROJ,'checknode');
        catch
            try
                % delete new tree and continue
                deleteproject(PROJ);
            end
            PROJ = [];
        end
    end
end
