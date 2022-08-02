function fileFunList = get_fun_and_files(filePackage)

% Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.4.4.1 $
%   $Date: 2004/04/15 00:27:04 $

%fileName{:}.name
%           .function{:}.name
%                       .type (chart or graphical function)
%                       .exported
%                       .inline
%                       .static
%                       .empty

for i=1:length(filePackage)
    fi = i;
    fileName{fi}.name = filePackage{i}.fileName;
    cfi=0;
    for j=1:length(filePackage{i}.chart)
        cfi = cfi+1;
        fileName{fi}.function{cfi}.name = filePackage{i}.chart{j}.MPMFcnName;
        handle =  filePackage{i}.chart{j}.chart.handle;
        fileName{fi}.function{cfi}.handle = handle;
        fileName{fi}.function{cfi}.opt = get_fun_option(handle);
        exportChartFunctions = sf('get',fileName{fi}.function{cfi}.handle,'.exportChartFunctions');
        fileName{fi}.function{cfi}.type = 'chart';
        fileName{fi}.function{cfi}.exported = exportChartFunctions;
        fileName{fi}.function{cfi}.inline = 0;
        fileName{fi}.function{cfi}.static = 0;
        fileName{fi}.function{cfi}.empty = 0;
        fileName{fi}.function{cfi}.data = [];
        fileName{fi}.function{cfi}.flowDiagram = filePackage{i}.chart{j}.chart.flowDiagram;
        for k=1:length(filePackage{i}.chart{j}.chart.stateTree)
            if strcmp(filePackage{i}.chart{j}.chart.stateTree{k}.stateType, 'Function') == 1
                cfi = cfi+1;
                fileName{fi}.function{cfi}.name = filePackage{i}.chart{j}.chart.stateTree{k}.stateName;
                handle = filePackage{i}.chart{j}.chart.stateTree{k}.stateHandle;
                fileName{fi}.function{cfi}.handle = handle;
                fileName{fi}.function{cfi}.opt = get_fun_option(handle);
                fileName{fi}.function{cfi}.type = 'gf';
                fileName{fi}.function{cfi}.exported = exportChartFunctions;
                fileName{fi}.function{cfi}.inline = filePackage{i}.chart{j}.chart.stateTree{k}.functionInlineOption;
                fileName{fi}.function{cfi}.static = 0;
                fileName{fi}.function{cfi}.empty = 0;
                fileName{fi}.function{cfi}.data  = filePackage{i}.chart{j}.chart.stateTree{k}.data;
                fileName{fi}.function{cfi}.flowDiagram = 0;
            end
        end
    end
end
fileFunList = fileName;


function opt = get_fun_option(handle)
funOption = get_mpt_fun_option(handle);
opt = funOption;
% genReplaceStr = 'Gen';
% exportFromStr = 'off';
% genUniqueStr = 'off';
% exportHeaderStr = '';
% replaceHeaderStr = '';
% for i=1:length(funOption)
%     switch(funOption{i}.optionStr)
%         case 'GenReplace'
%             genReplaceStr = funOption{i}.valueStr;
%         case 'ExportFrom'
%             exportFromStr = funOption{i}.valueStr;
%         case 'GenUnique'
%             genUniqueStr = funOption{i}.valueStr;
%         case 'ExportHeader'
%             exportHeaderStr = funOption{i}.valueStr;
%         case 'ReplaceHeader'
%             replaceHeaderStr = funOption{i}.valueStr;
%         otherwise
%     end
% end
% if strcmp(genReplaceStr,'Replace') == 1
%     opt.genReplace = 'Replace';
% else
%     opt.genReplace = 'Gen';
% end
% if strcmp(exportFromStr,'on') == 1
%     opt.exportFrom = 1;
% else
%     opt.exportFrom = 0;
% end
% if strcmp(genUniqueStr,'on') == 1
%     opt.genUnique = 1;
% else
%     opt.genUnique = 0;
% end
% opt.exportHeader = exportHeaderStr;
% opt.replaceHeader = replaceHeaderStr;
