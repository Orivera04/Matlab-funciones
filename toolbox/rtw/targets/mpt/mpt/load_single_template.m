function parsed = load_single_template(templateName )
%LOAD_SINGLE_TEMPLATE will load in a file template for code generation.
%
%   [PARSED]=LOAD_SINGLE_TEMPLATE(TEMPLATENAME)
%   This function will load in a file template (templateName) and parse 
%   symbols and free form text into a structure (parsed).
%
%    INPUT:
%          templateName : file name of template
%    OUTPUT:
%          parsed       : structure of parsed symbols and text

%   Steve Toeppe
%   Copyright 2002-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/15 00:27:15 $

parsed.line=[];
parsed.symbol.name=[];
parsed.symbol.resolve=[];

fid = fopen(templateName);   %open the template file

% if the file handle is still valid
%   get each line
%   if valid character
%    then parse out any possible symbols and free form text
%    add symbol names to total list of symbol names
%   else break out of get each line loop

if fid > 0
        while 1
            lineStr = fgetl(fid);
            if ~ischar(lineStr), break, end
            if isempty(regexp(lineStr,'^\s*%%')) == 0
                info.symbol={''};
                info.freeFormText{1}=lineStr;
                parsed.line{end+1}=info;
            else
                parsed.line{end+1} = symbol_parse(lineStr );
            end
            for i=1:length(parsed.line{end}.symbol)
                parsed.symbol.name{end+1}=parsed.line{end}.symbol{i};
            end
        end
    fclose(fid);
end

% get rid of duplicates and put into alphabetical order
parsed.symbol.name=union(parsed.symbol.name,[]);
index=strmatch('',parsed.symbol.name,'exact');
parsed.symbol.name = [parsed.symbol.name(1:index-1),parsed.symbol.name(index+1:end)];
