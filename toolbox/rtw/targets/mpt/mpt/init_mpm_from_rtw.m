function status = init_mpm_from_rtw(modelName,templateList)
%INIT_MPM_FROM_RTW is used to initialize MPM from RTW.
%
%   STATUS = INIT_MPM_FROM_RTW(MODELNAME) initializes MPM from RTW. 
%
%   INPUT:
%         modelName: Name of model (without ".mdl")
%   OUTPUT:
%         status:  Status of operation

%   Steve Toeppe
%   Copyright 2001-2004 The MathWorks, Inc.
%   $Revision: 1.11.4.11 $  $Date: 2004/04/15 00:27:13 $

ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');


status = [];
ecac.formatFlag = 0;
ecac.filterFileName=' ';
ecac.filterSymbol=' ';
ecac.filterType = ' ';
ecac.templateList = templateList;
mpmResult = [];
mpmResult.modelName=modelName;
rtwprivate('rtwattic', 'AtticData', 'mpmResult',mpmResult);
 

customComment.customCommentEnable = mpt_config_get(modelName,'EnableCustomComments');
customComment.customCommentScript = mpt_config_get(modelName,'CustomCommentsFcn');
initFlag = 0;

if isempty(customComment.customCommentScript) == 0
    if exist(customComment.customCommentScript) ~= 2
        customComment.customCommentEnable = 0;
    end
else
    customComment.customCommentEnable = 0;
end
ecac.customComment = customComment;

rtwprivate('rtwattic', 'AtticData', 'ecac',ecac);
mpt_basic_analysis_init(modelName,initFlag);
ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');
ecac.ZeroExternalMemoryAtStartup = get_rtw_option(modelName,'ZeroExternalMemoryAtStartup');
rtwprivate('rtwattic', 'AtticData', 'ecac',ecac);
% mpt_init_registration;

%Process all data and events prior to generate of code.
% This is a major processing segment for data scope and data dictionary information.
% % process_objects2(modelName);


