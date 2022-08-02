function status = set_mpt_feature(name,state)
%SET_MPT_FEATURE

%   Steve Toeppe
%   Copyright 2003 The MathWorks, Inc.
%   $Revision: 1.1.6.2 $  
%   $Date: 2003/05/17 04:49:04 $

global ecac;
status = 0;

try
    switch(name)
        case 'nameRules'
            ecac.features.nameRules = state;
        case 'externalComments'
            ecac.features.externalComments = state;
        case 'globalComments'
            ecac.features.globalComments = state;
        case 'readWriteRule'
            ecac.features.readWriteRule = state;
        case 'dataObjectWizard'
            ecac.features.dataObjectWizard = state;
        case 'dataObjectWizardSourceDest'
            ecac.features.dataObjectWizardSourceDest = state;
        case 'dataObjectWizardAutoParam'
            ecac.features.dataObjectWizardAutoParam = state;
        case 'signalSourceAnalysis'
            ecac.features.signalSourceAnalysis = state;
        case 'preSetOptions'
            ecac.features.preSetOptions = state;
        case 'guiTechnology'
            ecac.features.guiTechnology = state;
        case 'errorCheck'
            ecac.features.errorCheck = state;
        otherwise
            status = -1;
    end
catch
    status = -1;
end