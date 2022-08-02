function remove_reg_obj(name,symbolName,fileName)
%REMOVE_REG_OBJ removes a specific object from the symbol db.
%
%   REMOVE_REG_OBJ(NAME, SYMBOLNAME, FILENAME)
%         removes an object "name" from the symbol "symbolName" registry
%         associated with file "fileName".
%
%   INPUT:
%         name:       name of object to remove
%         symbolName  name of symbol where object is associated
%         fileName    name of file where symbol is associated

%   Steve Toeppe
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.7.4.2 $
%   $Date: 2004/04/15 00:29:03 $

ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');

% for all files
%   if the file name matches
%      for all symbols in the file
%        if the symbol name matches
%           for all object names
%             if object name matches
%               remove from the list
%
for i=1:length(ecac.file)
    if strcmp(ecac.file{i}.name,fileName) == 1
        for j=1:length(ecac.file{i}.sinfo)
            if strcmp(ecac.file{i}.sinfo{j}.symbolName,symbolName) == 1
                newObjects = [];
                for k=1:length(ecac.file{i}.sinfo{j}.objects)
                    if strcmp(ecac.file{i}.sinfo{j}.objects{k}.name, name) == 1

                    else
                        newObjects{end+1}=ecac.file{i}.sinfo{j}.objects{k};
                    end
                end
                ecac.file{i}.sinfo{j}.objects=newObjects;
                rtwprivate('rtwattic', 'AtticData', 'ecac',ecac);
                return;
            end
        end
    end
end
rtwprivate('rtwattic', 'AtticData', 'ecac',ecac);
