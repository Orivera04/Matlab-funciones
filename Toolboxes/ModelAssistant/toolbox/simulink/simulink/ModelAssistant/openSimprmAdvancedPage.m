function openSimprmAdvancedPage

%   Copyright 2002 The MathWorks, Inc.
%   $Revision: 1.1 $ $Date: 2002/11/27 17:40:16 $

model = get_param(bdroot(HTMLattic('AtticData', 'model')), 'handle');
openSimprmDlg(model, 'Advanced');


function openSimprmDlg(model, page)
% this function will open simprm dialog GUI of the model, at the specified
% TAB page.

hModel = get_param(model, 'handle');
SimParamHandle = get_param(hModel, 'SimParamHandle');
if SimParamHandle == -1 % create new one if not created yet
    SimParamHandle = simprm('create', get_param(hModel, 'handle'));
end

switch page
    case 'Solver'
        pageidx = 1;
    case 'Workspace I/O'
        pageidx = 2;
    case 'Diagnostics'
        pageidx = 3;
    case 'Advanced'
        pageidx = 4;
    case 'Real-Time Workshop'
        pageidx = 5;
    otherwise
        errordlg('Incorrect page specified');
end

% switch tab to the specified page
tabdlg('tabpress' ,   [SimParamHandle],    page ,   [pageidx]);
% show page
simprm('show', SimParamHandle);