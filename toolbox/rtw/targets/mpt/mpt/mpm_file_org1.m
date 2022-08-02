function fileInfo = mpm_file_org1(modelName,machine)
%MPM_FILE_ORG1 Organize information for generating code.
%
%   FILEINFO = MPM_FILE_ORG1(MODELNAME)
%         This function organizes the information on which files will be
%         generated based on the file generation information stored in the
%         model.
%
%   INPUT:
%         modelName: Simulink model file name.
%         machine:   SF Machine defintion
%
%   OUTPUT:
%         fileInfo: Structure with information for each file.

%   Steve Toeppe
%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $
%   $Date: 2002/08/22 04:26:52 $

%  Revision:
%   S. Toeppe  1.8  4/26/02
%   Add in support for graphical function parented local and constants
%   Add in support for state parented local and constants

%assumptions
%  Signal names correspond to port names.
%  Signal name space is flat


%for each chart
%  register its information under selected file name
%end

%make list of all inputs
%make list of all outputs

%based upon selected file names, determine net set of inputs and outputs
%if inputs are sourced anywhere outside of file (another sub or context diagram)
%  then true interface
%  else
%  resolved internally (filescope)
%end

%if outputs are consumed anywhere outside of file (another sub or context diagram)
%  then true interface
%  else
%  resolved internally (filescope)
%end


MPMFileList = [];
fileList=[];
for i=1:length(machine.chart)
    fullName = [modelName,'/',machine.chart{i}.name];
    machine.chart{i}.optionFcnFile = establish_function_file_name(fullName,machine.chart{i}.uniqueName);
    MPMFileInfo.MPMFileName = machine.chart{i}.optionFcnFile.MPMFileName;
    MPMFileInfo.MPMFcnName = machine.chart{i}.optionFcnFile.MPMFcnName;
    MPMFileInfo.chart = machine.chart{i};
    fileList{end+1} = [MPMFileInfo.MPMFileName,'.c'];
    MPMFileList{end+1} = MPMFileInfo;
end

[fileList, index] = union(fileList,[]);
allInputName = [];
allInputObj = [];
allOutputName = [];
allOutputObj = [];
for i=1:length(machine.chart)
    for j=1:length(machine.chart{i}.input)
        allInputName{end+1}=machine.chart{i}.input{j}.name;
        allInputObj{end+1}=machine.chart{i}.input{j};
    end
    for j=1:length(machine.chart{i}.output)
        allOutputName{end+1}=machine.chart{i}.output{j}.name;
        allOutputObj{end+1}=machine.chart{i}.output{j};
    end
end
%Combine all of the charts associated with a given file.
for i=1:length(fileList)
   fileInfo{i}.fileName = fileList{i};
   fileInfo{i}.chart=[];
   fileInfo{i}.flowDiagram = 0;
   for j=1:length(MPMFileList)
       if strcmp(fileList{i},[MPMFileList{j}.MPMFileName,'.c'])
           if MPMFileList{i}.chart.flowDiagram == 1
               fileInfo{i}.flowDiagram = 1;
           end
           fileInfo{i}.chart{end+1}=MPMFileList{j};
       end
   end
end

% determine the total inputs and outputs associated with file.
for i=1:length(fileInfo)
    fileInfo{i}.totalFileInputName=[];
    fileInfo{i}.totalFileInputObj=[];
    fileInfo{i}.totalFileOutputName=[];
    fileInfo{i}.totalFileOutputObj=[];
    fileInfo{i}.totalFileConstantName=[];
    fileInfo{i}.totalFileConstantObj=[];
    fileInfo{i}.totalFileLocalName=[];
    fileInfo{i}.totalFileLocalObj=[];
    fileInfo{i}.totalFileTempName=[];
    fileInfo{i}.totalFileTempObj=[];
    
    %for each chart associated with a given file name
    
    for j=1:length(fileInfo{i}.chart)
        for k=1:length(fileInfo{i}.chart{j}.chart.input)
            fileInfo{i}.totalFileInputName{end+1}=fileInfo{i}.chart{j}.chart.input{k}.name;
            fileInfo{i}.totalFileInputObj{end+1}=fileInfo{i}.chart{j}.chart.input{k};
        end
        for k=1:length(fileInfo{i}.chart{j}.chart.output)
            fileInfo{i}.totalFileOutputName{end+1}=fileInfo{i}.chart{j}.chart.output{k}.name;
            fileInfo{i}.totalFileOutputObj{end+1}=fileInfo{i}.chart{j}.chart.output{k};
        end
        for k=1:length(fileInfo{i}.chart{j}.chart.constant)
            fileInfo{i}.totalFileConstantName{end+1}=fileInfo{i}.chart{j}.chart.constant{k}.name;
            fileInfo{i}.totalFileConstantObj{end+1}=fileInfo{i}.chart{j}.chart.constant{k};
        end
        for k=1:length(fileInfo{i}.chart{j}.chart.local)
            fileInfo{i}.totalFileLocalName{end+1}=fileInfo{i}.chart{j}.chart.local{k}.name;
            fileInfo{i}.totalFileLocalObj{end+1}=fileInfo{i}.chart{j}.chart.local{k};
        end
        for k=1:length(fileInfo{i}.chart{j}.chart.temporary)
            fileInfo{i}.totalFileTempName{end+1}=fileInfo{i}.chart{j}.chart.temporary{k}.name;
            fileInfo{i}.totalFileTempObj{end+1}=fileInfo{i}.chart{j}.chart.temporary{k};
        end
        %temporaries need to be handled differently.
        dataList = [];
        funList = [];
        for m=1:length(fileInfo{i}.chart{j}.chart.stateTree)
            %             [dataList, funList] = recursive_data_list(state,dataList,funList)
            [dataList, funList] = recursive_data_list(fileInfo{i}.chart{j}.chart.stateTree{m},dataList, funList);
        end
        for q=1:length(dataList)
            for k=1:length(dataList{q}.constant)
                fileInfo{i}.totalFileConstantName{end+1}=dataList{q}.constant{k}.name;
                fileInfo{i}.totalFileConstantObj{end+1}=dataList{q}.constant{k};
            end
            for k=1:length(dataList{q}.local)
                fileInfo{i}.totalFileLocalName{end+1}=dataList{q}.local{k}.name;
                fileInfo{i}.totalFileLocalObj{end+1}=dataList{q}.local{k};
            end
        end
        for q=1:length(funList)
            for k=1:length(funList{q}.data.constant)
                fileInfo{i}.totalFileConstantName{end+1}=funList{q}.data.constant{k}.name;
                fileInfo{i}.totalFileConstantObj{end+1}=funList{q}.data.constant{k};
            end
            for k=1:length(funList{q}.data.local)
                fileInfo{i}.totalFileLocalName{end+1}=funList{q}.data.local{k}.name;
                fileInfo{i}.totalFileLocalObj{end+1}=funList{q}.data.local{k};
            end
        end
    end
end

%determine proper scope of inputs and outputs of file.
%rules:
%   net input if not provided by another chart within the file or from another signal input external to the file
%   file scope if input is only provided from another chart within the file.
%   net output is if output signal is only consumed by another chart within file and not used outside of file (including context)
%   dictionary and manual rules not factored in at this point. Overrides should occur after this stage.

%temporary. This does not detect file scope. Waiting for R13 actualSrc to actually work.
for i=1:length(fileInfo)
    [fileInfo{i}.netFileInputName, index] = unique(fileInfo{i}.totalFileInputName);
    fileInfo{i}.netFileInputObj = fileInfo{i}.totalFileInputObj(index);
    [fileInfo{i}.netFileOutputName, index] = unique(fileInfo{i}.totalFileOutputName);
    fileInfo{i}.netFileOutputObj = fileInfo{i}.totalFileOutputObj(index);

    [fileInfo{i}.netFileConstantName, index] = unique(fileInfo{i}.totalFileConstantName);
    fileInfo{i}.netFileConstantObj = fileInfo{i}.totalFileConstantObj(index);

    %check for duplicates. If so, then need to determine if name space collision.
     [names, indexTotal]=determine_duplicates(fileInfo{i}.netFileConstantName,fileInfo{i}.totalFileConstantName);

     for q=1:length(indexTotal)
         for r=1:length(indexTotal{q})
             if fileInfo{i}.totalFileConstantObj{indexTotal{q}(r)}.initFromWorkspace == 0
                 disp(['Constant Name Space Collision: ',names{q}]);
             end
         end
     end
    [fileInfo{i}.netFileLocalName, index] = unique(fileInfo{i}.totalFileLocalName);
    fileInfo{i}.netFileLocalObj = fileInfo{i}.totalFileLocalObj(index);
    
    [fileInfo{i}.netFileTempName, index] = unique(fileInfo{i}.totalFileTempName);
    fileInfo{i}.netFileTempObj = fileInfo{i}.totalFileTempObj(index);
    
        %check for duplicates. If so, then need to determine if name space collision.
     [names, indexTotal]=determine_duplicates(fileInfo{i}.netFileLocalName,fileInfo{i}.totalFileLocalName);

     for q=1:length(indexTotal)
         for r=1:length(indexTotal{q})
             if fileInfo{i}.totalFileLocalObj{indexTotal{q}(r)}.initFromWorkspace == 0
                 disp(['Stateflow Local Name Space Collision: ',names{q}]);
             end
         end
     end
end

function [names, indexTotal]=determine_duplicates(net,total)
names=[];
indexTotal =[];

for i=1:length(net)
    memberFound = ismember(total,net{i});
    if sum(memberFound) > 1
       %need to investigate
       memberIndex = find(memberFound);
       names{end+1}=net{i};
       indexTotal{end+1}=memberIndex;

    end
end

x=1;

