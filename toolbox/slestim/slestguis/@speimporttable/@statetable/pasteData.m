function pasteData(h, statesStr)
%PASTEDATA
%
%   Authors: James G. Owen
%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/11 00:38:28 $
   
javaSelectedNode = h.Explorer.getSelected;
if ~isempty(javaSelectedNode) && isa(handle(javaSelectedNode.getObject),...
        'spenodes.TransientDataLeaf')
    selectedNode = handle(h.Explorer.getSelected.getObject);
else % Selected node (if any) does not correspond to a valid paste target
    return
end

%% Get indices of blocks in the state table
nrows = 0;
if selectedNode.Dialog.getTransientICData.isVisible
    target = 'state';
    selectedrows = ...
        selectedNode.Dialog.getTransientICData.getDataTable.getSelectedRows+1;
    indices = selectedNode.Experiment.InitialStates(1).indices(selectedNode.Experiment.InitialStates);
else
    return
end

%% Check that the size of the selected rows match size of the imported data
%% and remove selected rows which contain block titles
if length(selectedrows)>1 
    selectedind = ismember(selectedrows,indices);
    selectedrows(selectedind) = [];    
    if length(selectedrows)~= length(statesStr)
       errordlg('Imported vector size does not match the number of rows selected in the table',...
          'Simulink Parameter Estimation Import Tool')
       nrows = 0;
       return
    end
else
    %sum(indices<selectedrows) discounts rows which contain block titles
    dims = get(selectedNode.Experiment.InitialStates,{'Dimensions'});
    allStatesSum = 0;
    for k=1:length(dims)
        allStatesSum = allStatesSum+prod(dims{k});
    end
    if length(statesStr)> allStatesSum-selectedrows+1+sum(indices<selectedrows)
        errordlg('Imported data/time size exceeds the available number of rows in the table',...
          'Simulink Paremeter Estimation Import Tool')
        nrows = 0;
        return
    else % Extend the selected rows vector
        for k=2:length(statesStr)
            if any(selectedrows(end)+1==indices)
                selectedrows = [selectedrows selectedrows(end)+2];
            else
                selectedrows = [selectedrows selectedrows(end)+1];
            end
        end
    end
end

% TO DO: Assign the data source
%% Import states into table
for k=1:length(indices)
    if k<length(indices)
        I = find(selectedrows>indices(k) & selectedrows<indices(k+1));
    else
        I = find(selectedrows>indices(k));
    end
    for j=1:length(I)  
        selectedNode.setStateData(statesStr{I(j)}, indices(k)+j, 3);
    end
    selectedNode.Experiment.InitialStates(k).Data(I) = statesStr(I);
end

% Refresh the table
[thisdata, isxs] = getStateData(selectedNode);
tablemodel = getfield(selectedNode.Handles, 'StateTableModel');
tablemodel.setData(thisdata,isxs-1);
tablemodel.tableRowsUpdated(0, tablemodel.getRowCount-1);
