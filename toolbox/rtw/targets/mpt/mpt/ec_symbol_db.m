function ec_symbol_db()
%EC_SYMBOL_DB

%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $
%   $Date: 2004/04/15 00:26:50 $

%package{}.name
%package{}.class{}.name
%package{}.class{}.memorySection{}.name
%package{}.class{}.memorySection{}.globalDefSym
%package{}.class{}.memorySection{}.globalDecSym
%package{}.class{}.memorySection{}.fileScopeSym

% ec_symbol_db_set(packageName,className,memorySectionName,...
%     globalDefSym,globalDecSym,fileScopeSym)
% ec_symbol_db_set('mpt','Global','Default',...
%     'FilescopeCalibrationScalar','FilescopeVariableScalar','GlobalCalibrationScalar',1);