function [MP] = modifyData(MP, pData, newData)
%MODIFYDATA function to replace data in the project with new data
%
%  PROJECT = MODIFYDATA(PROJECT, PDATA, NEWDATA)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:03:43 $ 

oldData = pData.info;
% Update the data ... do we need to create a new top level sweepset
[pSSnew, lNew, newSS] = getOriginal(newData);
[pSSold, lOld, oldSS] = getOriginal(oldData);
% What are the dependancies of this data object
pDepend = getDataDependancies(MP, pData);
% Has the underlieing sweepset changed?
if length(pDepend) == 0 || isempty(oldSS) || isequal(newSS, oldSS)
    % No change at all or Changed ... but no one else is dependant on the parent
    pData.info = pData.assign(newData);
else
    % Changed ... someone else is dependant on the parent so copy the
    % sweepset to a new location on the heap
    pData.info = copy(newData);
end