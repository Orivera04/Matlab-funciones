function CreateSearchResultPage(blocks, foundParameters, foundDialogParameters)
% given HTML file name and blocks list, create search result page
% it should only be called from htmlgateway.m

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:13 $

% counter for input boxes
countInputBoxes = 0;
countInputBoxes = countInputBoxes + 5; % first 5 always reserved for static search criteria part

HTMLfilename = HTMLattic('AtticData', 'SearchResultPage');

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
%fprintf(f, '<h2 align="center">Search Results</h2>\n');
fprintf(f, '<h2 align="center">Refine Search/Confirm Search Results</h2>\n');

% write current searh criteria
fprintf(f, '<h4>Current search criteria:\n</h4>');
USER_INPUT = HTMLattic('AtticData', 'USER_INPUT');
[line, countInputBoxes] = createPropertySetupBoxes(USER_INPUT, countInputBoxes);
fprintf(f, '%s\n', line);
fprintf(f, '%s\n', '<hr>');

% write static search options header
%line = fileread([HTMLattic('AtticData', 'cmdRoot') '\staticOptions.html']);
fprintf(f, '<h4>Refine search (add criteria):\n</h4>');
line = createHTMLSource('normal');
fprintf(f, '%s', line);

% write re-search button
fprintf(f, '<p align="left"><input type="submit" value="Refine Search" name="researchButton" onClick="htmlEncode(this.form)"></p>');
fprintf(f, '%s\n', '<hr>');
fprintf(f, '<h4>Search results:\n</h4>');
%fprintf(f, '<p align="left"><input type="submit" value="Proceed to Update Page" name="gotoupdateButton" onClick="htmlEncode(this.form)"> &nbsp;if you are satisfied with the current search result</p>');

%fprintf(f, '<p><h4>If you just want refine your search result, leave "Update To" fields blank.</h4>');

% create search results table
if ~isempty(blocks)
    line = createfoundObjectsTable(blocks);
else
    line = '<p>No objects found.';
end
fprintf(f, '%s\n', line);

fprintf(f, '<p><p><P>');

% create Dialog parameters table
ShowDialogParam = HTMLattic('AtticData', 'ShowDialogParam');
if ShowDialogParam
    fprintf(f, '<p align="left">To view paramater values for each found objects, check the check box associated with parameters then click <input type="submit" value="Show Parameter value" name="showParamvalueButton" onClick="htmlEncode(this.form)"></p>');
    [line,countInputBoxes] = createdialogParamsTable(blocks, countInputBoxes);
    fprintf(f, '%s\n', line);
end

% create user defined free parameters table

fprintf(f, '</form>\n');
fclose(f);
% end main function


% create proerty setting rows from saved user input
function [htmlSource,countInputBoxes] = createPropertySetupBoxes(USER_INPUT, countInputBoxes)
htmlSource = '<p><table border="0" width="60%">';
for i=1:length(USER_INPUT)
%    if ~isempty(USER_INPUT(i).Value) 
%        ButtonClicked = HTMLattic('AtticData', 'ButtonClicked');
%        if strcmpi(ButtonClicked, 'ShowParamValue')
%            if isfield(USER_INPUT(i), 'paramChecked')
                %if USER_INPUT(i).paramChecked
%                    continue                % when show param value, skip checked parameters
                    %end
%            end
%        end
        if ~isfield(USER_INPUT(i), 'paramChecked')
            continue        % skip non checked params
        elseif isempty(USER_INPUT(i).paramChecked) || (~USER_INPUT(i).paramChecked)  % skip non checked params
            continue
        elseif isempty(USER_INPUT(i).Property)
            continue
        else        
            idxStr = num2str(i+countInputBoxes);
            htmlSource = [htmlSource '<tr><td><input type="checkbox" name="paramChecked_' idxStr '" checked></td>'];
            htmlSource = [htmlSource, '<td>', createReadOnlyInputBox(['Property_' idxStr], USER_INPUT(i).Property), '</td>'];
            %          ParamCheckedTag = ['paramChecked_' num2str(idxStr)];
            %        htmlSource = [htmlSource '<td>' '<input type="hidden" name="' ParamCheckedTag '" value="on">']; % create hidden checkbox field
            htmlSource = [htmlSource, '<td>', createIsorNotInputMenu(['IsorNot_' idxStr], USER_INPUT(i).IsorNot), '</td><td>' createInputBox(['Value_' idxStr], USER_INPUT(i).Value) '</td></tr>'];
            %if isfield(USER_INPUT(i), 'NewValue')
            %    NewValue = USER_INPUT(i).NewValue;
            %else
            %    NewValue = '';
            %end
            %htmlSource = [htmlSource, 'Update to ', createInputBox(['NewValue_' idxStr], NewValue)];
            %    end
        end
end
htmlSource = [htmlSource, '</table>'];
countInputBoxes = countInputBoxes+length(USER_INPUT);

% create input box 
function htmlSource = createInputBox(name, value)
htmlSource = ['<input type="text" name="' locDeocdeHTML(name) '" size="20" value="' locDeocdeHTML(value) '">'];

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
htmlSource = '<p> Objects that satisfy search conditions (manually select or deselect specific items):<p>';
htmlSource = [htmlSource '<table width="100%" border="0" cellspacing="0" cellpadding="0">'];
htmlSource = [htmlSource '    <tr> '];
htmlSource = [htmlSource '      <td width="33%">'];
htmlSource = [htmlSource '         <p align="left"><input type="button" value="Select All" name="SelectAll" onClick="selectAll(this.form, true)">'];
htmlSource = [htmlSource '      </td>'];
htmlSource = [htmlSource '      <td width="33%">'];
htmlSource = [htmlSource '         <p align="left"><input type="button" value="Deselect All" name="UnSelectAll" onClick="selectAll(this.form, false)">'];
htmlSource = [htmlSource '      </td>'];
htmlSource = [htmlSource '      <td width="33%">'];
htmlSource = [htmlSource '         <p align="left"><input type="submit" value="Proceed to Update Page" name="gotoupdateButton" onClick="htmlEncode(this.form)">'];
htmlSource = [htmlSource '      </td> '];     
htmlSource = [htmlSource '    </tr>'];
htmlSource = [htmlSource '</table>'];
%htmlSource = [htmlSource '<input type="radio" value="select" name="SelectAll" onChange="selectAll(this.form, true)">select all'];
%htmlSource = [htmlSource '<input type="radio" value="unselect" name="SelectAll" onChange="selectAll(this.form, false)">unselect all'];

htmlSource = [htmlSource '<table border="1" width="100%">'];

htmlSource = [htmlSource '<tr><td></td><td>name</td>'];
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
    htmlSource = [htmlSource '<td>' '<input type="checkbox" name="' userSelectTag '" checked>' '</td>'];
    %str = ['<td>' '<input type="checkbox" name="' get_param(blocks(i), 'name') '">' '</td>'];
    %fprintf(f, '\t%s\n', str);
    currentBlockName = get_param(foundObjects(i),'name');
    currentBlockType = get_param(foundObjects(i),'Type');
    htmlSource = [htmlSource '<td>' getHiliteHyperlink(i) '</td>']; 
    
    for j=1:length(USER_INPUT)
        if isfield(USER_INPUT(j), 'paramChecked')
            if (USER_INPUT(j).paramChecked)
                if ~strcmpi(USER_INPUT(j).Property, 'You name it')
                    p=get_param(foundObjects(i), 'ObjectParameters');
                    if isfield(p, USER_INPUT(j).Property)
                        htmlSource = [htmlSource '<td>' get_param(foundObjects(i), USER_INPUT(j).Property) '</td>'];
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
htmlSource = [htmlSource '<table width="100%" border="0" cellspacing="0" cellpadding="0">'];
htmlSource = [htmlSource '    <tr> '];
htmlSource = [htmlSource '      <td width="33%">'];
htmlSource = [htmlSource '         <p align="left"><input type="button" value="Select All" name="SelectAll" onClick="selectAll(this.form, true)">'];
htmlSource = [htmlSource '      </td>'];
htmlSource = [htmlSource '      <td width="33%">'];
htmlSource = [htmlSource '         <p align="left"><input type="button" value="Deselect All" name="UnSelectAll" onClick="selectAll(this.form, false)">'];
htmlSource = [htmlSource '      </td>'];
htmlSource = [htmlSource '      <td width="33%">'];
htmlSource = [htmlSource '         <p align="left"><input type="submit" value="Proceed to Update Page" name="gotoupdateButton" onClick="htmlEncode(this.form)">'];
htmlSource = [htmlSource '      </td> '];     
htmlSource = [htmlSource '    </tr>'];
htmlSource = [htmlSource '</table>'];

% create fuzzy parameters search result table
function [htmlSource,countInputBoxes] = createfoundfuzzyParamsTable(foundParameters, objects,countInputBoxes)
%htmlSource = sprintf('<p>Fuzzy Parameter Search Result: \n');
htmlSource = sprintf('\n');
htmlSource = [htmlSource '<table border="1" width="100%">'];
htmlSource = [htmlSource '<tr><td></td><td>Name</td><td></td><td>Dialog Prompt</td><td>Value</td></tr>'];
for i=1:length(foundParameters)
    htmlSource = [htmlSource '<tr>'];
    idxStr = num2str(i+countInputBoxes);
    [prompt, inputBox] = findParamInfo(foundParameters{i}, ['Value_' idxStr], ['paramChecked_' idxStr '.checked=true'], objects);
     % write param check box
     ParamCheckedTag = ['paramChecked_' num2str(idxStr)];
     htmlSource = [htmlSource '<td>' '<input type="checkbox" name="' ParamCheckedTag '">' 'View</td>'];
    htmlSource = [htmlSource sprintf('<td>%s</td><td>%s</td><td>%s</td><td>%s</td>\n', createReadOnlyInputBox(['Property_' idxStr], foundParameters{i}),createIsorNotInputMenu(['IsorNot_' idxStr], 1), prompt,inputBox)];
    htmlSource = [htmlSource '</tr>'];
end
countInputBoxes = countInputBoxes+length(foundParameters);
htmlSource = [htmlSource '</table>'];


function [htmlSource,countInputBoxes] = createdialogParamsTable(objects,countInputBoxes)
dialogParams = [];
for i=1:length(objects)
    fp = get_param(objects(i), 'ObjectParameters');
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
htmlSource = sprintf('<p>Dialog Parameter List: (To View paramater values for each found objects, check the check box then click Show Parameter Value button.)\n');
[line,countInputBoxes] = createfoundfuzzyParamsTable(dialogParams, objects,countInputBoxes);
htmlSource = [htmlSource line];
%htmlSource = [htmlSource '</pre>'];



