function [OK, ssf] = modifyGuidFiltersDlg(ssf, hParent, indexSS)
% EDITPROPERTIESLDG 
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.1.6.3 $  $Date: 2004/04/04 03:32:00 $

% Need to get a sweepset to index the guid filters against
if nargin < 3
    indexSS = sweepset(ssf.pSweepset.info);
end
% Which guids are we dealing with
guidList = getGuids(indexSS);
% Which rows of indexSS have been removed
removedRows = sort(getIndices(guidList, ssf.filterGuid));
% Remove any zeros as not interesting
removedRows(removedRows == 0) = [];

% Create the dialog
dlg = xregdialog(...
    'Name', 'Restore Removed Data',...
    'Resize', 'on',...
    'Visible', 'off');
% Add a close action property
schema.prop(dlg, 'OK', 'bool');
% Default close state
dlg.OK = false;

xregcenterfigure(dlg, [290, 310], hParent);

dlgH = double(dlg);

list = listitemselector('parent',dlgH,...
   'itemlist',removedRows,...
   'selectionstyle','multiple',...
   'unselectedtitle','Removed data:',...
   'selectedtitle','Points to restore:');

btn{1}= uicontrol('parent',dlgH,...
   'string','OK',...
   'callback',{@i_ok,dlg});

btn{2}= uicontrol('parent',dlgH,...
   'string','Cancel',...
   'callback',{@i_cancel,dlg});

btn{3} = mv_helpbutton(dlgH,'xreg_globalRestoreOutliers');

lyt = xreggridbaglayout(dlgH,...
   'dimension',[2 4],...
   'gapy',10,...
   'border',[7 7 7 7],...
   'gapx',7,...
   'rowsizes',[-1 25],...
   'colsizes',[-1 65 65 65],...
   'mergeblock',{[1 1],[1 4]},...
   'elements',{list,[],[],btn{1},[],btn{2},[],btn{3}},...
   'container',dlgH,...
   'packstatus', 'on');

dlg.LayoutManager = lyt;

dlg.showDialog(btn{1});
% Implicit waifor on visible property!
OK = dlg.OK;
if OK
    % Which guids are being restored
    restoreGuids = guidList(list.selecteditems);
    ssf = removeGuidFilter(ssf, restoreGuids);
end
% And delete the dialog
delete(dlg);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_ok(src,evt,dlg)
set(dlg, 'OK', true, 'Visible', 'off');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_cancel(src,evt,dlg)
set(dlg, 'OK', false, 'Visible', 'off');
