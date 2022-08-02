function custom_reg_param(varargin)
%CUSTOM_REG_PARAM Register custom parameters

%   Steve Toeppe
%   Copyright 1984-2002 The MathWorks, Inc.
%   $Revision: 1.5 $
%   $Date: 2002/04/14 17:50:55 $

symbol.symbolName = 'table2d';
symbol.symbolExpand='symbol_expansion';
symbol.duplicateFlag = 'No';
symbol.operation = 'define';
symbol.scope = 'global';
symbol.restrictions = 'none';
symbol.scopeDupRes = 'symbolName';
symbol.scopeDupResSymbol = '';
symbol.scopeDupResMessage = '';
symbol.description = '';
set_symbol_db_element(symbol);
return;
