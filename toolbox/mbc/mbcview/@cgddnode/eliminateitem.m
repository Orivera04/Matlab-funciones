function [ddnode, ok, newPtr] = eliminateitem(ddnode, pCurr)
%ELIMINATEITEM Make this item into an alias of another existing item
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:33:16 $

ok = false;
newPtr = xregpointer;

[inDS, pDS] = indataset(ddnode, pCurr);
if inDS
    if length(pDS)>1
        errorstr = sprintf('Unable to change %s to be an alias because it is a member of the data sets ', pCurr.getname);
    else
        errorstr = sprintf('Unable to change %s to be an alias because it is a member of the data set ', pCurr.getname);
    end
    DSnames = cell(size(pDS));
    for n =1:length(pDS)
        DSnames{n} = pDS(n).name;
    end
    errorstr = [errorstr, sprintf('%s, ', DSnames{:})];
    errorstr = errorstr(1:end-1);
    errorstr(end) = '.';
    errordlg(errorstr, 'Convert to Alias', 'modal');
    return
end

pAllowed = aliasallowed(ddnode, pCurr);
if isempty(pAllowed)
    errordlg(sprintf('There are no suitable items for %s to be made an alias of.', pCurr.getname), ...
        'Convert to Alias', 'modal');
    return
end

sAllowed = cell(size(pAllowed));
for n = 1:length(pAllowed)
    sAllowed{n} = pAllowed(n).getname;
end
% Sort items alphabetically to make them easier to find
sAllowed = sort(sAllowed);

% pop up a dialog
f=xregdialog('name','Convert to Alias',...
	'resize','off');
xregcenterfigure(f, [300 250]);
label=uicontrol('style','text',...
	'parent',f,...
	'string',['Eliminate ', pCurr.getname, ' by making it an alias of:'],...
	'horizontalalignment','left');
listPopUp=uicontrol('style','listbox',...
	'parent',f,...
	'string',sAllowed,...
	'backgroundcolor','w',...
	'horizontalalignment','right');
ok=uicontrol('parent',f,...
	'style','pushbutton',...
	'string','OK',...
	'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');');
cancel=uicontrol('parent',f,...
	'style','pushbutton',...
	'string','Cancel',...
	'callback','set(gcbf,''visible'',''off'');');

grd=xreggridbaglayout(f,'dimension',[4 3],...
	'gapy',5,'gapx',7,...
	'rowsizes',[15 -1 0 25],...
	'colsizes',[-1 65 65],...
	'mergeblock',{[1 1],[1 3]},...
	'mergeblock',{[2 2],[1 3]},...
	'elements',{label,listPopUp,[],[],[],[],[],ok,[],[],[],cancel},...
	'packstatus','off',...
	'border',[10 10 10 10]);

f.LayoutManager=grd;
set(grd,'packstatus','on');
f.showDialog(ok);

% GUI blocks here until OK/cancel pressed

tg=get(f,'tag');
if strcmp(tg,'ok')
    newstr = sAllowed{get(listPopUp,'value')};
    newPtr = find(ddnode,newstr);
    if ~isempty(newPtr)
        % Add aliases to chosen item
        newObj = newPtr.info;
        newObj = addalias(newObj, pCurr.getname);
        otherals = pCurr.getaliaslist;
        for n = 1:length(otherals)
            newObj = addalias(newObj, otherals{n});
        end
        newPtr.info = newObj;
        % Replace olditem with new one everywhere in session
        replace(ddnode,pCurr,newPtr);
        ok = true;
    end
end
delete(f);
