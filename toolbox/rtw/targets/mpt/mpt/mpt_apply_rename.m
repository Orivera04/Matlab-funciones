function mpt_apply_rename(modelName,dataInfo)

%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2003/11/19 21:40:24 $

nameRules = get_name_rules(modelName);
list = evalin('base','whos');
wList=[];
for i=1:length(list)
    obj = evalin('base',list(i).name);
%     elem=[];
%     elem.name = list{i}.name;
    if (isa(obj,'mpt.Signal'))
%         elem.cat = 'signal';
        wList{end+1}= list(i).name;
    elseif  isa(obj,'mpt.Parameter')
%         elem.cat = 'paramemeter';
        wList{end+1}=list(i).name;
    end
    
end

for i=1:length(dataInfo)
    name = dataInfo{i}.name;
    if ismember(name,wList) == 1
            object = [];
            
            
            storageClassCat = upper(get_general_dictionary(name,'STORAGECLASS',[],modelName));
            
            %This is a hook location for customization. It is turned off via
            %comment. Do not remove.
            %     storageClassCat = mpt_determine_storage_cat(name,storageClassCat);
            
            %Get basic data object information including comments, initial value,
            %data type
            comment = get_general_dictionary(name,'DESCRIPTION',[],modelName);
            initialValue = get_general_dictionary(name,'INITIAL_VALUE',[],modelName);
            type = get_general_dictionary(name,'DATATYPE',[],modelName);
            scope = get_data_info(name,'SCOPE',modelName);
            %this will return either scalar or array
            % The name of the function is not clear. It is not true storage class
            objectTypeCat = mpt_determine_storage_class(name);
            
            object.storageClass = get_storage_class_modifier(storageClassCat);
            mappingInfo = get_data_mapping(objectTypeCat, storageClassCat);
            %Establish symbols for definition and reference based upon the record
            %type
            %Assumption is that all data is global. Switches need to be added to
            %restrict to potential file or function scope.
%             object.storageClass = '';
            switch(dataInfo{i}.recordType)
                case  {'BlockOutput','ExternalInput'}
                    if (dataInfo{i}.possibleFileStatic == 1) && (strcmp(scope,'File') == 1)
                        defineSymbol = mappingInfo.fileDeclareSymbol;
                        referenceSymbol = [];
                        fileStaticFlag = 1;
                        object.storageClass = 'static';
                    else
                        defineSymbol = mappingInfo.globalDeclareSymbol;
                        referenceSymbol = mappingInfo.globalRefSymbol;
                        fileStaticFlag = 0;
                    end
                case  'ModelParameter'
                    defineSymbol = mappingInfo.globalDeclareSymbol;
                    referenceSymbol = mappingInfo.globalRefSymbol;
                    fileStaticFlag = 0;
                   
                otherwise
                    defineSymbol = mappingInfo.globalDeclareSymbol;
                    referenceSymbol = mappingInfo.globalRefSymbol;
                    fileStaticFlag = 0;
            end
            symbolName = defineSymbol;
            %Get the proper data type and suffic
            [userDataType, suffix, tmwUserType] = determine_datatype(name,modelName);
            
            object.originalName = name;
            object.type = userDataType;
            object.tmwUserType = tmwUserType;
            object.suffix = suffix;
            object.comment = comment; 
            object.InitialValue = initialValue; 
            object.fileInclude = [];
            object.includeFileFlag = 0;
            
            %apply name revision based upon data category and select rules
            revisedName = name_revision(nameRules, name, object, symbolName,modelName);
        end
end

function dictStr = get_general_dictionary(name,attribute,objectType,modelName)
dictStr = get_data_info(name,attribute,modelName);
return

function [dataType, suffix, tmwType] = determine_datatype(name,modelName);

dataType = get_data_info(name,'DATATYPE',modelName);
dataType = covert_dt(dataType);
suffix = '';
% dataType = apply_user_types(dataType);
% if isempty(dataType) == 1
%     dataTypeID = sf('get',dataH,'.sfDataType');
%     [dataType,suffix] = determine_sf_data_type_name(dataTypeID);
%     
%     dataType = apply_user_types(dataType);
% else
tmwType = ac_get_type(dataType, 'userName', 'tmwName', 'primary');
if isempty(tmwType) == 1
    tmwType = dataType;
end
if strcmp(tmwType,'single') == 1 | strcmp(tmwType,'real32_T') == 1
    suffix='F';
end
