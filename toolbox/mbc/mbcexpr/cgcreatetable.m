function [pTbl, OK] = cgcreatetable(dims, pDD)
%CGCREATETABLE GUI for creating lookup tables
%
%  [PTBL, OK] = CGCREATETABLE(DIMS, PDD) opens a dialog for creating a new
%  lookup table with DIMS dimensions.  PDD is an optional pointer to the
%  variable dictionary node.  If the user clicks "Cancel", pTbl will be
%  null and OK will be false, otherwise pTbl will point to a table object
%  that has been set up with normalisers and input variables.
%
%  Note that the 1D table option creates a cglookupone, not a normfunction.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.1 $    $Date: 2004/04/04 03:27:50 $

if nargin<2
    pDD = [];
end

% Calculate size that depends on number of dimensions being edited.  We
% assume that at higheer dimensions the editing panel will include a
% scalable scrolling list of values to edit, so max-out dims at 4.
h = 100 + min(dims, 4)*27;

figh = xregdialog('name','Table Setup',...
    'resize','off',...
    'tag','tableinputs');
xregcenterfigure(figh,[320 h]);

hEditPane = cgtools.tablecreator('parent', figh, ...
    'Dimensions', dims, ...
    'VariableDictionary', pDD);

okbtn = uicontrol('parent',figh,...
    'style','pushbutton',...
    'string','OK',...
    'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');',...
    'interruptible','off');
cancbtn = uicontrol('parent',figh,...
    'style','pushbutton',...
    'string','Cancel',...
    'callback','set(gcbf,''visible'',''off'');',...
    'interruptible','off');

if dims==1
    helptag = 'CGCREATE1DTABLE';
elseif dims==2
    helptag = 'CGCREATE2DTABLE';
else
    tag = 0;
end
helpbtn = cghelpbutton(figh, helptag);

grd = xreggridbaglayout(figh,...
    'dimension',[2 4],...
    'rowsizes',[-1 25],...
    'colsizes',[-1 65 65 65],...
    'gapy',10,'gapx',7,...
    'border',[7 7 7 7],...
    'mergeblock',{[1 1],[1 4]},...
    'elements',{hEditPane,[],[],okbtn,[],cancbtn,[],helpbtn});
figh.LayoutManager = grd;
set(grd,'packstatus','on');

% Dialog blocks here
figh.showDialog(okbtn);

tg = get(figh,'tag');
if strcmp(tg,'ok')
    pTbl = hEditPane.createTable;
    OK = true;
else
    pTbl = xregpointer;
    OK = false;
end
delete(figh);
