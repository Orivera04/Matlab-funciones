function CreateUpdateResultPage(varargin)

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:13 $

HTMLfilename = HTMLattic('AtticData', 'UpdateResultPage');

f=fopen(HTMLfilename, 'w');

% write help java script
js = fileread([HTMLattic('AtticData', 'cmdRoot') filesep 'translate.js']);
fprintf(f, '%s', js);

fprintf(f, '<form method="POST" action="matlab: htmlgateway " name=f>');

% Write start new search link
line = createHTMLSource('StartNewSearch');
fprintf(f, '%s\n', line);

% Write Title
fprintf(f, '<h2 align="center">Update results</h2>\n');

fprintf(f, '<table border="0" width="100%s">', '%');
fprintf(f, '  <tr>');
fprintf(f, '    <td width="50%s">', '%');
fprintf(f, '<p align="center"><input type="submit" value="Undo Updates" name="undoButton" onClick="htmlEncode(this.form)"></td>');
fprintf(f, '    <td width="50%s">', '%');
if ~isempty(varargin)
    %fprintf(f, '<p align="center"><input type="submit" value="Continue" name="refreshDetailConfigButton" onClick="htmlEncode(this.form)"></td>');
    fprintf(f, ['<p align="center"><a href="' varargin{1} '">Continue</a></p>']);
else
    fprintf(f, '<p align="center"><a href="javascript:history.go(-1)">Continue</a></p>');
end
fprintf(f, '  </tr>');
fprintf(f, '</table>');

errorLog = HTMLattic('AtticData', 'errorLog');
if ~isempty(errorLog)
    fprintf(f, '<pre>%s</pre>', errorLog);
end

updateLog= HTMLattic('AtticData', 'updateLog');
[htmlSourceChanged, htmlSourceUnChanged] = createupdateLogTable(updateLog);
fprintf(f, '<p><b>Objects changed</b>%s\n', htmlSourceChanged);
fprintf(f, '<p><b>Objects not changed</b>%s\n', htmlSourceUnChanged);


fprintf(f, '<table border="0" width="100%s">', '%');
fprintf(f, '  <tr>');
fprintf(f, '    <td width="50%s">', '%');
fprintf(f, '<p align="center"><input type="submit" value="Undo Updates" name="undoButton" onClick="htmlEncode(this.form)"></td>');
fprintf(f, '    <td width="50%s">', '%');
if ~isempty(varargin)
    %fprintf(f, '<p align="center"><input type="submit" value="Continue" name="refreshDetailConfigButton" onClick="htmlEncode(this.form)"></td>');
    fprintf(f, ['<p align="center"><a href="' varargin{1} '">Continue</a></p>']);
else
    fprintf(f, '<p align="center"><a href="javascript:history.go(-1)">Continue</a></p>');
end
fprintf(f, '  </tr>');
fprintf(f, '</table>');
%fprintf(f, '<p align="center"><input type="submit" value="Continue Change Parameters" name="continuedoButton" onClick="htmlEncode(this.form)"></p>');
%<input type="submit" value="Start New Search" name="newsearchButton" onClick="htmlEncode(this.form)">

fprintf(f, '</form>');
fclose(f); % end main function


% create update log table
function [htmlSourceChanged, htmlSourceUnChanged] = createupdateLogTable(updateLog)
%htmlSource = '<p> Update Log';
if ~isempty(updateLog) && ~isempty(updateLog{1}) && ~isempty(updateLog{1}.log)
    htmlSource = '<table border="1" width="100%">';
    htmlSource = [htmlSource '<tr><td>Object</td>'];
    currentLog = updateLog{1}.log;
    for i=1:length(currentLog)
        htmlSource = [htmlSource '<td>' currentLog{i}.ParamName '</td>'];
    end
    htmlSource = [htmlSource '</tr>'];  % created table header
    tblHead = htmlSource;
    
    htmlSourceChanged = '';   % table contains changed log
    htmlSourceUnChanged = ''; % table contains unchanged log
    
    for i = 1:length(updateLog)
        %htmlSource = [htmlSource '<tr>'];
        htmlSource = '<tr>';
        ValueChanged = 0;
        htmlSource = [htmlSource '<td>' getHiliteHyperlink(i) '</td>'];
        currentLog = updateLog{i}.log;
        for j=1:length(currentLog)
            if currentLog{j}.NA
                htmlSource = [htmlSource '<td>' 'N/A' '</td>']; 
                %htmlSource = [htmlSource '<td>' 'NA' '</td>']; 
                %htmlSource = [htmlSource '<td>' 'NA' '</td>']; 
            else
                %htmlSource = [htmlSource '<td>' currentLog{j}.newValue '(was ' currentLog{j}.oldValue ')</td>']; 
                %htmlSource = [htmlSource '<td>' currentLog{j}.setValue '</td>']; 
                %htmlSource = [htmlSource '<td>' currentLog{j}.newValue '</td>']; 
                if ~strcmp(currentLog{j}.newValue, currentLog{j}.oldValue)
                    ValueChanged =1;
                    htmlSource = [htmlSource '<td>' currentLog{j}.newValue '(was ' currentLog{j}.oldValue ')</td>']; 
                else
                    htmlSource = [htmlSource '<td>' currentLog{j}.newValue '</td>']; 
                end
            end
        end
        htmlSource = [htmlSource '</tr>'];
        if ValueChanged
            htmlSourceChanged = [htmlSourceChanged htmlSource];
        else
            htmlSourceUnChanged = [htmlSourceUnChanged htmlSource];
        end
    end
    %htmlSource = [htmlSource '</table>'];
    if ~isempty(htmlSourceChanged)
        htmlSourceChanged = [tblHead htmlSourceChanged '</table>'];
    else
        htmlSourceChanged = '<p>None.';
    end
    if ~isempty(htmlSourceUnChanged)
        htmlSourceUnChanged = [tblHead htmlSourceUnChanged '</table>'];
    else
        htmlSourceUnChanged = '<p>None.';
    end
else
    %htmlSource = [htmlSource ' is empty.'];
    htmlSourceChanged = '<p> None.';
    htmlSourceUnChanged = '<p> None.';
end
