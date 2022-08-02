function [menubar, toolbar] = getMenuToolBarSchema(this, manager)
% GETMENUTOOLBARSCHEMA Create menubar and toolbar.  Also, set the callbacks
% for the menu items and toolbar buttons.

% Author(s): Bora Eryilmaz
% Revised:
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.4 $ $Date: 2004/04/11 00:39:01 $

% Create menubar
menubar = com.mathworks.toolbox.control.explorer.MenuBar( ...
                                                  this.getGUIResources, ...
                                                  manager.Explorer );

% Create toolbar
toolbar = com.mathworks.toolbox.control.explorer.ToolBar( ...
                                                  this.getGUIResources, ...
                                                  manager.Explorer );

% Menu callbacks
h = handle( menubar.getMenuItem('project'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalNewProject, this, manager };

h = handle( menubar.getMenuItem('task'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalNewTask, this, manager };

h = handle( menubar.getMenuItem('open'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalOpen, this, manager };

h = handle( menubar.getMenuItem('save'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalSave, this, manager };

h = handle( menubar.getMenuItem('close'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalClose, this, manager };

h = handle( menubar.getMenuItem('model'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalModel, this };

h = handle( menubar.getMenuItem('output'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalOutput, this, manager };

h = handle( menubar.getMenuItem('using'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalUsing, this, manager };

h = handle( menubar.getMenuItem('demos'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalDemos, this, manager };

h = handle( menubar.getMenuItem('about'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalAbout, this, manager };

% Toolbar button callbacks
h = handle( toolbar.getToolbarButton('project'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalNewProject, this, manager };

h = handle( toolbar.getToolbarButton('task'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalNewTask, this, manager };

h = handle( toolbar.getToolbarButton('open'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalOpen, this, manager };

h = handle( toolbar.getToolbarButton('save'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalSave, this, manager };

h = handle( toolbar.getToolbarButton('output'), 'callbackproperties' );
h.ActionPerformedCallback = { @LocalOutput, this, manager };

% --------------------------------------------------------------------------
function LocalNewProject(hSrc, hData, this, manager)
% Create the new project dialog and let it handle the rest
newdlg = explorer.NewProjectDialog(manager.Root);
newdlg.Dialog.show;

% --------------------------------------------------------------------------
function LocalNewTask(hSrc, hData, this, manager)
% Create the new task dialog and let it handle the rest
newdlg = explorer.NewTaskDialog(this.up);
newdlg.Dialog.show;

% --------------------------------------------------------------------------
function LocalOpen(hSrc, hData, this, manager)
manager.loadfrom(this.up);

% --------------------------------------------------------------------------
function LocalSave(hSrc, hData, this, manager)
manager.saveas(this.up)

% --------------------------------------------------------------------------
function LocalClose(hSrc, hData, this, manager)
manager.Explorer.doClose;

% --------------------------------------------------------------------------- %
function LocalModel(hSrc, hData, this)
open_system(this.Model);

% --------------------------------------------------------------------------- %
function LocalOutput(hSrc, hData, this, manager)
isVisible = hData.getSource.isSelected;
awtinvoke(manager.Explorer, 'setStatusArea', isVisible ); % Thread safe

% ----------------------------------------------------------------------------- %
function LocalUsing(hSrc, hData, this, manager)
helpview([docroot '/toolbox/slestim/slestim_product_page.html'])

% ----------------------------------------------------------------------------- %
function LocalDemos(hSrc, hData, this, manager)
demo simulink 'Simulink Parameter Estimation';

% ----------------------------------------------------------------------------- %
function LocalAbout(hSrc, hData, this, manager)
import javax.swing.JOptionPane;

message = sprintf('%s\n%s', 'Simulink Parameter Estimation 1.0', ...
                            'Copyright 2002-2004, The MathWorks, Inc.');

JOptionPane.showMessageDialog(manager.Explorer, message, ...
                              'About Simulink Parameter Estimation', ...
                              JOptionPane.PLAIN_MESSAGE);
