function buffer = ec_global_doc_buffer(modelName)

% Copyright 1994-2004 The MathWorks, Inc.
%
% $Revision: 1.1.6.3 $


ecMPTGlobalBuffer=[];
rtwprivate('rtwattic', 'AtticData', 'ecMPTGlobalBuffer',ecMPTGlobalBuffer);

toolVersion = ec_mp_tool_version;
ec_reg_global_buffer('ToolVersion', toolVersion);
ec_reg_global_buffer('Date', date);
ec_reg_global_buffer('Created', get_param(modelName,'Created'));
ec_reg_global_buffer('Creator', get_param(modelName,'Creator'));
ec_reg_global_buffer('ModifiedBy', get_param(modelName,'ModifiedBy'));
ec_reg_global_buffer('ModifiedDate', get_param(modelName,'ModifiedDate'));
ec_reg_global_buffer('ModifiedComment', get_param(modelName,'ModifiedComment'));
ec_reg_global_buffer('ModelVersion', get_param(modelName,'ModelVersion'));
ec_reg_global_buffer('Description', get_param(modelName,'Description'));
ec_reg_global_buffer('LastModifiedBy', get_param(modelName,'LastModifiedBy'));
ec_reg_global_buffer('LastModificationDate', get_param(modelName,'LastModifiedDate'));
ec_reg_global_buffer('ModifiedHistory', get_param(modelName,'ModifiedHistory'));


% Register notes, annotations, abstract, history, docBlock and other symbols
[abstract, history, notes, otherSym, otherTxt] = ec_mp_global_comments(modelName);
if isempty(abstract) == 0
ec_reg_global_buffer('Abstract', abstract);
end
if isempty(history) == 0
ec_reg_global_buffer('History', history);
end
if isempty(notes) == 0
ec_reg_global_buffer('Notes', notes);
end
for i = 1:length(otherSym)
	ec_reg_global_buffer(otherSym{i}, otherTxt{i});
end
buffer = rtwprivate('rtwattic', 'AtticData', 'ecMPTGlobalBuffer');
function ec_reg_global_buffer(bufferName, bufferContent)

ecMPTGlobalBuffer  = rtwprivate('rtwattic', 'AtticData', 'ecMPTGlobalBuffer');
info=[];
info.bufferName = bufferName;
info.bufferContent = bufferContent;
ecMPTGlobalBuffer{end+1}=info;
rtwprivate('rtwattic', 'AtticData', 'ecMPTGlobalBuffer',ecMPTGlobalBuffer);
