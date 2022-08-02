function CreateUpdatePage(blocks, foundParameters, foundDialogParameters)
% given HTML file name and blocks list, create search result page
% it should only be called from htmlgateway.m

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:13 $

% counter for input boxes
countInputBoxes = 0;

HTMLfilename = HTMLattic('AtticData', 'UpdatePage');

f=fopen(HTMLfilename, 'w');

% write help java script
js = fileread([HTMLattic('AtticData', 'cmdRoot') filesep 'translate.js']);
fprintf(f, '%s', js);

% write form header
fprintf(f, '<form method="POST" action="matlab: htmlgateway " name=f>\n');

% Write start new search link
line = createHTMLSource('StartNewSearch');
fprintf(f, '%s\n', line);

% Write Title
fprintf(f, '<h2 align="center">Search and replace</h2>\n');

% write update button
if ~isempty(blocks)
    fprintf(f, '<p align="center">Perform a batch update on the following selected items: <input type="submit" value="Update Parameter" name="updateButton" onClick="htmlEncode(this.form)"></p>');
    
    % create Dialog parameters table
    if isa(blocks(1), 'Stateflow.Data')
        [line,countInputBoxes] = createsfParamsTable(countInputBoxes);
        fprintf(f, '%s\n', line);
        % create search results table
        line = createfoundsfObjectsTable(blocks);
        fprintf(f, '%s\n', line);
    else
        [line,countInputBoxes] = createdialogParamsTable(blocks, countInputBoxes);
        fprintf(f, '%s\n', line);
        % create search results table
        line = createfoundObjectsTable(blocks);
        fprintf(f, '%s\n', line);
    end
    
    
    fprintf(f, '<p><p><P>');
    
    % write update button
    fprintf(f, '<p align="center">Perform a batch update on the following selected items: <input type="submit" value="Update Parameter" name="updateButton" onClick="htmlEncode(this.form)"></p>');
else
    fprintf(f, '<p>No objects found. </p>');
end    

fprintf(f, '</form>\n');
fclose(f);
% end main function



% create read-only input box 
function htmlSource = createReadOnlyInputBox(name, value)
htmlSource = ['<input type="text" name="' locDeocdeHTML(name) '" size="20" value="' locDeocdeHTML(value) '" readonly>'];

% create is/isnot input menu
function htmlSource = createIsorNotInputMenu(name, value)
if value == 1
    htmlSource = ['<select name="' locDeocdeHTML(name) '"><option selected>is</option><option>isnot</option></select> '];
else
    htmlSource = ['<select name="' locDeocdeHTML(name) '"><option>is</option><option selected>isnot</option></select> '];
end


% translate HTML decode
function output = locDeocdeHTML(input)
output = '';
if ~isempty(input)
    output = strrep(input, '+', ' ');
end

% create found objects table
function htmlSource = createfoundObjectsTable(foundObjects)
htmlSource = '<p> Objects that satisfy search conditions: ';
%htmlSource = '<p> Objects that satisfy search conditions (manually select or deselect specific items): ';
%htmlSource = [htmlSource '<input type="radio" value="select" name="SelectAll" onChange="selectAll(this.form, true)">select all'];
%htmlSource = [htmlSource '<input type="radio" value="unselect" name="SelectAll" onChange="selectAll(this.form, false)">unselect all'];
htmlSource = [htmlSource '<table border="1" width="100%">'];

htmlSource = [htmlSource '<tr><td>name</td>'];
USER_INPUT = HTMLattic('AtticData', 'USER_INPUT');
for j=1:length(USER_INPUT)
    if isfield(USER_INPUT(j), 'paramChecked')
        if (USER_INPUT(j).paramChecked)
            if ~strcmpi(USER_INPUT(j).Property, 'You name it')
                htmlSource = [htmlSource '<td>' USER_INPUT(j).Property '</td>'];
            end
        end
    end
end
htmlSource = [htmlSource '<td>Type</td></tr>'];

for i = 1:length(foundObjects)
    htmlSource = [htmlSource '<tr>'];
    userSelectTag = ['foundObjChecked_' num2str(i)];
    htmlSource = [htmlSource  '<input type="hidden" name="' userSelectTag '" checked>' ];
    %htmlSource = [htmlSource '<td>' '<input type="checkbox" name="' userSelectTag '" checked>' '</td>'];
    %str = ['<td>' '<input type="checkbox" name="' get_param(blocks(i), 'name') '">' '</td>'];
    %fprintf(f, '\t%s\n', str);
    currentBlockName = unifygetparam(foundObjects(i),'name');
    currentBlockType = unifygetparam(foundObjects(i),'Type');
    %htmlSource = [htmlSource '<td>' getHiliteHyperlink(foundObjects(i)) '</td>']; 
    htmlSource = [htmlSource '<td>' getHiliteHyperlink(i) '</td>']; 
    
    for j=1:length(USER_INPUT)
        if isfield(USER_INPUT(j), 'paramChecked')
            if (USER_INPUT(j).paramChecked)
                if ~strcmpi(USER_INPUT(j).Property, 'You name it')
                    %p=unifygetparam(foundObjects(i), 'ObjectParameters');
                    %if isfield(p, USER_INPUT(j).Property)
                    if isprop(foundObjects(i), USER_INPUT(j).Property)
                        htmlSource = [htmlSource '<td>' unifygetparam(foundObjects(i), USER_INPUT(j).Property) '</td>'];
                    else
                        htmlSource = [htmlSource '<td> N/A </td>'];
                    end
                end
            end
        end
    end
    htmlSource = [htmlSource '<td>' currentBlockType '</td>'];
    htmlSource = [htmlSource '</tr>'];
end
htmlSource = [htmlSource '</table>'];


% create fuzzy parameters search result table
function [htmlSource,countInputBoxes] = createfoundfuzzyParamsTable(foundParameters, objects,countInputBoxes)
%htmlSource = sprintf('<p>Fuzzy Parameter Search Result: \n');
HideNoPromptDialogParameter = HTMLattic('AtticData', 'HideNoPromptDialogParameter');
htmlSource = sprintf('\n');
htmlSource = [htmlSource '<table border="1" width="100%">'];
htmlSource = [htmlSource '<tr><td></td><td>Name</td><td>Dialog Prompt</td><td>Value</td></tr>'];
for i=1:length(foundParameters)
    idxStr = num2str(i+countInputBoxes);
    ParamCheckedTag = ['paramChecked_' num2str(idxStr)];
    [prompt, inputBox] = findParamInfo(foundParameters{i}, ['NewValue_' idxStr], [ParamCheckedTag '.checked=true; uncheckOthers(this.form, ' ParamCheckedTag ');'], objects);
    if strcmp(prompt, 'No associated dialog prompt') && HideNoPromptDialogParameter % if empty prompt and hide empty parameters
        continue;
    end
     % write param check box
     htmlSource = [htmlSource '<tr>'];
     htmlSource = [htmlSource '<td>' '<input type="checkbox" name="' ParamCheckedTag '" onChange="uncheckOthers(this.form, this)" >' 'Update</td>'];
    htmlSource = [htmlSource sprintf('<td>%s</td><td>%s</td><td>Specify New Value: %s</td>\n', createReadOnlyInputBox(['Property_' idxStr], foundParameters{i}), prompt,inputBox)];
    htmlSource = [htmlSource '</tr>'];
end
countInputBoxes = countInputBoxes+length(foundParameters);
htmlSource = [htmlSource '</table>'];


function [htmlSource,countInputBoxes] = createdialogParamsTable(objects,countInputBoxes)
dialogParams = [];
for i=1:length(objects)
    fp = get_param(objects(i), 'ObjectParameters');
    if strcmpi(get_param(objects(i), 'Type'), 'port')  % grab all paramters if objects is port
        dialogParams = union(dialogParams, fieldnames(fp));
        continue
    end
    if isfield(fp, 'DialogParameters')
        dp = get_param(objects(i), 'DialogParameters');
        try
            if ~isempty(dp)
                dialogParams = union(dialogParams, fieldnames(dp));
            end
        catch
            %just ignore it;
        end
    end
end
dialogParams = unique(dialogParams);
%for i=1:length(dialogParams)
%    htmlSource = [htmlSource sprintf('\t%s\n', dialogParams{i})];
%end
if ~isempty(dialogParams)
    htmlSource = sprintf('<p>Dialog Parameter List: \n');
    [line,countInputBoxes] = createfoundfuzzyParamsTable(dialogParams, objects,countInputBoxes);
    htmlSource = [htmlSource line];
else
    htmlSource = ['<p> No dialog parameters found.'];
end
%htmlSource = [htmlSource '</pre>'];


% create stateflow parameters table
function [htmlSource,countInputBoxes] = createsfParamsTable(countInputBoxes)
htmlSource = sprintf('\n');
htmlSource = [htmlSource '<table border="1" width="100%">'];
htmlSource = [htmlSource '<tr><td></td><td>Name</td><td>Dialog Prompt</td><td>Value</td></tr>'];
htmlSource = [htmlSource '<tr>'];

countInputBoxes = countInputBoxes+1;
idx = num2str(countInputBoxes);
htmlSource = [htmlSource '  <td><input type="checkbox" name="paramChecked_' idx '" onChange="uncheckOthers(this.form, this)" >Update</td>'];
htmlSource = [htmlSource '  <td><input type="text" name="Property_' idx '" size="20" value="DataType" readonly></td>'];
htmlSource = [htmlSource '  <td>Data type:</td>'];
htmlSource = [htmlSource '  <td>Specify New Value: <select name="NewValue_' idx '" onChange="paramChecked_' idx '.checked=true; uncheckOthers(this.form, paramChecked_' idx ');">'];
htmlSource = [htmlSource '     <option>fixpt</option>'];
htmlSource = [htmlSource '     <option>double</option>'];
htmlSource = [htmlSource '     <option>single</option>'];
htmlSource = [htmlSource '     <option>int32</option>'];
htmlSource = [htmlSource '     <option>int16</option>'];
htmlSource = [htmlSource '     <option>int8</option>'];
htmlSource = [htmlSource '     <option>uint32</option>'];
htmlSource = [htmlSource '     <option>uint16</option>'];
htmlSource = [htmlSource '     <option>uint8</option>'];
htmlSource = [htmlSource '     <option>boolean</option>'];
htmlSource = [htmlSource '     <option>ml</option>'];
htmlSource = [htmlSource '  </select></td>'];
htmlSource = [htmlSource '</tr>'];

countInputBoxes = countInputBoxes+1;
idx = num2str(countInputBoxes);
htmlSource = [htmlSource '  <td><input type="checkbox" name="paramChecked_' idx '" onChange="uncheckOthers(this.form, this)" >Update</td>'];
htmlSource = [htmlSource '  <td><input type="text" name="Property_' idx '" size="20" value="FixptType_BaseType" readonly></td>'];
htmlSource = [htmlSource '  <td>Fixpoint data type:</td>'];
htmlSource = [htmlSource '  <td>Specify New Value: <select name="NewValue_' idx '" onChange="paramChecked_' idx '.checked=true; uncheckOthers(this.form, paramChecked_' idx ');">'];
htmlSource = [htmlSource '     <option>int32</option>'];
htmlSource = [htmlSource '     <option>int16</option>'];
htmlSource = [htmlSource '     <option>int8</option>'];
htmlSource = [htmlSource '     <option>uint32</option>'];
htmlSource = [htmlSource '     <option>uint16</option>'];
htmlSource = [htmlSource '     <option>uint8</option>'];
htmlSource = [htmlSource '  </select></td>'];
htmlSource = [htmlSource '</tr>'];

htmlSource = [htmlSource '</table>'];



% create found sf objects table
% the main difference is user will be able to do single adjustment on the
% page for each sf objects
function htmlSource = createfoundsfObjectsTable(foundObjects)
sfParamsTbl=[];
sfIdx = 0;
sfIdx = sfIdx + 1;
sfParamsTbl(sfIdx).paramName = 'DataType';
sfParamsTbl(sfIdx).paramType = 'enum';
sfParamsTbl(sfIdx).paramenum = {'fixpt', 'double', 'single', 'int32', 'int16',...
        'int8', 'uint32', 'uint16', 'uint8', 'boolean', 'ml'};
sfIdx = sfIdx + 1;
sfParamsTbl(sfIdx).paramName = 'FixptType_BaseType';
sfParamsTbl(sfIdx).paramType = 'enum';
sfParamsTbl(sfIdx).paramenum = {'int32', 'int16', 'int8', 'uint32', 'uint16', 'uint8'};
sfIdx = sfIdx + 1;
sfParamsTbl(sfIdx).paramName = 'FixptType_RadixPoint';
sfParamsTbl(sfIdx).paramType = 'negative_integer';
sfIdx = sfIdx + 1;
sfParamsTbl(sfIdx).paramName = 'FixptType_FractionalSlope';
sfParamsTbl(sfIdx).paramType = 'boolean';

    
htmlSource = '<p> Objects that satisfy search conditions: ';
%htmlSource = '<p> Objects that satisfy search conditions (manually select or deselect specific items): ';
%htmlSource = [htmlSource '<input type="radio" value="select" name="SelectAll" onChange="selectAll(this.form, true)">select all'];
%htmlSource = [htmlSource '<input type="radio" value="unselect" name="SelectAll" onChange="selectAll(this.form, false)">unselect all'];
htmlSource = [htmlSource '<table border="1" width="100%">'];

htmlSource = [htmlSource '<tr><td>name</td>'];
for j=1:length(sfParamsTbl)
    htmlSource = [htmlSource '<td>' sfParamsTbl(j).paramName '</td>'];
end
htmlSource = [htmlSource '<td>Type</td></tr>'];

for i = 1:length(foundObjects)
    htmlSource = [htmlSource '<tr>'];
    userSelectTag = ['foundObjChecked_' num2str(i)];
    htmlSource = [htmlSource  '<input type="hidden" name="' userSelectTag '" checked>' ];
    currentBlockName = unifygetparam(foundObjects(i),'name');
    currentBlockType = unifygetparam(foundObjects(i),'Type');
    %htmlSource = [htmlSource '<td>' getHiliteHyperlink(foundObjects(i)) '</td>']; 
    htmlSource = [htmlSource '<td>' getHiliteHyperlink(i) '</td>']; 
    
    for j=1:length(sfParamsTbl)
        htmlSource = [htmlSource '<td>' num2str(unifygetparam(foundObjects(i), sfParamsTbl(j).paramName)) '</td>'];
    end
    htmlSource = [htmlSource '<td>' currentBlockType '</td>'];
    htmlSource = [htmlSource '</tr>'];
end
htmlSource = [htmlSource '</table>'];