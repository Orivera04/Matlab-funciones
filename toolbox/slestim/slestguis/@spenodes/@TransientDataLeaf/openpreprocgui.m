function thisgui = openpreprocgui(this, manager)
%OPENPREPROCGUI 
%
% Author(s): James G. Owen
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.8 $ $Date: 2004/04/11 00:40:02 $

% Callback from the Data Preprocessing Button. 
% Opens the preprocessing GUI

% Peristent handle to preprocessing GUI - GUI is a singleton
persistent thispreprocessgui;

%% Get the table numeric data and string data models
hstr = [this.Experiment.InputData; this.Experiment.OutputData];
hdata = [this.up.Experiment.InputData; this.up.Experiment.OutputData];
ioboundary = length(this.up.Experiment.InputData);

%% Convert spe data objects into an array of preprocessgui.dataset objects
idx = 1;
predataset = [];
badblocks = {};

for k=1:length(hdata)
    % Numerical data stored in new object constructed out of the above strings
    data = copy(hdata(k));
    
    % Only package the data set for display if this block has valid data
    try
        % Create data and @dataset for this block
        data = hstr(k).build(data);
        % Simulink uses the last dim for time for matrix signals
        ndatadims = ndims(data.Data);
        if ndatadims>2
            rawdata = shiftdim(data.Data,ndatadims-1);
            rawdata = rawdata(:,:);
        else
            rawdata = data.Data;
        end
        
        if size(rawdata,1)>1
            thisdataset = preprocessgui.dataset(rawdata,data.Time(:,1));

            % Loop through each cell entry and see if it's a MATLAB workspace
            % variable. If not assume its a MATLAB expression. Assign the
            % heading names accordingly.
            wspacevars = evalin('base','who');
            thisdataset.Headings = cell(length(hstr(k).Data),1);

            for col=1:length(hstr(k).Data)
                thisdataset.Headings{col} = hstr(k).Data{col};
            end

            % If time is derived from a real data source or a named
            % MATLAB variable then preserve its name. Otherwise it is a
            % MATLAB expression such as 1:10 which cannot be used as label
            % since preprocessing may alter its length in which case the
            % label would be misleading
            if ~isempty(hstr(k).TimeSrc) || length(who(hstr(k).Time))>0
                thisdataset.timevariable = [hstr(k).Time '*'];
            else
                thisdataset.timevariable = 'time*';
            end
            
            % Add to the list of datasets 
            predataset = [predataset; thisdataset];
            if k>ioboundary 
                set(predataset(end),'Name',data.Block,'Userdata','output');
            else
                set(predataset(end),'Name',data.Block,'Userdata','input');
            end
            idx = idx+1;
        end
    catch
        badblocks = [badblocks; {hstr(k).Block}; {getfield(lasterror,'message')}];
    end
end

%% If idx is still 1, no valid data has been loaded so abort
if idx==1
     msg = ['No valid data has been specified for any of the blocks.',...
            ' Valid data sets must have at least two samples for preprocessing.',... 
            ' Last error from the build method: ',getfield(lasterror,'message')];
     errordlg(msg,'Data Preprocessing Tool','modal')
     return
elseif length(badblocks)>0
    msg = ['The following blocks contain invalid data sets or have time ',...
           'vectors which are not syncronized with the ordinate data:'];
    for k=1:length(badblocks)
        msg = [msg, sprintf('%s\n ',badblocks{k})];
    end
    warndlg(msg,'Data Preprocessing Tool','modal')
end

%% Get the list of avaialable target nodes
nodenames = get(this.up.getChildren,{'Label'});
         
%% If a preprocessgui has already been created use it, otherwise build a new
%% one
if ~isempty(thispreprocessgui) && ishandle(thispreprocessgui) 
     
     % Destroy listeners to old transient leaf nodes which may have been
     % deleted
     thispreprocessgui.resetListeners
     
     % Populate gui database with unprocessed data
     thispreprocessgui.reset(predataset);
       
     % Refresh GUI
     thispreprocessgui.rebuild
     thispreprocessgui.generic_listeners;
     
else
     % Build database
     thispreprocessgui = preprocessgui.preprocess(predataset);
     
     % Create dialog
     thispreprocessgui.viewer(manager.Explorer)  
     
     % Add the help button callback
     set(handle(thispreprocessgui.javaframe.fHelpButton,'callbackproperties'),...
         'ActionPerformedCallback',@localHelp);
     
end

% Populate nodes combo and new node text box
localUpdateDatasetCombo([],[],this.up,this,thispreprocessgui,manager);

%% Preprocessing GUI listeners
 % Listener which populates the table when the process "Newdatasets"
 % property is updated by hitting the "Apply" or "OK" buttons in the
 % preprocessing GUI
 Lnewdata = handle.listener(thispreprocessgui, ...
      thispreprocessgui.findprop('Newdatasets'),'PropertyPostSet',...
      {@localAddPreprocessedData, this, thispreprocessgui, manager});

 % Listeners which syncronize the destination set combo with the
 % children of the Transient Data node
 model = manager.ExplorerPanel.getSelector.getTree.getModel;
 Lnewdataset = [handle.listener(this.up, 'ObjectChildAdded',...
                  {@localUpdateDatasetCombo this.up this thispreprocessgui manager});
                handle.listener(this.up, 'ObjectChildRemoved',...
                  {@localUpdateDatasetCombo this.up this thispreprocessgui manager})   
                handle.listener(handle(model,'callbackproperties'), 'TreeNodesChanged', ...
                  {@localUpdateDatasetCombo this.up this thispreprocessgui manager})];                                   
 % These listeners are stored in the preproceessing GUI so they are not
 % rebuilt if the preprocessing GUI is opened multiple times 
 thispreprocessgui.addlisteners([Lnewdata;Lnewdataset]);
 this.Handles.preprocframe = thispreprocessgui.javaframe;
 set(handle(this.Handles.preprocframe,'callbackproperties'),'WindowClosingCallback', ...
     {@localHidePreProc thispreprocessgui});

%% Sync current dataset position with selected items in SPE table
localSyncCurrentDataset(this,thispreprocessgui)

%% Prevent table edits while the prproc gui is open
localTableEditManager(this,thispreprocessgui)

%% Delete preproc gui if source node or CETM is deleted
this.addListeners(handle.listener(this, 'ObjectBeingDestroyed',...
     {@localDestroyPreProc thispreprocessgui}));
set(handle(manager.Explorer,'callbackproperties'),'WindowClosedCallback', ...
   {@localDestroyPreProc thispreprocessgui});

%% Identify the source node on the preprocess GUI
thispreprocessgui.javaframe.setTitleLabel( ...
    ['Data Preprocessing Tool for  Dataset: ' this.Label]);
thisgui = thispreprocessgui; % Output for debugging


function localHidePreProc(es,ed,guihandle)

guihandle.Visible = 'off';
    
function localDestroyPreProc(es,ed,guihandle)

if ~isempty(guihandle) && ishandle(guihandle) 
    if ~isempty(guihandle.javaframe) && ...
        isjava(guihandle.javaframe)
        % Note: overloaded dispose is thread safe
        guihandle.javaframe.dispose;
    end
    delete(guihandle);
end



function localAddPreprocessedData(es,ed, this, thispreprocessgui, manager)

%% Callback for hitting the apply or ok buttons
if ishandle(this) && isa(this.up,'spenodes.TransientData')
   utAddPreprocessedData(this, thispreprocessgui, manager)
else
   errordlg('Invalid destination node, reopen Preprocessing Tool', ...
       'Data Preprocessing Tool','modal')
end
      
function localUpdateDatasetCombo(es,ed, transdatanode, leafnode, ...
    preprocgui, manager)

%% If the current node was removed then close the preprocessing GUI
if ~isempty(ed) && strcmp(ed.Type,'ObjectChildRemoved') && leafnode == ed.Child
    preprocgui.javaframe.dispose;
    return
end

%% Listener callback which updates the preprocessing GUI node combo if
%% the transientdata node children change

% Find selected data leaf (if any)
transdatasetnodes = transdatanode.getChildren;
if ~isempty(ed) && strcmp(ed.Type,'ObjectChildRemoved') % Remove any nodes being deleted
    deletedNodes = (transdatasetnodes==ed.Child);
    transdatasetnodes = transdatasetnodes(~deletedNodes);
end
datasetlabels = get(transdatasetnodes,{'Label'});
selectedLeaf = manager.Explorer.getSelected;
% Put selected leaf first
for k=1:length(transdatasetnodes)
    if isequal(transdatasetnodes(k).getTreeNodeInterface,selectedLeaf)
        tempstr = datasetlabels{1};
        datasetlabels{1} = datasetlabels{k};
        datasetlabels{k} = tempstr;
    end
end
if ~isempty(transdatasetnodes)
    preprocgui.javaframe.setNodeComboContents(datasetlabels);
else
    preprocgui.javaframe.setNodeComboContents({''});
end

% Update the new node text box to a good default
newnodestr = 'Dataset1';
k = 1;
while any(strcmp(newnodestr,datasetlabels))
    k=k+1;
    newnodestr = sprintf('Dataset%d',k);
end
preprocgui.javaframe.fNewNodeText.setText(newnodestr);

function localSyncCurrentDataset(this,h)

% Forces the currently selected data set in the processing GUI to match
% the first row selection in the SPE table
if this.Dialog.getTransientOutData.isVisible % Output tab selected 
    selrows = this.Dialog.getTransientOutData.getDataTable.getSelectedRows;
    if ~isempty(selrows)  
        localSetposition(this.Experiment.OutputData,selrows,h);
    end
elseif this.Dialog.getTransientInData.isVisible  % Input table selected
    selrows = this.Dialog.getTransientInData.getDataTable.getSelectedRows;
    if ~isempty(selrows)  
        localSetposition(this.Experiment.InputData,selrows,h);
    end
end

function localSetposition(tableData,selrows,thispreprocessgui)

% Find the block which coresponds to the first selected row in the
% table and move the current preprocessgui handle Position property 
% to the location of that block. This will force the dataset combo
% on the preproc gui to the earliest currently selected block
indices = tableData(1).indices(tableData);
blocks = get(tableData,{'Block'});
I = selrows+1>indices(1)  & ~ismember(selrows+1,indices);
if any(I)
   blknum = max(find(indices<min(selrows(I)+1)));
   Iselect = find(strcmp(blocks{blknum},get(thispreprocessgui.datasets,{'Name'})));
   if ~isempty(Iselect)
       thispreprocessgui.Position = Iselect;
   end
end

function localTableEditManager(this,h)

%% Install table edit listeners to prevent input data edits
send(handle(this.Dialog.getTransientInData),'AncestorAdded')
ceditin = this.Dialog.getTransientInData.getDataTable.getCellEditor(0,0);
txtboxinedit = getComponent(ceditin);
this.Handles.h_txtboxinedit = handle(txtboxinedit, 'callbackproperties');
this.Handles.h_txtboxinedit.KeyTypedCallback = ...
    {@localStopEdit ceditin h};

%% Install table edit listeners to prevent output data edits
send(handle(this.Dialog.getTransientOutData),'AncestorAdded')
ceditout = this.Dialog.getTransientOutData.getDataTable.getCellEditor(0,0);
txtboxoutedit = getComponent(ceditout);
this.Handles.h_txtboxoutedit = handle(txtboxoutedit, 'callbackproperties');
this.Handles.h_txtboxoutedit.ActionPerformedCallback = ...
    {@localStopEdit ceditout h};

function localStopEdit(eventSrc, eventData, cedit,h)

if strcmp(h.Visible,'on')
    awtinvoke(cedit,'cancelCellEditing');
    msgbox('Tabular input or output data cannot be modifed while the Preprocessing Tool is open.',...
        'Preprocessing Tool','modal')
end

function localHelp(eventSrc, eventData)

helpview([docroot, '/toolbox/slestim/slestim.map'], 'iodata_preprocess');

