function out = triggerinfo(obj, triggertype)
%TRIGGERINFO Provide information on available trigger configurations.
%
%    TRIGGERINFO(OBJ) displays all available trigger configurations
%    for video input object OBJ.
%
%    TRIGGERINFO(OBJ, TYPE) displays the available trigger configurations
%    for the specified TriggerType, TYPE, for video input object OBJ.
%
%    CONFIG = TRIGGERINFO(OBJ) returns CONFIG, an array of MATLAB structures,
%    containing all the valid trigger configurations for video input 
%    object OBJ. CONFIG contains the following fields:
%
%      TriggerType      - The name of the trigger type.
%      TriggerCondition - Condition that must be met before executing
%                         a trigger.
%      TriggerSource    - Hardware source used for triggering.
%
%    CONFIG = TRIGGERINFO(OBJ, TYPE) returns CONFIG, an array of MATLAB 
%    structures, each specifying a valid trigger configuration for the 
%    specified TriggerType, TYPE, for video input object OBJ.
%
%    OBJ can only be a 1x1 object. 
%
%    Use TRIGGERCONFIG to configure OBJ with a valid trigger configuration.
%
%    Example:
%       obj = videoinput('dt', 1);
%       triggerinfo(obj)
%
%    See also IMAQDEVICE/TRIGGERCONFIG, IMAQHELP. 
%

%    CP 10-07-02
%    Copyright 2001-2004 The MathWorks, Inc.
%    $Revision: 1.1.6.5 $  $Date: 2004/03/30 13:05:38 $

% Error checking.
if ~isa(obj, 'imaqdevice')
    errID = 'imaq:triggerinfo:invalidType';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif (length(obj) > 1)
    errID = 'imaq:triggerinfo:OBJ1x1';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif ~isvalid(obj)
    errID = 'imaq:triggerinfo:invalidOBJ';
    error(errID, imaqgate('privateMsgLookup',errID));
elseif nargin~=1 && ~ischar(triggertype),
    errID = 'imaq:triggerinfo:stringType';
    error(errID, imaqgate('privateMsgLookup',errID));
end

% Get trigger information.
try
    if nargin==1,
        result = triggerinfo(imaqgate('privateGetField', obj, 'uddobject'));
    else
        result = triggerinfo(imaqgate('privateGetField', obj, 'uddobject'), triggertype);
    end
catch
    errorstruct = lasterror;
    % If the user specifies a known triggertype that does not happen to be
    % supported on the current device, TRIGGERINFO should not error, but
    % should return no information.  This checks that the trigger type
    % specified was hardware, and the reason for the error was that the
    % hardware trigger was not found.
    knownTypes = {'immediate', 'manual', 'hardware'};
    if ( (nargin ~= 1) && any(strmatch(lower(triggertype), knownTypes)) && strcmp(errorstruct.message, 'The TYPE specified is not a valid TriggerType.') )
        % This seems to be the only way in m to make an empty struct with
        % the correct fields.
        result = struct('TriggerType', 'hardware', 'TriggerCondition', 'none', 'TriggerSource', 'none');
        result(1) = [];
    else
        rethrow(errorstruct);
    end
end

% Return results, or pretty print.
if nargout~=0,
    out = result;
else
    % Determine if we want a compact or loose display.    
    isloose = strcmp(get(0,'FormatSpacing'),'loose'); 
    if isloose, 
        newline = sprintf('\n'); 
    else 
        newline = sprintf('');
    end
    
    % Initialize.
    % File identifier...fid=1 outputs to the screen. 
    fid=1;
    indent = blanks(3);
    columnSpacing = blanks(4);
    columnTitle = {'TriggerType' 'TriggerCondition', 'TriggerSource'};
    
    % Calculate the max width for each column in the heading.
    hdrLengths = cellfun('length', columnTitle);
    
    % Determine the total number of configurations.
    nIterations = length(result);
    
    % Create the cell matrix of trigger types appended
    % with each of their available configurations.
    resultVals = {{}, {}, {}};
    for t=1:nIterations,
        resultVals(t, 1:3) = struct2cell(result(t));
    end
    
    % Determine the maximum width we should use for each column.
    %
    % Note: The maximum column width may be widened by long
    %       property value strings. Since strings get 'quoted', we 
    %       add 2 to the width calculation so spacing remains 
    %       aligned.
    lenVals = max(cellfun('length', resultVals));
    maxColWidth = max(lenVals+2, hdrLengths);
    
    % First display a header.
    heading = [indent 'Valid Trigger Configurations'];
    fprintf(fid, '\n%s:\n\n', heading);
    
    % Display each trigger configuration.
    %
    % i==0 indicates the header line to be displayed.
    for i=0:nIterations
        % Determine the row elements to use for this object.
        if i==0
            % Display headers.
            rowValue = columnTitle;
            addQuotes = false;
        else
            % Extract the configuratino to display.
            rowValue = resultVals(i, :);
            addQuotes = true;
        end
        
        % Determine the lengths for this configuration.
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
            elseif addQuotes,            
                % Add '' to the string that will be displayed.
                columnField(startInd:startInd + rowValLengths(j) + 1) = ['''' rowValue{j} ''''];
            end
            
            % Collect strings to display for the jth row.
            sprintfStr = [sprintfStr, columnField];
        end
        
        % Display the current jth row.
        fprintf(fid, '%s\n', sprintfStr);
    end
    
    % Carriage return
    fprintf(fid, '%s', newline);    
end
