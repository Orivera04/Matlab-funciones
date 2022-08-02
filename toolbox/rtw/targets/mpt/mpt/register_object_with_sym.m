function status = register_object_with_sym(fileName, symbolName, object)
%REGISTER_OBJECT_WITH_SYM will register the object with the proper symbol
%   name where the object should be declared.
%
%   STATUS = REGISTER_OBJECT_WITH_SYM(FILENAME, SYMBOLNAME, OBJECT)
%         will register an object (object) with a symbol (symbolName)
%         associated with a specific file (fileName).
%
%   INPUT:
%         fileName:     file name that symbol information is associated with
%         symbolName:   symbol name of interest
%         object:       object to be registered (structure of info)
%
%   OUTPUT:
%         status:       status of operation. 0...pass, -1...fail

%   Steve Toeppe
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.8.4.2 $
%   $Date: 2004/04/15 00:29:02 $

ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');

status = 0; %assume pass until proven otherwise
%file{}.name
%file{}.type    (code, types, globals, misc)
%file{}.sinfo{..}.symbolName
%file{}.sinfo{..}.objects{}.name
%file{}.sinfo{..}.objects{}.type
%file{}.sinfo{..}.objects{}.storage_class
%file{}.sinfo{..}.objects{}.initial_value
%file{}.sinfo{..}.objects{}.comment
try    %protect for flaws in the db structure
if isempty(symbolName) == 1
    x=1;
end

% If this is the first time a chart file has been registered.
%   Then establish the first file element.
%   Else process the update to the file database.
%
if isfield(ecac,'file') == 0
    ecac.file{1}.name = fileName;
    ecac.file{1}.sinfo{1}.symbolName = symbolName;
    ecac.file{1}.sinfo{1}.objects{1} = object;

else
    fi = 0;

    % Search for a file name match. A non zero fi indicates a match.
    for j=1:length(ecac.file)
        if strcmp(ecac.file{j}.name,fileName) == 1
            fi = j;
            break;
        end
    end

    % If a match was not found,
    %   Then insert the new file name at the end of the list
    %   Else add additional information to the same file
    %
    if fi == 0
        fi = length(ecac.file)+1;
        ecac.file{fi}.name = fileName;
        ecac.file{fi}.sinfo{1}.symbolName = symbolName;
        ecac.file{fi}.sinfo{1}.objects{1} = object;
    else
        if isfield(ecac.file{fi},'sinfo') == 0
            ecac.file{fi}.sinfo{1}.symbolName = symbolName;
            ecac.file{fi}.sinfo{1}.objects{1}=object;
        else
            symbolFound = 0;
            for i=1:length(ecac.file{fi}.sinfo)
                if strcmp(ecac.file{fi}.sinfo{i}.symbolName, symbolName) == 1
                    index = i;
                    symbolFound = 1;
                    break;
                end
            end
            if symbolFound == 1
                oindex = length(ecac.file{fi}.sinfo{index}.objects);
                ecac.file{fi}.sinfo{index}.objects{oindex+1} = object;
            else
                index = length(ecac.file{fi}.sinfo);
                ecac.file{fi}.sinfo{index+1}.symbolName = symbolName;
                ecac.file{fi}.sinfo{index+1}.objects{1} = object;
            end
        end
    end
end
catch
    status =-1;  %fail
end
rtwprivate('rtwattic', 'AtticData', 'ecac',ecac);
