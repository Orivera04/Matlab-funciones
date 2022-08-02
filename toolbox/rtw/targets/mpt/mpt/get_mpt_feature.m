function value = get_mpt_feature(name)
%GET_MPT_FEATURE

%   Steve Toeppe
%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.6.4 $  
%   $Date: 2004/04/15 00:27:05 $

ecac = rtwprivate('rtwattic', 'AtticData', 'ecac');
value = 0;
try
    switch(name)
        case {'externalComments','globalComments','readWriteRule','dataObjectWizard',...
                    'dataObjectWizardSourceDest','dataObjectWizardAutoParam',...
                    'signalSourceAnalysis','nameRules','preSetOptions','guiTechnology','errorCheck'}
            value = getfield(ecac.features,name);
        otherwise
            value = 0;
    end
catch
    value = 0;
end