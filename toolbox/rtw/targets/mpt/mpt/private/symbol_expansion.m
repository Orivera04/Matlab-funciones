function resolvedSymbol = symbol_expansion(symbol,symbolData)
%SYMBOL_EXPANSION converts a specific symbol to fully process symbol data.
%
%   RESOLVEDSYMBOL = SYMBOL_EXPANSION(SYMBOL,SYMBOLDATA)
%         returns a completely resolved symbol. All objects associated with
%         the symbol are contained in symbolData.
%
%   INPUT:
%         symbol:         Name of symbol to resolve
%         symbolData:     Objects associated with symbol and file of interest
%
%   OUTPUT:
%         resolvedSymbol: String that fully resolves the symbol and can be
%                         substituted into code

%   Steve Toeppe
%   Copyright 2002-2004 The MathWorks, Inc.
%
%   $Revision: 1.1.6.4 $
%   $Date: 2004/04/15 00:28:56 $

ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');
customComment = ecac.customComment;
modelName = symbolData.modelName;
miscOptions = get_misc_options(modelName);

cr = sprintf('\n');
resolvedSymbol='';
try
    fn = symbolData.cFile;
    switch (symbol)
    case 'Date'
        resolvedSymbol = [date, ' ', datestr(rem(now,1))];
    case 'HeaderPrologue'
        label = upper(strrep(fn,'.','_'));
        resolvedSymbol =  ['#ifndef ',label,cr,'#define ',label,cr];
    case 'HeaderEpilogue'
        label = upper(strrep(fn,'.','_'));
        resolvedSymbol =  ['#endif /* ',label,' */'];
    case 'ToolVersion'
        ml_ver = ver('matlab');
        sl_ver = ver('simulink');
        rt_ver = ver('rtw');
        ec_ver = ver('ecoder');
        sf_ver = ver('stateflow');
        sc_ver = ver('coder');
        mp_ver = ver('mpt');
        fx_ver = ver('fixpoint');
        if ~isempty(ml_ver)
            ml_str = sprintf('%s %s %s', ml_ver.Name, ml_ver.Version, ml_ver.Date);
            ml_str = [' * ', ml_str, blanks(75-length(ml_str)), '*', cr];
        else
            ml_str = [];
        end
        if ~isempty(sl_ver)
            sl_str = sprintf('%s %s %s', sl_ver.Name, sl_ver.Version, sl_ver.Date);
            sl_str = [' * ', sl_str, blanks(75-length(sl_str)), '*', cr];
        else
            sl_str = [];
        end
        if ~isempty(rt_ver)
            rt_str = sprintf('%s %s %s', rt_ver.Name, rt_ver.Version, rt_ver.Date);
            rt_str = [' * ', rt_str, blanks(75-length(rt_str)), '*', cr];
        else
            rt_str = [];
        end
        if ~isempty(ec_ver)
            ec_str = sprintf('%s %s %s', ec_ver.Name, ec_ver.Version, ec_ver.Date);
            ec_str = [' * ', ec_str, blanks(75-length(ec_str)), '*', cr];
        else
            ec_str = [];
        end
        if ~isempty(sf_ver)
            sf_str = sprintf('%s %s %s', sf_ver.Name, sf_ver.Version, sf_ver.Date);
            sf_str = [' * ', sf_str, blanks(75-length(sf_str)), '*', cr];
        else
            sf_str = [];
        end
        if ~isempty(sc_ver)
            sc_str = sprintf('%s %s %s', sc_ver.Name, sc_ver.Version, sc_ver.Date);
            sc_str = [' * ', sc_str, blanks(75-length(sc_str)), '*', cr];
        else
            sc_str = [];
        end
        if ~isempty(mp_ver)
            mp_str = sprintf('%s %s %s', mp_ver.Name, mp_ver.Version, mp_ver.Date);
            mp_str = [' * ', mp_str, blanks(75-length(mp_str)), '*',cr];
        else
            mp_str = [];
        end
        if ~isempty(fx_ver)
            fx_str = sprintf('%s %s %s', fx_ver.Name, fx_ver.Version, fx_ver.Date);
            fx_str = [' * ', fx_str, blanks(75-length(fx_str)), '*',cr];
        else
            fx_str = [];
        end
        topComm = '/*======================== TOOL VERSION INFORMATION ==========================*';
        botComm = ' *============================================================================*/';
        resolvedSymbol = [topComm,cr,ml_str, sl_str, rt_str, ec_str, sf_str, sc_str, mp_str,fx_str ,botComm];
    case 'ModelVersion'
        versionNumber = get_param(symbolData.modelName,'ModelVersion');
        versionString = ['Model: ', symbolData.modelName, ' Version: ', num2str(versionNumber)];
        resolvedSymbol = versionString;
    case 'FunctionName'
        objects = get_data_objects('ChartInfo', fn);
        if isempty(objects)==0
            resolvedSymbol = [];
            for oi = 1:length(objects)
                resolvedSymbol = [resolvedSymbol, ' ', objects{oi}.optionFcnFile.MPMFcnName];
            end
        end
    case 'Abstract'
        objects = get_data_objects('Abstract',fn);
        if isempty(objects)==0
            resolvedSymbol = strrep(objects{1}.name,cr,[cr,'**']);
        end
    case 'Notes'
        objects = get_data_objects('Notes',fn);
        if isempty(objects)==0
            resolvedSymbol = strrep(objects{1}.name,cr,[cr,'**']);
        end       
    case 'CFunctionCode'
        objects=get_data_objects('CFunctionCode',fn);
        if isempty(objects)==0
            for j=1:length(objects)
                resolvedSymbol = [resolvedSymbol,'/******************************************************************************/'];
                resolvedSymbol=[resolvedSymbol,cr,objects{j}.name];
                resolvedSymbol   = mpt_extern_manip_buffer(resolvedSymbol,symbol,fn, symbolData.modelName,'manBuffer');
%                                 bufferOut = cat_manipulate_buffer(objects{j}.name,symbolData.modelName,fn);
%                 resolvedSymbol=[resolvedSymbol,cr,bufferOut];
            end
        end
    case 'ExternalCalibrationLookup1D'
    case 'ExternalCalibrationLookup2D'
    case 'ExternalCalibrationScalar'
        objects = get_data_objects('ExternalCalibrationScalar', fn);
        normalList = [];
        ipcList = [];
        for i=1:length(objects)
            sectionName = get_data_info(objects{i}.originalName,'SECTIONNAME',modelName);
            if strcmp(sectionName,'IPC')
                ipcList{end+1} = objects{i};
            else
                normalList{end+1} = objects{i};
            end
        end
        ipcSymbol = get_resolved_extern_symbol_str(symbol,ipcList, customComment);
        normalSymbol = get_resolved_extern_symbol_str(symbol,normalList, customComment);
        resolvedSymbol = [ipcSymbol, normalSymbol];
    case 'ExternalVariableFlag'
        objects = get_data_objects('ExternalVariableFlag', fn);
        resolvedSymbol = get_resolved_extern_symbol_str(symbol,objects, customComment);
    case 'ExternalVariableScalar'
        objects = get_data_objects('ExternalVariableScalar', fn);
        resolvedSymbol = get_resolved_extern_symbol_str(symbol,objects, customComment);
    case 'ExternalVariableTimer'
        objects = get_data_objects('ExternalVariableTimer', fn);
        resolvedSymbol = get_resolved_extern_symbol_str(symbol,objects, customComment);
    case 'FileName'
        resolvedSymbol =  get_resolved_str('FileName',fn);
    case 'FilescopeCalibrationLookup1D'
    case 'FilescopeCalibrationLookup2D'
    case 'FilescopeCalibrationScalar'
        objects = get_data_objects('FilescopeCalibrationScalar', fn);
        normalList = [];
        ipcList = [];
        for i=1:length(objects)
            sectionName = get_data_info(objects{i}.originalName,'SECTIONNAME',modelName);
            if strcmp(sectionName,'IPC')
                ipcList{end+1} = objects{i};
            else
                normalList{end+1} = objects{i};
            end
        end
        ipcSymbol = get_resolved_extern_symbol_str(symbol,ipcList, customComment);
        normalSymbol = get_resolved_defining_symbol_str(0,symbol,normalList, customComment,symbolData.modelName);
        resolvedSymbol = [ipcSymbol, normalSymbol];
    case 'FilescopeVariableFlag'
        objects = get_data_objects('FilescopeVariableFlag',fn);
        ramList = [];
        kamList = [];
        for i=1:length(objects)
            sectionName = get_data_info(objects{i}.originalName,'SECTIONNAME',modelName);
            if strcmp(sectionName,'KAM')
                kamList{end+1} = objects{i};
            else
                ramList{end+1} = objects{i};
            end
        end
        kamSymbol = get_resolved_defining_symbol_str(1,symbol,kamList, customComment,symbolData.modelName);
        ramSymbol = get_resolved_defining_symbol_str(1,symbol,ramList, customComment,symbolData.modelName);
        resolvedSymbol = [kamSymbol, ramSymbol];
    case 'FilescopeVariableScalar'
        objects = get_data_objects('FilescopeVariableScalar',fn);
        ramList = [];
        kamList = [];
        for i=1:length(objects)
            sectionName = get_data_info(objects{i}.originalName,'SECTIONNAME',modelName);
            if strcmp(sectionName,'KAM')
                kamList{end+1} = objects{i};
            else
                ramList{end+1} = objects{i};
            end
        end
        kamSymbol = get_resolved_defining_symbol_str(1,symbol,kamList, customComment,symbolData.modelName);
        ramSymbol = get_resolved_defining_symbol_str(1,symbol,ramList, customComment,symbolData.modelName);
        resolvedSymbol = [kamSymbol, ramSymbol];
    case 'FilescopeVariableTimer'
        objects = get_data_objects('FilescopeVariableTimer',fn);
        ramList = [];
        kamList = [];
        for i=1:length(objects)
            sectionName = get_data_info(objects{i}.originalName,'SECTIONNAME',modelName);
            if strcmp(sectionName,'KAM')
                kamList{end+1} = objects{i};
            else
                ramList{end+1} = objects{i};
            end
        end
        kamSymbol = get_resolved_defining_symbol_str(1,symbol,kamList, customComment,symbolData.modelName);
        ramSymbol = get_resolved_defining_symbol_str(1,symbol,ramList, customComment,symbolData.modelName);
        resolvedSymbol = [kamSymbol, ramSymbol];
    case 'GlobalCalibrationLookup1D'
    case 'GlobalCalibrationLookup2D'
    case 'GlobalCalibrationScalar'
        objects = get_data_objects('GlobalCalibrationScalar', fn);
        normalList = [];
        ipcList = [];
        for i=1:length(objects)
            sectionName = get_data_info(objects{i}.originalName,'SECTIONNAME',modelName);
            if strcmp(sectionName,'IPC')
                ipcList{end+1} = objects{i};
            else
                normalList{end+1} = objects{i};
            end
        end
        ipcSymbol = get_resolved_extern_symbol_str(symbol,ipcList, customComment);
        normalSymbol = get_resolved_defining_symbol_str(0,symbol,normalList, customComment,symbolData.modelName);
        resolvedSymbol = [ipcSymbol, normalSymbol];
    case 'GlobalVariableFlag'
        objects = get_data_objects('GlobalVariableFlag',fn);
        ramList = [];
        kamList = [];
        for i=1:length(objects)
            sectionName = get_data_info(objects{i}.originalName,'SECTIONNAME',modelName);
            if strcmp(sectionName,'KAM')
                kamList{end+1} = objects{i};
            else
                ramList{end+1} = objects{i};
            end
        end
        kamSymbol = get_resolved_defining_symbol_str(1,symbol,kamList, customComment,symbolData.modelName);
        ramSymbol = get_resolved_defining_symbol_str(1,symbol,ramList, customComment,symbolData.modelName);
        resolvedSymbol = [kamSymbol, ramSymbol];
    case 'GlobalVariableScalar'
        objects = get_data_objects('GlobalVariableScalar',fn);
        ramList = [];
        kamList = [];
        for i=1:length(objects)
            sectionName = get_data_info(objects{i}.originalName,'SECTIONNAME',modelName);
            if strcmp(sectionName,'KAM')
                kamList{end+1} = objects{i};
            else
                ramList{end+1} = objects{i};
            end
        end
        kamSymbol = get_resolved_defining_symbol_str(1,symbol,kamList, customComment,symbolData.modelName);
        ramSymbol = get_resolved_defining_symbol_str(1,symbol,ramList, customComment,symbolData.modelName);
        resolvedSymbol = [kamSymbol, ramSymbol];
    case 'GlobalVariableTimer'
        objects = get_data_objects('GlobalVariableTimer',fn);
        ramList = [];
        kamList = [];
        for i=1:length(objects)
            sectionName = get_data_info(objects{i}.originalName,'SECTIONNAME',modelName);
            if strcmp(sectionName,'KAM')
                kamList{end+1} = objects{i};
            else
                ramList{end+1} = objects{i};
            end
        end
        kamSymbol = get_resolved_defining_symbol_str(1,symbol,kamList, customComment,symbolData.modelName);
        ramSymbol = get_resolved_defining_symbol_str(1,symbol,ramList, customComment,symbolData.modelName);
        resolvedSymbol = [kamSymbol, ramSymbol];
    case 'History'
        objects = get_data_objects('History',fn);
        if isempty(objects)==0
            resolvedSymbol = objects{1}.name;
        end
    case 'StatemachineDeclaration'
            resolvedSymbol = [];
            objects=get_data_objects('StatemachineDeclaration',fn);
            %         for i=1:length(symbolData.localDataStructure)
            %             resolvedSymbol = [resolvedSymbol,symbolData.localDataStructure{i},cr];
            %         end
            
            %only need 1 per file
            if objects{1}.need_broadcastevent
                resolvedSymbol = [resolvedSymbol,['extern unsigned char _sfEvent_',objects{1}.modelName,'_;',cr]];
            end
            for j=1:length(objects)
                if isempty(objects{j}.localDataStructure) == 1
                    for i=1:length(objects{j}.stateStructure)
                        resolvedSymbol = [resolvedSymbol,objects{j}.stateStructure{i},cr];
                    end
                    resolvedSymbol = [resolvedSymbol,cr];
                    for i=1:length(objects{j}.instanceStructure)
                        resolvedSymbol = [resolvedSymbol,objects{j}.instanceStructure{i},cr];
                    end
                    resolvedSymbol = [resolvedSymbol,cr];
                    for i=1:length(objects{j}.chartInstanceDefinition)
                        chartInstanceDefinition = objects{j}.chartInstanceDefinition{i};
                        index = findstr(chartInstanceDefinition,';');
                        chartInstanceDefinition = [chartInstanceDefinition(1:index-1),...
                                num2str(objects{j}.chartFileNumber),';'];
                        resolvedSymbol = [resolvedSymbol,chartInstanceDefinition,cr,cr];
                        %                     resolvedSymbol = [resolvedSymbol,objects{j}.chartInstanceDefinition{i},cr];
                    end
                else
                    if isempty(objects{j}.stateStructure) == 0
                        for i=1:length(objects{j}.stateStructure)
                            stateStructure = objects{j}.stateStructure{i};
                            resolvedSymbol = [resolvedSymbol,stateStructure,cr];
                        end
                        resolvedSymbol = [resolvedSymbol,cr];
                        %                 resolvedSymbol = [resolvedSymbol,symbolData.instanceStructure{1},cr];
                        for i=1:length(objects{j}.instanceStructure)
                            if isempty(findstr(objects{j}.instanceStructure{i},' LocalData;'))
                                resolvedSymbol = [resolvedSymbol,objects{j}.instanceStructure{i},cr];
                            end
                        end
                        resolvedSymbol = [resolvedSymbol,cr];
                        for i=1:length(objects{j}.chartInstanceDefinition)
                            chartInstanceDefinition = objects{j}.chartInstanceDefinition{i};
                            index = findstr(chartInstanceDefinition,';');
                            chartInstanceDefinition = [chartInstanceDefinition(1:index-1),...
                                    num2str(objects{j}.chartFileNumber),';'];
                            resolvedSymbol = [resolvedSymbol,chartInstanceDefinition,cr,cr];
                            %                         resolvedSymbol = [resolvedSymbol,objects{j}.chartInstanceDefinition{i},cr];
                        end
                        
                    end
                end
            end
    case 'IncludeFiles'
        miscOption = get_misc_options(symbolData.modelName);
        switch(miscOption.IncludeFileEnclosure)
        case '#include <header.h>'
            defaultQuoteFlag = 0;
        case '#include "header.h"'
            defaultQuoteFlag = 1;
        otherwise
            defaultQuoteFlag = 1;
        end
        resolvedSymbol=[];
        objName = [];
        objects=get_data_objects('IncludeFiles',fn);
        for i=1:length(objects)
            objName{i}=objects{i}.fileInclude;
        end
        objName = union(objName,[]);
        objName = reorder_includeFile(objName);      % re-sorted include files.
        for i=1:length(objName)
            quoteFlag = defaultQuoteFlag;  %default
            fileName = objName{i};
            fileName = strrep(fileName,' ','');
            len = length(fileName);
            if len > 0
                indexQuote = findstr(fileName,'"');
                if isempty(indexQuote) == 0
                    if (length(indexQuote) == 2) & (indexQuote(1) == 1) & (indexQuote(2) == len)
                        %fully qualified double quote enclosed include
                        quoteFlag = 1;
                    end
                else
                    indexAngleOpen = findstr(fileName,'<');
                    indexAngleClose = findstr(fileName,'>');
                    if (isempty(indexAngleOpen) == 0) & (isempty(indexAngleClose) == 0)
                        if (length(indexAngleOpen) == 1) & (indexAngleOpen(1) == 1) & ...
                                (length(indexAngleClose) == 1) & (indexAngleClose(1) == len)
                            %fully qualified angle brace enclosed include
                            quoteFlag = 0;

                        end
                    end
                end

                fileName = strrep(fileName,'"','');
                fileName = strrep(fileName,'<','');
                fileName = strrep(fileName,'>','');
                index = findstr(fileName,'.');

                %At this point the file name is inclosed by either double quotes or angle braces
                if isempty(index) == 0
                    if index(1) > 1
                        fileName=fileName(1:index(1)-1);
                    else
                        fileName = '';
                    end
                end
                if quoteFlag == 1
                    fileName = ['"',fileName,'.h"'];
                else
                    fileName = ['<',fileName,'.h>'];
                end
                resolvedSymbol = [resolvedSymbol,'#include ',fileName,cr];
            end
        end
    case 'IncludeLibraryExternalPublicFunctions'
    case 'IncludePrototypesExternalPublicFunctions'
        objects=get_data_objects('IncludePrototypesExternalPublicFunctions',fn);
        resolvedSymbol=[];
        externList = [];
        for i=1:length(objects)
            %             resolvedSymbol=[resolvedSymbol,'extern void ',objects{i}.name,'(void);',cr];
            externList{i}=objects{i}.name;
        end
        if isempty(externList) == 0
            externList = unique(externList);
        end
        for i=1:length(externList)
            %             resolvedSymbol=[resolvedSymbol,'extern void ',objects{i}.name,'(void);',cr];
            resolvedSymbol=[resolvedSymbol,externList{i},cr];
        end
    case 'LocalDefines'
        objects = get_data_objects('LocalDefines',fn);
        resolvedSymbol=[];
        for i=1:length(objects)
            if objects{i}.includeFileFlag == 0
                typeStr = objects{i}.type;
                initialValue = get_data_info(objects{i}.originalName,'INITIAL_VALUE',modelName);
                tvalue = str2num(initialValue);
                baseType = objects{i}.modelType;
%                 baseType = objects{i}.tmwType; %ac_get_type(typeStr, 'userName', 'tmwName', 'primary');
                numPlaces = 15;
                switch(lower(baseType))
                    case {'float','double','real_t','real32_t','single'}
                        if  abs(mod(str2num(initialValue),floor(str2num(initialValue)))) > 0.0,
                            resolvedSymbol{end+1}=['#define ',objects{i}.name,' ',num2str(tvalue,numPlaces),objects{i}.suffix,cr];
                        else
                            resolvedSymbol{end+1}=['#define ',objects{i}.name,' ',sprintf('%0.1f',str2num(initialValue)),objects{i}.suffix,cr];
                        end
                    otherwise
                        resolvedSymbol{end+1}=['#define ',objects{i}.name,' ',sprintf('%d',str2num(initialValue)),objects{i}.suffix,cr];
                end
            end
        end
        temp = unique(resolvedSymbol);
        resolvedSymbol = [];
        for i=1:length(temp)
            resolvedSymbol = [resolvedSymbol,temp{i}];
        end
    case 'StatemachineConstants'
        objects = get_data_objects('StatemachineConstants',fn);
        resolvedSymbol=[];
        for i=1:length(objects)
            if objects{i}.includeFileFlag == 0
                resolvedSymbol=[resolvedSymbol,'#define ',objects{i}.name,' ',objects{i}.initialValue,cr];
            end
        end
    case 'LocalMacros'
            objects=get_data_objects('LocalMacros',fn);
            resolvedSymbol=[];
            for i=1:length(objects)
                %             resolvedSymbol=[resolvedSymbol,'void ',objects{i}.name,'(void);',cr];
                resolvedSymbol=[resolvedSymbol,objects{i}.name,cr];
            end
        
    case 'PrivateFunctions'
        objects=get_data_objects('PrivateFunctions',fn);
        resolvedSymbol=[];
        for i=1:length(objects)
            %             resolvedSymbol=[resolvedSymbol,'void ',objects{i}.name,'(void);',cr];
            resolvedSymbol=[resolvedSymbol,objects{i}.name,cr];
        end
    case 'PublicLocalOwnershipFunctions'
        objects=get_data_objects('PublicLocalOwnershipFunctions',fn);
        resolvedSymbol=[];
        if isempty(objects) == 0
            for i=1:length(objects)
                externStr = '';
                if isfield(objects{i},'externFlag') == 1
                    if objects{i}.externFlag == 1
                        externStr = 'extern ';
                    end
                end
                protoArgStr = [];
                returnStr = [];
                if isfield(objects{i},'data') == 1
                    if isempty(objects{i}.data) == 0

                        if isempty(objects{i}.data.functionInput) == 0
                            commaStr = '';
                            for j=1:length(objects{i}.data.functionInput)
                                protoArgStr = [protoArgStr,commaStr,' ',objects{i}.data.functionInput{j}.rtwDataType,' ',...
                                        objects{i}.data.functionInput{j}.name];
                                commaStr = ',';
                            end
                        else
                            protoArgStr = 'void';
                        end

                        if isempty(objects{i}.data.functionOutput) == 0
                            for j=1:length(objects{i}.data.functionOutput)
                                returnStr = [returnStr,' ',objects{i}.data.functionOutput{j}.rtwDataType];
                            end
                        else
                            returnStr = 'void';
                        end
                    else
                        returnStr = 'void';
                        protoArgStr = 'void';
                    end
                else
                    returnStr = 'void';
                    protoArgStr = 'void';
                end

                resolvedSymbol=[resolvedSymbol,externStr,returnStr,' ',objects{i}.name,'(',protoArgStr,');',cr];
            end
        end
    case 'TypeDefinitions'
    case 'ExportAccessMethods'
            objects=get_data_objects('ExportAccessMethods',fn);
            resolvedSymbol=[];
            for i=1:length(objects)
                %             resolvedSymbol=[resolvedSymbol,'void ',objects{i}.name,'(void);',cr];
                resolvedSymbol=[resolvedSymbol,'#define ',objects{i}.method,' ',objects{i}.name,cr];
            end
        
    otherwise
        objects = get_data_objects(symbol,fn);
        if isempty(objects)==0
            resolvedSymbol = objects{1}.name;
        end
    end
catch
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function table = get_1dlookup_ws_table(name)

try
    table.x = evalin('base',[name,'.X']);
    table.y = evalin('base',[name,'.Y']);
catch
    try
        table.x = evalin('base',[name,'.Value.X']);
        table.y = evalin('base',[name,'.Value.Y']);
    catch
        table = [];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function table = get_ws_table(name)

try
    table = evalin('base',[name,'.Z']);
catch
    try
        table = evalin('base',[name,'.Value.Z']);
    catch
        table = [];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function str = cell_2_string(cellofstr)

str=[];
cr = sprintf('\n');
for i=1:length(cellofstr)
    str = [str,cellofstr{i},cr];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function wStr = comment_format(basicStr,comment, cStr,cEnd)

% case 1...comment will fit on line
% case 1a..comment start is at cStr
% case 1b..comment start is beyond cStr

% case 2...comment willr require 2 or more lines
% case 2a..comment start is at cStr
% case 2b..comment start is beyond cStr
%

%Padding String

miscOptions = get_misc_options(bdroot);
postProcess = miscOptions.PostProcessEnable;

if length(comment) == 0
    wStr = basicStr;
    return;
end
ePad = '                                                                                                       ';
cr = sprintf('\n');
comment=strrep(comment,cr,'');
len = length(basicStr);
cLen = length(comment);

if len < cStr     % does the basic string end before the start of the comments
    start = 1;
    pad = '';
    for i=1:cStr-len
        pad = [pad,' '];
    end
    strPad = '';
else
    start = 0;
    pad = '';
    strPad = ' ';
end
postProcess = 0;    %  disable postProcess here
if postProcess == 1
    cSize = (cEnd -  cStr - 6);
else
    cSize = (cEnd -  cStr - 7);
end

if cLen <= cSize
    lineType = 1;
    if postProcess == 1
        wStr = [basicStr,pad,strPad,'/** ',comment];
    else
        wStr = [basicStr,pad,strPad,'/* ',comment];
    end
    len = length(wStr);
    if len < cEnd

        pad = ePad(1:cEnd-len);

    end
    wStr = [wStr,pad,' */'];
else
    lineType = 0;
    restofc = comment;

    sPad = ePad(1:cStr);

    wStr = basicStr;
    wcStr = length(basicStr);
    if wcStr < cStr
        wcStr = cStr;
    end
    while isempty(restofc) == 0
        if postProcess == 1
            wcSize=cEnd-wcStr-5;
            [nextc, restofc]=parsec(restofc,wcSize+1);
            endpad = ePad(wcStr+length([nextc,strPad])+5:cEnd);
            wStr = [wStr,pad,strPad,'/** ',nextc,endpad,' */',cr];
        else
            wcSize=cEnd-wcStr-4;
            [nextc, restofc]=parsec(restofc,wcSize+1);
            endpad = ePad(wcStr+length([nextc,strPad])+4:cEnd);
            wStr = [wStr,pad,strPad,'/* ',nextc,endpad,' */',cr];
        end
        pad = sPad;
        wcSize=cSize;
        wcStr = cStr;
        strPad = '';
    end

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function resolvedSymbol = get_resolved_str(symbol_name,file_name)
resolvedSymbol = '';
objects=get_data_objects(symbol_name,file_name);
if isempty(objects) == 0
    resolvedSymbol = objects{1}.name;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function resolvedSymbol = get_resolved_extern_symbol_str(symbol_name,file_name,customComment,miscOptions)
function resolvedSymbol = get_resolved_extern_symbol_str(symbol_name,objects,customComment)
cr = sprintf('\n');
resolvedSymbol = '';
% objects=get_data_objects(symbol_name,file_name);

for i=1:length(objects)
    if objects{i}.includeFileFlag == 0
        
        pad = need_pad(objects{i}.storageClass);
        if objects{i}.arraySize <= 1
            arrayStr = '';
        else
            arrayStr = sprintf('[%g]',objects{i}.arraySize);
        end
        
        
        basicStr = ['extern ',objects{i}.storageClass,pad,objects{i}.type,' ',objects{i}.name,arrayStr,';'];
        if customComment.customCommentEnable == 1
            
            [commentStr, normalCommentFlag ] = evalin('base',...
                [customComment.customCommentScript,'([],','''',symbol_name,'''',',','''',objects{i}.originalName,'''',')']);
            
            %             [commentStr, normalCommentFlag ] = format_custom_comment([], symbol_name, objects{i}.originalName);
        else
            normalCommentFlag = 1;
            commentStr = [];
        end
        
        if normalCommentFlag == 1,
            fullStr = comment_format(basicStr,objects{i}.comment, 27,77);
        else
            fullStr = basicStr;
        end
        
        resolvedSymbol = [resolvedSymbol,commentStr,cr,fullStr,cr];
        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function resolvedSymbol = get_resolved_defining_symbol_str(symbolName,fileName,customComment)
function resolvedSymbol = get_resolved_defining_symbol_str(initControlFlag,symbolName,objects,customComment,modelName)
cr = sprintf('\n');
resolvedSymbol = '';
ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');

% objects=get_data_objects(symbolName,fileName);
for i=1:length(objects)
    if objects{i}.includeFileFlag == 0
        pad = need_pad(objects{i}.storageClass);
        if isempty(objects{i}.type) == 0
            typeStr = objects{i}.type;
        else
            typeStr = 'MISSING DATA TYPE';
        end
        arrayLen = 1;
        arraySize = objects{i}.arraySize;
        if isempty(arraySize) == 1
            arraySize = 1;
        else
            for ix=1:length(arraySize),
              arrayLen = arrayLen * arraySize(ix);
            end
            arraySize= arrayLen;
        end

        if arraySize <= 1,
            arrayStr = '';
        else
            arrayStr = sprintf('[%g]',objects{i}.arraySize);
        end
        initialValue =[];
        initialValue = get_data_info(objects{i}.originalName,'INITIAL_VALUE',modelName);

        if isempty(initialValue)==1,
            initialValue = '0.0';
            disp(['****** The Initial Value/Value field for data object "',objects{i}.originalName,'" therefore a default value will be used.']);
        end

        %
        % Attempt to get the tmw data type as a primary type
        %

        baseType = objects{i}.modelType; %ac_get_type(typeStr, 'userName', 'tmwName', 'primary');
        numPlaces = 15;

        %
        % Protect for the case where the data type is not a primary.
        %

%         if isempty(baseType),
%             baseTypeTmp = ac_get_type(typeStr, 'userName', 'tmwName', 'all');
%             if length(baseTypeTmp) > 0,
%               baseType = baseTypeTmp{1};
%             end
%         end

        if ~isempty(baseType),
            if isempty(initialValue) == 0
                if arraySize <= 1
                    [m,n] = size(str2num(initialValue));
                    len = m*n;

                    tvalue = str2num(initialValue)';
                    if arraySize == len,
                        switch(lower(baseType))
                            case {'float','double','real_t','real32_t','single'}
                                if abs(mod(str2num(initialValue),floor(str2num(initialValue)))) > 0.0,
                                    initial = [' = ',num2str(tvalue,numPlaces),objects{i}.suffix];
                                else
                                    initial = [' = ',sprintf('%0.1f',str2num(initialValue)),objects{i}.suffix];
                                end
                            otherwise
                                initial = [' = ',sprintf('%d',str2num(initialValue)),objects{i}.suffix];
                        end
                    else
                        disp(['******* Warning: Array Dimensions and Initial Value/Value field for "',objects{i}.originalName,'" sizes do not match, dimension of 1 will be used *****']);
                        switch(lower(baseType))
                            case {'float','double','real_t','real32_t','single'}
                                if  abs(mod(str2num(initialValue),floor(str2num(initialValue)))) > 0.0,
                                    initial = [' = ',num2str(tvalue(1),numPlaces),objects{i}.suffix];
                                else
                                    initial = [' = ',sprintf('%0.1f',tvalue(1)),objects{i}.suffix];
                                end
                            otherwise
                                initial = [' = ',sprintf('%d',str2num(tvalue(1))),objects{i}.suffix];
                        end
                    end
                else
                    switch(lower(baseType))
                        case {'float','double','real_t','real32_t','single'}
                            iVal = '0.0';
                        otherwise
                            iVal = '0';
                    end
                    initial = ' = {';
                    [m,n] = size(str2num(initialValue));
                    len = m*n;
                    tvalue = str2num(initialValue)';
                    if len == arrayLen,
                        switch(lower(baseType))
                            case {'float','double','real_t','real32_t','single'}
                                for in=1:(len)-1,
                                    if  abs(mod(tvalue(in),floor(tvalue(in)))) > 0.0,
                                        initial = [ initial, ' ',num2str(tvalue(in),numPlaces),objects{i}.suffix,','];
                                    else
                                        initial = [ initial, ' ',sprintf('%0.1f',tvalue(in)),objects{i}.suffix,','];
                                    end
                                end

                                if  abs(mod(tvalue(end),floor(tvalue(end)))) > 0.0,
                                    initial = [initial,' ',num2str(tvalue(end),numPlaces),objects{i}.suffix,' }'];
                                else
                                    initial = [initial,' ',sprintf('%0.1f',tvalue(end)),objects{i}.suffix,' }'];
                                end
                            otherwise
                                for in=1:(len)-1,
                                    initial = [ initial, ' ',sprintf('%d',tvalue(in)),objects{i}.suffix,','];
                                end
                                initial = [initial,' ',sprintf('%d',tvalue(end)),objects{i}.suffix,' }'];
                        end
                    else
                        disp(['***** WARNING: "',objects{i}.originalName,'" Array Dimensions and Initial Value Size Do Not Match : default ( 0 or 0.0 ) values used. *******']);
                        for j=1:arraySize-1
                            initial = [ initial, ' ',iVal,objects{i}.suffix,','];
                        end
                        initial = [initial,' ',iVal,objects{i}.suffix,' }'];
                    end
                end
            else
                initial = '';
            end       
            %if it is optional to support initialization and the usser has
            %indicated they dont want zero initialization and the initial
            %vlaue is zero
            %  then clear the initial string.
            %
            if (initControlFlag == 1) & (strcmp(ecac.ZeroExternalMemoryAtStartup,'1')==0)
                if abs(tvalue) < eps
                    
                    initial='';
                end
            end
            basicStr = [objects{i}.storageClass,pad,typeStr,' ',...
                    objects{i}.name,arrayStr,initial,';'];
            if customComment.customCommentEnable == 1
                
                [commentStr, normalCommentFlag ] = evalin('base',...
                    [customComment.customCommentScript,'([],','''',symbolName,'''',',','''',objects{i}.originalName,'''',')']);
                
                %             [commentStr, normalCommentFlag ] = format_custom_comment([], symbol_name, objects{i}.originalName);
            else
                normalCommentFlag = 1;
                commentStr = [];
            end
            %             if (exist('format_custom_comment') == 2 & customComment == 1)
            %                 [commentStr, normalCommentFlag ] = format_custom_comment([], symbolName, objects{i}.originalName);
            %             else
            %                 normalCommentFlag = 1;
            %                 commentStr = [];
            %             end
            if normalCommentFlag == 1,
                fullStr = comment_format(basicStr,objects{i}.comment, 33,77);
            else
                fullStr = basicStr;
            end
            %             resolvedSymbol = [resolvedSymbol,fullStr,cr,commentStr];
            if isempty(commentStr) == 0
                resolvedSymbol = [resolvedSymbol,commentStr,cr,fullStr,cr];
            else
                resolvedSymbol = [resolvedSymbol,fullStr,cr];
            end
        else
            fullStr ='';
            resolvedSymbol = [resolvedSymbol,fullStr];
        end
    end
end
if ~isempty(objects)
    if mpt_config_get(modelName,'PragmaEnable') == 1
        outFile = mpt_config_get(modelName,'PragmaScript');
        memType = get_data_info(objects{1}.originalName,'SECTIONNAME',modelName);
        outFile = strtok(outFile,'.');
        [startPragma, endPragma] = eval([outFile,'(memType)']);
        if length(startPragma) > 1
            resolvedSymbol = [startPragma, cr, cr, resolvedSymbol, cr, endPragma, cr];
        end
    end
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pad = need_pad(sc);
if isempty(sc) == 0
    pad = ' ';
else
    pad = '';
end
