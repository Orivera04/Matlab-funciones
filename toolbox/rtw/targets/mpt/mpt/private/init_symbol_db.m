function init_symbol_db
%INIT_SYMBOL_DB is used to initialize the symbol database.
%
%   INIT_SYMBOL_DB()
%   This function initializes the symbol data base with all the default
%   symbols avaialable.
%
%   INPUTS:
%             none
%
%   OUTPUTS:
%             none
%


%   Steve Toeppe
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.13.4.8 $  $Date: 2004/04/15 00:28:16 $

% Base Parent Symbols
%<Includes>
%<Defines>
%<Types>
%<Enums>
%<Definitions>
%<Declarations>
%<Functions>

establish_symbol_db;

symbol=[];
symbol.symbolName = 'TypeDefinitions';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Types';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'ExternalCalibrationLookup1D';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Declarations';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'ExternalCalibrationLookup2D';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Declarations';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'ExternalCalibrationScalar';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Declarations';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'ExternalVariableScalar';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Declarations';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'FilescopeCalibrationLookup1D';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Definitions';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'FilescopeCalibrationLookup2D';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Definitions';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'FilescopeCalibrationScalar';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Definitions';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'FilescopeVariableScalar';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Definitions';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'GlobalCalibrationLookup1D';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Definitions';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'GlobalCalibrationLookup2D';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Definitions';
set_symbol_db_element(symbol);


symbol=[];
symbol.symbolName = 'GlobalCalibrationScalar';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Definitions';
set_symbol_db_element(symbol);


symbol=[];
symbol.symbolName = 'GlobalVariableScalar';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Definitions';
set_symbol_db_element(symbol);


symbol=[];
symbol.symbolName = 'LocalDefines';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Defines';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'LocalMacros';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Defines';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'ExportAccessMethods';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Defines';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'ToolVersion';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'Abstract';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'Created';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'Creator';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);


symbol=[];
symbol.symbolName = 'Date';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'Description';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'FileName';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'History';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'LastModificationDate';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'LastModifiedBy';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'ModelName';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'ModelVersion';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'ModifiedBy';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'ModifiedComment';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'ModifiedDate';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'ModifiedHistory';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

symbol=[];
symbol.symbolName = 'Notes';
symbol.symbolExpand= [];
symbol.dataPlacementFunction = [];
symbol.dataPlacementFile =  [];
symbol.duplicateFlag = 'No';
symbol.parent = 'Documentation';
set_symbol_db_element(symbol);

%%% Hook for custom initialized the symbol 
if exist('custom_init_symbol_db','file') == 2
   custom_init_symbol_db;         
end

% Abstract
% Created
% Creator
% Date
% Description
% FileName
% History
% LastModificationDate
% LastModifiedBy
% ModelName
% ModelVersion
% ModifiedBy
% ModifiedComment
% ModifiedDate
% ModifiedHistory
% Notes
% ToolVersion

