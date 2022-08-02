function varargout = proteinpropertydlg(handles)
%PROTEINPROPERTYDLG create protein property dialog

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.5.4.3 $  $Date: 2004/01/24 09:20:23 $

% java import
import javax.swing.*; import java.awt.*;
import com.mathworks.mwswing.*;


% create main frame
frame = MJFrame('Property');
frame.setSize(300,500);

% create tabbed panes
tabpane = MJTabbedPane;

% configuration panel
[configpanel,configwindowlength,configedgeweight] = makeConfigPanel(handles);
tabpane.addTab('Configure',configpanel);

% property table
[proptablepanel, propertytable,propertylist] = makePropertyPanel(handles);
tabpane.addTab('Property Data', proptablepanel);

% new property
[addproppanel, addproptable] = makeAddPropertyPanel(handles,propertylist,tabpane);
tabpane.addTab('Add Property', addproppanel);
% tabpane.setEnabledAt(2,false);

tabpane.setSize(275,300);

% actions: auto apply check box, buttons
gbl = GridBagLayout;
actionpanel = MJPanel(gbl);

gbc = GridBagConstraints;
gbc.gridx = 0; gbc.gridy = 0;
gbc.fill = GridBagConstraints.NONE;
gbc.insets = Insets(5,5,5,5);


autoapplybox = JCheckBox('Auto apply changes');
h_autoapplybox = handle(autoapplybox,'callbackproperties');

okbutton = MJButton('OK');
h_okbutton = handle(okbutton,'callbackproperties');

cancelbutton = MJButton('Cancel');
h_cancelbutton = handle(cancelbutton,'callbackproperties');

applybutton = MJButton('Apply');
h_applybutton = handle(applybutton,'callbackproperties');

helpbutton = MJButton('Help');
h_helpbutton = handle(helpbutton,'callbackproperties');

% apply check box
set(h_autoapplybox,'ItemStateChangedCallback',{@autoapplychanged,autoapplybox,handles.proteinplotfig,cancelbutton,applybutton})
gbc.gridwidth = GridBagConstraints.REMAINDER;
gbc.anchor = GridBagConstraints.WEST;
gbl.setConstraints(autoapplybox,gbc);
actionpanel.add(autoapplybox);


% OK
okbutton.setSize(okbutton.getMinimumSize);
set(h_okbutton,'MouseClickedCallback',{@okclicked,okbutton,handles.proteinplotfig,frame})
gbc.gridy = 1;
gbc.gridwidth = 1;
gbc.anchor = GridBagConstraints.CENTER;
gbl.setConstraints(okbutton,gbc);
actionpanel.add(okbutton);


% Cancel
cancelbutton.setSize(cancelbutton.getMinimumSize);
set(h_cancelbutton,'MouseClickedCallback',{@cancelclicked,cancelbutton,handles.proteinplotfig,frame})
gbc.gridx = GridBagConstraints.RELATIVE;
gbl.setConstraints(cancelbutton,gbc);
actionpanel.add(cancelbutton);


% Apply
applybutton.setSize(applybutton.getMinimumSize);
set(h_applybutton,'MouseClickedCallback',{@applyclicked,applybutton,handles.proteinplotfig,frame})
gbl.setConstraints(applybutton,gbc);
actionpanel.add(applybutton);


% Help
helpbutton.setSize(helpbutton.getMinimumSize);
set(h_helpbutton,'MouseClickedCallback',{@helpclicked,helpbutton,handles.proteinplotfig,})
gbl.setConstraints(helpbutton,gbc);
actionpanel.add(helpbutton);

actionpanel.setSize(275,140);

centerdlg(handles.proteinplotfig,frame);

% set frame properties
frame.setResizable(false);
frame.setDefaultCloseOperation(MJFrame.HIDE_ON_CLOSE)

cp = frame.getContentPane;
cp.setLayout(BorderLayout);
cp.add(tabpane, BorderLayout.NORTH);
cp.add(actionpanel,BorderLayout.CENTER);


% pass output back to PROTEINPLOT
pd.frame = frame;
pd.tabpane = tabpane;
pd.proptablepanel = proptablepanel;
pd.propertylist = propertylist;
pd.propertytable = propertytable;
pd.configpanel = configpanel;
pd.configwindowlength = configwindowlength;
pd.configedgeweight = configedgeweight;
pd.addproppanel = addproppanel;
pd.addproptable = addproptable;

handles.dialog = pd;

varargout{1} = handles;

function autoapplychanged(aacheckbox,data,h,hfig,close,apply) %#ok
import java.awt.event.ItemEvent;
handles = guidata(hfig);

if h.isSelected
    handles.autoapply = true;
    awtinvoke(close,'setEnabled',false);
    awtinvoke(apply,'setEnabled',false);
    proteinplot('analyze',handles.proteinplotfig,[],guidata(handles.proteinplotfig))
else
    handles.autoapply = false;
    awtinvoke(close,'setEnabled',true);
    awtinvoke(apply,'setEnabled',true);
end

guidata(hfig,handles);

function okclicked(okbtn,data,h,hfig,frame) %#ok
frame.hide;
proteinplot('analyze',hfig,[],guidata(hfig))


function cancelclicked(cancelbtn,data,h,hfig,frame) %#ok
frame.hide;

function applyclicked(applybtn,data,h,hfig,frame) %#ok
proteinplot('analyze',hfig,[],guidata(hfig))

function helpclicked(helpbtn,data,h,hfig) %#ok
helpwin('proteinplot');
