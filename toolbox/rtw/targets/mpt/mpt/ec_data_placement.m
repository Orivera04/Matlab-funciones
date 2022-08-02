function result = ec_data_placement(record,modelName)
% EC_DATA_PLACEMENT is used to determine the placement of data.
%
% RESULT = EC_DATA_PLACEMENT(RECORD,MODELNAME) will determine the proper
% placement of data for a given model , model scope and user selected data
% placement mapping rules.
%
% Input:  record....Data scope record provided by the listener and the
%                   EnginePostRTWCompFileNames and DataObjectsUsage
%                   options.
%         modelName.Name of model
% Output: result....Modified scope record with data placement information
%                   added in.

%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.6 $
%   $Date: 2004/04/15 00:26:40 $



% Field Definitions:
% FilePackaging.DefineFile : File where object should be defined
% FilePackaging.FilesWithDecl : File where object ref declaration is needed
% FilePackaging.FilesWithIncl : File where header file needs to be included
% FilePackaging.HeaderFile : Header file to include in "FileWithIncl"
% FilePackaging.DeclareSymbol : Template symbol index for reference decl
% FilePackaging.DefineSymbol : Template symbol index for definition decl

%data definition
%ownership
%read/write, global or auto rule

%Note: All usage of int32 and boolean casts are to support the strict data
%type format requirements of "DataObjectsUsage" attribute

%temp basic CSC rules
% Name             Definition .c Reference .h Other
% Scalar               X              X
% BitField          Dont Touch    Dont Touch  Structured
% Const                X              X
% Volatile             X              X
% ConstVolatile        X              X
% Define                                       .c if local, .h if header
% ExportToFile         X              X
% Struct            Dont Touch    Dont Touch   Structured
% GetSet            Dont Touch    Dont Touch
% ImportFromFile  Include File

cFileList = [];
hFileList = [];
totalFileList=[];
globalCDefinitionIndex=[];
globalHDeclarationIndex=[];
modelCIndex=[];
modelHIndex=[];
decFile=[];
decRefFile=[];

result = record;
result.totalFileList=[];
dataDefinitionFile = mpt_config_get(modelName,'DataDefinitionFile');
dataReferenceFile = mpt_config_get(modelName,'DataReferenceFile');
globalDataDefinitionStr = mpt_config_get(modelName,'GlobalDataDefinition');
%InSeparateSourceFile
%InSourceFile
%Auto
globalDataReferenceStr = mpt_config_get(modelName,'GlobalDataReference');
%InSeparateHeaderFile
%InSourceFile
%Auto

%determine if any of the C API operations are enabled.
%If cAPI is in usage, extern statements must appear in model.h
h=getActiveConfigSet(modelName);
if strcmp(get_param(h,'RTWCAPISignals'),'on') | ...
    strcmp(get_param(h,'RTWCAPIParams'),'on')  | ...
    strcmp(get_param(h,'RTWCAPIStates'),'on')
  cAPIFlag = 1;
  return;
else
  cAPIFlag = 0;
end

moduleNamingRule = mpt_config_get(modelName,'ModuleNamingRule');
%UserSpecified
%SameAsModel
%Unspecified
moduleOwner = mpt_config_get(modelName,'ModuleName');
includeFileDelimiter = mpt_config_get(modelName,'IncludeFileDelimiter');

switch(includeFileDelimiter)
  case 'Auto'
    openDelimiter='';
    closeDelimiter='';
  case 'UseBracket'
    openDelimiter='<';
    closeDelimiter='>';
  case 'UseQuote'
    openDelimiter='"';
    closeDelimiter='"';
  otherwise
    openDelimiter='';
    closeDelimiter='';
end
switch(globalDataDefinitionStr)
  case 'Auto'                      %Auto..No placement
    globalDataDefinition = 0;
  case 'InSeparateSourceFile'          %Global Rule
    globalDataDefinition = 1;
  case 'InSourceFile'                  %Read Write Rule
    globalDataDefinition = 2;
  otherwise                            %Auto..No placement
    globalDataDefinition = 0;
end

switch(globalDataReferenceStr)
  case 'Auto'                           %Auto..No placement
    globalDataReference = 0;
  case 'InSeparateHeaderFile'           %Global Rule
    globalDataReference = 1;
  case 'InSourceFile'                   %Read Write Rule
    globalDataReference = 2;
  otherwise                             %Auto..No placement
    globalDataReference = 0;
end
%0...Auto
%1...Global Rule
%2...Read Write Rule


mpt_symbol_mapping = rtwprivate('rtwattic', 'AtticData', 'mpt_symbol_mapping');

sLen = length(mpt_symbol_mapping.symbolList);
for i=1:sLen
  result.TemplateSymbol(i).Name = mpt_symbol_mapping.symbolList{i};
end
% result.TemplateSymbol(1).Name ='Defines';
% result.TemplateSymbol(2).Name ='GlobalVariableScalar';%'Definitions'; %'GlobalVariableScalar';%
% result.TemplateSymbol(3).Name ='Declarations';
result.NumTemplateSymbols=int32(sLen);

%Determine proper name rule to apply
switch(moduleNamingRule)
  case 'Unspecified'
    moduleNameFlag = 0;
    moduleOwner = '';
  case 'UserSpecified'
    moduleNameFlag = 1;
  case 'SameAsModel'
    moduleNameFlag = 1;
    moduleOwner = modelName;
  otherwise
    moduleNameFlag = 0;
    moduleOwner = '';
end
try
  flagIsCustom = isfield(record.File(1),'IsCustom');
catch
  flagIsCustom = 0;
end
for i=1:length(record.File)
  switch(record.File(i).Type)
    case 'source'
      if strcmp(record.File(i).Name,modelName) == 1
        modelCIndex=int32(i-1);
      end
      cFileList{end+1}=record.File(i).Name;
      totalFileList{i}=[record.File(i).Name,'.c'];
    case 'header'
      if strcmp(record.File(i).Name,modelName) == 1
        modelHIndex=int32(i-1);
      end
      hFileList{end+1}=record.File(i).Name;
      totalFileList{i}=[record.File(i).Name,'.h'];
    otherwise
      totalFileList{i}=record.File(i).Name;
  end
end

%if there are global rule specific files, add them to list
if globalDataDefinition == 1  %is it global rule
  globalFile = strtok(dataDefinitionFile,'.');
  globalFileC = [globalFile,'.c'];
  info.totalFileList = totalFileList;
  [result, info] = add_file(result,info,globalFile,'source','yes');
  referenceIndex = info.index;
  totalFileList = info.totalFileList;
  globalCDefinitionIndex = info.index;

end

if globalDataReference == 1 %is it global rule
  % global placement rule
  decGlobalHeaderFile = strtok(dataReferenceFile,'.');
  decGlobalHeaderFileH = [decGlobalHeaderFile,'.h'];
  info.totalFileList = totalFileList;
  [result, info] = add_file(result,info,decGlobalHeaderFile,'header','yes');
  referenceIndex = info.index;
  totalFileList = info.totalFileList;
  globalHDeclarationIndex = info.index;

end
info.totalFileList = totalFileList;
[result, info] = add_file(result,info,[modelName,'_private'],'header','no');
totalFileList = info.totalFileList;
private_index=info.index;

[result, info] = add_file(result,info,modelName,'header','no');
totalFileList = info.totalFileList;
model_index=info.index;
% Process all Signal objects

for i=1:double(record.NumDataObjects) %double(record.NumSignalObjects)
  try
    useIncludeFileFlag = 0;
    genDecFileFlag = 0;
    referenceIndex=[];
    definitionIndex=[];
    filesWithIncl=[];
    readWriteDefineFlag=0;
    bypassFlag = 0;
    extraRefFlag = 1;
    headerOverride = 0;
    name = record.DataObject(i).Name;

    obj = evalin('base',name);

    if isa(obj,'Simulink.Signal') || isa(obj,'Simulink.Parameter')
      %             mptDerived = isa(obj,'mpt.Signal') | isa(obj,'mpt.Parameter');
      mptDerived=0;
      placementRule = ec_get_placement_rules(name);
      desiredScope =  'Exported';

      %only process if the placement rule is not "none"
      if strcmp(placementRule.mode, 'None') == 0
        csc = get_data_info(name,'CUSSTORAGECLASS');
        memorySection = get_data_info(name,'STORAGECLASS');
        if isa(obj,'Simulink.Signal')
          classIndex=1;
        else
          classIndex=2;
        end
        symbolInfo = ec_get_datasym('mpt',classIndex,csc,memorySection);
        %Need to initialize
        result.DataObject(i).FilePackaging.HeaderFile='';
        result.DataObject(i).FilePackaging.DefineFile =[];
        result.DataObject(i).FilePackaging.DeclareSymbol =[];
        result.DataObject(i).FilePackaging.DefineSymbol =[];
        result.DataObject(i).FilePackaging.FilesWithDecl = [];
        result.DataObject(i).FilePackaging.FilesWithIncl =[];

        definitionFile = get_data_info(name,'DEFINITIONFILE',modelName);

        externalModuleOwnerFlag = (isowned(name,moduleOwner,modelName) == 0);

        obj = get_data_info(name,'ALL',modelName);
        if isempty(obj) == 0
          if strcmp(placementRule.mode,'Include') == 1
            switch(placementRule.importCat)
              case 'Instance'
                [header, headerOverride] = get_header(name);
              case 'csc'
                header = strtok(placementRule.Header,'.');
              case 'None'
                header = '';
              otherwise
                header = '';
            end

            % There are 3 cases supported. Rules are same for Simulink and mpt objects.
            % Default (auto) behaviour is standard RTW-EC default behaviour
            % (model_private.h)
            % (or extern) refers to case where header is not specified.
            % Ref option
            % ----------
            % Auto
            %  Header.h (or extern) is included in model_private.h only
            % Source
            %  Header.h (or extern) is included in source.c where used.
            % Separate
            %  Header (or extern) is included in global.h which is included in files
            % where used.
            referenceIndex=[];

            switch(globalDataReference)
              case 0  %Auto
                referenceIndex(end+1) = int32(private_index);
              case 1  %Separate
                referenceIndex(end+1) = int32(private_index);
                %                                 referenceIndex(end+1) = int32(globalHDeclarationIndex);
              case 2  %Source

                if mptDerived == 1
                  for j=1:length(result.DataObject(i).ReadFromFile)
                    referenceIndex(end+1) = int32(result.DataObject(i).ReadFromFile(j));
                  end
                  for j=1:length(result.DataObject(i).WrittenInFile)
                    referenceIndex(end+1) = int32(result.DataObject(i).WrittenInFile(j));
                  end
                else
                  referenceIndex(end+1) = int32(private_index);
                end
              otherwise
                referenceIndex(end+1) = int32(private_index);
            end

            result.DataObject(i).HasMPTAttributes = logical(1); %Turn it on
            % Treated the sames as Exported global.
            result.DataObject(i).Scope= 'Imported';
            %                     result.DataObject(i).FilePackaging.DeclareSymbol = int32(2);
            %                     result.DataObject(i).FilePackaging.DefineSymbol = int32(1);
            result.DataObject(i).FilePackaging.DeclareSymbol = int32(symbolInfo.globalDecSymIndex-1);
            result.DataObject(i).FilePackaging.DefineSymbol = int32(symbolInfo.globalDefSymIndex-1);
            if isempty(header) == 0
              result.DataObject(i).FilePackaging.HeaderFile = header_str(header,openDelimiter,closeDelimiter,headerOverride);

              result.DataObject(i).FilePackaging.FilesWithIncl = int32(referenceIndex);
            else
              result.DataObject(i).FilePackaging.FilesWithDecl = int32(referenceIndex);
            end
            %                 elseif strcmp(placementRule.mode, '#DEFINE') == 0
            %                     referenceIndex(end+1) = int32(private_index);
          else %data case.
            if isempty(placementRule.exportCat) == 0
              switch(placementRule.exportCat)
                case 'Instance'
%                   header = strtok(get_data_info(name,'FILEINCLUDE'),'.');
                  [header, headerOverride] = get_header(name);
                case 'csc'
                  header = strtok(placementRule.Header,'.');
                case 'None'
                  header = '';
                otherwise
                  header = '';
              end
              if isempty(header) == 0
                info.totalFileList = totalFileList;
                [result, info] = add_file(result,info,header,'header','yes');
                referenceIndex = info.index;
                totalFileList = info.totalFileList;
                extraRefFlag=0;
                switch(globalDataReference)
                  case 0  %auto
                    useIncludeFileFlag = 0;
                    extraRefFlag=0;

                    filesWithIncl(end+1)=modelHIndex;

                  case 1  %separate
                    useIncludeFileFlag = 1;
                    if mptDerived == 0
                      filesWithIncl(end+1)=modelHIndex;
                    end
                  case 2  %source
                    useIncludeFileFlag = 1;
                    if mptDerived == 0
                      filesWithIncl(end+1)=modelHIndex;
                    end
                  otherwise
                    useIncludeFileFlag = 1;
                end
%                   result.DataObject(i).FilePackaging.HeaderFile = [openDelimiter,header,'.h',closeDelimiter];
                   result.DataObject(i).FilePackaging.HeaderFile = ...
                     header_str(header,openDelimiter,closeDelimiter,headerOverride);
              end

            end
            %Determine the data placement rule to use
            % There are three major categories:
            %     definitionFile
            %     ownership
            %     read-write-global

            if isempty(definitionFile) == 0
              placeType = 'definitionFile';
            else
              if strcmp(placementRule.mode,'#Define') == 0
                if (isempty(externalModuleOwnerFlag) == 0)
                  if (externalModuleOwnerFlag == 1)
                    placeType = 'ownership';
                    desiredScope = 'Imported';
                  else
                    placeType = 'read-write-global';
                  end
                else
                  placeType = 'read-write-global';
                end
              else
                if isempty(header) == 0
                  placeType='definitionFile';
                  definitionFile=header;
                else
                  placeType = 'read-write-global';
                end
              end
            end


            switch(placeType)
              case 'definitionFile'
                % The DefintionFile option requires a source and header
                % file to be generated. THis will be accomplished by adding
                % the files to the File Packaging "Files" list
                % Note: indexes are normalized by 1 for zero index in tlc
                decFile = strtok(definitionFile,'.');
                decRefFile = decFile;
                %if the header file is not already in the list
                %then add it to the list and get the index
                %else get the index
                %end

                if isempty(header) == 1
                  refFile = decRefFile;
                else
                  refFile = header;
                end
                info.totalFileList = totalFileList;
                [result, info] = add_file(result,info,refFile,'header','yes');

                totalFileList = info.totalFileList;
                %Establish the header file name to be included into the
                %identified files.

%                 result.DataObject(i).FilePackaging.HeaderFile = [openDelimiter,refFile,'.h',closeDelimiter];
                   result.DataObject(i).FilePackaging.HeaderFile = ...
                     header_str(refFile,openDelimiter,closeDelimiter,headerOverride);
                if strcmp(placementRule.mode,'#Define') == 0
                  referenceIndex = info.index;
                  genDecFileFlag = 1;
                else
                  definitionIndex = info.index;
                  genDecFileFlag = 0;
                end
                useIncludeFileFlag = 1;

              case 'ownership'
                if isempty(header) == 1
                  switch(globalDataReference)
                    case 1
                      %                             if globalDataReference == 1
                      % Global Data rule
                      % References go into header file that is included in
                      % all files that have readers or writers
                      decRefFile = strtok(dataReferenceFile,'.');
                      %It already exists.
                      useIncludeFileFlag = 1; %Active include file reference
                      %                       result.DataObject(i).FilePackaging.HeaderFile = [openDelimiter,decRefFile,'.h',closeDelimiter];
                      result.DataObject(i).FilePackaging.HeaderFile = ...
                        header_str(decRefFile,openDelimiter,closeDelimiter,headerOverride);
                      referenceIndex(end+1) = globalHDeclarationIndex;
                      %                                 else
                    case 2
                      %                                 %read-write rule
                      %                                 % References go into source files that are readers and
                      %                                 % writers of the data. The only exception is if the
                      %                                 % definition is also in the same file (read write rule)

                      useIncludeFileFlag = 0;
                    case 0
                      useIncludeFileFlag = 1; %Active include file reference

%                       result.DataObject(i).FilePackaging.HeaderFile = [openDelimiter,modelName,'.h',closeDelimiter];
                   result.DataObject(i).FilePackaging.HeaderFile = ...
                     header_str(modelName,openDelimiter,closeDelimiter,headerOverride);
                      referenceIndex(end+1) = modelHIndex;
                    otherwise
                  end

                end

              case 'read-write-global'
                switch(globalDataDefinition)
                  case 0
                    %                             bypassFlag = 1;
                    decFile = modelName;
                    genDecFileFlag = 0;
                    if strcmp(placementRule.mode,'#Define') == 0
                      definitionIndex = modelCIndex;
                    else
                      definitionIndex = modelHIndex;
                    end
                  case 1
                    %Definitions go into global file
                    decFile = strtok(dataDefinitionFile,'.');
                    genDecFileFlag = 0;
                    if strcmp(placementRule.mode,'#Define') == 0
                      definitionIndex = globalCDefinitionIndex;
                    else

                      definitionIndex = modelHIndex;

                    end
                  case 2
                    %Read Write rule
                    %Definitions go into individual C Function files
                    %First writer file is used. If it does not exist, then
                    %the first reader file is used.
                    readWriteDefineFlag = 1;
                    genDecFileFlag = 0;
                    if strcmp(placementRule.mode,'#Define') == 0
                      if isempty(result.DataObject(i).WrittenInFile) == 0
                        definitionIndex = result.DataObject(i).WrittenInFile(1);
                      else
                        definitionIndex = result.DataObject(i).ReadFromFile(1);
                      end
                    else
                      definitionIndex = modelHIndex;
                    end
                    decFile = result.File(definitionIndex+1).Name;
                  otherwise
                end


                % if global header file is required
                %   get global file name and set flag to generate header file
                % else
                %   clear flag to generate header file
                %  end
                if isempty(header) == 1
                  switch(globalDataReference)
                    case 0
                      %                             bypassFlag = 1;
                      % Global Data rule
                      % References go into header file that is included in
                      % all files that have readers or writers
                      decRefFile = [modelName];
                      %It already exists.
                      useIncludeFileFlag = 1; %Active include file reference
%                       result.DataObject(i).FilePackaging.HeaderFile =  [openDelimiter,decRefFile,'.h',closeDelimiter];%[decRefFile,'.h'];
                                         result.DataObject(i).FilePackaging.HeaderFile = ...
                     header_str(decRefFile,openDelimiter,closeDelimiter,headerOverride);
                      referenceIndex(end+1) = modelHIndex;
                    case 1
                      % Global Data rule
                      % References go into header file that is included in
                      % all files that have readers or writers
                      decRefFile = strtok(dataReferenceFile,'.');
                      %It already exists.
                      useIncludeFileFlag = 1; %Active include file reference
%                       result.DataObject(i).FilePackaging.HeaderFile = [openDelimiter,decRefFile,'.h',closeDelimiter];
                      
                                         result.DataObject(i).FilePackaging.HeaderFile = ...
                     header_str(decRefFile,openDelimiter,closeDelimiter,headerOverride);referenceIndex(end+1) = globalHDeclarationIndex;
                    case 2
                      %read-write rule
                      % References go into source files that are readers and
                      % writers of the data. The only exception is if the
                      % definition is also in the same file (read write rule)

                      useIncludeFileFlag = 0;
                    otherwise
                  end
                end
              otherwise
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            % The code in this section is common to each of the data placement
            % rules. The need for its usage is covered by the genDecFileFlag
            %  that are set during the rule detection
            % phase.

            %if the source file is not already in the list
            %then add it to the list and get the index
            %else get the index
            %end
            %                     if bypassFlag == 0
            if genDecFileFlag == 1
              info.totalFileList = totalFileList;
              [result, info] = add_file(result,info,decFile,'source','yes');
              definitionIndex = info.index;
              totalFileList = info.totalFileList;
            end



            result.DataObject(i).HasMPTAttributes = logical(1); %Turn it on
            % Treated the sames as Exported global.
            result.DataObject(i).Scope= desiredScope;




            %if references are handled with the include files
            % then reference the include in every file that
            % references the data
            %else
            % use direct extern references directly in the files
            % that reference the data.
            %end
            if extraRefFlag == 1
              if useIncludeFileFlag == 1
                %Get all of the readers of the data objects
                for j=1:length(result.DataObject(i).ReadFromFile)
                  if strcmp(decFile, result.File(result.DataObject(i).ReadFromFile(j)+1).Name) == 0
                    filesWithIncl(end+1) = int32(result.DataObject(i).ReadFromFile(j));
                  end
                end
                %Get all of the writers of the data object
                for j=1:length(result.DataObject(i).WrittenInFile)
                  if strcmp(decFile, result.File(result.DataObject(i).WrittenInFile(j)+1).Name) == 0
                    filesWithIncl(end+1) = result.DataObject(i).WrittenInFile(j);
                  end
                end
              else
                % it is necessary to support all usage of the object
                % with reference declarations. This requires that every
                % reader and writer file is identified and collected.
                % Any references in the file where the definition will
                % be placed need to be excluded.

                if isempty(definitionIndex) == 0
                  if (genDecFileFlag == 0) & (readWriteDefineFlag == 1)
                    defIndx = definitionIndex;
                  else
                    defIndx = -1;
                  end
                else
                  defIndx = -1;
                end

                % detect and record all reader files that are not the
                % definition file

                for j=1:length(result.DataObject(i).ReadFromFile)
                  if defIndx ~= result.DataObject(i).ReadFromFile(j)
                    referenceIndex(end+1) = int32(result.DataObject(i).ReadFromFile(j));
                  end
                end

                % detect and record all writer files that are not the
                % definition file

                for j=1:length(result.DataObject(i).WrittenInFile)
                  if defIndx ~= result.DataObject(i).WrittenInFile(j)
                    referenceIndex(end+1) = result.DataObject(i).WrittenInFile(j);
                  end
                end

              end %useIncludeFileFlag == 1
            end %extraRefFlag == 1
            if cAPIFlag == 1
              referenceIndex(end+1) = modelHIndex;
            end
            % Specify which files should have a defining declaration
            if strcmp(placementRule.mode,'#Define') == 0
              result.DataObject(i).FilePackaging.DefineFile = int32(definitionIndex);
            else
              result.DataObject(i).FilePackaging.DefineFile = int32(definitionIndex);

            end


            %Identify the referencing declare symbol and define symbols
            %                     result.DataObject(i).FilePackaging.DeclareSymbol = int32(2);
            result.DataObject(i).FilePackaging.DeclareSymbol = int32(symbolInfo.globalDecSymIndex-1);
            if strcmp(placementRule.mode,'#Define') == 0
              %                         result.DataObject(i).FilePackaging.DefineSymbol = int32(1);
              result.DataObject(i).FilePackaging.DefineSymbol = int32(symbolInfo.globalDefSymIndex-1);
            else
              %                         result.DataObject(i).FilePackaging.DefineSymbol = int32(0);
              result.DataObject(i).FilePackaging.DefineSymbol = int32(symbolInfo.defineIndex-1);%int32(symbolInfo.globalDecSymIndex-1);
            end


            % Specify which files should have a reference declaration
            if strcmp(placementRule.mode,'#Define') == 0
              result.DataObject(i).FilePackaging.FilesWithDecl = int32(referenceIndex);
            else
              result.DataObject(i).FilePackaging.FilesWithDecl = [];
            end
            % Specify which files should have a header included.
            result.DataObject(i).FilePackaging.FilesWithIncl = int32(filesWithIncl);
            %                     end %if bypassFlag == 0
          end %if strcmp(placementRule.mode,
          % Filter out any duplicate cases
          result.DataObject(i).FilePackaging.DefineFile = ...
            unique(result.DataObject(i).FilePackaging.DefineFile);
          result.DataObject(i).FilePackaging.DeclareSymbol = ...
            unique(result.DataObject(i).FilePackaging.DeclareSymbol);
          result.DataObject(i).FilePackaging.DefineSymbol = ...
            unique(result.DataObject(i).FilePackaging.DefineSymbol);
          result.DataObject(i).FilePackaging.FilesWithDecl = ...
            unique(result.DataObject(i).FilePackaging.FilesWithDecl);
          result.DataObject(i).FilePackaging.FilesWithIncl = ...
            unique(result.DataObject(i).FilePackaging.FilesWithIncl);
          result.DataObject(i).FilePackaging.FilesWithDecl = ...
            setdiff(result.DataObject(i).FilePackaging.FilesWithDecl,...
            result.DataObject(i).FilePackaging.DefineFile);

        else
          disp(['Object: ',name,' not found in workspace']);
        end %if isempty(obj) == 0
      end % if strcmp(placementRule.mode, 'None')
    end %if isa(obj,'Simulink.Signal')
  catch
    disp(['Data Placement Error for object ',num2str(i),': ',record.DataObject(i).Name]);
  end
end %for i=1:double

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [result, info] = add_file(result,info,fileName,fileType,isCustom)
switch(fileType)
  case 'header'
    str = '.h';
  case 'source'
    str = '.c';
  otherwise
    str = '.c';
end
match = ismember(info.totalFileList,[fileName,str]);
index = find(match);
if isempty(index) == 1
  file.Name = fileName;            %establish file
  file.Type = fileType;
  %     if flagIsCustom
  file.IsCustom=isCustom;
  %     end
  result.File(end+1)=file;          %add file to list
  info.index = result.NumFiles; %get index
  result.NumFiles = result.NumFiles + 1; %increase count
  info.totalFileList{end+1}=[file.Name,str];
else
  info.index = index - 1;
end

function status = chk_enclose(str)
m = regexp(str,{'<','>','"'});
status = ~isempty(m{1}) && isempty(m{2}) && isempty(m{3});


function headerFile = header_str(header,openDelimiter,closeDelimiter,headerOverride)
switch(headerOverride)
  case 0
    headerFile = [openDelimiter,header,'.h',closeDelimiter];
  case 1
    headerFile = ['<',header,'.h','>'];
  case 2
    headerFile = ['"',header,'.h','"'];
  otherwise
    headerFile = [openDelimiter,header,'.h',closeDelimiter];
end

function [header, headerOverride] = get_header(name);
rawHeader = get_data_info(name,'FILEINCLUDE');
if isempty(rawHeader) == 0
  headerNoSpace = strrep(rawHeader,' ','');
  header = strrep(rawHeader,'"','');
  header = strrep(header,'<','');
  header = strrep(header,'>','');
  header = strtok(header,'.');
  if (headerNoSpace(1) == '<') && (headerNoSpace(end) == '>')
    headerOverride = 1;

  elseif (headerNoSpace(1) == '"') && (headerNoSpace(end) == '"')
    headerOverride = 2;

  else
    headerOverride = 0;
  end
else
  header = '';
  headerOverride = 0;
end


