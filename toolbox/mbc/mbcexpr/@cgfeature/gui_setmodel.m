function [feat, ok] = gui_setmodel(feat, pPROJ)
%GUI_SETMODEL Dialog for selecting a new model
%
%  [FEAT, OK] = GUI_SETMODEL(FEAT, pPROJ) pops up a small dialog that lists
%  all of the models in the project pointed to by pPROJ and lets the user
%  select a new one to use as part of the feature.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.3 $    $Date: 2004/04/04 03:27:28 $ 

ok = false;
if isempty(pPROJ.getmodels)
    h = errordlg(['You have no models in the project to choose for this feature.', ...
        '  You must import or create a model first'], 'No Models Found', 'modal');
    waitfor(h);
    return
end

fH = xregdialog('name', 'Select Model', ...
    'resize', 'off');
xregcenterfigure(fH, [250 300]);
    
t = uicontrol('parent', fH, ...
    'style', 'text', ...
    'enable', 'inactive', ...
    'string', 'Select a model for the feature:', ...
    'horizontalalignment', 'left');

mdlList = cgtools.projectList('parent', fH, ...
    'DisplayTypeColumn', false, ...
    'DisplayHeaderRow', false, ...
    'FilterTypeObject', cgtypes.cgmodeltype, ...
    'Project', pPROJ);
dblClickList = handle.listener(mdlList, 'Open', {@i_invokeOK, fH});

% Find the current model and select it
pMdlExpr = get(feat, 'model');
pItems = mdlList.Items;
for n = 1:length(pItems)
    if pItems(n).getdata==pMdlExpr
        mdlList.SelectedItems = pItems(n);
        break
    end
end

% OK and cancel buttons
btOK = uicontrol('parent', fH, ...
    'style', 'pushbutton', ...
    'string', 'OK', ...
    'callback', 'set(gcbf, ''tag'', ''ok'', ''visible'', ''off'');');
btCanc = uicontrol('parent', fH, ...
    'style', 'pushbutton', ...
    'string', 'Cancel', ...
    'callback', 'set(gcbf, ''tag'', ''cancel'', ''visible'', ''off'');');
btHelp = cghelpbutton(fH, 'CGFEATURESELECTMODEL');

lyt = xreggridbaglayout(fH, ...
    'packstatus', 'off', ...
    'dimension', [4 4], ...
    'rowsizes', [15 -1 3 25], ...
    'colsizes', [-1 65 65 65], ...
    'gapx', 7, ...
    'gapy', 2, ...
    'border', [7 7 7 10], ...
    'mergeblock', {[1 1], [1 4]}, ...
    'mergeblock', {[2 2], [1 4]}, ...
    'elements', {t, mdlList, [], [], ....
        [], [], [], btOK, ...
        [], [], [], btCanc, ...
        [], [], [], btHelp});

fH.LayoutManager = lyt;
set(lyt, 'packstatus', 'on');
    
validSel = false;

while ~validSel
    set(fH, 'tag', 'Feature_ModelSelection');
    fH.showDialog(btOK);
    
    % GUI goes modal and execution blocks here
    
    tg = get(fH, 'tag');
    if strcmp(tg, 'ok')
        % Get selection and check the model type is OK
        pNewMdlNode = mdlList.SelectedItems;
        if isempty(pNewMdlNode)
            validSel = true;
        else
            pNewMdlExpr = pNewMdlNode.getdata;
            if ~pNewMdlExpr.isSwitchExpr
                feat = set(feat, 'model', pNewMdlExpr);
                validSel = true;
                ok = true;
            else
                % Notify user that the selection isn't allowed
                h = errordlg(['This model consists of a limited set of discrete', ...
                    ' evaluation points and cannot be used in feature work'], ...
                    'Invalid Model Type', 'modal');
                waitfor(h)
            end
        end
    else
        % Cancel has been pressed
         validSel = true;
    end
end

delete(fH);


function i_invokeOK(src, evt, fH)
set(fH, 'tag', 'ok', 'visible', 'off');