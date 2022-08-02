function revisedName = name_revision(nameRules, name, object, symbolName, modelName)
%NAME_REVISION will change a given name (name) based upon the
%         specified rule (rule).
%
%   REVISEDNAME = NAME_REVISION(NAMERULES, NAME, OBJECT, SYMBOLNAME)
%         Will change a given name (name) based upon the specified rule (rule).
%
%   INPUT:
%         nameRules: Rules for name revision
%         name: name to revise
%         object: object
%         symbolName: used to select name revision approach
%         modelName: the name of the model
%
%   OUTPUT:
%         revisedName: revised name
%
%   The result (revisedName) is returned.
%   The rules include the following:
%       name_create:     permits user specified function to be used to create the name
%       case_type:       permits name case to be changed to all upper or lower
%       alias:           permit usage of an alias for the given name.
%       none:            name is not altered

%   Steve Toeppe
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $
%   $Date: 2002/01/26 23:42:48

%
% Updated by PWM on 11-07-2001, 2/5/2001
% Added better support for Alias field and corrected bug with Alias override
% not taking effect, this now reads the locked flag for the alias field.
% Added interface to Alias on Data Objects
% set_data_info(ObjectName,'Alias',revisedName);
%
% nameRules = get_name_rules(modelName);
revisedName = name;

aliasOverride = 0;

try
    if aliasOverride == 1
        dictStr = get_data_info(name,'ALIAS',modelName);
        if isempty(dictStr) == 0
            revisedName = dictStr;
             return
        end
    end
catch
end

switch symbolName
    case {'ExternalVariableScalar','ExternalVariableFlag', ...
          'ExternalVariableTimer','GlobalVariableScalar', ...
          'GlobalVariableFlag','GlobalVariableTimer', ...
          'FilescopeVariableScalar','FilescopeVariableFlag', ...
          'FilescopeVariableTimer'}
        nameCreateScriptCat = 'VariableNameCreateMFunction';
        approachCat = 'VariableApproach';
        caseCat = 'VariableCaseType';
    case {'ExternalCalibrationScalar','ExternalCalibrationLookup1D', ...
          'ExternalCalibrationLookup2D','GlobalCalibrationScalar', ...
          'GlobalCalibrationLookup1D','GlobalCalibrationLookup2D', ...
          'FilescopeCalibrationScalar','FilescopeCalibrationLookup1D', ...
          'FilescopeCalibrationLookup2D'}
        nameCreateScriptCat = 'ParameterNameCreateMFunction';
        approachCat = 'ParameterApproach';
        caseCat = 'ParameterCaseType';
    case 'LocalDefines'
        nameCreateScriptCat = 'DefineNameCreateMFunction';
        approachCat = 'DefineApproach';
        caseCat = 'DefineCaseType';
    otherwise
        nameCreateScriptCat = 'VariableNameCreateMFunction';
        approachCat = 'VariableApproach';
        caseCat = 'VariableCaseType';
end

approach = get(nameRules,approachCat);
caseType = get(nameRules,caseCat);
nameCreateScript = strtok(get(nameRules,nameCreateScriptCat),'.');
aliasAllowed = 'yes';

try

    %
    % The user specified name overrides the naming rules proposed
    % since this is the case, if the alias is a locked field we
    % override the naming rules.
    %

    if islocked_data_info(name,'Alias')==1,
       revisedName = get_data_info(name,'Alias',modelName);
       return
    end

    switch(approach)

    case 'Name Creation Script'

        revisedName = eval([nameCreateScript,'(''',name,''',object);']);
        if strcmp(revisedName,name) == 0
            if islocked_data_info(name,'Alias')==0,
              set_data_info(name,'Alias',revisedName,modelName);
            end
        else
            if islocked_data_info(name,'Alias')==0,
              set_data_info(name,'Alias',[],modelName);
            end
        end

    case 'Force Case'

        switch (caseType)
        case 'Upper'
            revisedName = upper(revisedName);
        case 'Lower'
            revisedName = lower(revisedName);
        case 'No Change'
        otherwise
            disp('Error in Process Objects:name_revision 2');
        end

        if strcmp(revisedName,name) == 0
            if islocked_data_info(name,'Alias')==0,
                set_data_info(name,'Alias',revisedName,modelName);
            end
        else
            if islocked_data_info(name,'Alias')==0,
              set_data_info(name,'Alias',[],modelName);
            end
        end
    case 'None'
        if islocked_data_info(name,'Alias')==0,
              set_data_info(name,'Alias',[],modelName);
        end
    otherwise
    end
catch
end
