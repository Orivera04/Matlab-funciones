function mpm_scope_analysis(modelName)
%MPM_SCOPE_ANALYSIS Analyzes the scope for a chart variables.
%
%  MPM_SCOPE_ANALYSIS(MODELNAME)
%        It is used to analyze the scope for variables in a chart. It can
%        (1) Check if the scoping is compatible with all files involved
%        (2) Check each symbol for duplication within given scope
%        (3) Check each file scope
%        (4) Check each global scope
%         
%  INPUT:
%        modelName: name of the model 
%         
%  OUTPUT:
%        none

%  Steve Toeppe
%  Copyright 2001-2002 The MathWorks, Inc.
%  $Revision: 1.13.4.1 $
%  $Date: 2004/04/15 00:28:32 $

global ecac;

%
% Scopes that have duplications (multiple defines or declarations) need to be 
% resolved. Generally this will mean taking duplicates define/declarations and 
% make them references if the declarations are in different files. If the 
% duplicate is in the same file, it needs to be resolved by eliminating one of the
% duplications. 
%
% If a duplication in name in the same scope does not imply the same item, then 
%there is an error

% Check Global Name Scope Between Files.  Determine if all global name scopes 
% within each file are multiply defined/declared.  If a duplicate is found, then 
% convert to reference symbol.
%
%  For each element associated with each symbol, determine its scope rule
%  globals Define
%       Check if it is globaly defined elsewhere
%           If so, make it extern reference instead
%

scopeInfo = get_scope_info(modelName);

for i=1:length(ecac.definedGlobalNameSpace)
    objStruct = ecac.definedGlobalNameSpace{i};
    objLen = length(objStruct.objInfo);
    
    if objLen > 1
        %
        %duplicate item in name space
        %change declaration of each object except for the first one.
        %
        if scopeInfo.globalFileFlag == 0
            for j=2:objLen
                object = objStruct.objInfo{j}.object;
                remove_reg_obj(objStruct.name,objStruct.objInfo{j}.symbolName,objStruct.objInfo{j}.fileName);
                symInfo = get_symbol_db_element(objStruct.objInfo{j}.symbolName);
                status = register_object_with_sym(objStruct.objInfo{j}.fileName, symInfo.scopeDupResSymbol, object);
            end
        end
    end
end
