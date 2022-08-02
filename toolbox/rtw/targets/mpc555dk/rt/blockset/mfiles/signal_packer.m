function out = signal_packer(block,action, varargin)
%SIGNAL_PACKER

%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.8.4.2 $

block = get_param(block,'handle');
obj = get_param(block,'UserData');

switch action
case 'getmessage'
    out = {obj.message};
case 'getsignals'
    out = {obj.signals};
case 'reset'
    obj.message = {};
    obj.signals = {};
    obj.dBaseName = 'Jaguar CAN Database'; 
    obj.tableName = 'db1';
    obj.block = block;
    obj.gui = [];
    
    set_param(block,'UserDataPersistent','on');
    set_param(block,'MaskSelfModifiable','on');
    
    set_param(block,'openfcn','');
    set_param(block,'openfcn','signal_packer(gcbh,''openfcn'')');
    set_param(block,'initfcn','');
    set_param(block,'linkstatus','none');
    set_param(block,'presavefcn','signal_packer(gcbh,''presavefcn'')');
    object.gui=[];
    disp('User Data Has Fields')
    obj
case 'build'
    build_candb_tx(block,obj.message,obj.signals)
case 'openfcn'
    raiseGui(block)
case 'presavefcn'
    obj.gui = [];
otherwise
    error([action ' is not a supported argument']);
end

set_param(block,'UserData',obj);


function raiseGui(block)
obj = get_param(block,'UserData');
obj.block = get_param(block,'Handle');
if isempty(obj.gui) 
    object = buildGui(obj,block);
else
    %obj = i_setData(obj);
    obj.gui.dialog.show;
    obj.gui.dialog.pack;
end


function object = buildGui(object,block)
import('javax.swing.*');
import('javax.swing.table.*');
import('java.lang.*');
import('java.awt.*');
import('com.mathworks.a157.util.*');


gui.dialog = JDialog([],'Can Signal Builder');
gui.dialog.setDefaultCloseOperation(WindowConstants.DO_NOTHING_ON_CLOSE);
%dialog.setModal(1);

%   $Revision: 1.8.4.2 $  $Date: 2004/04/29 03:40:20 $

gui.dBasePanel.panel = Box.createHorizontalBox;
gui.dBasePanel.panel.add(JLabel('Database Name'));
gui.dBasePanel.text = JTextField(object.dBaseName,20);
gui.dBasePanel.panel.add(gui.dBasePanel.text);

gui.signalsPanel.panel = JPanel(BorderLayout);

gui.signalsPanel.list = JTable;
list = gui.signalsPanel.list;
list.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
list.sizeColumnsToFit(JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);
list.setAutoResizeMode(JTable.AUTO_RESIZE_SUBSEQUENT_COLUMNS);

gui.signalsPanel.list.getTableHeader.setReorderingAllowed(0) 

scroll = JScrollPane(gui.signalsPanel.list);
scroll.setBorder( BorderFactory.createTitledBorder('Signals'));
gui.signalsPanel.panel.add(scroll,BorderLayout.CENTER);

gui.exitPanel.buttons.confirm = JButton('Confirm Change');
gui.exitPanel.buttons.cancel  = JButton('Cancel');
gui.exitPanel.panel = JPanel;
gui.exitPanel.panel.add(gui.exitPanel.buttons.confirm);
gui.exitPanel.panel.add(gui.exitPanel.buttons.cancel);


cp = gui.dialog.getContentPane; 
cp.setLayout(BorderLayout);
cp.add(gui.dBasePanel.panel,BorderLayout.NORTH);
cp.add(gui.signalsPanel.panel,BorderLayout.CENTER);
cp.add(gui.exitPanel.panel,BorderLayout.SOUTH);

object.gui = gui;
object = i_setData(object);

set(gui.exitPanel.buttons.confirm,'ActionPerformedCallback',{@i_confirm object });
set(gui.exitPanel.buttons.cancel,'ActionPerformedCallback',{@i_cancel object });
set(gui.dialog,'WindowClosingCallback',{@i_cancel object });




gui.dialog.pack;
gui.dialog.show;

%-----------------------------------------
% Refresh The Data In The Gui
function object = i_setData(object)
import('com.mathworks.a157.util.*');

colHeaders = { 'Message Name' 'Message ID' 'DLC' }; 

object.gui.data.messages = candb('getmessages',object.dBaseName,object.tableName,'%');
object.gui.data.tablemodel = SelectionOnlyTableModel(object.gui.data.messages,colHeaders);
object.gui.signalsPanel.list.setModel(object.gui.data.tablemodel);

if ~isempty(object.message)
    selection = find(strcmp({object.gui.data.messages{:,1}},object.message{1})) -1 ;
else
    selection = 0;
end
if(~isempty(selection))
    object.gui.signalsPanel.list.setRowSelectionInterval(selection,selection);
end



%-----------------------------------
% The 'CONFIRM' Button
function i_confirm(src, event, object)
i = object.gui.signalsPanel.list.getSelectedRow;
object.gui.dialog.dispose;
object.message = {object.gui.data.messages{i+1,:}};
object.signals = candb('getsignals',object.dBaseName,object.tableName,object.message{1});

set_param(object.block,'UserData',object);
signal_packer(gcb,'build');


%--------------------------------------
% The 'CANCEL' Button
function i_cancel(src,event, object)

object.gui.dialog.dispose;

