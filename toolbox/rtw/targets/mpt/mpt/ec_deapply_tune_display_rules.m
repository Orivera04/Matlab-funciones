function ec_deapply_tune_display_rules(modelName )
%EC_DEAPPLY_TUNE_DISPLAY_RULES resets storage class on objects previously
%turned to Auto


%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $
%   $Date: 2004/04/15 00:26:42 $

%The ecMasterDisplayTuneRuleList contains a list of data object names that were
%previoulsy turned to Auto at an earlier stage of the code generation cycle.
ecMasterDisplayTuneRuleList = rtwprivate('rtwattic', 'AtticData', 'ecMasterDisplayTuneRuleList');

%for each item that had storage class set to Auto 
%  reset storage class
%  handle both Simulink and mpt objects
%end
for i=1:length(ecMasterDisplayTuneRuleList)
    try
     set_data_info(ecMasterDisplayTuneRuleList{i},'BASESTORAGECLASS','Custom');
    catch
    end
end

