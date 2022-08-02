function mbcaddongui(varargin)
%MBCADDONGUI Create a GUI for managing add-ons
%
%  MBCADDONGUI creates  a window that lists the currently installed
%  add-ons and provides a mechanism for adding new ones.  This function
%  blocks until the addon setup has been completed.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:25:45 $

h = xregdialog('Name','MBC Add-On Manager',...
    'Renderer','painters',...
    'tag','mbcaddons');
xregcenterfigure(h,[450 180]);

txt=uicontrol('parent',h,...
    'style','text',...
    'string','Currently installed add-on packages:',...
    'horizontalalignment','left');

ud.list=xregGui.listview([0 0 10 10],double(h),{'Columnclick','xreglvsorter'});
ud.list.View=3;
ud.list.Parent=double(h);
ud.list.HideSelection=0;
ud.list.LabelEdit=1;
ud.list.FullRowSelect=1;
ud.list.GridLines=1;
ch=ud.list.columnheaders;
c = ch.Add;
c.Text='Name';
c.Width=250;
c = ch.Add;
c.Text='Version';
c.Width=80;

ud.add=uicontrol('parent',h,...
    'style','pushbutton',...
    'string','Add...',...
    'callback',@i_add,...
    'interruptible','on');
ud.remove=uicontrol('parent',h,...
    'style','pushbutton',...
    'string','Remove',...
    'callback',@i_remove);

cls=uicontrol('parent',h,...
    'style','pushbutton',...
    'string','Close',...
    'callback','close(gcbf)');
lyt=xreggridbaglayout(h,...
    'packstatus','off',...
    'dimension',[5 2],...
    'rowsizes',[15 25 25 -1 25],...
    'colsizes',[-1 65],...
    'gapy',7,'gapx',15,...
    'border',[10 10 10 10],...
    'mergeblock',{[2 5],[1 1]},...
    'elements',{txt,actxcontainer(ud.list),[],[],[],[],ud.add,ud.remove,[],cls});


h.LayoutManager=lyt;
set(lyt,'packstatus','on');
ud=i_setupgui(ud);
set(h,'userdata',ud);
h.showDialog;
delete(h);


function ud=i_setupgui(ud)
% fill list
itms=ud.list.listitems;
if itms.Count
    itms.Clear;
end
addons=which('-all','mbcextras.mbc');
i_createlistitems(ud.list,addons)
if itms.Count
    set(ud.remove,'enable','on');
else
    set(ud.remove,'enable','off');
end


function i_remove(src,evt)
fig = get(src,'Parent');
ud = get(fig,'userdata');

try
    itm = ud.list.SelectedItem;
catch
    return
end

if ~isempty(itm)
    % Remove the addon
    file = itm.Tag;
    pth = fileparts(file);
    try
        mbcuninstalladdon(pth);
    catch
        h = warndlg('An error occurred during the removal of the addon.', ...
            'MBC Toolbox', 'modal');
        waitfor(h);
    end
    % Refresh the list
    ud = i_setupgui(ud);
    set(fig,'userdata',ud);
end


function i_add(src,evt)
fig=get(src,'Parent');
ud=get(fig,'userdata');

% open a customised dir-chooser so that we can scan for add-ons.
[pth,dosubs]=i_getscandir;
if pth~=0
    % find all addons
    set(fig,'pointer','watch');
    if dosubs
        % pop up a progress notifier
        fH=xregfigure('Name','MBC Add-On Progress',...
            'visible','off','pointer','watch','renderer','painters',...
            'closerequestfcn','','windowstyle','modal','resize','off');
        xregcenterfigure(fH,[400 100]);
        hText=uicontrol('parent',fH,'style','text','horizontalalignment','left','position',[10 50 380 30]);
        cancptr=xregGui.RunTimePointer(0);
        cancptr.LinkToObject(fH);
        hCancel=uicontrol('parent',fH,'style','pushbutton','string','Cancel','position',[325 10 65 25],...
            'callback',@i_cancelsearch,'userdata',cancptr);
        set(fH,'visible','on');
    else
        cancptr=[];
        hText=[];
    end
    drawnow;
    newaddons=i_scanforaddons({},pth,dosubs,hText,cancptr);
    set(fig,'pointer','arrow');
    if dosubs
        delete(fH);
    end
    if ~iscell(newaddons)
        if newaddons==0
            return   % user cancelled search
        end
    end

    if length(newaddons)
        % user chooses which to install
        [newaddons,ok]=i_chooseaddons(newaddons);
        if ok
            % Only install ones which are not currently installed - decide by looking at names
            notinstalled=[];
            for n=1:length(newaddons)
                if ~i_isinstalled(ud,newaddons{n})
                    % Check whether the new addon in is under the toolbox
                    % directory and warn if this is so - it is bad practice
                    % for users to put their code in matlab\toolbox
                    tbxdir = fullfile(matlabroot, 'toolbox');
                    if strncmp(tbxdir, newaddons{n}, length(tbxdir))
                        h = warndlg(['You have installed an add-on inside MATLAB''s ' ...
                            'toolbox directory.  It is recommended that no user code ' ...
                            'is placed inside this directory to avoid it being overwritten ' ...
                            'by the MATLAB installer and to avoid undesired caching of ' ...
                            'the code.  As an alternative you can use the $matlabroot\work ' ...
                            'directory instead.'], ...
                            'MBC Toolbox', 'modal');
                        waitfor(h);
                    end
                    mbcinstalladdon(newaddons{n});
                else
                    notinstalled=[notinstalled n];
                end
            end
            ud=i_setupgui(ud);
            set(fig,'userdata',ud);
            if length(notinstalled)
                str=['The following add-ons were not installed because an add-on with the same name ' ...
                    'already exists on the MATLAB path.  Remove the current add-on(s) before installing ' ...
                    'a new one with the same name.' char(10) char(10)];
                for n=notinstalled
                    str=[str  '   ' newaddons{n} char(10)];
                end
                str=str(1:end-1);
                h=warndlg(str,'MBC Toolbox','modal');
                drawnow;
                waitfor(h);
            end
        end
    else
        h=msgbox(['No add-ons found in folder ' pth],'MBC Toolbox','modal');
        drawnow;
        waitfor(h);
    end
end









function [pth,dosubs]=i_getscandir

h=xregdialog('Name','Choose Folder to Scan',...
    'resize','off');
xregcenterfigure(h,[250 300]);

pcc=actxcontrol('MWMBCControls.PathChooserCtrl',[0 0 100 100],double(h));

subs=uicontrol('parent',h,...
    'style','checkbox',...
    'string','Check subdirectories',...
    'value',0);
ok= uicontrol('parent',h,...
    'style','pushbutton',...
    'string','OK',...
    'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');');
canc= uicontrol('parent',h,...
    'style','pushbutton',...
    'string','Cancel',...
    'callback','set(gcbf,''visible'',''off'');');


lyt=xreggridbaglayout(h,...
    'packstatus','off',...
    'dimension',[3 3],...
    'rowsizes',[-1 20 25],...
    'colsizes',[-1 65 65],...
    'gapy',7,'gapx',10,...
    'border',[10 10 10 10],...
    'mergeblock',{[1 1],[1 3]},...
    'mergeblock',{[2 2],[1 3]},...
    'elements',{actxcontainer(pcc),subs,[],[],[],ok,[],[],canc});

h.LayoutManager=lyt;
set(lyt,'packstatus','on');

h.showDialog(ok);


tg=get(h,'tag');
if strcmp(tg,'ok')
    pth= pcc.Path;
    dosubs=get(subs,'value');
else
    pth=0;
    dosubs=0;
end
delete(h)



function addonpth=i_scanforaddons(addonpth,pth,dosubs,hText,cancptr)
s=struct2cell(dir(pth));
isdir=[s{4,:}];
files=s(1,~isdir);
dirs=s(1,isdir);

found=strcmp(files,'mbcextras.mbc');
if any(found)
    for n=find(found)
        addonpth=[addonpth, {pth}];
    end
end
if dosubs
    for n=1:length(dirs)
        if cancptr.info
            addonpth=0;
            return % cancel condition has occurred
        end
        if ~any(strcmp(dirs{n},{'.','..'}))
            if ~isempty(hText)
                set(hText,'string',sprintf('Checking folder:\n%s ', fullfile(pth,dirs{n})));
                drawnow;
            end
            addonpth=i_scanforaddons(addonpth,fullfile(pth,dirs{n}),dosubs,hText,cancptr);
        end
    end
end


function i_cancelsearch(src,evt)
cancptr = get(src,'userdata');
cancptr.info = 1;




function [newaddons,ok]=i_chooseaddons(newaddons)


h=xregdialog('Name','Available MBC Add-Ons',...
    'resize','off');
xregcenterfigure(h,[400 200]);

lv=xregGui.listview([0 0 100 100],double(h),{'Columnclick','xreglvsorter'});
lv.View=3;
lv.GridLines=1;
lv.FullRowSelect=1;
lv.LabelEdit=1;
lv.Parent=double(h);
lv.HideSelection=0;
lv.MultiSelect=1;

ch=lv.columnheaders;
c = ch.Add;
c.Text='Name';
c.Width=250;
c = ch.Add;
c.Text='Version';
c.Width=80;

i_createlistitems(lv,newaddons)

txt=uicontrol('parent',h,...
    'style','text',...
    'horizontalalignment','left',...
    'string','Select the MBC add-ons you wish to install:');
ok= uicontrol('parent',h,...
    'style','pushbutton',...
    'string','OK',...
    'callback','set(gcbf,''tag'',''ok'',''visible'',''off'');');
canc= uicontrol('parent',h,...
    'style','pushbutton',...
    'string','Cancel',...
    'callback','set(gcbf,''visible'',''off'');');


lyt=xreggridbaglayout(h,...
    'packstatus','off',...
    'dimension',[3 3],...
    'rowsizes',[15 -1 25],...
    'colsizes',[-1 65 65],...
    'gapy',7,'gapx',10,...
    'border',[10 10 10 10],...
    'mergeblock',{[1 1],[1 3]},...
    'mergeblock',{[2 2],[1 3]},...
    'elements',{txt,actxcontainer(lv),[],[],[],ok,[],[],canc});

h.LayoutManager=lyt;
set(lyt,'packstatus','on');
h.showDialog(ok);


tg=get(h,'tag');
if strcmp(tg,'ok')
    try
        selind=double(lv.SelectedItemIndex);
        itms=lv.ListItems;
        newaddons=cell(1,length(selind));
        for n=1:length(selind)
            itm= itms.Item(selind(n));
            newaddons{n}=itm.Tag;
        end
        ok=1;
    catch
        newaddons={};
        ok=0;
    end
else
    newaddons={};
    ok=0;
end
delete(h)



function i_createlistitems(list,addons)

itms=list.listitems;
for n=1:length(addons)
    try
        S=load(addons{n},'-mat');
    catch
        try
            S=load(fullfile(addons{n},'mbcextras.mbc'),'-mat');
        end
    end
    if isfield(S,'MBC_EXTENSION_PACKAGE')
        if S.MBC_EXTENSION_PACKAGE
            itm= itms.Add;
            itm.Text=S.Name;
            itm.Tag=addons{n};
            set(itm,'subitems',1,S.Version);
        end
    end
end



function out=i_isinstalled(ud,pth)

packagename='';
try
    S=load(fullfile(pth,'mbcextras.mbc'),'-mat');
    if isfield(S,'MBC_EXTENSION_PACKAGE')
        if S.MBC_EXTENSION_PACKAGE
            packagename=S.Name;
        end
    end
end
if isempty(packagename)
    out=0;
    return
end
% get current list from listview
itms=ud.list.listitems;
if itms.Count
    out=0;
    for n=1:double(itms.Count)
        itm= itms.Item(n);
        if strcmp(itm.Text,packagename)
            out=1;
            break
        end
    end
else
    out=0;
end

