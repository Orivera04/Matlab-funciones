function objects = get_data_objects(symbolName, fileName)
%GET_DATA_OBJECTS - Will return objects associated with a symbol and file.
%
%   [OBJECTS]=GET_DATA_OBJECTS(SYMBOLNAME,FILENAME)
%   This function returns all objects associated with a file of fileName
%   and the symbol name of symbolName
%
%   INPUT:
%        fileName:   Name of file to search for
%        symbolName: Namoe of symbol to search for
%   OUTPUT:
%        objects:  all objects associated with the symbol and file name

%   Steve Toeppe
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.10.4.3 $
%   $Date: 2004/04/15 00:27:01 $

ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');

% for all files,
%   if the fileName is found
%     search all allocated symbols associated with the file
%       if the symbolName matches
%         then return all objects associated with the symbol name and file name

objects = [];
if isfield(ecac,'file') == 1
    for i=1:length(ecac.file)
        if strcmp(ecac.file{i}.name,fileName) == 1
            for j=1:length(ecac.file{i}.sinfo)
                if strcmp(ecac.file{i}.sinfo{j}.symbolName,symbolName) == 1
                    objects = ecac.file{i}.sinfo{j}.objects;
                end
            end
        end
    end
end

