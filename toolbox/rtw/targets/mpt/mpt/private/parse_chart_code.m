function parsed = parse_chart_code(cFile,hFile);
%PARSE_CHART_CODE Coordinates parsing of Stateflow code for processing.
%
%  PARSED = PARSE_CHART_CODE(CFILE, HFILE) 
%        It parses the "c" (cFile) and  "h" (hFile) files specified.
%
%  INPUTS:  
%        cFile:  "c" file name to parse
%        hFile:  "h" file name to parse
%
%  OUTPUT:
%        parsed:  results of parsing operation. Array of symbol & free form 
%                     text pairs.

%  Steve Toeppe
%  Copyright 2001-2002 The MathWorks, Inc.
%  $Revision: 1.8.4.1 $  
%  $Date: 2004/04/15 00:28:40 $

parsed = parse_sf_code_init;

parsed = parse_sf_code(parsed,cFile,'c');
parsed = parse_sf_code(parsed,hFile,'h');