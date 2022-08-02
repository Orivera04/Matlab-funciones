function status = init_mpt_feature
%INIT_MPT_FEATURE

%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.3 $  
%   $Date: 2003/06/14 03:36:11 $
set_mpt_feature('nameRules',1);
set_mpt_feature('externalComments',1);
set_mpt_feature('globalComments',1);
set_mpt_feature('readWriteRule',1);
set_mpt_feature('dataObjectWizard',1);
set_mpt_feature('dataObjectWizardSourceDest',1);
set_mpt_feature('dataObjectWizardAutoParam',1);
set_mpt_feature('signalSourceAnalysis',1);
set_mpt_feature('preSetOptions',0);
set_mpt_feature('guiTechnology','hg');
set_mpt_feature('errorCheck',1);
