function dataObj = fp_for_active_sdo2(packInfo,modelName)
%FP_FOR_ACTIVE_SDO provides data scope management for active SDO.

%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $  $Date: 2004/04/15 00:26:57 $

%Example of mptDataInfo{}
%                      name: 'A'
%              destFileName: {'Subsystem1'}
%          destFunctionName: {'abc'}
%            sourceFileName: {'test1R133a'}
%        sourceFunctionName: {'test1R133a'}
%                      dest: {[1x1 struct]}
%                    source: {[1x1 struct]}
%        possibleFileStatic: 0
%     possibleFunctionScope: 0

%Cases
%  1) Dictionary Override
%      Establish source file
%      Establish reference file
%        Insert reference file into all places where variable is used
%
% 2)  Dictionary external reference overrise (include file specified)
%     Use external include file to resolve symbol
%
% 3)  Module Ownership
%     If element is externally owned
%       Extablish reference either direct or via global.h
%       Eventually a hook for registering .h per module name will be
%       provided
%
% 4)  Global File Flag
%    If set, all variables not covered above will be put into the global
%    file specifed.
%    Insert reference file into all places where variable is used
%
% 5)  Read/Write Rule
%    If not global files, then put definition and reference directly into
%    files.
%
%

% obj.name
% obj.defineFile
% obj.refFiles{..}
% obj.defineSymbol
% obj.refSymbol

%for each sdo usage
%  find object ref/definition details
%  establish definition
%  establish refefrence
%end

%general Flags of interest
scopeInfo = get_scope_info(modelName);
miscOptions = get_misc_options(modelName);
dataObj = [];
% scopeInfo.globalFileFlag
% scopeInfo.globalHFileFlag
globalFileName =   scopeInfo.globalFileName;
globalExternFileName = scopeInfo.globalExternFileName;

for i=1:length(packInfo.var)

    if strcmp(packInfo.var{i}.compiledRTWStorageClass,'Custom') == 1
        obj = analyze_object('ExternalInput',scopeInfo,packInfo.var{i},modelName);
        dataObj{end+1}=obj;
    end
end
for i=1:length(packInfo.param)
    obj = analyze_object('ModelParameter',scopeInfo,packInfo.param{i},modelName);
    dataObj{end+1}=obj;
end
return

function obj = analyze_object(recordType,scopeInfo,sdoInfo,modelName)
obj=[];
name = sdoInfo.name;
% recordType =  mptDataInfo{i}.record.RecordType;
%BlockOutput
%ModelParameter
%ExternalInput

declarationFile = get_data_info(name,'DEFINITIONFILE',modelName);
includeFile = get_data_info(name,'FILEINCLUDE',modelName);
owner = get_data_info(name,'OWNER',modelName);
memSection = get_data_info(name,'STORAGECLASS',modelName);
mpmScope = get_data_info(name,'SCOPE',modelName);
externalModuleOwnerFlag = (isowned(name,scopeInfo.moduleOwner,modelName) == 0);
poundDefineFlag = strcmp(memSection,'#DEFINE');
%%%%%%%%%%%%%%%% Dictionary Override Logic %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% If dictionary has a declaration file specified (definition), then
% that will override all other settings. The include file will be the
% same as the declaration file unless the include file is specified. If
% the declaration file is not set, but the include file is specified,
% it will override the setting and treat the data as external to the
% module.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
genIncludeFileFlag = 0;  %Flag controls generation of .h file

%if declaration file flag iis not selected in data object
%then clear flags and file name
% if include file option is not selected in data object
%   then clear flags and file name
%  else
%    set include file flag and save reference file flag
%    DONOT set generate include file flag since it is externally provided
% end
%else
%  set declaration file flag and generate include file flag and file name
%  automatically set the reference file (.h) to be the same name but
%  with .h
%end
if isempty(declarationFile) == 1
    declarationFileFlag = 0;
    defineFile = [];
    if isempty(includeFile) == 1
        includeFileFlag = 0;
        decRefFile = [];
    else
        includeFileFlag = 1;
        decRefFile = [strtok(includeFile,'.'),'.h'];
    end
else
    declarationFileFlag = 1;
    includeFileFlag = 0;
    if poundDefineFlag == 0
        defineFile = [strtok(declarationFile,'.'),'.c'];
    else
        defineFile = [];
    end
    decRefFile =  [strtok(declarationFile,'.'),'.h'];  %may not use if references in file is selected
    genIncludeFileFlag = 1;  %generate .h file

end
%%%%%%%%%%%%%%%%%%%%%%%% Total Override Logic %%%%%%%%%%%%%%%%%%%%%%%%
%
% The override flag indicates that one of override mechanisms has been
% turned on. Whenever an override occues, the necessary definition
% file has been set or made empty as required. No further definition
% is required beyond this point.

overRideFlag = includeFileFlag || declarationFileFlag || externalModuleOwnerFlag;

switch(recordType)
    case 'ModelParameter'
        %         index = get_index(packInfo.paramList,name);
        %         sdoInfo = packInfo.param{index};
        len = length(sdoInfo.fileName);
        % if there has not been an override
        %  if the global file has been selected
        %     the definition file will be the global file
        %  else
        %     the definition file will be the c file name
        %  end
        %   all parameter references except for the first one
        %   encountered will require a reference declaration
        % else
        %   all parameter references will require a reference
        %   declaration
        % end
        if overRideFlag == 0
            if scopeInfo.globalFileFlag == 1
                if poundDefineFlag == 0
                    defineFile = scopeInfo.globalFileName;
                else
                    if scopeInfo.globalHFileFlag == 1
                        defineFile = [strtok(scopeInfo.globalExternFileName,'.'),'.h'];
                    else
                        defineFile = [strtok(sdoInfo.fileName{1},'.'),'.c'];
                    end
                end
            else
                if ( poundDefineFlag == 0 ) || ((poundDefineFlag == 1) &&  (scopeInfo.globalHFileFlag == 0))
                    defineFile = [strtok(sdoInfo.fileName{1},'.'),'.c'];

                end
            end
            if scopeInfo.globalHFileFlag == 1
                decRefFile = scopeInfo.globalExternFileName;
                genIncludeFileFlag = 1;
            end
            if len > 1
                obj.referenceInsert = sdoInfo.fileName{2:end};
            else
                obj.referenceInsert =[];
            end
        else
            obj.referenceInsert = sdoInfo.fileName; %one or more files
        end
        obj.compiledModeDataType = covert_dt(sdoInfo.dataType);%'real_T';
        obj.possibleFileStatic =0;
        obj.possibleFunctionScope = 0;
        if strcmp(sdoInfo.wsInfo.wsCompiledLineRTWStorageClass,'Auto') & strcmp(sdoInfo.wsInfo.wsDestBlkType,'sf_sfun') ...
                & strcmp(sdoInfo.wsInfo.wsRefBlockType,'Constant')
            fileName = find_file_match(sdoInfo.wsInfo.wsDestBlkHandle);
            if isempty(fileName) == 0
                obj.referenceInsert{end+1} = fileName;
            end
        end

    case {'BlockOutput','ExternalInput'}
        %         index = get_index(packInfo.nameList,name);
        %         sdoInfo = packInfo.var{index};
        len = length(sdoInfo.sourceFileName);
        if overRideFlag == 0
            if scopeInfo.globalFileFlag == 1
                defineFile = scopeInfo.globalFileName;
            else
                defineFile = sdoInfo.sourceFileName{1};
            end
            if scopeInfo.globalHFileFlag == 1
                decRefFile = scopeInfo.globalExternFileName;
                genIncludeFileFlag = 1;
            end


            if len > 1
                obj.referenceInsert = sdoInfo.sourceFileName{2:end};
            else
                obj.referenceInsert =[];
            end
            obj.referenceInsert = [obj.referenceInsert,sdoInfo.destFileName];
        else

            obj.referenceInsert = sdoInfo.sourceFileName;

            obj.referenceInsert = [obj.referenceInsert,sdoInfo.destFileName];
        end
        [type, scale] = fix_to_type(sdoInfo.dataType);
        obj.compiledModeDataType =  covert_dt(type);
        obj.possibleFileStatic = sdoInfo.possibleFileStatic;
        obj.possibleFunctionScope = sdoInfo.possibleFunctionScope;
    otherwise
end
if (isempty(defineFile) == 0) && (isempty(obj.referenceInsert) == 0)
    if iscell(obj.referenceInsert) == 0
        temp = obj.referenceInsert;
        obj.referenceInsert=[];
        obj.referenceInsert{1}=temp;

    end
    match = ismember(obj.referenceInsert,defineFile);
    index = find(match);
    if isempty(index) == 0
        obj.referenceInsert = [obj.referenceInsert(1:index(1)-1),obj.referenceInsert(index(1)+1:end)];
    end
end
obj.referenceInsert = unique(obj.referenceInsert);
%%%%%%%%%%%%%%%%%%%%%%% Global File Logic %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Global file can only be used if there is not a dictionary override or
% a module ownership override.
%
for k=1:length(obj.referenceInsert)
    obj.referenceInsert{k}=[strtok(obj.referenceInsert{k},'.'),'.c'];
end
obj.name = name;
obj.recordType = recordType;
if isempty(defineFile) == 0
    if poundDefineFlag == 0
        obj.defineFile = [strtok(defineFile,'.'),'.c'];
    else
        obj.defineFile = defineFile;
    end
else
    obj.defineFile = [];
end
if isempty(decRefFile) == 0
    obj.decRefFile = [strtok(decRefFile,'.'),'.h'];
else
    obj.decRefFile = [];
end
obj.includeFileFlag = includeFileFlag;         %external include file supplied and should be
%used provided the declare file option is
%not set
obj.genIncludeFileFlag = genIncludeFileFlag;   %flag for generate include file for variable
obj.declarationFileFlag = declarationFileFlag; % flag for generate define of variable in specified file
obj.externalModuleOwnerFlag = externalModuleOwnerFlag;
obj.memSection = memSection;
obj.poundDefineFlag = poundDefineFlag;


obj.width = prod(sdoInfo.width);
function index = get_index(nameList,name)
index = [];
match = ismember(nameList,name);
index = find(match);

function [type, scale] = fix_to_type(typeStr)

[sType, sScale] = strtok(typeStr,'_');
scale =[];
switch(sType)
    case 'sfix16'
        type = 'int16_T';
    case 'sfix8'
        type = 'int8_T';
    case 'sfix32'
        type = 'int32_T';
    case 'ufix16'
        type = 'uint16_T';
    case 'ufix8'
        type = 'uint8_T';
    case 'ufix32'
        type = 'uint32_T';
    otherwise
        type = typeStr;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function fileName = find_file_match(wsDestBlkHandle)
ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');
fileName=[];
o=get_param(wsDestBlkHandle,'Object');
fullName=get_param(o.Parent,'Parent');
for i=1:length(ecac.packInfo.filePackage)
    for j=1:length(ecac.packInfo.filePackage{i}.functionList)
        if strcmp(ecac.packInfo.filePackage{i}.functionList{j}.FullPath,fullName) == 1
            fileName = ecac.packInfo.filePackage{i}.functionList{j}.fileName;
            return
        end
        for k=1:length(ecac.packInfo.filePackage{i}.functionList{j}.includedSubs)
            if strcmp(ecac.packInfo.filePackage{i}.functionList{j}.includedSubs{k}.FullPath,fullName) == 1
                fileName = ecac.packInfo.filePackage{i}.functionList{j}.fileName;
                return
            end
        end
    end
end
