function CreateFrequentTaskPage
% given HTML file name and blocks list, create search result page
% it should only be called from htmlgateway.m

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:12 $

% counter for input boxes
countInputBoxes = 0;

HTMLfilename = HTMLattic('AtticData', 'FrequentTaskPage');

f=fopen(HTMLfilename, 'w');

% write help java script
js = fileread([HTMLattic('AtticData', 'cmdRoot') filesep 'translate.js']);
fprintf(f, '%s', js);

% Write start new search link
line = createHTMLSource('StartNewSearch');
fprintf(f, '%s\n', line);

% Write Title
fprintf(f, '<p align="left"><b>Frequent tasks:</b> quickly perform the following tasks.  The first set of tasks perform search and modify actions.  The second set of tasks only perform find actions.</p>\n');

% write form header
fprintf(f, '<form method="POST" action="matlab: htmlgateway " name=f>\n');

% write update button
fprintf(f, '<p align="center">Modify all objects for these predefined tasks: <input type="submit" value="Modify" name="frequentTaskButton" onClick="htmlEncode(this.form)"></p>');

% create frequent task table
line = frequentTask;
fprintf(f, '%s\n', line);

fprintf(f, '</form>\n');

fprintf(f, '<p><p><P>');

% write find form header
fprintf(f, '<form method="POST" action="matlab: htmlgateway " name=f2>\n');
% write update button
fprintf(f, '<p align="center">Find all objects for these predefined tasks: <input type="submit" value="Find" name="frequentFindTaskButton" onClick="htmlEncode(this.form)"></p>');
% create frequent task table
line = frequentFindTask;
fprintf(f, '%s\n', line);
fprintf(f, '</form>\n');


fclose(f);
% end main function

function htmlSource = frequentTask
htmlSource = '';
htmlSource = [htmlSource '<table border="1" width="100%"><tr><td></td><td>Description</td><td>Value</td></tr>'];%<tr><td><input type="checkbox" name="paramChecked_1" onChange="uncheckOthers(this.form, this)" >Update</td><td><input type="text" name="Property_1" size="20" value="Gain" readonly></td><td>Gain:</td><td>Specify New Value: <input type="text" name="NewValue_1" onChange="paramChecked_1.checked=true; uncheckOthers(this.form, paramChecked_1);" size="20"></td>'];
%htmlSource = [htmlSource '</tr><tr><td><input type="checkbox" name="paramChecked_9" onChange="uncheckOthers(this.form, this)" >Update</td><td><input type="text" name="Property_9" size="20" value="ParameterScaling" readonly></td><td>Parameter scaling (Slope or [Slope Bias], e.g. 2^-9):</td><td>Specify New Value: <input type="text" name="NewValue_9" onChange="paramChecked_9.checked=true; uncheckOthers(this.form, paramChecked_9);" size="20"></td>'];
%htmlSource = [htmlSource '</tr><tr><td><input type="checkbox" name="paramChecked_10" onChange="uncheckOthers(this.form, this)" >Update</td><td><input type="text" name="Property_10" size="20" value="ParameterScalingMode" readonly></td><td>Parameter scaling mode</td><td>Specify New Value: <select name="NewValue_10" onChange="paramChecked_10.checked=true; uncheckOthers(this.form, paramChecked_10);"><option>Use specified scaling</option><option>Best Precision: Element-wise</option><option>Best Precision: Row-wise</option><option>Best Precision: Column-wise</option><option>Best Precision: Matrix-wise</option></select></td>'];
htmlSource = [htmlSource '<tr><td><input type="checkbox" name="paramChecked_11" onChange="uncheckOthers(this.form, this)" >Modify</td><td><input type="hidden" name="Property_11" size="20" value="RndMeth">Round integer calculations toward</td><td>Specify New Value: <select name="NewValue_11" onChange="paramChecked_11.checked=true; uncheckOthers(this.form, paramChecked_11);"><option>Zero</option><option>Nearest</option><option>Ceiling</option><option>Floor</option></select></td>'];
htmlSource = [htmlSource '<tr><td><input type="checkbox" name="paramChecked_12" onChange="uncheckOthers(this.form, this)" >Modify</td><td><input type="hidden" name="Property_12" size="20" value="SaturateOnIntegerOverflow">Saturate on integer overflow</td><td>Specify New Value: <select name="NewValue_12" onChange="paramChecked_12.checked=true; uncheckOthers(this.form, paramChecked_12);"><option>on</option><option>off</option></select></td>'];
htmlSource = [htmlSource '<tr><td><input type="checkbox" name="paramChecked_13" onChange="uncheckOthers(this.form, this)" >Modify</td><td><input type="hidden" name="Property_13" size="20" value="ShowAdditionalParam">--------------- Show additional parameters ---------------</td><td>Specify New Value: <select name="NewValue_13" onChange="paramChecked_13.checked=true; uncheckOthers(this.form, paramChecked_13);"><option>on</option><option>off</option></select></td>'];
htmlSource = [htmlSource '<tr><td><input type="checkbox" name="paramChecked_14" onChange="uncheckOthers(this.form, this)" >Modify</td><td><input type="hidden" name="Property_14" size="20" value="TestPoint">Test point signals </td><td>Specify New Value: <select name="NewValue_14" onChange="paramChecked_14.checked=true; uncheckOthers(this.form, paramChecked_14);"><option>on</option><option>off</option></select></td>'];
htmlSource = [htmlSource '<tr><td><input type="checkbox" name="paramChecked_15" onChange="uncheckOthers(this.form, this)" >Modify</td><td><input type="hidden" name="Property_15" size="20" value="RTWStorageClass">RTW storage class for signals </td><td>Specify New Value: <select name="NewValue_15" onChange="paramChecked_15.checked=true; uncheckOthers(this.form, paramChecked_15);"><option>Auto</option><option>ExportedGlobal</option><option>ImportedExtern</option><option>ImportedExternPointer</option></select></td>'];
htmlSource = [htmlSource '</tr></table>    '];

function htmlSource = frequentFindTask
htmlSource = '';
htmlSource = [htmlSource '<table border="1" width="100%"><tr><td></td><td>Description</td><td>Condition</td><td>Value</td></tr>'];
htmlSource = [htmlSource '<tr><td><input type="checkbox" name="paramChecked_16" onChange="uncheckOthers(this.form, this)" >Find</td><td><input type="hidden" name="Property_16" size="20" value="TestPoint">Test point signals </td> <td><select name="IsorNot_16"><option>is</option><option>isnot</option></select></td><td> <select name="Value_16" onChange="paramChecked_16.checked=true; uncheckOthers(this.form, paramChecked_16);"><option>on</option><option>off</option></select></td>'];
htmlSource = [htmlSource '<tr><td><input type="checkbox" name="paramChecked_17" onChange="uncheckOthers(this.form, this)" >Find</td><td><input type="hidden" name="Property_17" size="20" value="RTWStorageClass">RTW storage class for signals </td> <td><select name="IsorNot_17"><option>is</option><option>isnot</option></select></td> <td><select name="Value_17" onChange="paramChecked_17.checked=true; uncheckOthers(this.form, paramChecked_17);"><option>Auto</option><option>ExportedGlobal</option><option>ImportedExtern</option><option>ImportedExternPointer</option></select></td>'];
htmlSource = [htmlSource '<tr><td><input type="hidden" name="fuzzySearch" value="off"><input type="checkbox" name="paramChecked_18" onChange="uncheckOthers(this.form, this)" >Find</td><td>Block parameter value </td> <td></td> <td><input type="text" name="fuzzyValue" onChange="paramChecked_18.checked=true; fuzzySearch.value=''on''; uncheckOthers(this.form, paramChecked_18);"></td>'];
htmlSource = [htmlSource '</tr></table>    '];
