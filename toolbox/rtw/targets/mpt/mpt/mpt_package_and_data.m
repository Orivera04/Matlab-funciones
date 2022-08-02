function packInfo = mpt_package_and_data(modelName,o)
%MPT_PACKAGE_AND_DATA will analyze and organize model per file, function
%and data scope usage.

%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.7 $  $Date: 2003/09/18 18:05:20 $

global ecac;
actualSourceB = ecac.line_s_d.actualSource;
lineInfo = ecac.line_s_d.lineInfo;
[functionList, filePackage, wsList] = udd_atomic2_list(modelName,o);
% [actualSourceB, lineInfo] = find_all_line_s_and_d(modelName);
[aList, I, J ] = unique(actualSourceB.name);

actualSource.name = actualSourceB.name(I);
actualSource.handle = actualSourceB.handle(I);
actualSource.destHandle = actualSourceB.destHandle(I);
actualSource.actualPortInfo = actualSourceB.actualPortInfo(I);

subsystemList = find_system(modelName,'FollowLinks','on','LookUnderMasks','all','blocktype','SubSystem');


handleList = [];
list{1}.subsystemName = modelName;
list{1}.root = 1;
list{1}.param='';
list{1}.dest='';
list{1}.source='';
list{1}.exFoldRef='';
list{1}.wsInfo=[];
handleList(1)=get_param(modelName,'Handle');
for i=1:length(subsystemList)
    handleList(i+1)=get_param(subsystemList{i},'Handle');
    list{i+1}.root = 0;
    list{i+1}.subsystemName = subsystemList{i};
    list{i+1}.param='';
    list{i+1}.dest='';
    list{i+1}.source= '';
    list{i+1}.exFoldRef='';
    list{i+1}.wsInfo = [];
end

%for each workspace reference
% determine the proper subsystem reference
%
for i=1:length(wsList.wsRef)
    handle = wsList.wsRef(i);
    ws.wsRef = wsList.wsRef(i);
    ws.wsDestBlkHandle = wsList.wsDestBlkHandle{i};
    ws.wsHandle = wsList.wsHandle(i);
    ws.wsLineName = wsList.wsLineName(i);
    ws.wsDestBlkType  = wsList.wsDestBlkType(i);
    ws.wsRefBlockType = wsList.wsRefBlockType(i);
    ws.wsCompiledLineRTWStorageClass = wsList.wsCompiledLineRTWStorageClass{i};
    type = get_param(handle,'Type');
    if strcmp(type,'block_diagram') == 0
        blocktype  = get_param(handle,'blocktype');
    else
        blocktype = '';
    end

    while (strcmp(type,'block_diagram') == 0)  && (strcmp(blocktype,'SubSystem') ==0)

        %         strcmp(get_param(handle,'blocktype'),'SubSystem') == 0
        handle = get_param(handle,'Parent');
        type = get_param(handle,'Type');
        if strcmp(type,'block_diagram') == 0
            blocktype  = get_param(handle,'blocktype');
        end
    end
    if strcmp(type,'block_diagram') == 0
        handle = get_param(handle,'Handle');
        match = ismember(handleList,handle);
        if isempty(match) == 0
            index = find(match);
            if isempty(index) == 0
                list{index(1)}.param{end+1}=wsList.wsName{i};
                list{index(1)}.wsInfo{end+1}=ws;
            end
        end
    else
        list{1}.param{end+1}=wsList.wsName{i};
        list{1}.wsInfo{end+1}=ws;
    end
end

for i=1:length(actualSource.handle)

    handle = actualSource.handle(i);
    type = get_param(handle,'Type');
    if strcmp(type,'block_diagram') == 0
        blocktype  = get_param(handle,'blocktype');
    else
        blocktype='';
    end
    %find subsystem or block diagram where the block resides
    while (strcmp(type,'block_diagram') == 0)  && (strcmp(blocktype,'SubSystem') ==0)

        %         strcmp(get_param(handle,'blocktype'),'SubSystem') == 0
        handle = get_param(handle,'Parent');
        type = get_param(handle,'Type');
        if strcmp(type,'block_diagram') == 0
            blocktype  = get_param(handle,'blocktype');
        end
    end
    %associate signal name with subsystem
    if strcmp(type,'block_diagram') == 0
        handle = get_param(handle,'Handle');
        match = ismember(handleList,handle);
        if isempty(match) == 0
            index = find(match);
            if isempty(index) == 0
                list{index(1)}.source{end+1}=actualSource.name{i};
            end
        end
    else
        list{1}.source{end+1}=actualSource.name{i};
    end
end

for i=1:length(actualSource.destHandle)
    sizeH = size(actualSource.destHandle{i});
    for j = 1:sizeH(2)
        try
            handle = actualSource.destHandle{i}(1,j);
            status = is_valid_handle(handle);
            if status == 0
                type = get_param(handle,'Type');
                %     blocktype  = get_param(handle,'blocktype');
                blocktype='port';
                while (strcmp(type,'block_diagram') == 0)  && (strcmp(blocktype,'SubSystem') ==0)
                    
                    %         strcmp(get_param(handle,'blocktype'),'SubSystem') == 0
                    handle = get_param(handle,'Parent');
                    type = get_param(handle,'Type');
                    if strcmp(type,'block_diagram') == 0
                        blocktype  = get_param(handle,'blocktype');
                    end
                end
                if strcmp(type,'block_diagram') == 0
                    handle = get_param(handle,'Handle');
                    match = ismember(handleList,handle);
                    if isempty(match) == 0
                        index = find(match);
                        if isempty(index) == 0
                            list{index(1)}.dest{end+1}=actualSource.name{i};
                        end
                    end
                else
                    list{1}.dest{end+1}=actualSource.name{i};
                end
            end
        catch
            x=1;
        end
    end
    
end

for i=1:length(filePackage)
    filePackage{i}.dest=[];
    filePackage{i}.source=[];
    filePackage{i}.param=[];
    filePackage{i}.wsInfo=[];
    for j=1:length(filePackage{i}.functionList)
        filePackage{i}.functionList{j}.dest='';
        filePackage{i}.functionList{j}.source='';
        filePackage{i}.functionList{j}.param='';
        filePackage{i}.functionList{j}.wsInfo='';
        handle = get_param(filePackage{i}.functionList{j}.FullPath,'Handle');
        match = ismember(handleList,handle);
        if isempty(match) == 0
            index = find(match);
            if isempty(index) == 0
                filePackage{i}.functionList{j}.dest = list{index(1)}.dest;
                filePackage{i}.functionList{j}.source = list{index(1)}.source;
                filePackage{i}.functionList{j}.param = list{index(1)}.param;
                filePackage{i}.functionList{j}.wsInfo = list{index(1)}.wsInfo;
            end
        end
        for k=1:length(filePackage{i}.functionList{j}.includedSubs)
            handle = get_param(filePackage{i}.functionList{j}.includedSubs{k}.FullPath,'Handle');
            match = ismember(handleList,handle);
            if isempty(match) == 0
                index = find(match);
                if isempty(index) == 0
                    filePackage{i}.functionList{j}.dest = [filePackage{i}.functionList{j}.dest,list{index(1)}.dest];
                    filePackage{i}.functionList{j}.source = [filePackage{i}.functionList{j}.source,list{index(1)}.source];
                    filePackage{i}.functionList{j}.param = [filePackage{i}.functionList{j}.param,list{index(1)}.param];
                    filePackage{i}.functionList{j}.wsInfo = [filePackage{i}.functionList{j}.wsInfo,list{index(1)}.wsInfo];
                end
            end
        end %end of for k=1
        filePackage{i}.dest = [filePackage{i}.dest,filePackage{i}.functionList{j}.dest];
        filePackage{i}.source = [filePackage{i}.source,filePackage{i}.functionList{j}.source];
        filePackage{i}.param = [filePackage{i}.param,filePackage{i}.functionList{j}.param];
        filePackage{i}.wsInfo = [filePackage{i}.wsInfo,filePackage{i}.functionList{j}.wsInfo];
    end %end of for j=1

end

%Variable List
% var.name
% var.destFileName
% var.destFunctionName
% var.sourceFileName
% var.sourceFunctionName

%first make list of variables with index scheme.
nameList = '';
for i=1:length(filePackage)
    nameList = [nameList, filePackage{i}.dest];
    nameList = [nameList, filePackage{i}.source];
end

nameList = unique(nameList);

paramList = '';
wsInfo = [];
for i=1:length(filePackage)
    paramList = [paramList, filePackage{i}.param];
    wsInfo = [wsInfo,filePackage{i}.wsInfo];
end

[paramList, indexI, indexJ] = unique(paramList);
wsInfo = wsInfo(indexI);
param='';
pList = '';
for i=1:length(paramList)
    paramTmp = mpt_param_info(paramList{i});
    paramTmp.wsInfo = wsInfo{i};
    if isempty(paramTmp) == 0
        param{end+1} = paramTmp;
        pList{end+1} = paramTmp.name;
    end
end
for i=1:length(filePackage)
    fileName  = filePackage{i}.fileName;
    for j=1:length(filePackage{i}.functionList)
        functionName = filePackage{i}.functionList{j}.functionName;
        for q=1:length(filePackage{i}.functionList{j}.param)
            name = filePackage{i}.functionList{j}.param{q};
            index = get_index(pList,name);
            if isempty(index) == 0
                param{index}.fileName{end+1}= fileName;
                param{index}.functionName{end+1} = functionName;
                ds.fileName=fileName;
                ds.functionName=functionName;
                param{index}.ref{end+1}=ds;
            end
        end

    end
end

for i=1:length(param)
    param{i}.fileName = unique(param{i}.fileName);
    param{i}.functionName = unique(param{i}.functionName);

end

var=[];
ind = 1;
for i=1:length(nameList)

    index = get_index(actualSource.name, nameList{i});
    if isempty(index) == 0
        var{ind}.name = nameList{i};
        var{ind}.dataType = actualSource.actualPortInfo{index}.CompiledPortDataType;
        var{ind}.compiledRTWStorageClass = actualSource.actualPortInfo{index}.compiledRTWStorageClass;
        var{ind}.width = actualSource.actualPortInfo{index}.width;
        var{ind}.destFileName = '';
        var{ind}.destFunctionName = '';
        var{ind}.sourceFileName = '';
        var{ind}.sourceFunctionName = '';
        var{ind}.dest='';
        var{ind}.source='';
        ind = ind + 1;
    end
end

for i=1:length(filePackage)
    fileName  = filePackage{i}.fileName;
    for j=1:length(filePackage{i}.functionList)
        functionName = filePackage{i}.functionList{j}.functionName;
        for q=1:length(filePackage{i}.functionList{j}.dest)
            name = filePackage{i}.functionList{j}.dest{q};
            index = get_index(nameList,name);
            var{index}.destFileName{end+1}= fileName;
            var{index}.destFunctionName{end+1} = functionName;
            ds.fileName=fileName;
            ds.functionName=functionName;
            var{index}.dest{end+1}=ds;
        end
        for q=1:length(filePackage{i}.functionList{j}.source)
            name = filePackage{i}.functionList{j}.source{q};
            index = get_index(nameList,name);
            var{index}.sourceFileName{end+1} = fileName;
            var{index}.sourceFunctionName{end+1} = functionName;
            ds.fileName=fileName;
            ds.functionName=functionName;
            var{index}.source{end+1}=ds;
        end
    end
end
for i=1:length(var)
    var{i}.destFileName = unique(var{i}.destFileName);
    var{i}.destFunctionName = unique(var{i}.destFunctionName);
    var{i}.sourceFileName = unique(var{i}.sourceFileName);
    var{i}.sourceFunctionName = unique(var{i}.sourceFunctionName);
end

for i=1:length(var)
    list = setxor(var{i}.destFileName,var{i}.sourceFileName);
    if isempty(list) == 1
        var{i}.possibleFileStatic = 1;
        list = setxor(var{i}.destFunctionName,var{i}.sourceFunctionName);
        if isempty(list) == 1
            var{i}.possibleFunctionScope=1;
        else
            var{i}.possibleFunctionScope = 0;
        end
    else
        var{i}.possibleFileStatic = 0;
        var{i}.possibleFunctionScope = 0;
    end
end
packInfo.filePackage = filePackage;
packInfo.var=var;
packInfo.param=param;
packInfo.nameList = nameList;
packInfo.paramList = paramList;

function index = get_index(nameList,name)
index = [];
match = ismember(nameList,name);
index = find(match);

function status = is_valid_handle(handle)
try
    p=get_param(handle,'Parent');
    status = 0;
catch
    status = -1;
end
