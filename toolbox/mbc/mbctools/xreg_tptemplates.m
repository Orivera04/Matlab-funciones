function [d,ok,chk]=xreg_tptemplates(action,varargin)
%XREG_TPTEMPLATES   Template chooser gui
%
%  [D,OK] = xreg_tptemplates creates a blocking gui prompting
%  the user to select a template design, or the design wizard
%  option.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.3 $  $Date: 2004/02/09 08:21:10 $




if nargin==0
    action='create';
end

if mbciscom(action)
    varargin=[{action} varargin];
    action='axevent';
end

switch lower(action)
case 'create'
    if nargin<2
        varargin{1}=1;
    end
    
    scrsz=get(0,'screensize');
    figh=xregfigure('visible','off',...
        'position',[scrsz(3).*0.5-275 scrsz(4).*0.5-135 550 270],...
        'doublebuffer','on',...
        'numbertitle','off',...
        'name','New Test Plan',...
        'resize','off',...
        'units','pixels',...
        'toolbar','none',...
        'menubar','none',...
        'tag','TestplanTemplates',...
        'closerequestfcn',[mfilename '(''cancel'',gcbf);'],...
        'color',get(0,'defaultuicontrolbackgroundcolor'),...
        'integerhandle','off',...
        'windowstyle','modal',...
        'handlevisibility','callback');
    
    figh= double(figh);
    
    % objects
    lv=xregGui.listview([10 10 100 100],figh,...
        {'click',mfilename;'dblclick',mfilename;'keyup',mfilename;...
            'keypress',mfilename});
    
    ilm= xregGui.ILmanager;
    ind= bmp2ind(ilm,'testplantp.ico');
    
    lv.InsertIcons(ilm.IL);
    lv.LabelEdit=1;
    lv.HideSelection=0;
    lv.Arrange=2;
    lst=lv.ListItems;
    % load templates and populate the listbox
    % builtin
    templates=[];
    load('tpbuiltintemps.mat');
    % user
    ud.numbuiltin=size(templates,1);
    ud.Builtin= templates;
    
    ud.Dir = xregGetDefaultDir('Designs');
    ud.userfiles= dir(fullfile(ud.Dir,'*.MBT'));;
        
    % add a node for each design template
    for n=1:size(templates,1)
        nd=lst.Add;
        nd.Text=name(templates{n,1});
        nd.Icon=1;
        nd.Tag=figh;
    end
    
    for n=1:length(ud.userfiles)
        nd=lst.Add;
        nd.Text= ud.userfiles(n).name(1:end-4);
        nd.Icon=1;
        nd.Tag=figh;
    end
    
    lv.SelectedItem = lst.Item(1);
    lv=actxcontainer(lv);
    ud.listview=lv;
    
    infobox=xreguicontrol('style','edit',...
        'parent',figh,...
        'enable','inactive',...
        'max',2,...
        'min',0,...
        'FontName','FixedWidth',...
        'horizontalalignment','left');
    ud.info=infobox;
    
    % default is first builtin
    T= templates{1};
    info= [colhead(T); num2cell(statistics(T))];
    infostr=sprintf('%-8s: %3d\n',info{:} );
    set(ud.info,'string',infostr);   
    ud.Selected = T;
    
    okbtn=xreguicontrol('style','pushbutton',...
        'parent',figh,...
        'string','OK',...
        'position',[0 0 65 25],...
        'callback',[mfilename '(''ok'',gcbf);']);
    cancbtn=xreguicontrol('style','pushbutton',...
        'parent',figh,...
        'string','Cancel',...
        'position',[0 0 65 25],...
        'callback',[mfilename '(''cancel'',gcbf);']);
     helpbtn = mv_helpbutton(figh,'xreg_newTestPlan');

    btmbl = xreggridlayout(figh,...
        'dimension',[1,4],...
        'correctalg','on',...
        'colsizes',[-1 80 80 80],...
        'gapx',7,...
        'elements',{[], okbtn,cancbtn,helpbtn});
    
    browsebtn=xreguicontrol('style','pushbutton',...
        'parent',figh,...
        'string','Browse...',...
        'position',[0 0 65 25],...
        'callback',[mfilename '(''browse'',gcbf);']);
    
    bl=xregborderlayout(figh,...
        'center',infobox',...
        'innerborder',[0 25 0 0],...
        'packstatus','on');
    
    frm=xregframetitlelayout(figh,...
        'center',bl,...
        'innerborder',[15 10 10 10],...
        'outerborder',[0 0 0 0],...
        'title','Information',...
        'packstatus','on');
    frm2=xregframetitlelayout(figh,...
        'center',lv,...
        'innerborder',[15 10 10 10],...
        'outerborder',[0 0 0 0],...
        'title','Templates',...
        'packstatus','on');
    
    mainl=xreggridbaglayout(figh,...
        'container',figh,...
        'dimension',[4, 4],...
        'elements',{...
            frm2,[],[],btmbl,...
            frm,browsebtn,[],[],...
            [],[],[],[],...
            [],[],[],[]},...
        'mergeblock',{[1 2],[1 1]},...%% for templates window
        'mergeblock',{[1 1],[2 4]},...%% for info
        'mergeblock',{[4 4],[1 4]},...%% for ok/cancel buttons        
        'rowsizes',[-1, 25 5 25],...
        'colsizes',[-1 80 30 30],...
        'border',[10 10 10 15],...
        'gapy',10,...
        'gapx',10,...
        'packstatus','on');
    
    ud.ok=0;
    set(figh,'visible','on','userdata',ud,'handlevisibility','off');
    drawnow;
    waitfor(figh,'tag','CLOSEGUI');
    
    ud=get(figh,'userdata');
    ok=ud.ok;
    d= [];
    if ok
        d= cacheTSSF(ud.Selected);
    end
    delete(figh);
    
case 'ok'
    ud=get(varargin{1},'userdata');
    
    ud.ok=1;
    set(varargin{1},'userdata',ud,'tag','CLOSEGUI');  
    
case 'cancel'
    ud=get(varargin{1},'userdata');
    ud.Selected=[];
    ud.ok=0;
    set(varargin{1},'userdata',ud,'tag','CLOSEGUI');
    
case 'axevent'
    varargin{1}.inactive=-1;
    switch varargin{2}
    case {1,5}
        % item click
        it=varargin{1}.SelectedItem;
        ind= double(it.Index);
        figh=it.Tag;
        ud=get(figh,'userdata');
        
        set(figh,'pointer','watch');
        drawnow
        if ind<=ud.numbuiltin
            T= ud.Builtin{ind};
        else
            i= ind-ud.numbuiltin;
            Ti=struct2cell(load('-mat',fullfile(ud.Dir,ud.userfiles(i).name)));
            T= Ti{1};
        end
        
        info= [colhead(T); num2cell(statistics(T))];
        infostr=sprintf('%-8s: %3d\n',info{:} );
        set(ud.info,'string',infostr);
        
        ud.Selected = T;
        
        set(figh,'userdata',ud,...
            'pointer',get(0,'DefaultFigurePointer'));
    case 4
        if varargin{3}==13
            it=varargin{1}.SelectedItem;
            ind=it.Index;
            figh=it.Tag;
            feval(mfilename,'ok',figh);
        end
    case 2
        % double click
        it=varargin{1}.SelectedItem;
        ind=it.Index;
        figh=it.Tag;
        feval(mfilename,'ok',figh);
    end
    varargin{1}.inactive=0;
    
case 'browse'
    
    figh = varargin{1};
    ud = get(figh,'userdata');
    pathname = uigetdir(ud.Dir, 'Select template directory:');
    pathname = [pathname '\'];
    if pathname
        lv = ud.listview;
        ud.Dir = pathname;
        %clear listview
        for i = double(lv.ListItems.Count):-1:ud.numbuiltin+1
           lv.ListItems.Remove(i);
        end
        
        ud.userfiles= dir(fullfile(ud.Dir,'*.MBT'));;
        
        for n=1:length(ud.userfiles)
           nd = lv.ListItems.Add;
           nd.Text= ud.userfiles(n).name(1:end-4);
           nd.Icon=1;
           nd.Tag=figh;
        end
        
        T = ud.Builtin{1};
        lv.SelectedItem = lv.ListItems.Item(1);
        ud.Selected = T;
        info= [colhead(T); num2cell(statistics(T))];
        infostr=sprintf('%-8s: %3d\n',info{:} );
        set(ud.info,'string',infostr);

        set(figh,'userdata',ud);
    else
        %% user hit "cancel" or some error occurred    
        return
    end
    
end
