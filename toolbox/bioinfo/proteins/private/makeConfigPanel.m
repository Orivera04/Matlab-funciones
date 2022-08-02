function [panel,windowcombobox,edgeweightcombospinner] = makeConfigPanel(handles)
% function [panel,windowcombobox,edgeweighttextfield] = makeConfigPanel(handles)
% create configuration panel

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.2.4.2 $  $Date: 2004/01/24 09:20:18 $

import javax.swing.*; import java.awt.*; import java.awt.event.*;
import com.mathworks.mwswing.*;

% create panel
panel = MJPanel([]);

windowlabel = MJLabel('Window Size:', [], JLabel.LEFT);
windowcombobox = MJComboBox(num2cell(handles.windowrange)); h_windowcombobox = handle(windowcombobox,'callbackproperties');
edgeweightlabel = MJLabel('Edge Weight:', [], JLabel.LEFT);
edgeweightcombospinner = com.mathworks.page.utils.ComboSpinner(1,0,1,.01); h_edgeweightcombospinner = handle(edgeweightcombospinner,'callbackproperties');

windowlabel.setBounds(25,25,100,25);
panel.add(windowlabel);


windowcombobox.setBounds(140,25,75,25);
windowcombobox.setSelectedItem(windowcombobox.getItemAt(find(handles.windowrange == handles.windowlength) - 1));
set(h_windowcombobox,'ActionPerformedCallback', {@windowsizechanged,windowcombobox,handles.proteinplotfig});
panel.add(windowcombobox);


edgeweightlabel.setBounds(25,70,75,25);
edgeweightlabel.setToolTipText('Values should be between 0 and 1');
panel.add(edgeweightlabel);


edgeweightcombospinner.setBounds(140,70,75,25);
edgeweightcombospinner.setInsets(Insets(20,0,20,0));
set(h_edgeweightcombospinner,'ActionPerformedCallback', {@edgeweightchanged,edgeweightcombospinner,handles.proteinplotfig});
set(h_edgeweightcombospinner,'FocusLostCallback', {@edgeweightchanged,edgeweightcombospinner,handles.proteinplotfig});
panel.add(edgeweightcombospinner);


smoothinglabel = MJLabel('Smoothing');
smoothinglabel.setBounds(25,125,75,25);
panel.add(smoothinglabel);


buttonpanel = MJPanel(GridLayout(3,1));

linearradio = MJRadioButton('Linear'); h_linearradio = handle(linearradio,'callbackproperties');
expradio = MJRadioButton('Exponential'); h_expradio = handle(expradio,'callbackproperties');
lowessradio = MJRadioButton('Lowess'); h_lowessradio = handle(lowessradio,'callbackproperties');

linearradio.setSelected(true);
linearradio.setBounds(25,25,150,25);
set(h_linearradio,'ActionPerformedCallback', {@linearradioselected,linearradio,handles.proteinplotfig,edgeweightcombospinner});
buttonpanel.add(linearradio);


expradio.setBounds(25,50,150,25);
set(h_expradio,'ActionPerformedCallback', {@expradioselected,expradio, handles.proteinplotfig,edgeweightcombospinner});
buttonpanel.add(expradio);


lowessradio.setBounds(25,75,150,25);
set(h_lowessradio,'ActionPerformedCallback', {@lowessradioselected,lowessradio,handles.proteinplotfig,edgeweightcombospinner});
buttonpanel.add(lowessradio);

weightgroup = ButtonGroup;
weightgroup.add(linearradio);
weightgroup.add(expradio);
weightgroup.add(lowessradio);

buttonpanel.setBounds(25,150,200,200);

  
buttonpanel.setBorder(BorderFactory.createEmptyBorder(5,5,5,5));
buttonpanel.setBorder(...
    BorderFactory.createCompoundBorder(...
                                          BorderFactory.createLineBorder(Color.gray),...
                                          buttonpanel.getBorder));

panel.add(buttonpanel);
panel.setSize(275,350);



function windowsizechanged(jcb,data,h,hfig) %#ok
handles = guidata(hfig);
handles.windowlength = handles.windowrange(h.getSelectedIndex + 1);
guidata(handles.proteinplotfig,handles);
if handles.autoapply
    proteinplot('analyze', h, [], handles)
end

function edgeweightchanged(jtf,data,h,hfig) %#ok
handles = guidata(hfig);
handles.edgeweight = str2num(h.getText); %#ok
guidata(handles.proteinplotfig,handles);
if handles.autoapply
    proteinplot('analyze', h, [], handles)
end

function linearradioselected(jb,data,h,hfig,ewcs) %#ok
handles = guidata(hfig);
handles.uselinear = true;
handles.useexp = false;
handles.uselowess = false;
guidata(handles.proteinplotfig,handles);
ewcs.setEnabled(true);
if handles.autoapply
    proteinplot('analyze', h, [], handles)
end

function expradioselected(jb,data,h,hfig,ewcs) %#ok
handles = guidata(hfig);
handles.useexp = true;
handles.uselinear = false;
handles.uselowess = false;
guidata(handles.proteinplotfig,handles);
ewcs.setEnabled(true);
if handles.autoapply
    proteinplot('analyze',h, [], handles)
end

function lowessradioselected(jb,data,h,hfig,ewcs) %#ok
handles = guidata(hfig);
handles.uselowess = true;
handles.uselinear = false;
handles.useexp = false;
guidata(handles.proteinplotfig,handles);
ewcs.setEnabled(false);
if handles.autoapply
    proteinplot('analyze', h, [], handles)
end
