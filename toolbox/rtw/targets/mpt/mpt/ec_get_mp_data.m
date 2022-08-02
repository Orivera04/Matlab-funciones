function info = ec_get_mp_data(modelName,fileName,typeList,codeTemplate)

%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.5 $
%   $Date: 2004/04/15 00:26:44 $
info = [];

baseSymbol{1}='Includes';
baseSymbol{2}='Defines';
baseSymbol{3}='IntrinsicTypes';
baseSymbol{4}='PrimitiveTypedefs';
baseSymbol{5}='UserTop';
baseSymbol{6}='Typedefs';
baseSymbol{7}='Enums';
baseSymbol{8}='Definitions';
baseSymbol{9}='ExternData';
baseSymbol{10}='ExternFcns';
baseSymbol{11}='FcnPrototypes';
baseSymbol{12}='Declarations';
baseSymbol{13}='Functions';
baseSymbol{14}='CompilerErrors';
baseSymbol{15}='CompilerWarnings';
baseSymbol{16}='Documentation';
baseSymbol{17}='UserBottom';

%Types of information placed into template files
% 1) Data object information related to data placement
%    This is handled via buffer in tlc and ec_data_placement
% 2) Comment or Documentation information for all files
%    Information that all files may include. Global in nature.
%    No effort to constrain to specific files via set_symbol_db_element
% 3) File specific information in symbol buffers
% 4) Custom files with custom hooks

%Establish symbols data base
init_symbol_db;

%Get symbol contents that are global in scope and are not file specific
buffer = ec_global_doc_buffer(modelName);


symbolTemplateDB = rtwprivate('rtwattic', 'AtticData', 'symbolTemplateDB');


symbolList=[];

%Establish list of symbols in data base
for i=1:length(symbolTemplateDB)
    symbolList{i}= symbolTemplateDB{i}.symbolName;
end

%for each of the 4 standard templates and extra custom templates
%  Establish the list of symbols used
%  Save with index for future reference
%end


templateInfo = [];
tIndex = 1;
[templateName,status] = mpt_config_get(modelName,'ERTSrcFileBannerTemplate');
templateInfo{tIndex} = load_single_template(templateName);
templateInfo{tIndex}.symreg = get_symbols(templateName,symbolList,baseSymbol);
templateInfo{tIndex}.templateSpecificBuffer = setup_buffer(buffer,templateInfo{tIndex}.symbol.name);
templateInfo{tIndex}.templateName = templateName;
templateList{tIndex}=templateName;

tIndex = tIndex + 1;
[templateName,status] = mpt_config_get(modelName,'ERTHdrFileBannerTemplate');
templateInfo{tIndex} = load_single_template(templateName);
templateInfo{tIndex}.symreg = get_symbols(templateName,symbolList,baseSymbol);
templateInfo{tIndex}.templateSpecificBuffer = setup_buffer(buffer,templateInfo{tIndex}.symbol.name);
templateInfo{tIndex}.templateName = templateName;
templateList{tIndex}=templateName;

tIndex = tIndex + 1;
[templateName,status] = mpt_config_get(modelName,'ERTDataSrcFileTemplate');
templateInfo{tIndex} = load_single_template(templateName);
templateInfo{tIndex}.symreg = get_symbols(templateName,symbolList,baseSymbol);
templateInfo{tIndex}.templateSpecificBuffer = setup_buffer(buffer,templateInfo{tIndex}.symbol.name);
templateInfo{tIndex}.templateName = templateName;
templateList{tIndex}=templateName;

tIndex = tIndex + 1;
[templateName,status] = mpt_config_get(modelName,'ERTDataHdrFileTemplate');
templateInfo{tIndex} = load_single_template(templateName);
templateInfo{tIndex}.symreg = get_symbols(templateName,symbolList,baseSymbol);
templateInfo{tIndex}.templateSpecificBuffer = setup_buffer(buffer,templateInfo{tIndex}.symbol.name);
templateInfo{tIndex}.templateName = templateName;
templateList{tIndex}=templateName;

index = 0;
[len,wid]=size(fileName);
info=[];
fIndex = 1;
for i=1:len
    [templateName, fileType] = strtok(codeTemplate(i,1:end),'.');
    if isempty(fileType) == 0
        invalidTemplate = 1;
        nullC=0;
        findNull = find(fileType == nullC);
        if isempty(findNull) == 0
            fileType = fileType(1:findNull-1);
        end
%         fileType = strrep(fileType,nullC,''); %work around for geck 198755
        switch(fileType) %work around for geck 198753 
            case '.cgt'
                templateFileName = [templateName,fileType];
                invalidTemplate = 0;
            case '.tlc'
                %it might be a valid template
                %c_file_template_cgt.tlc is a possible format
                if length(templateName) > 4
                    if strcmp(templateName(end-3:end),'_cgt')
                        templateFileName=[templateName(1:end-4),'.cgt'];
                        invalidTemplate = 0;
                    end
                end
            otherwise
        end
        if invalidTemplate == 0
            tIndex = find(strcmp(templateFileName,templateList));
            if isempty(tIndex) == 0
                tIndex = tIndex(1);
                name = fileName(i,1:end);
                type = typeList(i,1:end);
                info.fileBuf{fIndex}.fileName = name;
                info.fileBuf{fIndex}.fileType = type;
                info.fileBuf{fIndex}.buffer = templateInfo{tIndex}.templateSpecificBuffer;
                info.fileBuf{fIndex}.symreg = templateInfo{tIndex}.symreg;
                fIndex = fIndex + 1;
            end
        end
    end

end

if isempty(info) == 1
    info.state = 0;
else
    info.state = 1;
end
return

function templateSpecificList = get_symbols(templateName,symbolList,baseSymbol)

symbolTemplateDB = rtwprivate('rtwattic', 'AtticData', 'symbolTemplateDB');
info = load_single_template(templateName);

%for each symbol in template
% if it is in the symbol data base
%   process per data base
% end
templateSpecificList=[];
for i=1:length(info.symbol.name)
    %if the symbol name is one of the base systems,
    %  There is no need to process it.
    if isempty(find(strcmp(info.symbol.name{i},baseSymbol))) == 1
        index = find(strcmp(info.symbol.name{i},symbolList));
        if isempty(index) == 0
            templateSpecificList{end+1} = symbolTemplateDB{index};
        end
    end
end

function templateSpecificBuffer = setup_buffer(buffer,templateSpecificList)
%for each globally available buffer entry
% if the symbol is supported in the files template (symbols)
%   bundle it up for inclusion into template expansion in tlc
% end
%end
templateSpecificBuffer = [];
foundList(length(templateSpecificList))=0;
for i=1:length(buffer)
    index = find(strcmp(buffer{i}.bufferName,templateSpecificList));
    if index == 1
        xx=2;
    end
    if isempty(index) == 0
        if foundList(index) == 1
            buffer{i}.bufferContent=[sprintf('\n'),buffer{i}.bufferContent];
        else
            foundList(index) = 1;
        end
        templateSpecificBuffer{end+1}=buffer{i};
    end
end
