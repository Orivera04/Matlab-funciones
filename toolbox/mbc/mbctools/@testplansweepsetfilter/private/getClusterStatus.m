function status = getClusterStatus(data, selectedData, design, selectedDesign)
%GETCLUSTERSTATUS A short description of the function
%
%  STATUS = GETCLUSTERSTATUS(DATA, SELECTEDDATA, DESIGN, SELECTEDDESIGN)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.2 $    $Date: 2004/02/09 08:12:32 $ 

% Default output
CELL_OUT = true;

% We could be given a cluster structure
if isstruct(data)
    clusters = data;
    data = {clusters.data};
    selectedData = {clusters.selecteddata};
    design = {clusters.design};
    selectedDesign = {clusters.selecteddesign};
    CELL_OUT = length(clusters) > 1;
end

% Check all the inputs are cell arrays
if iscell(data)
    % Get all the lengths of the inputs
    dataLength = cellfun('length', data);
    selectedDataLength = cellfun('length', selectedData);
    designLength = cellfun('length', design);
    selectedDesignLength = cellfun('length', selectedDesign);
    % Make the output cell array
    status = cell(size(data));
else
    dataLength = length(data);
    selectedDataLength = length(selectedData);
    designLength = length(design);
    selectedDesignLength = length(selectedDesign);  
    % Make the output cell array
    status = {''};  
    CELL_OUT = false;
end

% Fill in the outputs
status(selectedDesignLength > selectedDataLength)  = {'moredesign'};
status(selectedDesignLength < selectedDataLength)  = {'moredata'};
status(selectedDesignLength == selectedDataLength) = {'same'};
status(selectedDataLength == 0)                    = {'designonly'};
status(designLength == 0)                          = {'unmatcheddata'};
status(dataLength == 0)                            = {'unmatcheddesign'};

if ~CELL_OUT
    status = status{1};
end