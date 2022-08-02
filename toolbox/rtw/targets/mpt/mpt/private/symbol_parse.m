function parsedLine = symbol_parse(lineStr)
%SYMBOL_PARSE Parses file templates into "comments" and "symbols".
%
%  PARSEDLINE = SYMBOL_PARSE(LINESTR)
%        It is used to parse symbols and free form text from the template files. 
%        This function handles one line at a time.
%
%  INPUT:
%        lineStr:  string from file to process
%
%  OUTPUT:
%        parsedLine:  resulting parsed text containing symbol and free form text

%  Steve Toeppe
%  Revised: Donn Shull
%      changed symblod delimiters for tlc based template.
%  Copyright 2001-2003 The MathWorks, Inc.
%  $Revision: 1.9.4.2 $  $Date: 2004/04/15 00:28:57 $

%
% Structure  parsedLine is  organized as two cell arrays of  strings
% The parsing assuming that each array is indexed with the same index.
% The free_form_text field is the leading field. The symbol follows. Some 
% empty strings will appear in order to preserve pair wise combinations.
%
parsedLine.freeFormText=[];
parsedLine.symbol=[];
symStart=0;
symEnd=0;
 
symbolDelimiterIndex1 = findstr(lineStr, '%<');
symbolDelimiterIndex2 = findstr(lineStr, '>');

% Check for symbol pattern between tlc delimters
if ~isempty(symbolDelimiterIndex1)
    for i=1:length(symbolDelimiterIndex1)
        symbolDelimiterIndex{i} = [symbolDelimiterIndex1(i)+1, symbolDelimiterIndex2(i)];
    end
else
    symbolDelimiterIndex = [];
end

% 
% if symbolfound
%   then separate symbol from extra text on the same line.
%   Save parsed information
%  else
%   indicate empty symbol and save text
%

if isempty(symbolDelimiterIndex) == 0
    len = length(symbolDelimiterIndex);
    for i=1:len
            freeFormStart = symEnd+1;
            symStart= symbolDelimiterIndex{i}(1);
            symEnd  = symbolDelimiterIndex{i}(2);
            parsedLine.symbol{end+1} = lineStr(symStart+1:symEnd-1);  %extract symbol.
            %empty symbol will give empty str
            parsedLine.freeFormText{end+1}=lineStr(freeFormStart:symStart-2);
    end
    %handle lagging free from text case
    if symEnd < length(lineStr)
        parsedLine.freeFormText{end+1}=lineStr(symEnd+1:end);
        parsedLine.symbol{end+1}='';
    end
else
    %NO symbol in string case
    parsedLine.symbol{1}='';
    parsedLine.freeFormText{1}=lineStr;
end
