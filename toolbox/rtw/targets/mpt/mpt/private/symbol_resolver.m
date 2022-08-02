function [expandedString, status] = symbol_resolver(symbol ,symbolData)
%SYMBOL_RESOLVER Permits the resolution of a specified symbol.
%
%  [EXPANDEDSTRING, STATUS] = SYMBOL_RESOLCER(SYMBOL, SYMBOLDATA)
%        It will resolve a specific symbol type with associated symbol data. 
%        The  symbol  is  expanded  into  a  string  that  is  returned  via
%        expandedString. That status is also reported.
%
%  INPUTS:
%        symbol:          symbol name
%        symbolData:  object info associated with symbol
%
%  OUTPUTS:
%        expandedString:  resolved string based upon symbol data
%        status:                 operation status.  0...pass; -1...fail

%  Steve Toeppe
%  Copyright 2001-2002 The MathWorks, Inc.
%  $Revision: 1.8.4.1 $ 
%  $Date: 2004/04/15 00:28:58 $

%
% The symbol can be resolved per a specified symbol resolver script. Most
% symbols are resolved using "symbol_expansion" script. However, other 
% resolver scripts can be registered for a given symbol name.
%

%
% Get symbol data base information
%  if found
%   then excute expansion script specified in symbol database
%  else
%   report error
%
symbolInfo = get_symbol_db_element(symbol);
if isempty(symbolInfo) == 0
    symStr = symbolInfo.symbolExpand;
    symStr=[symStr,'(','''',symbol,'''',',symbolData)'];
    expandedString = eval(symStr);
    status = 0;  %pass
else
    expandedString = '';
    status = -1; %fail
end

