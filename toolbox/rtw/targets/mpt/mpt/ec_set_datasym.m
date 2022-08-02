function ec_set_datasym(info)
%EC_SET_DATASYM 

%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  $Date: 2004/04/15 00:26:49 $

% info.packageName=packageName;
% info.className=className;
% info.memorySectionName=memorySectionName;
% info.globalDefSym=globalDefSym;
% info.globalDecSym=globalDecSym;
% info.fileScopeSym=fileScopeSym;

mpt_symbol_mapping = rtwprivate('rtwattic', 'AtticData', 'mpt_symbol_mapping');
matches = strcmp(mpt_symbol_mapping.packageList,info.packageName);
pIndex = find(matches,1);
if isempty(pIndex) == 0
    matches = strcmp(mpt_symbol_mapping.package{pIndex}.class{info.classIndex}.CSCNames,info.className);
    cscIndex = find(matches,1);
    if isempty(cscIndex) == 0
        matches = strcmp(mpt_symbol_mapping.package{pIndex}.memorySectionList,info.memorySectionName);
        memSIndex = find(matches,1);
        if isempty(memSIndex) == 0
            minfo=[];
            minfo.globalDefSym=info.globalDefSym;
            index = strcmp(mpt_symbol_mapping.symbolList,minfo.globalDefSym);
            minfo.globalDefSymIndex = find(index,1);

            minfo.globalDecSym=info.globalDecSym;
            index = strcmp(mpt_symbol_mapping.symbolList,minfo.globalDecSym);
            minfo.globalDecSymIndex = find(index,1);

            minfo.fileScopeSym=info.fileScopeSym;
            index = strcmp(mpt_symbol_mapping.symbolList,minfo.fileScopeSym);
            minfo.fileScopeSymIndex = find(index,1);

            mpt_symbol_mapping.package{pIndex}.class{info.classIndex}.csc{cscIndex}.memorySection{memSIndex}=minfo;
            return;
        end
    end
end
rtwprivate('rtwattic', 'AtticData', 'mpt_symbol_mapping',mpt_symbol_mapping);

