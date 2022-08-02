function parsed = parse_sf_code_init()
%PARSE_SF_CODE_INIT Creates an empty SF parse structure.
%
%  PARSED = PARSE_SF_CODE_INIT() 
%        It is used to create an  empty SF parse structure.
%
%  INPUT:  
%        none
%
%  OUTPUT:
%        parsed:  an empty parse structure 

%  Steve Toeppe
%  Copyright 2001-2002 The MathWorks, Inc.
%  $Revision: 1.8.4.1 $  
%  $Date: 2004/04/15 00:28:43 $

% 
% Structure has placeholders for each type of segment in the SF file.
%
parsed.headers = [];
parsed.stateConstants = [];
parsed.constants = [];
parsed.eventEnumerations = [];
parsed.chartInstanceDefinition = [];
parsed.protoTypes = [];
parsed.chartFunctions = [];
parsed.chartInitializer = [];
parsed.stateStructure = [];
parsed.instanceStructure = [];
parsed.hProtoTypes = [];
parsed.outputDataExterns = [];
parsed.inputDataExterns = [];
parsed.localDataStructure = [];
parsed.parseState = 'EMPTY';
