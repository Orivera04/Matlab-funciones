function establish_symbol_db
%ESTABLISH_SYMBOL_DB will create an empty symbol DB.
%
%   ESTABLISH_SYMBOL_DB
%   This function established the global variable symbolTemplateDB as the
%   root of the symbol template data base.  This data base is used for template 
%   symbols for the code genration process.
%
%   INPUTS: 
%            none
%
%   OUTPUTS: 
%            none
%

%   Steve Toeppe
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.9.4.2 $  $Date: 2004/04/15 00:28:02 $


symbolTemplateDB = [];
rtwprivate('rtwattic', 'AtticData', 'symbolTemplateDB',symbolTemplateDB);
