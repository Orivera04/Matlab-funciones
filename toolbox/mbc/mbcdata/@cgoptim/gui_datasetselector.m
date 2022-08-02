function [obj, ok] = gui_datasetselector(obj, indx, pPROJ)
%GUI_DATASETSELECTOR  Gui to select dataset for optim
%
%  [OBJ, OK] = GUI_DATASETSELECTOR(OBJ, IDX,  P_PROJECT) where OBJ is a
%  cgoptim object, IDX is the index of the data item that is being edited
%  and P_PROJECT is a pointer to a cgproject to selct datasets from.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.4 $    $Date: 2004/04/04 03:26:11 $


[obj, ok] = i_Create(obj, indx, pPROJ);


%-------------------------------------------------------------------
function [newobj, ok] = i_Create(optimobj, indx, pPROJ)
%-------------------------------------------------------------------

% Import dialog for Data Set models
nodes = filterbytype(pPROJ.info, cgtypes.cgdatasettype);

% Only allow those data sets which contain the required pointers

DSvals = get(optimobj, 'oppointValues');
freevals = get(optimobj, 'values');

if indx == 1 % if we are the primary data set don't allow any free variables in the data set
    disallowed = freevals;
    msg = ['There are no data sets in this session that have the required factors', ...
            ' and do not contain one of the free variables.'];
else
    disallowed = [];
    msg = 'There are no data sets in this session that have the required factors.';
end
nodes = i_FilterDisallowedDS(nodes, DSvals{indx}, disallowed);
errmsg = {msg, '', 'Import a new data set and try again.'};    
errtitle = 'Data Set Selector';    
dialogTitle = 'Select Data Set';    

if isempty(nodes)
    % Display an error dialog
    h = errordlg(errmsg, errtitle, 'modal');
    waitfor(h);
    newobj = optimobj;
    ok = false;
    
elseif length(nodes) == 1
    pSelDS = getdata(nodes{1});
    oppts = get(optimobj, 'oppoints');
    oppts(indx) = pSelDS;
    newobj = set(optimobj, 'oppoints', oppts);
    ok = true;
    
else
    str = []; dsPtr = [];
    for n = 1:length(nodes)
        dsPtr = [dsPtr,getdata(nodes{n})];
        str{n} = name(nodes{n});
    end
    Handles.Figure = xregdialog(...
        'tag' , 'cgmodelselector' , ...
        'name' , dialogTitle,...
        'visible','off',...
        'Resize','off');
    
    fh = Handles.Figure;
    % center the dialog on the cgbrowser figure
    figH = 300; figW = 260;
    xregcenterfigure(fh, [figW, figH]);
    
    Handles.List = xreguicontrol('style' , 'listbox' , ...
        'parent' , fh , ...
        'backgroundcolor' , [1 1 1] , ...
        'position' , [20 35 figW-40 figH-90], ...
        'string', str);
    xreguicontrol('style' , 'text' , ...
        'parent' , fh , ...
        'position' , [20 figH-35 figW-40 20] , ...
        'horizontalalignment' , 'left' , ...
        'fontweight' , 'demi' , ...
        'string' , dialogTitle);
    xreguicontrol('style' , 'push' , ...
        'parent' , fh , ...
        'position' , [figW-75 10 65 25] , ...
        'string' , 'Cancel' , ...
        'callback' , 'set(gcbf, ''tag'', ''cancel'', ''visible'', ''off'');');
    ok=xreguicontrol('style' , 'push' , ...
        'parent' , fh , ...
        'position' , [figW-150 10 65 25] , ...
        'string' , 'OK' , ...
        'callback' , 'set(gcbf, ''tag'', ''ok'', ''visible'', ''off'');');
    
    listindx = strmatch(name(nodes{indx}), str, 'exact');
    if ~isempty(listindx)
        set(Handles.List , 'value' , listindx);
    end
    % finally set dialog visible.  This call blocks the execution thread
    fh.showDialog(ok);
    
    tg = get(fh, 'tag');
    if strcmp(tg, 'ok')
        % OK pressed
        v=get(Handles.List , 'value');
        pSelDS = dsPtr(v);
        oppts = get(optimobj, 'oppoints');
        oppts(indx) = pSelDS;
        newobj = set(optimobj, 'oppoints', oppts);
        ok = true;
    else
        % Cancel pressed
        newobj = optimobj;
        ok = false;
    end
    delete(fh);
end

%-------------------------------------------------------------------
function outnodes = i_FilterDisallowedDS(nodes, reqdptrs, disallowedptrs)
%-------------------------------------------------------------------

outnodes = [];
for n = 1:length(nodes)
    pOp = getdata(nodes{n});
    ptrs = get(pOp.info, 'ptrlist');
    commonPtrs = intersect(ptrs, reqdptrs);
    commonBadPtrs = intersect(ptrs, disallowedptrs);
    if (length(commonPtrs) == length(reqdptrs)) && isempty(commonBadPtrs) && ~isempty(pOp.info)
        outnodes = [outnodes, nodes(n)];
    end
end