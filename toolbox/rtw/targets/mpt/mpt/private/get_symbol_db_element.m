function info = get_symbol_db_element(symName)
%GET_SYMBOL_DB_ELEMENT returns previously registered details about a symbol
%
%   [INFO]=GET_SYMBOL_DB_ELEMENT(SYMNAME)
%   This function will return all the details about symName symbol.
%
%   INPUTS:
%           symName:   Name of symbol
%   
%   OUTPUTS:
%           info:      Registered details about the symbol.

%   Steve Toeppe
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.11.4.2 $
%   $Date: 2004/04/15 00:28:11 $


symbolTemplateDB = rtwprivate('rtwattic', 'AtticData', 'symbolTemplateDB');
info = [];

% Check all symbols for a mach.
%   Return the information for the matching symbol.
for i=1:length(symbolTemplateDB)
    m=strcmp(symbolTemplateDB{i}.symbolName,symName);
    if m == 1
        info = symbolTemplateDB{i};
    end
end
