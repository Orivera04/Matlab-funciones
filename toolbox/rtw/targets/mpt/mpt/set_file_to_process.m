function result = set_file_to_process(fileName)
%SET_FILE_TO_PROCESS Establish global symbolData structure.
%
%   RESULT = SET_FILE_TO_PROCESS(FILENAME)
%         Establish global symbolData and set initial fields.
%
%   INPUT:
%         fileName: File to process
%
%   OUTPUT:
%         result: status = 'OK'

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.9.4.1 $
%   $Date: 2004/04/15 00:29:05 $

global symbolData;
symbolData = [];
result = 'ok';
    symbolData.parsedCode.cFile = fileName;
    symbolData.object = get_data_objects('parsedCode',fileName);
    if isempty(symbolData.object) == 0
    symbolData.parsedCode = symbolData.object{1}.parsedCode;
    symbolData.outputFile = symbolData.object{1}.outputFile;
    symbolData.parseInfo = symbolData.object{1}.parseInfo;
end
