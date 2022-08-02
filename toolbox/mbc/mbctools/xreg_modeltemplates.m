function [mlist,ok] = xreg_modeltemplates(action,varargin)
%XREG_MODELTEMPLATES  Model template chooser gui
%
%  [D,OK] = XREG_MODELTEMPLATES( 'CREATE', MODEL, NOBS ) creates a blocking
%  gui prompting the user to select a model template.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.8.4.4 $  $Date: 2004/04/12 23:35:00 $

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
            'name','Build Models',...
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

        % objects
        lv=xregGui.listview([10 10 100 100],double(figh),...
            {'click',mfilename;'dblclick',mfilename;'keyup',mfilename;...
            'keypress',mfilename});

        ilm= xregGui.ILmanager;
        bmp2ind(ilm,'gloreg32.bmp');
        lv.InsertIcons(ilm.IL);
        lv.labeledit=1;
        lv.hideselection=0;
        lv.arrange=2;

        lst=lv.listitems;

        % load templates and populate the listbox
        m = varargin{1};
        nobs = varargin{2};
        nf = nfactors(m);
        ud = iAddBuiltinTemplates( figh, lst, m, nf );
        ud.Dir = xregGetDefaultDir('Designs');
        ud = iAddUserTemplates( figh, lst, ud, nf );
        ud.Selected={};

        lv.selecteditem= lst.Item(1);
        lv=actxcontainer(lv);
        ud.listview=lv;

        infobox=xreguicontrol('style','edit',...
            'parent',figh,...
            'enable','inactive',...
            'max',2,...
            'min',0,...
            'horizontalalignment','left');
        ud.info=infobox;

        % default is first builtin
        set(ud.info,'string','Pre-defined Template');

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
        helpbtn = mv_helpbutton(figh,'xreg_buildModels');
        set(helpbtn,'position',[0 0 65 25]);

        btmbl=xregflowlayout(figh,'orientation','right/bottom',...
            'elements',{helpbtn,cancbtn,okbtn},...
            'gap',7);

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

        set(figh, 'LayoutManager',mainl,...
            'visible','on',...
            'userdata',ud );

        mlist={};
        ok=0;
        waitfor(figh,'tag','CLOSEGUI');

        ud=get(figh,'userdata');
        d=ud.Selected;
        ok=ud.ok;

        if ok
            it= lv.SelectedItem;
            ind= double(it.Index);
            if ind<=ud.numbuiltin
                bm= copymodel(m, ud.Builtin{ind} );
                mlist= buildmodels(bm,nobs);
                ok= ~isempty(mlist);
            else
                mlist= ud.Selected;
            end
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
                it=varargin{1}.selecteditem;
                ind= double(it.index);
                figh=it.tag;
                ud=get(figh,'userdata');

                set(figh,'pointer','watch');
                drawnow
                if ind<=ud.numbuiltin
                    mlist= ud.Builtin{ind};
                    set(ud.info,'string', 'Pre-defined Template' );
                else
                    i= ind-ud.numbuiltin;
                    Ti=struct2cell(load('-mat',fullfile(ud.Dir,ud.userfiles(i).name)));
                    mlist= Ti{1};
                    infostr = cell( size(mlist) );
                    for i=1:length(mlist)
                        infostr{i}=sprintf('%s\n',name(mlist{i}) );
                    end
                    set(ud.info,'string',[infostr{:}]);
                end
                ud.Selected = mlist;
                set(figh,'userdata',ud,...
                    'pointer',get(0,'DefaultFigurePointer'));
            case 4
                if varargin{3}==13
                    it=varargin{1}.selecteditem;
                    figh=it.tag;
                    feval(mfilename,'ok',figh);
                end
            case 2
                % double click
                it=varargin{1}.selecteditem;
                figh=it.tag;
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

            nf = nfactors( ud.Builtin{1} );

            ud = iAddUserTemplates( figh, lv.listitems, ud, nf );

            T = ud.Builtin{1};
            lv.selecteditem=lv.ListItems.Item(1);
            ud.Selected = T;
            set(ud.info,'string','Pre-defined Template');

            set(figh,'userdata',ud);
        else
            %% user hit "cancel" or some error occurred
            return
        end
end

% -------------------------------------------------
function ud = iAddBuiltinTemplates( figh, lst, m, nf )

templates = {'New...','Polynomials','RBF Kernels'};
bms= {xregmulti('nfactors',nf),xregcubic('nfactors',nf) xregrbf('nfactors',nf)};

if nf==1
    templates= [templates {'Free Knot Splines'}];
    bms= [bms {xregunispline}];
end
if isa(m,'xregmultilin')
    templates= [templates {'Multi-linear'}];
    bms= [bms {m}];
end

ud.numbuiltin=length(templates);
ud.Builtin= bms;

% add a node for each predefined template
for n=1:length(templates)
    nd=lst.Add;
    nd.text=templates{n};
    nd.icon=1;
    nd.tag=double(figh);
end

% -------------------------------------------------
function ud = iAddUserTemplates( figh, lst, ud, nf )
% add user defined templates to the listctrl

ud.userfiles= dir(fullfile(ud.Dir, '*.MBM'));
mok= zeros(1,length(ud.userfiles));
set( figh, 'Pointer', 'watch');
for n=1:length(ud.userfiles)
    tmp= load('-mat',fullfile(ud.Dir, ud.userfiles(n).name));
    if isfield(tmp,'mlist') && iscell(tmp.mlist) && ~isempty(tmp.mlist)
        mi= tmp.mlist{1};
        if nfactors(mi)==nf
            nd=lst.Add;
            nd.text= ud.userfiles(n).name(1:end-4);
            nd.icon=1;
            nd.tag= double(figh);
            mok(n)= 1;
        else
            mok(n)= 0;
        end

    end
end
ud.userfiles= ud.userfiles(mok~=0);
set( figh, 'Pointer', get(0,'DefaultFigurePointer') );

