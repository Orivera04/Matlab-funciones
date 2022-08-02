function [indices, allIndices] = convertTestIndices(obj, indicesToAllData)
%CONVERTTESTINDICES Convert test index for all data into test index for actual data
%
%  [INDICES, ALLINDICES] = CONVERTTESTINDICES(OBJ, INDICESTOALLDATA)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:11:16 $ 

% Get the sweep guids of the selected data
allguids = getSweepGuids(obj.cachedInfo.globaldata, indicesToAllData);
% Get the data guids
guids = getSweepGuids(sweepset(obj));
% Convert
allIndices = getIndices(guids, allguids);
% Remove any zeros
indices = allIndices(allIndices ~= 0);
