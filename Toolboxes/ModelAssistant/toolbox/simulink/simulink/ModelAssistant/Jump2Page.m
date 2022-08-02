function Jump2Page(PageName)

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:15 $

model=HTMLattic('AtticData', 'model');
switch PageName
    case 'model_advisor'
        ModelAdvisor(model);
    case 'model_detail'
        ModelAdvisor(model, 'silent');
        browser(HTMLattic('AtticData', 'DetailConfigurePage'));
    case 'model_diagnose'
        ModelAdvisor(model, 'silent');
        browser(HTMLattic('AtticData', 'DiagnoseStartPage'));
    otherwise
        ModelAdvisor(model);
end