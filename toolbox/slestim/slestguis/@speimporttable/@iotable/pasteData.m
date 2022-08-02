function nrows = pasteData(h,importStruct)
%PASTEDATA
%
%   Authors: James G. Owen
%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $  $Date: 2004/04/11 00:38:24 $

javaSelectedNode = h.Explorer.getSelected;
if ~isempty(javaSelectedNode) && isa(handle(javaSelectedNode.getObject),...
        'spenodes.TransientDataLeaf')
    selectedNode = handle(h.Explorer.getSelected.getObject);
else % Selected node (if any) does not correspond to a valid paste target
    return
end

nrows = 0;
if selectedNode.Dialog.getTransientInData.isVisible
    target = 'input';
    selectedColumn = ...
        selectedNode.Dialog.getTransientInData.getDataTable.getSelectedColumns+1;
    selectedrows = ...
        selectedNode.Dialog.getTransientInData.getDataTable.getSelectedRows+1;
    dataObj = selectedNode.Experiment.InputData;
elseif selectedNode.Dialog.getTransientOutData.isVisible
    target = 'output';
    selectedColumn = ...
        selectedNode.Dialog.getTransientOutData.getDataTable.getSelectedColumns+1;
    selectedrows = ...
        selectedNode.Dialog.getTransientOutData.getDataTable.getSelectedRows+1;
    dataObj = selectedNode.Experiment.OutputData;
else
    target = 'state';
    % TO DO: Handle state import
    return
end
indices = dataObj(1).indices(dataObj);

%% Get coordinates of selected rows/cols    
if ~isempty(selectedColumn) && any(selectedColumn==2) && any(selectedColumn==3)
    errordlg('Cannot import data and time simultaneosly',...
        'Data Import Tool','modal')
    return
elseif any(selectedColumn==2)
    selectedColumn = 2;
    timeimport = false;
elseif any(selectedColumn==3)
    selectedColumn = 3;
    timeimport = true; 
else 
    errordlg('You must select a destination on the i/o table ',...
        'Data Import Tool','modal')
    return    
end

%% Check that the size of the selected rows match size of the imported data
%% and remove selected rows which contain block titles
if length(selectedrows)>1 
    selectedind = ismember(selectedrows,indices);
    selectedrows(selectedind) = [];    
    if length(selectedrows)~= length(importStruct.columns)
       errordlg('Imported data/time size does not match the number of rows selected in the table',...
          'Simulink Paremeter Estimation Import Tool')
       nrows = 0;
       return
    end
else
    %sum(indices<selectedrows) discounts rows which contain block titles
    if length(importStruct.columns)> ...
            sum(cell2mat(get(dataObj,{'Dimensions'})))- ...
            selectedrows+1+sum(indices<selectedrows)
        errordlg('Imported data/time size exceeds the available number of rows in the table',...
          'Simulink Paremeter Estimation Import Tool')
        nrows = 0;
        return
    else % Extend the selected rows vector
        for k=2:length(importStruct.columns)
            if any(selectedrows(end)+1==indices)
                selectedrows = [selectedrows selectedrows(end)+2];
            else
                selectedrows = [selectedrows selectedrows(end)+1];
            end
        end
    end
end

%% Generate string representations of data
nonworkpace_prefix = '';
if ~strcmp(importStruct.source,'wor')   
    nonworkpace_prefix = '%';
end
switch importStruct.source
    case {'wor','mat'}
        for k=1:length(selectedrows)
            if ~importStruct.transposed
                datastr{k} = sprintf('%s%s%s%d%s',nonworkpace_prefix, ...
                    importStruct.subsource,'(:,', importStruct.columns(k),')');
            else
                datastr{k} = sprintf('%s%s%s%d%s',importStruct.subsource, ...
                   nonworkpace_prefix, '(', importStruct.columns(k), ',:)');
            end
            if strcmp(importStruct.source,'wor')
                datasrc{k} = ['Workspace expression: ', datastr{k}];
            elseif strcmp(importStruct.source,'mat')
                datasrc{k} = ['MAT file:', importStruct.source, ...
                    ' expression: ', datastr{k}];
                if importStruct.transposed                   
                    datavals{k} = importStruct.data(importStruct.columns(k),:);
                else
                    datavals{k} = importStruct.data(:,importStruct.columns(k));
                end
            end    
        end
    case {'xls','asc','csv'}
        for k=1:length(selectedrows)    
           datastr{k} = [nonworkpace_prefix, 'Column', ...
               char(double('A')+mod(importStruct.columns(k)-1,26))];
           datavals{k} = importStruct.data(:,k);
           if strcmp(importStruct.source,'xls')
               datasrc{k} = ['Excel: ' importStruct.subsource];
           elseif strcmp(importStruct.source,'asc')
               datasrc{k} = ['Ascii file: ' importStruct.subsource];
           elseif strcmp(importStruct.source,'csv')
               datasrc{k} = ['CSV file: ' importStruct.subsource];
           end
        end       
end

%% Convert the selected rows a vector of blocks and offset rows
for k=1:length(selectedrows)
    idx = find(selectedrows(k) > indices);
    blockrow(k) = selectedrows(k)-indices(idx(end)); % local row
    block{k} = dataObj(length(idx));
end

%% If it is a time import check that the time vector is ordered and that 
%% columns of time that belong to the same block are identical
if timeimport
    for k=1:length(indices)
        if k<length(indices)
            I = find(selectedrows>indices(k) & selectedrows<indices(k+1));
        else
            I = find(selectedrows>indices(k));
        end
        if ~isempty(I)
            A = importStruct.data(:,I);
            if norm(A-A(:,1)*ones(1,size(A,2)))>eps
                errordlg('Time vectors within each block must be identical',...
                    'Data Import Tool')
                return
            end
            if ~issorted(A(:,1))
                errordlg('Imported time vectors must be in ascending order',...
                    'Data Import Tool')
                return                
            end
            % Write the time string to the first row for this block
            if strcmp(target,'input')
                selectedNode.setInputData(datastr{I(1)}, indices(k)+1, 3);
            else
                selectedNode.setOutputData(datastr{I(1)}, indices(k)+1, 3);
            end  
            set(dataObj(k),'TimeSrc', datasrc{I(1)});
            if ~strcmp(importStruct.source,'wor')
                set(dataObj(k),'TimeVal',A(:,1));
            end
        end
    end
else       
    if strcmp(target,'input')      
        % Add the new data strings to the table in the new node. Note that the
        % following two 'for' loops must be separated since the table model
        % listeners will modify the DataVal property when the setOutputData
        % method is called
        for k = 1:length(selectedrows)
            selectedNode.setInputData(datastr{k}, selectedrows(k), ...
                selectedColumn);
        end
    elseif strcmp(target,'output')
        % Add the new data strings to the table in the new node. Note that the
        % following two 'for' loops must be separated since the table model
        % listeners will modify the DataVal property when the setOutputData
        % method is called
        for k = 1:length(selectedrows)
            selectedNode.setOutputData(datastr{k}, selectedrows(k), ...
                selectedColumn);
        end
    end 
        
    % Add data matrix to TransientData table object if the data is not
    % derived from the workspace
    if ~strcmp(importStruct.source,'wor')
        for k = 1:length(selectedrows)
            block{k}.DataVal{blockrow(k)} = datavals{k}; 
        end
    end
end        
 
%% Force a refesh on the output table
localTableRefresh(selectedNode,target)
nrows = length(selectedrows);

function localTableRefresh(node,target)

% Force a refesh on the table

if strcmp(target,'input')
    tablemodel = node.Handles.InputTableModel;
    [data, idxs] = getInputData(node);
else
    tablemodel = node.Handles.OutputTableModel;
    [data, idxs] = getOutputData(node);
end   
tablemodel.setData(data,idxs-1);
tablemodel.tableRowsUpdated(0, tablemodel.getRowCount-1);
