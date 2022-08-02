function ec_symbol_db_set(packageName,className,memorySectionName,...
    globalDefSym,globalDecSym,fileScopeSym,classIndex)
%EC_SYMBOL_DB_SET

%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/15 00:26:52 $

%Save entries for sorting once completed.


mpt_symbol_mapping_list = rtwprivate('rtwattic', 'AtticData', 'mpt_symbol_mapping_list');

if isempty(mpt_symbol_mapping_list) == 1
    index = 1;
else
    index = length(mpt_symbol_mapping_list)+1;
end

info.packageName=packageName;
info.className=className;
info.memorySectionName=memorySectionName;
info.globalDefSym=globalDefSym;
info.globalDecSym=globalDecSym;
info.fileScopeSym = fileScopeSym;
info.classIndex = classIndex;
mpt_symbol_mapping_list{index}=info;
rtwprivate('rtwattic', 'AtticData', 'mpt_symbol_mapping_list',mpt_symbol_mapping_list);

%package{}.name
%package{}.class{}.name
%package{}.class{}.memorySection{}.name
%package{}.class{}.memorySection{}.globalDefSym
%package{}.class{}.memorySection{}.globalDecSym
%package{}.class{}.memorySection{}.fileScopeSym

