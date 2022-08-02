function [addproppanel,addproptable] = makeAddPropertyPanel(handles,jproplist,tabpane)
%MAKEADDPROPERTYPANEL - create new amino acid property function

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.2.4.3 $  $Date: 2004/01/24 09:20:17 $

import javax.swing.*; import java.awt.*; import java.awt.event.*;
import com.mathworks.mwswing.*;


gbl = GridBagLayout;
gbc = GridBagConstraints;

addproppanel = MJPanel(gbl);

% create small panel to hold labels and textfields
smallpanel =MJPanel;
smallpanel.setLayout(GridLayout(2,3));


% filename
filenamelabel = MJLabel('Filename:',MJLabel.RIGHT);
smallpanel.add(filenamelabel);
aalabel = MJLabel('aa',MJLabel.RIGHT);
smallpanel.add(aalabel);
filenamefield = MJTextField('',20);
smallpanel.add(filenamefield);

% display string
displaylabel = MJLabel('Display Text:', MJLabel.RIGHT);
smallpanel.add(displaylabel);
smallpanel.add(MJLabel);
displayfield = MJTextField(25);
smallpanel.add(displayfield);


% set positioning for smallpanel in tab
gbc.gridx = 0;
gbc.gridy = 0;
gbc.gridheight = 2;
gbc.gridwidth = 1;
gbc.insets = Insets(10,0,5,0);
gbl.setConstraints(smallpanel,gbc);
addproppanel.add(smallpanel,gbc);


% panel with table
[tablepanel,addproptable] = makePropertyPanel;

gbc.gridy = gbc.RELATIVE;
gbc.gridheight = 12;
gbc.insets = Insets(0,0,0,0);
addproppanel.add(tablepanel,gbc);

% Save button
savebtn = MJButton('Save File');
h_savebtn = handle(savebtn,'callbackproperties');
set(h_savebtn,'ActionPerformedCallback',{@saveaafile,handles,filenamefield,displayfield,addproptable,jproplist,tabpane});

gbc.gridy = gbc.RELATIVE;
gbc.gridheight = 2;
gbc.insets = Insets(5,0,5,0);
addproppanel.add(savebtn,gbc);


function saveaafile(h,eventdata,handles,filenamefield,displayfield,...
                                addproptable,jproplist,tabpane) %#ok
                            
handles = guidata(handles.proteinplotfig);

tablemodel = addproptable.getModel;

rows = tablemodel.getRowCount;

filename = char(filenamefield.getText);
displaytext = char(displayfield.getText);

if isempty(filename)
    return    
end

if isempty(displaytext)
    return
end


filename = ['aa' filename];

if exist([pwd filesep filename '.m'])    
    existquest = questdlg([filename ' already exists.  Overwrite ' filename '?'],'Overwrite file?','Yes','No','No');
    if ~strcmp('Yes',existquest)
        return
    else % need to clear the function from memory
        clear(filename)
    end
end

fid = fopen([filename '.m'],'w');

% check for valid FID
if fid == -1
    errordlg(['Unable to open ' filename '.m for writing.'],'Error writing file','modal')    
    return
end

fprintf(fid,'function  prop = %s(aa) \n',filename);
fprintf(fid,'%%%s - \n' ,upper(filename));
fprintf(fid, 'if nargin == 0, \n');
fprintf(fid,'\tprop = ''AAProp_ %s'';\n', displaytext);
fprintf(fid,'\treturn\n');
fprintf(fid,'end\n\n');

fprintf(fid,'if numel(aa) == 1, \n');
fprintf(fid,'\tndx = double(lower(aa)) - 96;\n');
fprintf(fid,'\tdata = [%f; ...%% %s \n',addproptable.getValueAt(0,1),addproptable.getValueAt(0,0));
for r = 1:rows-2,
    pv = addproptable.getValueAt(r,1);
    if addproptable.getValueAt(r,2)       
        if isnumeric(pv)
            fprintf(fid,'\t\t%f;... %% %s \n',pv,addproptable.getValueAt(r,0));
        elseif ischar(pv)
            fprintf(fid,'\t\t%s;... %% %s \n',pv,addproptable.getValueAt(r,0));
        end        
    else
        fprintf(fid,'\t\tNaN;... %% %s \n',addproptable.getValueAt(r,0));
    end
end
 fprintf(fid,'\t\t%f]; %% %s \n\n',addproptable.getValueAt(rows-1,1),addproptable.getValueAt(rows-1,0));
 
fprintf(fid,'\t\ttry,prop = data(ndx);catch,prop = NaN;end\n\n');

fprintf(fid,'else\n');
fprintf(fid,'   prop = zeros(numel(aa),1);\n');
fprintf(fid,'    for n = 1:numel(aa),\n');
fprintf(fid,'        prop(n) = %s(aa(n));\n',filename);
fprintf(fid,'    end\n');
fprintf(fid,'end\n');

closestatus = fclose(fid);
rehash

if ~closestatus
    handles.statusmessage = [filename '.m saved.'];            
    proteinplot('statusdisplay',handles.proteinplotfig,5,handles);
    disp(handles.statusmessage)
else
    errordlg([filename '.m was not saved.'],'Error saving file');
end

% update the lists, and the value matrix
[handles.propfcnnames, handles.propfcnhandles] = getproteinpropfcns;
val = get(handles.propertylist,'Value');
val = min(val,length(handles.propfcnnames));    
set(handles.propertylist,'String',handles.propfcnnames,'Value',val);
handles.propfcnvalues = makepropvalmatrix(handles.propfcnhandles);
jFcnNames = javaArray('java.lang.String',length(handles.propfcnnames));
for n = 1:length(handles.propfcnnames)
    jFcnNames(n) = java.lang.String(handles.propfcnnames{n});
end

awtinvoke(jproplist,'setListData([Ljava/lang/Object;)',jFcnNames); % TODO waiting for fix to AWTINVOKE, to allow arrays in signature

guidata(handles.proteinplotfig,handles);
