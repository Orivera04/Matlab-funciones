function disp(obj)
%DISP Display method for image acquisition objects.
%
%    DISP(OBJ) dynamically displays information pertaining to image
%    acquisition object OBJ.
%
%    See also VIDEOINPUT, IMAQDEVICE/GET.

%    CP 9-01-01
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.4 $  $Date: 2004/03/30 13:04:46 $

% Use the default display for an imaqchild object.
if strcmp(class(obj), 'imaqchild');
   builtin('disp', obj);
   return
end

% We need to get variables that will be used in the display routine.
% File identifier...fid=1 outputs to the screen. 
fid=1;

% Determine if we want a compact or loose display.    
isloose = strcmp(get(0,'FormatSpacing'),'loose'); 
if isloose, 
    newline = sprintf('\n'); 
else 
    newline = sprintf('');
end
fprintf(newline);

%  Initialize variables for source table display.
propNames = {'SourceName', 'Selected'};
uddObj = imaqgate('privateGetField', obj, 'uddobject');
nprops = length(propNames);
nObjects = length(obj);
columnSpacing = blanks(4);
indent = blanks(3);

% Define a cell array of invalid values to fill in
% for invalid objects.
invalidStrs = cell(1, nprops);
[invalidStrs{:}] = deal('Invalid');

% Locate all invalid members.
validHandle = ishandle(uddObj);
validInd = find(validHandle==true);

% Add the property names for display as a heading 
% and calculate the max width for each column.
dispNames = {'Index' propNames{:}};
hdrLengths = cellfun('length', dispNames);
propValues = get(uddObj(validInd), propNames);
if nObjects>1,
    % Determine the max property width for each column.
    lenVals = max(cellfun('length', propValues));
else
    % The max property width for each column is simply the
    % length of each column element.
    lenVals = cellfun('length', propValues);
end
propValLengths = [1 lenVals(:)'];

% Determine the maximum width we should use for each column.
%
% Note: The maximum column width may be widened by long
%       property value strings. Since strings get 'quoted', we 
%       add 2 to the width calculation so spacing remains 
%       aligned.
maxColWidth = max(propValLengths+2, hdrLengths);

% First display a header for the object summary.
childHeading = [indent 'Display Summary for Video Source Object'];
if (numel(obj)==1)
    fprintf(fid, '%s:\n%s', childHeading, newline);
else
    fprintf(fid, '%s Array:\n%s', childHeading, newline);
end

% For each object, display its row of property values.
%
% i==0 indicates a header line, not a line of property values.
%
% count is used to index into the valid rows of property values.
% This avoids having to call GET again for each valid UDD object.
count = 0;
for i=0:nObjects,
    % Determine the row elements to use for this object.
    if i==0,
        % Display headers.
        rowValue = dispNames;
        quotes = false;
    elseif validHandle(i),
        count = count +1;
        % Use property values returned from GET and prepend
        % the row with the index value.
        vals = propValues(count, :);
        rowValue = {i vals{:}};
        quotes = true;
    else
        % Add index value and display "Invalid" for each column.
        rowValue = {i invalidStrs{:}};
        quotes = false;
    end
    
    % Determine the length of each row element.
    rowValLengths = cellfun('length', rowValue);
    
    % Cycle through each row's column, and build a string to display.
    sprintfStr = indent;
    for j=1:length(rowValue),
        % Initialize the column field size with blanks.
        columnField = [blanks(maxColWidth(j)), columnSpacing];
        
        % Left justify by determining the left starting point index.
        startInd = length(columnField) - maxColWidth(j);
        
        if i==0,
            % Add ':' to heading titles.
            columnField(startInd:startInd + rowValLengths(j)) = [rowValue{j} ':'];
        elseif ischar(rowValue{j}) && quotes,            
            % Add '' to the string that will be displayed, unless it's the
            % header line or an invalid object.
            columnField(startInd:startInd + rowValLengths(j) + 1) = ['''' rowValue{j} ''''];
        else
            % Convert numerical value to string. In order to index
            % correctly, we need to take into consideration the length of
            % the string to display.
            strval = num2str(rowValue{j});
            columnField(startInd:startInd + length(strval) - 1) = strval;
        end
        
        % Collect strings to display for the jth row.
        sprintfStr = [sprintfStr, columnField];
    end
        
    % Display the current jth row.
    fprintf(fid, '%s\n', sprintfStr);
end

fprintf(newline);
