function initialize(this,manager)
%INITIALIZE
%
%   Authors: James G. Owen
%   Copyright 1986-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  $Date: 2004/04/11 00:38:27 $

import java.awt.*;
import com.mathworks.toolbox.control.spreadsheet.*;
import javax.swing.*;

% Assign the targets so the import dialogs update the correct table and
% frame
this.Explorer = manager.Explorer;

% Type is state
this.Type = 'state';

% Show/build import selector if it is empty 
if isempty(this.ImportSelector) ||  ~ishandle(this.ImportSelector) 
    this.edit(manager.Explorer);
else
    this.ImportSelector.workbrowser.open
end
awtinvoke(this.ImportSelector.frame,'setVisible', ...
    true);

