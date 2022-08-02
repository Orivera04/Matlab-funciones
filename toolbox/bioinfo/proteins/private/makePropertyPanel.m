function varargout = makePropertyPanel(handles)
%MAKEPROPERTYPANEL - create panel for amino acid properties

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.2.4.3 $  $Date: 2004/01/24 09:20:19 $

import javax.swing.*; import java.awt.*; import java.awt.event.*; import javax.swing.table.*;
import com.mathworks.mwswing.*

update = false;

if nargin
    update = true;
end

propertypanel = MJPanel;

% Create some data
columnNames = {'Amino Acid','Value','Use'};
namedata = defaultaanames;
if update,
    propvaldata = handles.propfcnvalues(:,1);
else 
    propvaldata = zeros(26,1);
    propvaldata([2 10 15 21 24 26]) = NaN; % set B, J, O, U, X, Z to NaN
end
booldata = num2cell(~isnan(propvaldata));
propvaldata = num2cell(propvaldata);

data = [namedata propvaldata booldata];    

% Create the table
% propertytable = JTable(data, columnNames);
% tm = propertytable.getModel;
%propertytable.setModel(tm);

tm = DefaultTableModel(data,columnNames);
h_tm = handle(tm,'callbackproperties');
propertytable = MJTable(tm);

set(h_tm,'TableChangedCallback','');
cm = propertytable.getColumnModel;

% create cell editors

nameEditor = DefaultCellEditor(JTextField);
valueEditor = DefaultCellEditor(JTextField);
useEditor = DefaultCellEditor(JCheckBox);

propertytable.setDefaultEditor(java.lang.Class.forName('java.lang.String'),nameEditor);
propertytable.setDefaultEditor(java.lang.Class.forName('java.lang.Double'),valueEditor);
propertytable.setDefaultEditor(java.lang.Class.forName('java.lang.Boolean'),useEditor);

cm.getColumn(0).setCellEditor(nameEditor);
cm.getColumn(1).setCellEditor(valueEditor);
cm.getColumn(2).setCellEditor(useEditor);

% set number of clicks to start editing
numClicks = 0;
nameEditor.setClickCountToStart(numClicks);
valueEditor.setClickCountToStart(numClicks);
useEditor.setClickCountToStart(numClicks);

scrolltable = JScrollPane(propertytable);
if update % only create the property list when interacting with PROTEINPLOT
    propertypanel.setLayout(GridLayout(2,1));
    % create a listbox to hold the property list
    propertylist = JList(getproteinpropfcns);
    h_propertylist = handle(propertylist,'callbackproperties');
    propertylist.setSelectedIndex(0);
    propertylist.getSelectionModel.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
    set(h_propertylist,'valueChangedCallback', {@propertylistchanged,handles.proteinplotfig,propertytable});
    scrolllist = JScrollPane(propertylist);
    propertypanel.add(scrolllist);
    scrolllist.setPreferredSize(Dimension(200,175));    
    scrolltable.setPreferredSize(Dimension(200,175));
    % make sure that when the table changes, the data changes
    set(h_tm,'TableChangedCallback',{@tablechanged,handles.proteinplotfig,propertytable,propertylist});    
else 
    propertypanel.setLayout(GridLayout(1,1));
    scrolltable.setPreferredSize(Dimension(200,175));
end

propertypanel.add(scrolltable);
propertypanel.setSize(250,265);
propertypanel.setMinimumSize(propertypanel.getSize);

varargout{1} = propertypanel;
varargout{2} = propertytable;
if nargout > 2,
    varargout{3} = propertylist;
end

function tablechanged(h,data,varargin) %#ok

fig = varargin{1};
pt = varargin{2};
pl = varargin{3};

handles = guidata(fig);

selectedprop = get(pl,'SelectedIndex') + 1;

propvaldata = zeros(26,1);

for p = 1:26,
    pv = pt.getValueAt(p-1,1);    
    if isnumeric(pv)
        propvaldata(p) = pv;
    elseif ischar(pv)
        propvaldata(p) = str2num(pv); %#ok
    end
end

handles.propfcnvalues(:,selectedprop) = propvaldata;
guidata(handles.proteinplotfig,handles);

if handles.autoapply
    proteinplot('analyze',handles.proteinplotfig, [], handles)
end

function propertylistchanged(h,data,fig,pt) %#ok
handles = guidata(fig);

% determine which property was selected

selectedprop = get(h,'SelectedIndex') + 1;

if selectedprop,
    propvals = handles.propfcnvalues(:,selectedprop);
else 
    return
end

% shut off TableChangedCallback temporarily
tm = get(pt,'Model');
h_tm = handle(tm,'callbackproperties');
currentcb = get(h_tm,'TableChangedCallback');
set(h_tm,'TableChangedCallback','')

dataVector = javaArray('java.lang.Object',26,3);
namedata = defaultaanames;
for n = 1:26,
    dataVector(n,1) = java.lang.String(namedata{n});
    dataVector(n,2) = java.lang.Double(propvals(n));
    dataVector(n,3) = java.lang.Boolean(~isnan(propvals(n)));
end

columnIdentifiers = javaArray('java.lang.Object',3);
columnIdentifiers(1) = java.lang.String('Amino Acid');
columnIdentifiers(2) = java.lang.String('Value');
columnIdentifiers(3) = java.lang.String('Use');

% get table model's Class, use to get Method
tmClass = getClass(tm);

paramtypes = javaArray('java.lang.Class',2);
paramtypes(1) = dataVector.getClass;
paramtypes(2) = columnIdentifiers.getClass;

% get Method object
meth = tmClass.getMethod(java.lang.String('setDataVector'),paramtypes);

% inputs to Method
arglist = javaArray('java.lang.Object',2);
arglist(1) = dataVector;
arglist(2) = columnIdentifiers;

% invoke method
com.mathworks.mwswing.MJUtilities.invokeLater(tm, meth, arglist);

% make sure proper cell editors are used
nameEditor = javax.swing.DefaultCellEditor(javax.swing.JTextField);
valueEditor = javax.swing.DefaultCellEditor(javax.swing.JTextField);
useEditor = javax.swing.DefaultCellEditor(javax.swing.JCheckBox);

cm = pt.getColumnModel;
awtinvoke(cm.getColumn(0),'setCellEditor',nameEditor);
awtinvoke(cm.getColumn(1),'setCellEditor',valueEditor);
awtinvoke(cm.getColumn(2),'setCellEditor',useEditor); 

% restore callback
set(h_tm,'TableChangedCallback',currentcb);
