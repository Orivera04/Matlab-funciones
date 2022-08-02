function initialize(this,manager)
%INITIALIZE
%
%   Authors: James G. Owen
%   Copyright 1986-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  $Date: 2004/04/11 00:38:23 $

import java.awt.*;
import com.mathworks.toolbox.control.spreadsheet.*;
import javax.swing.*;

%% Assign the targets so the import dialogs update the correct table and
%% frame
this.Explorer = manager.Explorer;

%% Show/build import selector
this.edit(manager.Explorer);

%% Add the help button callback
set(handle(this.ImportSelector.Importhandles.BTNhelp,'callbackproperties'),...
    'ActionPerformedCallback',@localHelp)

%% Show it
rw = MLthread(this.ImportSelector.Importhandles.importDataFrame, ...
    'setVisible',{true});
SwingUtilities.invokeLater(rw);


function localHelp(eventSrc, eventData)

helpview([docroot, '/toolbox/slestim/slestim.map'], 'iodata_import');