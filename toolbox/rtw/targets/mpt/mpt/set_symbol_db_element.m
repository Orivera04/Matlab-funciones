function status = set_symbol_db_element(symbol)
%SET_SYMBOL_DB_ELEMENT will save details about a symbol.
%
%   STATUS = SET_SYMBOL_DB_ELEMENT(SYMBOL)
%         will register details about a symbol. If the symbol already exists,
%         it will be replaced. If it is new, it is added to the db list.
%
%   INPUT:
%         symbol:   Symbol to register. (structure of predefined format)
%
%   OUTPUT:
%         status:   Status of operation, 0 means pass, -1 means fail.
%                   Failures can occur if the symbol passed in is not valid

%   Steve Toeppe
%   Copyright 2000-2004 The MathWorks, Inc.
%   $Revision: 1.8.2.2 $
%   $Date: 2004/04/15 00:29:07 $


symbolTemplateDB = rtwprivate('rtwattic', 'AtticData', 'symbolTemplateDB');
status = 0;
try
    symName = symbol.symbolName;

    info = [];

    % Check all symbols for a match.
    %   If found, then replace.
    % Otherwise, insert into end of list.

    for i=1:length(symbolTemplateDB)
        m=strcmp(symbolTemplateDB{i}.symbolName,symName);
        if m == 1
            % Symbol found, replace in list.
            symbolTemplateDB{i}=symbol;
            return;
        end
    end
    % Insert symbol into end of list.
    symbolTemplateDB{end+1}=symbol;
catch
    status = -1;
end
rtwprivate('rtwattic', 'AtticData', 'symbolTemplateDB',symbolTemplateDB);
