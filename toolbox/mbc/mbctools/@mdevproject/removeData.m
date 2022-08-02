function [MP] = removeData(MP, pData)
%REMOVEDATA correctly remove data from a project
%
%  PROJECT = REMOVEDATA(PROJECT, PDATA)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:06:46 $ 

% Check that the input is an xregpointer
if ~isa(pData, 'xregpointer')
    error('mbc:mdevproject:InvalidArgument', 'Only xregpointers can be removed from the project data list');
end

% Which index in the data list is this pointer
index = find(MP.Datalist == pData);

% Remove this pointer from the datalist and update the project
MP.Datalist(index) = [];
xregpointer(MP);

% NOTE: nothing can be parented by a sweepsetfilter at the moment but code needs
% to be added here when we move to a data tree structure, so that desendent ssf's
% are correctly freed

% Do any other sweepsetfilters depend on the underlieing sweepset?
p = getDataDependancies(MP, pData);
if isempty(p)
    % If not then free the internal data
	pData.freeInternalPtrs;
end
% And finally free the actual data pointer
freeptr(pData);