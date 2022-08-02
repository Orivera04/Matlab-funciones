function newproteinproperty(varargin)
%NEWPROTEINPROPERTY create new amino acid property function.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.2.4.3 $  $Date: 2004/01/24 09:18:50 $

if nargin && isstruct(varargin{1})
    handles = varargin{1};
else
    handles = [];
end

import javax.swing.*; import java.awt.*; import java.awt.event.*;
import com.mathworks.mwswing.*;

frame = MJFrame('New Protein Property Function');


cp = frame.getContentPane;
cp.setLayout(BorderLayout);

smallpanel = MJPanel;
smallpanel.setLayout(GridLayout(2,2));

% filename

filenamelabel = MJLabel('Filename');
smallpanel.add(filenamelabel);
filenamefield = MJTextField(20);
smallpanel.add(filenamefield);



% display string
displaylabel = MJLabel('Display');
smallpanel.add(displaylabel);
displayfield = MJTextField(25);
smallpanel.add(displayfield);

cp.add(smallpanel,BorderLayout.NORTH);

% panel with table to enter data
[proppanel,proptable] = makePropertyPanel;
cp.add(proppanel,BorderLayout.CENTER);

% menu
menubar = MJMenuBar;
frame.setJMenuBar(menubar);

filemenu = MJMenu('File');
menubar.add(filemenu);

saveitem = MJMenuItem('Save');

% set(saveitem,'ActionPerformedCallback',{@savedata,filenamefield,displayfield,proppanel})
% set(saveitem,'MousePressedCallback','')

set(saveitem,'ActionPerformedCallback','')
set(saveitem,'MousePressedCallback',{@saveaafile,handles,filenamefield,displayfield,proptable})

% set(saveitem,'ActionPerformedCallback',{@savedata,filenamefield,displayfield,proppanel})
% set(saveitem,'MousePressedCallback',{@savedata,filenamefield,displayfield,proppanel})

filemenu.add(saveitem);

frame.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
frame.setSize(Dimension(300,450));
frame.setLocation(200,200);
frame.setVisible(1);


function resetdata(h,eventdata,handles,filenamefield,diaplayfield,proptable) %#ok



function saveaafile(h,eventdata,handles,filenamefield,displayfield,proptable) %#ok


tablemodel = proptable.getModel;

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

if exist(filename)
    existquest = questdlg([filename ' already exists.  Overwrite ' filename '?'],'Overwrite file?','Yes','No','No');
    if ~strcmp('Yes',existquest)
        return
    else % need to clear the function from memory
        clear(filename)
    end
end
        

fid = fopen([filename '.m'],'w');

fprintf(fid,'function  prop = %s(aa) \n',filename);
fprintf(fid,['%' upper(filename) ' - \n' ]);
fprintf(fid, 'if nargin == 0, \n');
fprintf(fid,'\tprop = ''AAProp_%s'';\n', displaytext);
fprintf(fid,'\treturn\n');
fprintf(fid,'end\n\n');

fprintf(fid,'if numel(aa) == 1, \n');
fprintf(fid,'\tndx = double(aa) - 96;\n');
fprintf(fid,'\tdata = [%f; ...%% %s \n',proptable.getValueAt(0,1),proptable.getValueAt(0,0));
for r = 1:rows-2,
    pv = proptable.getValueAt(r,1);
    if proptable.getValueAt(r,2)       
        if isnumeric(pv)
            fprintf(fid,'\t\t%f;... %% %s \n',pv,proptable.getValueAt(r,0));
        elseif ischar(pv)
            fprintf(fid,'\t\t%s;... %% %s \n',pv,proptable.getValueAt(r,0));
        end        
    else
        fprintf(fid,'\t\tNaN;... %% %s \n',proptable.getValueAt(r,0));
    end
end
 fprintf(fid,'\t\t%f]; %% %s \n\n',proptable.getValueAt(rows-1,1),proptable.getValueAt(rows-1,0));
 
fprintf(fid,'\t\tprop = data(ndx);\n\n');

fprintf(fid,'else\n');
fprintf(fid,'   prop = zeros(numel(aa),1);\n');
fprintf(fid,'    for n = 1:numel(aa),\n');
fprintf(fid,'        prop(n) = %s(aa(n));\n',filename);
fprintf(fid,'    end\n');
fprintf(fid,'end\n');

fclose(fid);


if ~isempty(handles) && isstruct(handles)
    % add the function handle
    [handles.propfcnnames, handles.propfcnhandles] = getproteinpropfcns;
    set(handles.propertylist,'String',handles.propfcnnames);
    handles.propfcnvaluess = makepropvalmatrix(handles.propfcnhandles);
    pl = handles.dialog.propertylist;
    pl.setListData(handles.propfcnnames)
    guidata(handles.proteinplotfig,handles);
end
