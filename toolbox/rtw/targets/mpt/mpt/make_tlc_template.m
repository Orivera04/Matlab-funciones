function make_tlc_template(fileName, newFileName)
%MAKE_TLC_TEMPLATE Make a new template file based on an existing template file
%
%   MAKE_TLC_TEMPLATE(FILENAME, NEWFILENAME)
%         Make a new template file based on an existing template file
%
%   INPUT:
%         fileName: Existing template file name
%         newFileName: New template file name

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.8.4.1 $
%   $Date: 2004/04/15 00:27:18 $

if isempty(fileName)
    disp('Template name (fileName) is empty');
    return;
elseif isempty(newFileName)
    disp('Template name (newFileName) is empty');
    return;
end
wfid = fopen(newFileName,'w');

info = load_single_template(fileName);

for i=1:length(info.line)
    lineStr = [];
    for j=1:length(info.line{i}.freeFormText)
        sStr = info.line{i}.symbol{j};
        if length(sStr) > 0
            symStr = ['%<SLibMPMResolveSymbol(fileIdx,"',sStr,'")>'];
        else
            symStr = '';
        end
        lineStr = [lineStr, info.line{i}.freeFormText{j},symStr];
    end
    fprintf(wfid,'%s\n',lineStr);
end

fclose(wfid);
