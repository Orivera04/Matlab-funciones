function make_file_from_template(modelName,parse_info,output_file,pcode,templateFullPath)
%MAKE_FILE_FROM_TEMPLATE create source file from file template 
%
%   MAKE_FILE_FROM_TEMPLATE(MODELNAME,PARSE_INFO,OUTPUT_FILE,PCODE,TEMPLATEFULLPATH)
%   This function makes C files from specified templates.
%
%   INPUTS:
%           modelName        :  Name of model from which code is generated
%           parse_info       :  Parse file information
%           output_file      :  Output file name
%           pcode            :  Parsed c code for the c file
%           templateFullPath :  Full path to the template
%
%   OUTPUTS: 
%           none  

%   Donn Shull
%   Copyright 2002-2003 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/15 00:27:17 $

%
% Step one create the Module Definition File this file has the
% same name as the final c file with the file extension mdf
%
if evalin('base','exist(''MPTTestEnable'',''var'');')==1,
    global mptSymbolDataSets;
    %   mptSymbolDataSets = [];
end  
set_template_info(modelName,'activeTemplateFullPath',templateFullPath);
outf = output_file;
index = findstr(outf,'.');
if index > 0
    outf = outf(1:index);
end
mdf_file = [outf,'mdf'];
mdf = fopen(mdf_file,'wt');

%
% create the filename section and output_file record
%

fprintf(mdf,'%s\n','FileName');
fprintf(mdf,'%s\n','{');
fprintf(mdf,'    output_file "%s"\n',output_file);
fprintf(mdf,'%s\n','}');


%
% Create and populate the ParsedCode section
%

fprintf(mdf,'%s\n','ParsedCode');
fprintf(mdf,'%s\n','{');
cr = sprintf('\n');
status = 0;
symbolList ='';
ic = 0;
for i=1:length(parse_info.line)
    
    for j=1:length(parse_info.line{i}.freeFormText)
        
        symbol = parse_info.line{i}.symbol{j};
        if length(symbol) > 0
            if ic == 0 | (ic ==1 & isempty(strmatch(symbol,symbolList,'exact'))== 1)
                % for the actual c_function_code section reformat the
                % code before placing in the record
                %
                ic = 1;
                symbolList{end+1} = symbol;
                [symstr, status] = symbol_resolver(symbol,pcode);
                if evalin('base','exist(''MPTTestEnable'',''var'');')==1,
                    mptSymbolDataSets{end+1}.symbolName = symbol;
                    mptSymbolDataSets{end}.expandedSymbol= symstr;
                    mptSymbolDataSets{end}.FileName = output_file;
                end  
                newstr = char(symstr);                                % resolve empty symstr
                newstr = strrep(newstr,'\','\\"');                    % escape quote symbol
                newstr = strrep(newstr,cr,['\',cr]);                  % add continuation char to newline
                newstr = strrep(newstr,'"','\"');                     % escape quote symbol
                str = [symbol,' "',newstr,'"'];
                fprintf(mdf,'    %s\n',[symbol,' "',newstr,'"']);
            end
        end
    end
end
fprintf(mdf,'%s\n','}');
fclose(mdf);

%
% Step two create the c Module using tlc
%
global mpmModelName;
mpmModelName = modelName;
templatePath = which('pac.tlc');

eval(['tlc -r ',mdf_file,' ',templatePath]);

%
% Delete mdf file after use
%

delete(mdf_file);

