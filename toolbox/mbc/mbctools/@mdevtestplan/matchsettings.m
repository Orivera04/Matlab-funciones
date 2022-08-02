function varargout=matchsettings(T,action,varargin)
%MATCHSETTINGS
% 
%  This function creates a dialogue that allows a user to change the 
%  tolerances used to match the data to the design points.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $  $Date: 2004/02/09 08:08:00 $

switch lower(action)
    case 'layout'
        varargout{1}=i_createLyt(varargin{:});
    case 'update'
        [varargout{1:2}]= i_apply(T);       
end

% ------------------------------------------------------------
% function i_createLyt
% ------------------------------------------------------------
function [lyt,ud] = i_createLyt(fH,p)

if isa(fH,'xregcontainer')
    lyt = fH;
    fH = allchild(0);
    udh = findobj(fH(1),'tag','TolUserData');
    
    ud = get(udh,'userdata');
    i_setValues(info(p),ud);
    
    return
end

% otherwise we need to create the uicontrols for this panel.
ud.pointer = p;
bgc= get(0, 'defaultuicontrolbackgroundcolor');

% make a table to show the tolerances
tableTitle = uicontrol('parent',fH,...
    'style','text',...
    'string','Input Factor Tolerances',...
    'FontWeight','bold',...
    'tag','TolUserData',...
    'horizontalalignment','left');
udh= tableTitle;

% build the Table
factor_names= factorNames(p.model);
NumRows = length(factor_names)+1;

ud.Tbl= xregtable(fH,...
    'visible','off',...
    'Frame.visible','off',...
    'Rows.number', NumRows,...
    'rows.spacing', 3,...
    'cols.number', 2,...
    'cols.spacing', 3,...
    'cols.size', 120);
set(ud.Tbl,...
    'cells.colselection',[1 1],...
    'cells.rowselection',[1 NumRows],...
    'cells.type','uitext',...
    'cells.colselection',[1 1],...
    'cells.rowselection',[2 NumRows],...
    'cells.string',factor_names,...
    'cells.horizontalalignment','right',...
    'cells.rowselection',[1 1],...
    'cells.colselection',[2 2],...
    'cells.type','uitext',...
    'cells.string',{'Mean Tol.'},...
    'cells.rowselection',[2 NumRows],...
    'cells.colselection',[2 2],...
    'cells.Foregroundcolor',[0 0 0],...
    'cells.Backgroundcolor',[1 1 1]);

% stick the summary text and table into a grid
tableLyt = xreggridlayout(fH,...
    'dimension', [2 1],...
    'elements', {tableTitle,ud.Tbl},...
    'correctalg', 'on',...
    'gapy', 3,...
    'rowsizes', [17 -1]);

% make some controls to choose what to do with your clusters when they
% appear
choiceTitle = xreguicontrol('parent',fH,...
    'style','text',...
    'string','Default Data Selection',...
    'FontWeight','bold',...
    'horizontalalignment','left');

unmatchedTxt = xreguicontrol(fH,...
    'style', 'text',...
    'backgroundcolor', bgc,...
    'horizontalAlignment', 'left',...
    'string', 'Unmatched data:');
unmatchedChoice = xreguicontrol(fH,...
    'backgroundcolor', 'w',...
    'style', 'popup',...
    'string', {'Use', 'Do not use'});

moreDataTxt = xreguicontrol(fH,...
    'horizontalAlignment', 'left',...
    'backgroundcolor', bgc,...
    'style', 'text',...
    'string', 'Clusters with more data:');
moreDataChoice = xreguicontrol(fH,...
    'style', 'popup',...
    'backgroundcolor', 'w',...
    'string', {'Use all data', 'Use closest match only'});

moreDesignTxt = xreguicontrol(fH,...
    'horizontalAlignment', 'left',...
    'backgroundcolor', bgc,...
    'style', 'text',...
    'string', 'Clusters with more design:');
moreDesignChoice = xreguicontrol(fH,...
    'backgroundcolor', 'w',...
    'style', 'popup',...
    'string', {'Do not replace design points', 'Replace design with closest'});

infoTxt = xreguicontrol('parent',fH,...
    'style', 'text',...
    'string', '',...
    'horizontalalignment', 'left');
choiceInfo = xregframetitlelayout(fH,...
    'title', 'Data Selection Information',...
    'center', infoTxt);

% get text to appear on callbacks
set(unmatchedChoice, 'callback', {@i_changeInfo, infoTxt, 1});
set(moreDataChoice, 'callback', {@i_changeInfo, infoTxt, 2});
set(moreDesignChoice, 'callback', {@i_changeInfo, infoTxt, 3});

choicesLyt = xreggridlayout(fH,...
    'dimension', [5 2],...
    'correctalg', 'on',...
    'gapy', 3,...
    'elements', {unmatchedTxt, [], moreDataTxt, [], moreDesignTxt,...
        unmatchedChoice, [], moreDataChoice, [], moreDesignChoice},...
    'correctalg', 'on',...
    'rowsizes', [17 3 17 3 17],...
    'colsizes', [130, -1]);

choicesLyt = xreggridlayout(fH,...
    'dimension', [3 1],...
    'correctalg', 'on',...
    'elements', {choiceTitle, choicesLyt, choiceInfo},...
    'gapy',5,...
    'correctalg', 'on',...
    'rowsizes', [17 80 -1]);


% hook all of this up into the main layout
lyt = xreggridlayout(fH,...
    'border',[10 10 10 10],...
    'correctalg', 'on',...
    'dimension', [1 2],...
    'gapx',10,...
    'elements', {choicesLyt, tableLyt},...
    'correctalg', 'on');

% %% %%%%% for testing TO DELETE %%%%%%%
%set(lyt,'container',fH, 'visible','on');

% save handles to choice controls
ud.unmatchedChoice = unmatchedChoice;
ud.moreDataChoice = moreDataChoice;
ud.moreDesignChoice = moreDesignChoice;


i_setValues(info(p),ud);
set(udh,'userdata',ud)

% ------------------------------------------------------------
% function i_changeInfo
% ------------------------------------------------------------
function i_changeInfo(src, evt, txtH, val)

switch val
    case 1 %unmatched
        str = {'Unmatched data:',...
            ['Choose whether or not to use data that is ',...
            'not within tolerance of any design points']};
    case 2 %more data
        str = {'Clusters with more data than design points:',...
            ['Choose to use all data in the cluster or create a one-to-one ',...
            'match of those data points closest to the design points and ',...
            'use only these data.']};
    case 3 %more design
        str = {'Clusters with more design than data points:',...
            ['All data in these clusters will be used.                 ',...
            'Choose to write these data points into the actual ',...
            'design, replacing those design points closest to the ',...
            'data. Or choose to not write any points into the design.']};
end

set(txtH,'string',char(str));


% ------------------------------------------------------------
% function i_setValues
% ------------------------------------------------------------
function i_setValues(T,ud)

% get the tolerances from the TSSF
tssf = T.DataLink.info;

tol = get(tssf, 'tolerances');
ud.Tbl(2:end, 2) = tol(:);



% ------------------------------------------------------------
% function i_apply(fH)
% ------------------------------------------------------------
function [T,OK]=i_apply(T)

OK=1;

fH= allchild(0);
udh= findobj(fH(1),'tag','TolUserData');
ud= get(udh,'userdata');

newMnTol= ud.Tbl(2:end,2);

% now apply user choices to the TSSF clusters
tssf = T.DataLink.info;

% 
% user choices
% unmatchedVal  1=all  2=none
% moreDataVal   1=all 2=closest
% moreDesignVal 1=none 2=closest
unmatchedVal = {'all', 'none'};
unmatchedVal = unmatchedVal{get(ud.unmatchedChoice,'value')};
moreDataVal = {'all', 'closest'};
moreDataVal = moreDataVal{get(ud.moreDataChoice, 'value')};
moreDesignVal = {'none', 'closest'};
moreDesignVal = moreDesignVal{get(ud.moreDesignChoice, 'value')};

tssf = set(tssf,...
    {'defaultSelectionUnmatchedData',...
        'defaultSelectionMoreData',...
        'defaultSelectionMoreDesign',...
        'defaultSelectionApply'},...
    {unmatchedVal,...
        moreDataVal,...
        moreDesignVal,...
        true}); 

% set user specified tolerances. This also runs the cluster alg on the tssf
% and applies all the user-specified default settings
tssf = setTolerance(tssf, newMnTol);

% get all of these changes back to the testplan 
T.DataLink.info = tssf;

% update T on the heap
xregpointer(T);

% open the data editor

return