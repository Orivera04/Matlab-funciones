function M = loadobj(Mold)
%LOADOBJ  Upgrade old object versions
%
%  OBJ = LOADOBJ(OBJ)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:13:19 $

if isstruct(Mold)
    if ~isfield(Mold, 'version')
        % pre version 2
        M = struct('modptr' , [] , 'list' , [] , 'units' , [], 'clips',[-inf inf]);
        M.cgexpr = Mold.cgexpr;
        if isfield(Mold , 'modptr')
            M.modptr = Mold.modptr;
        end
        if isfield(Mold , 'list')
            M.list = Mold.list;
        end
        if isfield(Mold , 'clips')
            M.clips = Mold.clips;
        end
        M.version = 1;
    else
        M = Mold;
    end
else
    M = Mold;
end

if M.version<2
    % register an upgrade that will remove the pointer
    hLoad = mbcloadrecorder('current');
    hLoad.add({@i_removepointer, M.modptr, getname(M.cgexpr)}, '14-Aug-2002');
    M.model = [];
    M = rmfield(M, 'modptr');
    M = rmfield(M, 'units');
    M.version = 2;
end

if M.version<3
    % Put input pointers into parent class
    M.cgexpr = setinputs(M.cgexpr, M.list(:)');
    M = rmfield(M, 'list');
    M.version = 3;
end


if isstruct(M)
    M = cgmodexpr(M);
end



function i_removepointer(pPROJ, evt, pModel, myname)
PROJ = pPROJ.info;
% Need to search through project to find modexpr and update it
pModelNode = findname(PROJ, myname);
if isempty(pModelNode)
    error('mbc:cgmodexpr:ProjectLoadError', 'Failed to update model expression structure');
else
    for n = 1:length(pModelNode)
        pModelExpr = pModelNode.getdata;
        M = pModelExpr.info;
        if strcmp(getname(M), myname)
            M.model = pModel.info;
        end
        pModelExpr.info = M;
    end
    % Must empty the heap location before removing the pointer to prevent
    % recursive calls to freeptr's of expression models
    pModel.info = [];
    freeptr(pModel);
end
