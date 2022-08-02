function mpm_exit_processing(modelName,rtwFlag)
%MPM_EXIT_PROCESSING completes the MPM code generation process. 
%
%   MPM_EXIT_PROCESSING(MODELNAME) completes the MPM code generation process. It
%   will perform post processing of alias and type replacement. It also does the
%   final prepare for the diagnostic viewer display of files that were
%   generated.
%
%   INPUT:
%         modelName:     Name of model (without ".mdl")

%   Steve Toeppe
%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.5.4.8 $
%   $Date: 2004/04/15 00:27:20 $

ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');
mpmResult = rtwprivate('rtwattic', 'AtticData', 'mpmResult');
existList=[];
result=[];
cFileNames=[];
hFileNames=[];
if rtwFlag == 1
%     disp(['### Successful completion of Real-Time Workshop build ',...
%             'procedure for model: ', modelName]);
%     buildDir = rtwprivate('rtwattic','getBuildDir');
%     curDir = pwd;
    
%     cd(buildDir);
%     delete('rtw_proj.tmw');
%     cd(curDir);
end
existList = [mpmResult.codeGenList, mpmResult.protoGenList, mpmResult.globalGenList, mpmResult.machineGenList, mpmResult.typeGenList, mpmResult.tableGenList];
if rtwFlag == 1
    c = dir('*.c');
    h = dir('*.h');
    result=[];
    cFileNames=[];
    hFileNames=[];
    for i=1:length(c)
        if strcmp(c(i).name,existList) == 0
            result{end+1}=[pwd,filesep,c(i).name];
            cFileNames{end+1}=c(i).name;
        end
    end
    for i=1:length(h)
        if strcmp(h(i).name,existList) == 0
            result{end+1}=[pwd,filesep,h(i).name];
            hFileNames{end+1}=h(i).name;
        end
    end

end

totalList = [result,existList];
totalList = unique(totalList);
% for i=1:length(totalList)
%   c_indent('-codebreakcolumn=80',totalList{i});
% end
% mpm_create_alias_list;  %S
% mpm_apply_aliases(result); %S
% mpm_create_user_type_list;
% 
% mpm_apply_user_type(totalList);
% evalin('base',['delete usertypes.typ']);

ver = version('-release');
vernum = str2num(ver);
if vernum < 14
    if mpt_config_get(modelName,'PostProcessEnable') == 1
        outFile = mpt_config_get(modelName,'EditPostProcess');
        outFile = strtok(outFile,'.');
        indentStatus = eval([outFile,'(totalList)']);
    end
end

mpmResult.refDir = pwd;
mpmResult.codeGenList= [mpmResult.codeGenList,cFileNames];
mpmResult.typeGenList= [mpmResult.typeGenList,hFileNames];

if isfield(ecac,'templateList') == 1
    dPat = pwd;
    cd ..;
%     for i=1:length(ecac.templateList)
%         evalin('base',['delete ',ecac.templateList{i}]);
%     end
    cd(dPat);
end

mpmResult.result=result;
mpmResult.modelName=modelName;
rtwprivate('rtwattic', 'AtticData', 'mpmResult',mpmResult);
