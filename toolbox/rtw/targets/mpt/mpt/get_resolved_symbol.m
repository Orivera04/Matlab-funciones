function expandedString = get_resolved_symbol(symbol)
%GET_RESOLVED_SYMBOL gets a resolved code generation symbol.
%
%   EXPANDEDSTRING = GET_RESOLVED_SYMBOL(SYMBOL) gets a resolved code
%   generateion symbol. If the symbol is not found, it blank space is returned.
%
%   INPUT:  
%         symbol:  Symbol name
%   OUTPUT:
%         expandedString:  The expansion of the symbol.

%   Steve Toeppe
%   Copyright 2001-2002 The MathWorks, Inc.
%   $Revision: 1.9.4.1 $  $Date: 2004/04/15 00:27:08 $

global symbolData;

[expandedString, status] = symbol_resolver(symbol ,symbolData.parsedCode);
if isempty(expandedString) == 1
    expandedString = ' ';
end
