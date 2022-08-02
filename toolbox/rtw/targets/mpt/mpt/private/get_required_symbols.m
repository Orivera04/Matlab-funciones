function  requiredSymbols = get_required_symbols(templateType)
%GET_REQUIRED_SYMBOLS Gets the list of required template symbols

%   REQUIREDSYMBOLS = GET_REQUIRED_SYMBOLS(TEMPLATETYPE)
%         It provides a list of required template symbols for different
%         templates.
%   INPUTS:
%         templateType: the type of template. It can be:
%            'cFunctionTemplate','globalTemplate','globalIncludeTemplate' 
%             and filePrototypeTemplate'.
%   OUTPUT:
%        requiredSymbols: the list of required template symbols in cell array.  

%   Linghui Zhang
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2003/06/14 03:36:37 $

switch(templateType)
    case 'cFunctionTemplate'
        requiredSymbols = {
            'Banner',
            'Includes',
            'IncludeFiles',
            'Defines',
            'IntrinsicTypes',
            'PrimitiveTypedefs',
            'UserTop',
            'Typedefs',
            'Enums',
            'Definitions',
            'ExternData',
            'ExternFcns',
            'FcnPrototypes',
            'Declarations',
            'LocalMacros',
            'LocalDefines',
            'TypeDefinitions',
            'StatemachineConstants',                  
            'StatemachineDeclaration',
            'ExternalCalibrationScalar',
            'ExternalCalibrationLookup1D',
            'ExternalCalibrationLookup2D',
            'ExternalVariableScalar',
            'ExternalVariableFlag',
            'ExternalVariableTimer',
            'GlobalCalibrationScalar',
            'GlobalCalibrationLookup1D',
            'GlobalCalibrationLookup2D',
            'GlobalVariableScalar',
            'GlobalVariableFlag',
            'GlobalVariableTimer',
            'FilescopeCalibrationScalar',
            'FilescopeCalibrationLookup1D',
            'FilescopeCalibrationLookup2D',
            'FilescopeVariableScalar',
            'FilescopeVariableFlag',
            'FilescopeVariableTimer',
            'IncludeLibraryExternalPublicFunctions',
            'IncludePrototypesExternalPublicFunctions',
            'PrivateFunctions',
            'PublicLocalOwnershipFunctions',
            'CFunctionCode',
            'CompilerErrors',
            'CompilerWarnings',
            'Documentation',
            'UserBottom'};
    case 'globalTemplate'
        requiredSymbols = {
            'Banner',
            'Includes',
            'IncludeFiles',
            'Defines',
            'IntrinsicTypes',
            'PrimitiveTypedefs',
            'UserTop',
            'Typedefs',
            'Enums',
            'Definitions',
            'ExternData',
            'ExternFcns',
            'FcnPrototypes',
            'Declarations',
            'LocalMacros',
            'LocalDefines',
            'TypeDefinitions',
            'StatemachineDeclaration',
            'GlobalCalibrationScalar',
            'GlobalCalibrationLookup1D',
            'GlobalCalibrationLookup2D',
            'GlobalVariableScalar',
            'GlobalVariableFlag',
            'GlobalVariableTimer',
            'Functions',
            'CompilerErrors',
            'CompilerWarnings',
            'Documentation',
            'UserBottom' };
    case 'globalIncludeTemplate'
        requiredSymbols = {
            'HeaderPrologue',
            'Banner',
            'Includes',
            'IncludeFiles',
            'Defines',
            'IntrinsicTypes',
            'PrimitiveTypedefs',
            'UserTop',
            'Typedefs',
            'Enums',
            'Definitions',
            'ExternData',
            'ExternFcns',
            'FcnPrototypes',
            'Declarations',
            'LocalMacros',
            'LocalDefines',
            'TypeDefinitions',
            'StatemachineDeclaration',
            'ExternalCalibration_scalar',
            'ExternalCalibrationLookup1D',
            'ExternalCalibrationLookup2D',
            'ExternalVariableScalar',
            'ExternalVariableFlag',
            'ExternalVariableTimer',
            'Functions',
            'CompilerErrors',
            'CompilerWarnings',
            'Documentation',
            'UserBottom',
            'HeaderEpilogue'};
    case 'filePrototypeTemplate'
        requiredSymbols = {
            'HeaderPrologue',
            'Banner',
            'Includes',
            'IncludeFiles',
            'Defines',
            'IntrinsicTypes',
            'PrimitiveTypedefs',
            'UserTop',
            'Typedefs',
            'Enums',
            'Definitions',
            'ExternData',
            'ExternFcns',
            'FcnPrototypes',
            'Declarations',
            'PublicLocalOwnershipFunctions',
            'Functions',
            'CompilerErrors',
            'CompilerWarnings',
            'Documentation',
            'UserBottom',
            'HeaderEpilogue'};
    otherwise
        requiredSymbols = '';
end
return
