function utAddPreprocessedData(node,thispreprocessgui, manager)

% Copyright 2003-2004 The MathWorks, Inc.
 
% Callback from the data procprocessing GUI "Apply" and "OK" buttons.
% Adds preprocessed data to the input table and creates nodes if necessary

IpreprocListeners = [];

%% Input dataset
indataset = thispreprocessgui.Datasets(thispreprocessgui.Position);

%% Selected node (can be empty if the node was deleted)
selectednode = [];
if ~isempty(manager.Explorer.getSelected)
   selectednode = handle(getObject(manager.Explorer.getSelected));
end

%% If the data originated from an input tab but the tab is an output tab or
%% state tab or vice versa warn and give an opportunity to abort
if isa(selectednode,'spenodes.TransientDataLeaf') && ...
        ~selectednode.Dialog.getTransientInData.isVisible && ...
        strcmp(indataset.Userdata,'input')
    msg = sprintf('%s\n%s','Preprocessed input data will be mapped to the input data table ',...
           'even though an output data tab is currently selected. Continue?');
    btnname = questdlg(msg,'Preprocessing Tool','Yes','No','Yes');
    if strcmp(btnname,'No')
        return
    end
end
if isa(selectednode,'spenodes.TransientDataLeaf') && ...
        ~selectednode.Dialog.getTransientOutData.isVisible && ...
        strcmp(indataset.Userdata,'output')
    msg = sprintf('%s\n%s','Preprocessed output data will be mapped to the output data table ',...
           'even though an input data tab is currently selected. Continue?');
    btnname = questdlg(msg,'Preprocessing Tool','Yes','No','Yes');
    if strcmp(btnname,'No')
        return
    end
end

%% Add a node if necessary  find the new (existing) node handle
thesenodes = node.up.getChildren;
nodename = thispreprocessgui.TargetNode;


%% Find/create the destination node
I = find(strcmp(nodename,get(thesenodes,{'Label'})));
if isempty(I) % Need to create a new node
    thisnode = node.up.addNode;
    thisnode.Label = nodename;
    % Need to build panel before modifiying the interior table
    thisnode.getDialogInterface(manager);
else
    thisnode = thesenodes(I(1));
    if node==thisnode
        % questdlg uses the CallbackObject proeprty of 0 which is equal to
        % the Newdatasets property that this callback is listening to. This
        % causes an error in questdlg
        msg = ['The destination node is the same as the source node, so preprocessing will modify ',...
               'data source in the current Parameter Estimation table. Do you wish to refresh the ',...
               'raw preprocessing data to its preprocessed form?'];
        ButtonName = questdlg(msg,'Update table data','Yes','No','Cancel','Yes');
        switch ButtonName,
             case 'Yes', 
                 
                % Store and disable the listeners which close the preprocessing GUI when
                % the i/o table data has changed
                IpreprocListeners = cellfun('isclass',get(node.listeners,{'Container'}), ...
                     'ParameterEstimatorData.TransientData');
                set(node.listeners(IpreprocListeners),'Enabled','off')
                
                % Swap old data sets for the modified data
                datasets = thispreprocessgui.Datasets;
                oldsrc = datasets(thispreprocessgui.Position).Userdata;
                datasets(thispreprocessgui.Position) = ...
                    thispreprocessgui.Newdataset;
                set(datasets(thispreprocessgui.Position),'Userdata', ...
                    oldsrc);
                
                % Clear all rules and manually exluded pts for this dataset
                % Cannot use reset becuase it resets the position to 1
                thispreprocessgui.Datasets = datasets;
                thispreprocessgui.ManExcludedpts{thispreprocessgui.Position} = ...
                    zeros(size(thispreprocessgui.Newdataset.Data));                    
                thispreprocessgui.flushrules
                thispreprocessgui.rebuild
             case 'Cancel',
                 return
        end
    end
end

%% Find the block and position in the i/o table which corresponds to the
%% selected block in the preprocessing GUI combo
exp = thisnode.Experiment;
if strcmp(indataset.Userdata,'output') && length(exp.OutputData)>0
    blocks = get(exp.OutputData,{'Block'});
    indices = exp.OutputData(1).indices(exp.OutputData);
elseif strcmp(indataset.Userdata,'input') && length(exp.InputData)>0
    blocks = get(exp.InputData,{'Block'});
    indices = exp.InputData(1).indices(exp.InputData);
else
    errordlg(['No ' indataset.Userdata 's are defined'],...
        'Prprocessing Tool','modal')
    return
end

[blocknames,position] = getstate(thispreprocessgui);
blockindex = find(strcmp(blocknames(position),blocks));
if ~isempty(blockindex)
    startrow = indices(blockindex);
else
    errordlg(['Table has changed since the opening the Preprocessing Tool.', ...
        ' Please reopen it to refresh'], 'Preprocessing Tool','modal')
    return
end

   
%% Add the new data strings to the table in the new node
s = size(thispreprocessgui.Datasets(position).Data);
if strcmp(indataset.Userdata,'output')
    for k = startrow+1:startrow+s(2)
        thisnode.setOutputData(...
            thispreprocessgui.Newdataset.Headings{k-startrow}, k, 2);
        thisnode.setOutputData(...
            thispreprocessgui.Newdataset.timevariable, k, 3);
    end
    exp.OutputData(blockindex).TimeVal = thispreprocessgui.Newdataset.Time;
    for k=1:s(2)
        exp.OutputData(blockindex).DataVal{k} = ...
            thispreprocessgui.Newdataset.Data(:,k);
        exp.OutputData(blockindex).DataSrc{k} = 'Preprocessed'; 
    end
    exp.OutputData(blockindex).TimeSrc = 'Preprocessed';
elseif strcmp(indataset.Userdata,'input')
    for k = startrow+1:startrow+s(2)
        thisnode.setInputData(...
            thispreprocessgui.Newdataset.Headings{k-startrow}, k, 2);
        thisnode.setInputData(...
            thispreprocessgui.Newdataset.timevariable, k, 3);
    end
    exp.InputData(blockindex).TimeVal = thispreprocessgui.Newdataset.Time;
    for k=1:s(2)
        exp.InputData(blockindex).DataVal{k} = ...
            thispreprocessgui.Newdataset.Data(:,k);
        exp.InputData(blockindex).DataSrc{k} = 'Preprocessed';

    end
    exp.InputData(blockindex).TimeSrc = 'Preprocessed';
end

localTableRefresh(thisnode,indataset.Userdata)

%% Re-enable any window closing listenrs which were disabled
if ~isempty(IpreprocListeners)
    set(node.listeners(IpreprocListeners),'Enabled','on')
end

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
