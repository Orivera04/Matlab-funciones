function DialogPanel = getDialogSchema(this, manager)
% GETDIALOGSCHEMA Construct the dialog panel for @EstimationLeaf nodes

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.6.9 $ $Date: 2004/04/11 00:38:46 $

% First create the GUI panel...
DialogPanel = com.mathworks.toolbox.slestim.estimation.EstimationLeaf;

% ... then initialize its data. Will fire listeners.
this.initialize;

% Configure panels
this.configureExperimentPanel( DialogPanel.getEstimationData,  manager);
this.configureParameterPanel( DialogPanel.getEstimationParameters, manager);
this.configureStatePanel( DialogPanel.getEstimationStates,  manager);
this.configureRunPanel( DialogPanel.getEstimationRun,  manager);
this.configureRestartPanel( DialogPanel.getEstimationRestarts,  manager);
