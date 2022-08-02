function parsed = parse_sf_code(parsed, fullFileName, fileType)
%PARSE_SF_CODE Parses special Stateflow comments.
%
%  PARSED = PARSE_SF_CODE(PARSED, FULLFILENAME, FILETYPE) 
%        It is used to parse special Stateflow comments for post processing into
%        a structure.
%
%  INPUTS:
%        parsed:             a parsing structure 
%        fullFileName:   full name of file to parse
%        fileType:         the type of the parsed file
%                                fileType = 'c';  fileType = 'h';

%  OUTPUT:
%        parsed:  results of parsing operation 

%  Steve Toeppe
%  Copyright 2001-2002 The MathWorks, Inc.
%  $Revision: 1.10.4.1 $
%  $Date: 2004/04/15 00:28:42 $

%
% parsed.headers                   % /* START OF HEADERS */
% parsed.stateConstants           % /* START OF STATE CONSTANTS */
% parsed.constants                 % /* START OF CONSTNATS */
% parsed.eventEnumerations        % /* START OF EVENT ENUMERATIONS */
% parsed.chartInstanceDefinition % /* START OF CHART INSTANCE DEFINITION */
% parsed.protoTypes                % /* START OF PROTOTYPES */
% parsed.chartFunctions           % /* START OF CHART FUNCTIONS */
% parsed.chartInitializer         % /* START OF CHART INITIALIZER */
% parsed.stateStructure          % /* START OF STATE STRUCTURE */
% parsed.instanceStructure       % /* START OF INSTANCE STRUCTURE */
% parsed.hProtoTypes             % /* START OF PROTOTYPES */
%

%
% open file
% read each line
% if comment matches start
%
fid = fopen(fullFileName, 'r');
if fid > 0
    while 1
        tLine = fgetl(fid);
        if ~ischar(tLine), break, end
        parsed = core_parse(parsed, tLine, fileType);
    end
    fclose(fid);
end

%----------------------------------------------------------------------------------------

function parsed = core_parse(parsed, lineStr, fileType)

switch (parsed.parseState)
case 'EMPTY'
    pStr = [];
    cStart = findstr(lineStr,'/*');
    if isempty(cStart) == 0
        try
            pStr = lineStr(cStart+2:end);
            cEnd =   findstr(pStr,'*/');
            if isempty(cEnd) == 0
                pStr = pStr(1:cEnd-1);
            end
        catch
        end
    end
    if isempty(pStr) == 0
        switch (pStr)
        case ' START OF HEADERS '
            parsed.parseState = 'HEADERS';
        case ' START OF STATE CONSTANTS '
            parsed.parseState = 'STATE_CONSTANTS';
        case ' START OF CONSTANTS '
            parsed.parseState = 'CONSTANTS';
        case ' START OF EVENT ENUMERATIONS '
            parsed.parseState = 'EVENT_ENUMERATIONS';
        case ' START OF CHART INSTANCE DEFINITION '
            parsed.parseState = 'CHART_INSTANCE_DEFINITION';
        case ' START OF PROTOTYPES '
            if strcmp(fileType,'c') == 1
                parsed.parseState = 'PROTOTYPES';
            elseif strcmp(fileType,'h') == 1;
                parsed.parseState = 'HPROTOTYPES';
            end
        case ' START OF CHART FUNCTIONS '
            parsed.parseState = 'CHART_FUNCTIONS';
        case ' START OF CHART INITIALIZER '
            parsed.parseState = 'CHART_INITIALIZATION';
        case ' START OF LOCAL DATA STRUCTURE '
            parsed.parseState = 'LOCAL_DATA_STRUCTURE';
        case ' START OF STATE STRUCTURE '
            parsed.parseState = 'STATE_STRUCTURE';
        case ' START OF INSTANCE STRUCTURE '
            parsed.parseState = 'INSTANCE_STRUCTURE';
        case ' START OF INPUT DATA EXTERNS '
            parsed.parseState = 'INPUT_DATA_EXTERNS';
        case ' START OF OUTPUT DATA EXTERNS '
            parsed.parseState = 'OUTPUT_DATA_EXTERNS';
        otherwise
        end
    end
case 'HEADERS'
    if isempty(findstr(lineStr,'/* END OF HEADERS */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.headers{end+1}=lineStr;
    end
case 'STATE_CONSTANTS'
    if isempty(findstr(lineStr,'/* END OF STATE CONSTANTS */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.stateConstants{end+1}=lineStr;
    end
case 'CONSTANTS'
    if isempty(findstr(lineStr,'/* END OF CONSTANTS */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.constants{end+1}=lineStr;
    end
case 'EVENT_ENUMERATIONS'
    if isempty(findstr(lineStr,'/* END OF EVENT ENUMERATIONS */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.eventEnumerations{end+1}=lineStr;
    end
case 'CHART_INSTANCE_DEFINITION'
    if isempty(findstr(lineStr,'/* END OF CHART INSTANCE DEFINITION */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.chartInstanceDefinition{end+1}=lineStr;
    end
case 'LOCAL_DATA_STRUCTURE'
    if isempty(findstr(lineStr,'/* END OF LOCAL DATA STRUCTURE */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.localDataStructure{end+1}=lineStr;
    end
case 'STATE_STRUCTURE'
    if isempty(findstr(lineStr,'/* END OF STATE STRUCTURE */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.stateStructure{end+1}=lineStr;
    end
case 'INSTANCE_STRUCTURE'
    if isempty(findstr(lineStr,'/* END OF INSTANCE STRUCTURE */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.instanceStructure{end+1}=lineStr;
    end
case 'PROTOTYPES'
    if isempty(findstr(lineStr,'/* END OF PROTOTYPES */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.protoTypes{end+1}=lineStr;
    end
case 'HPROTOTYPES'
    if isempty(findstr(lineStr,'/* END OF PROTOTYPES */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.hProtoTypes{end+1}=lineStr;
    end
case 'CHART_FUNCTIONS'
    if isempty(findstr(lineStr,'/* END OF CHART FUNCTIONS */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.chartFunctions{end+1}=lineStr;
    end
case 'CHART_INITIALIZATION'
    if isempty(findstr(lineStr,'/* END OF CHART INITIALIZER */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.chartInitializer{end+1}=lineStr;
    end
case 'INPUT_DATA_EXTERNS'
    if isempty(findstr(lineStr,'/* END OF INPUT DATA EXTERNS */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.inputDataExterns{end+1}=lineStr;
    end
case 'OUTPUT_DATA_EXTERNS'
    if isempty(findstr(lineStr,'/* END OF OUTPUT DATA EXTERNS */')) == 0
        parsed.parseState = 'EMPTY';
    else
        parsed.outputDataExterns{end+1}=lineStr;
    end
otherwise
end