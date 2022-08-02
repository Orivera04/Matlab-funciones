function reg_name_space(scope,objName,object,symbolName,fileName)
%REG_NAME_SPACE Rregisters an object with a particular name space name.
%
%  REG_NAME_SPACE(SCOPE, OBJNAME, SYMBOLNAME, FILENAME)
%        It is used to register an object with a particular name in the global 
%        name space. The objects associated symbol name in the template 
%        and file name are registered. Either a global declaration or reference 
%        is defined.
%
%  INPUTS:  
%         scope:               scope of the global data (global define or reference)
%         objName:          name of object
%         object:               the actual object
%         symbolName:   associated symbol name in the template file
%         fileName:          file where object will be declared or referenced (per scope)
%
%  OUTPUT:
%        none

%  Steve Toeppe
%  Copyright 2001-2002 The MathWorks, Inc.
%  $Revision: 1.8.4.1 $  
%  $Date: 2004/04/15 00:28:46 $

% Note:  The function permits all global objects to be registered per the global name space.

global ecac;

switch(scope)
case 'global'
    done = 0;
    %
    % for each defined global name
    %  if the name already exists
    %   add the object to the name space as a duplicate
    %  else
    %  add the object as a new name space name
    %
    for i=1:length(ecac.definedGlobalNameSpace)
        if strcmp(ecac.definedGlobalNameSpace{i}.name,objName) == 1
            regInfo.object=object;
            regInfo.symbolName = symbolName;
            regInfo.fileName = fileName;
            ecac.definedGlobalNameSpace{i}.objInfo{end+1}=regInfo;
            done=1;
            break;
        end
    end
    if done == 0
        %
        % scope_def.name = objName;
        % scope_def.object{1}=object;
        % ecac.definedGlobalNameSpace{end+1}=scope_def;
        %
        scopeDef = [];
        scopeDef.name = objName;
        scopeDef.objInfo{1}.object=object;
        scopeDef.objInfo{1}.symbolName = symbolName;
        scopeDef.objInfo{1}.fileName = fileName;
        ecac.definedGlobalNameSpace{end+1}=scopeDef;
    end
case 'reference'
    % for each reference name
    %  if the name already exists
    %   add the object to the name space as a duplicate
    %  else
    %  add the object as a new name space name
    done = 0;
    for i=1:length(ecac.refGlobalNameSpace)
        if strcmp(ecac.refGlobalNameSpace{i}.name,objName) == 1
            regInfo.object=object;
            regInfo.symbolName = symbolName;
            regInfo.fileName = fileName;
            ecac.refGlobalNameSpace{i}.objInfo{end+1}=regInfo;
            done=1;
            break;
        end
    end
    if done == 0
        scopeDef = [];
        scopeDef.name = objName;
        scopeDef.objInfo{1}.object=object;
        scopeDef.objInfo{1}.symbolName = symbolName;
        scopeDef.objInfo{1}.fileName = fileName;
        ecac.refGlobalNameSpace{end+1}=scopeDef;
    end
otherwise
end
