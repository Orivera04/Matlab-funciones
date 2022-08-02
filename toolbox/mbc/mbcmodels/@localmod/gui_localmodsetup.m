function [mout,ok]=gui_localmodsetup(m,action,varargin)
% GUI_LOCALMODSETUP  Gui for selecting and setting up the local model
%
%  [M,OK]=GUI_LOCALMODSETUP(M) creates a modal dialog for selecting the
%  local model type and setting up some options.  The file GUI_LOCALMODOPTS
%  is called for controlling model-dependent additional options such as
%  the spline orders.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.6.4.4 $  $Date: 2004/02/09 07:39:13 $



if nargin<2
    action='figure';
end

switch lower(action)
case 'figure'
    [mout,ok]=i_createfig(m,varargin{:});   
end

%=================================================
%   subfunction i_createfig
%=================================================
function [mout,ok]=i_createfig(m,varargin)

scsz=get(0,'screensize');
figh=xregfigure('menubar','none',...
    'toolbar','none',...
    'numbertitle','off',...
    'name','Local Model Setup',...
    'doublebuffer','on',...
    'renderer','zbuffer',...
    'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
    'position',[scsz(3).*0.5-250 scsz(4).*0.5-160 500 340],...
    'visible','off',...
    'color',get(0,'defaultuicontrolbackgroundcolor'),...
    'tag','LocalModSetup',...
    'resize','off');
 figh= double(figh);

%% create a pointer - this is where the model will live
p=xregpointer(m);
[lyt,ok]=i_createlyt(figh,p,varargin{:});

if ok
    % ok and cancel buttons
    okbtn = xreguicontrol('parent',figh,...
        'string','OK',...
        'style','pushbutton',...
        'callback','set(gcbf,''tag'',''ok'');',...
        'position',[0 0 65 25]);
    cancbtn = xreguicontrol('parent',figh,...
        'string','Cancel',...
        'style','pushbutton',...
        'callback','set(gcbf,''tag'',''cancel'');',...
        'position',[0 0 65 25]);
     helpbtn = mv_helpbutton(figh,'xreg_localModelSetup');
     set(helpbtn,'position',[0 0 65 25]);

    flw=xregflowlayout(figh,'orientation','right/bottom',...
        'elements',{helpbtn,cancbtn,okbtn},...
        'gap',7,...
        'border',[0 10 -7 10]);
    brd=xregborderlayout(figh,'center',lyt,'south',flw,...
        'innerborder',[10 45 10 10],...
        'container',figh,...
        'packstatus','on');
    
    set(figh,'visible','on');
    drawnow;
    set(figh,'windowstyle','modal');
    
    %% TWO LINES TO REMOVE (GET ROUND WAITFOR - FOR DEVELOPMENT)
    %     mout=[];
    %     return
    
    
    waitfor(figh,'tag');
    
    tg=get(figh,'tag');
    switch lower(tg)
    case 'ok'
        mout=p.info;
        ok=1;
        % look for changes in m->mout.
        % class check
        if ~strcmp(class(mout),class(m)) | ~modelcmp(mout,m)
            ok=3;
        else
            % look for changes in other properties
            if ~((covmodel(mout)==covmodel(m)) & ytranscmp(mout,m))
                ok=2;
            end
        end
        
        %%HARD CODED FOR NOW
        ok=3;
    case 'cancel'
        mout=m;
        ok=0;
    end
end
freeptr(p);
delete(figh);
return


%=================================================
%   subfunction i_createlyt
%=================================================
function [lyt,ok]=i_createlyt(figh,p,EquiSpaced,nf);
%% we create userdata here to pass around


%% p is pointer to the model that was passed into gui_localmodsetup
m=p.info;

if nargin<4
    nf= nfactors(m);
end
% get list of models that can be used in this case
ud= ModelClasses(m,nf);


for i=1:length(ud.lmgroups);
    if isa(ud.lmgroups{i},'function_handle')
        ud.lmgroups{i} = func2str(ud.lmgroups{i});
    end
end

ud.optsdone= zeros(size(ud.modeltps));
ok= ~isempty(ud.modeltps);
if ~ok
    lyt=[];
    errordlg('There are no local models available for this twostage problem','Local Setup','modal');
    return
end

ud.figh=figh;
ud.pointer=p;

% the layout we pass out
tabs = xregtablayout2(figh,...
   'packstatus','off',...
   'numcards',2,...
   'tablabels',{'Model Setup','Response Features'});
lyt=tabs;


%% ------------BUILD THE LOCAL MODEL CHOICE LAYOUT------------------
% lists  for controls
ud.transfrms={'None','log(y)','exp(y)','sqrt(y)','y^2','1/y','Other'};
ud.covars={'None','Power','Exponential','Mixed'};
ud.corr={'None','MA(1)','AR(1)','AR(2)'};

text2=xreguicontrol('parent',figh,...
    'style','text',...
    'string','Transform:',...
    'horizontalalignment','left',...
    'position',[0 0 80 15]);
text3=xreguicontrol('parent',figh,...
    'style','text',...
    'string','Covariance model:',...
    'horizontalalignment','left',...
    'position',[0 0 100 15]);
text4=xreguicontrol('parent',figh,...
    'style','text',...
    'string','Correlation model:',...
    'horizontalalignment','left',...
    'position',[0 0 100 15]);
% model type
ud.modellist=xreguicontrol('parent',figh,...
    'style','listbox',...
    'string',ud.modeltps,...
    'backgroundcolor','w',...
    'position',[0 0 120 20],...
    'interruptible','off');
%transform
ud.transpop=xreguicontrol('parent',figh,...
    'style','popupmenu',...
    'string',ud.transfrms,...
    'backgroundcolor','w',...
    'position',[0 0 60 20],...
    'interruptible','off');
% userdefined transform 
ud.transedt=xreguicontrol('parent',figh,...
    'style','edit',...
    'backgroundcolor','w',...
    'visible','off',...
    'position',[0 0 60 20],...
    'horizontalalignment','left',...
    'interruptible','off');
% transfrom both sides check
ud.transbs=xreguicontrol('parent',figh,...
    'style','checkbox',...
    'string','Apply transform to both sides',...
    'horizontalalignment','left',...
    'interruptible','off');
% covariance popup
ud.covarpop=xreguicontrol('parent',figh,...
    'style','popupmenu',...
    'string',ud.covars,...
    'backgroundcolor','w',...
    'position',[0 0 120 20],...
    'interruptible','off');

if nargin>2 & EquiSpaced
    Cenabled='on';
    ud.Ts= EquiSpaced;
else
    Cenabled='off';
end
% correlation popup
ud.corrpop=xreguicontrol('parent',figh,...
    'style','popupmenu',...
    'string',ud.corr,...
    'enable',Cenabled,...
    'backgroundcolor','w',...
    'position',[0 0 120 20],...
    'interruptible','off');

% set up stored data
udh= text2; 
ud.udh = text2;

% callbacks
set(ud.modellist,'callback',{@i_classchng,udh});
set(ud.transpop,'callback',{@i_transchng,udh});
set(ud.transedt,'callback',{@i_transchng,udh});
set(ud.transbs,'callback',{@i_transbs,udh});
set(ud.covarpop,'callback',{@i_covarchng,udh});
set(ud.corrpop,'callback',{@i_corrchng,udh});

% layouts
flw1=xregframetitlelayout(figh,'packstatus','off',...
    'title','Local model class',...
    'center',ud.modellist);

% fancy stats options (cov, corr, transform)
grd=xreggridbaglayout(figh,...
    'dimension',[2 6],...
    'elements',{...
        text2,ud.transbs,...
        ud.transpop,[],...
        ud.transedt,[],...
        [],[],...
        text3,text4,...
        ud.covarpop,ud.corrpop},...
    'mergeblock',{[2 2],[1 2],[2 2],[2 3]},...
    'gapy',10,...
    'gapx',5,...
    'colsizes',[80 -1 -1 10 100 -1],...
    'rowsizes',[20,20]);
covFrame = xregframetitlelayout(figh,...
    'title','Covariance modeling',...
    'center',grd);

% cards for model specific stuff
ud.crd=xregcardlayout(figh,'numcards',length(ud.classfuncs));
frm=xregframetitlelayout(figh,...
    'title','Model specific options',...
    'innerborder',[15 10 10 10],...
    'center',ud.crd);

lytMOD=xreggridbaglayout(figh,...
    'dimension',[2,2],...
    'correctalg','on',...
    'rowsizes',[150,-1],...
    'gapy',10,...
    'gapx',10,...
    'elements',{flw1,covFrame,frm,[]});
merge(lytMOD,[2,2],[1,2]);

MODtab = xregborderlayout(figh,...
    'center',lytMOD,...
    'border',[10 10 10 10]);


% -----------------BUILD THE RESPFEAT LAYOUT-----------------
% number of rfs this model currently has
ud.rfno= numfeats(m);

% title
listtext=xreguicontrol('style','text',...
   'visible','off',...
   'parent',figh,...
   'horiz','left',...
   'fontweight','demi',...
   'string','Current response features:');

%% the listeditor
listEd =  xregGui.listeditor(figh,'visible','off');
listEd.BackgroundColor = [1 1 1];
listEd.AddItemFcn = {@i_addRF,udh};
listEd.DeleteItemFcn = {@i_deleteRF,udh};
listEd.AddItemMode = 'unboundlist';
listEd.NewItemTemplate = 'newRF%d';
listEd.ListSelectionFcn = {@i_selectFcn,udh};
listEd.ListReorderFcn = {@i_ListReorderFcn,udh};
% listEd.fontSize=10;
% listEd.fontweight='demi';

ud.listEd= listEd;

% can we resonstruct? text
ud.reconstruct=xreguicontrol('style','text',...
   'visible','off',...
    'parent',figh,...
    'horiz','left',...
    'string','Two-stage reconstruction possible: NO');
% restore default rfs button
ud.defaults=xreguicontrol('style','push',...
   'visible','off',...
    'parent',figh,...
    'string','Default',...
    'callback',{@i_defaultRF,udh});

%% --lyt for left side of RF tab--
listgrd = xreggridlayout(figh,...
    'dimension',[3,1],...
    'elements',{listtext,listEd,ud.reconstruct},...
    'correctalg','on',...
    'rowsizes',[20,-1,20],...
    'gapy',5);
 
 
 %name of this rf
 ud.respnameTxt=xreguicontrol('style','text',...
    'visible','off',...
    'parent',figh,...
    'string','Name:',...
    'horizontalalignment','left');
 % list of all rfs
 ud.resplist=xreguicontrol('style','popupmenu',...
    'visible','off',...
    'backgroundcolor','w',...
    'parent',figh);
 % options stuff
 noopts=xreguicontrol('style','text',...
    'visible','off',...
    'parent',figh,...
    'string','No options are available for this response feature.',...
    'horizontalalignment','left');
 text1=xreguicontrol('style','text',...
    'visible','off',...
    'parent',figh,...
    'string','x value:',...
    'position',[0 0 70 15],...
    'horizontalalignment','left');
 for i= 1:nfactors(m) 
    ud.value(i)=xreguicontrol('style','edit',...
       'visible','off',...
       'parent',figh,...
       'backgroundcolor','w',...
       'position',[0 0 100 100]);
 end

% callbacks 
set(ud.resplist,'callback',{@i_changerf,udh});
set(ud.value,'callback',{@i_changevals,udh});

% options pane layout stuff

% f(x) value input edit box(es)
nRows = ceil(nfactors(m)/3);


c= reshape(1:nRows*3,[3,nRows]);
v= cell(size(c));
v(1:nf)= num2cell(ud.value);
v= v';
% v= ud.value(c(1:length(ud.value)));

valueGrd = xreggridlayout(figh,...
    'dimension',[nRows 3],...
    'elements',v,...
    'gap',5,...
    'correctalg','on',...
    'colsizes',[40 40 40],...
    'rowsizes',repmat(20,[1,nRows]));


flw1=xreggridlayout(figh,'dimension',[1 2],...
    'elements',{text1,valueGrd},...
    'correctalg','on',...
    'colsizes',[70, -1]);

ud.crdRF=xregcardlayout(figh,'numcards',2,'visible','off');
attach(ud.crdRF,noopts,1);
attach(ud.crdRF,flw1,2);

grb=xreggridbaglayout(figh,...
    'dimension',[2,2],...
    'colsizes',[70,-1],...
    'rowsizes',[20 -1],...
    'gapy',20,...
    'elements',{ud.respnameTxt,ud.crdRF,ud.resplist,[]});
merge(grb,[2 2],[1 2]);

frm2=xregframetitlelayout(figh,'title','Define selected response feature',...
    'center',grb,'visible','off');

% the rhs of the RF tab
lytRF=xreggridbaglayout(figh,...
    'correctalg','on',...
    'rowsizes',[-1, 25],...
    'colsizes',[90,-1],...
    'dimension',[2 2],...
    'elements',{frm2,ud.defaults,[],[]},...
    'border',[0 0 0 20],...
    'gapy',10);
merge(lytRF,[1 1],[1 2]);

% the whole RF layout
RFtab = xreggridlayout(figh,'dimension',[1,2],...
    'correctalg','on',...
    'gapx',20,...
    'elements',{listgrd,lytRF},...
    'border',[10 10 10 10]);

%% PUT THE MODEL TAB AND RF TAB TOGETHER
attach(tabs,MODtab,1);
attach(tabs,RFtab,2);
set(tabs,'packstatus','on',...
    'callback',{@i_tabcallback,udh});

% somehow the listeditor doesn't pack properly so we do it here
repack(RFtab);

ud=i_setvalues(ud,p);
%% save it all
set(udh,'userdata',ud);
return




%=================================================
%   subfunction i_setvalues
%=================================================
function ud=i_setvalues(ud,p)
%% setup the Model tab
%% controls enable on/off and lists depend on the lcoal model

m=p.info;

% model class
% class options
modeltps= ud.modeltps;

clsval=find(strcmp(lmgroup(m),ud.lmgroups));
if isempty(clsval)
    % have to setup default model
    % now allows cell expansion
    if isa(ud.classfuncs{1},'cell')
        mnew = feval(ud.classfuncs{1}{:});
    else
        mnew = feval(ud.classfuncs{1});
    end
    m= copymodel(m,mnew);
    p.info=m;
    clsval=1;
end
if clsval>length(modeltps)
    % DOH!  This combination is not valid - set to polynomial
    h=errordlg(['The combination of options in this model is not valid.  ',...
            'Growth models should not have a datum type set.  The model class is ',...
            'being reset to a Polynomial.'],'Error');
    waitfor(h);
    m= localpoly;
    p.info=m;
    clsval=1;
end
set(ud.modellist,'value',clsval,'string',modeltps);

% transform
Tstr= char(get(m,'ytrans'));
if isempty(Tstr)
    set(ud.transpop,'value',1);
    set(ud.transedt,'visible','off');
    set(ud.transbs,'enable','off','value',0);
else
    TNo= strmatch(Tstr,ud.transfrms,'exact');
    if ~isempty(TNo)
        set(ud.transpop,'value',TNo);
        set(ud.transedt,'visible','off');
    else
        set(ud.transpop,'value',length(ud.transfrms));
        set(ud.transedt,'visible','on');
        set(ud.transedt,'string',char(sym(get(m,'ytrans'))));
    end
    
    % transform bs
    if supportTBS(m)
        set(ud.transbs,'enable','on','value',get(m,'tbs'));
    else
        set(ud.transbs,'enable','off','value',0);
    end
    
end

% covariance model
set(ud.covarpop,'value',gls_wlist(covmodel(m)));
set(ud.corrpop,'value',gls_clist(covmodel(m)));


% create appropriate layout for model options
if ~ud.optsdone(clsval)
    % create and attach layout
    lyt=gui_localmodopts(m,'layout',ud.figh,p);
    attach(ud.crd,lyt,clsval);
    set(lyt,'packstatus','on');
    ud.optsdone(clsval)=1;
else
    % update
    lyt=getcard(ud.crd,clsval);
    lyt=lyt{1};
    lyt=gui_localmodopts(m,'layout',lyt,p);
end

% show correct card
set(ud.crd,'currentcard',clsval);

i_setvaluesRF(ud,p);
return

%=================================================
%   subfunction i_setvaluesRF
%=================================================
function i_setvaluesRF(ud,p)
%% SETUP RF TAB for the current local model (as selected on the model tab)

m=p.info;

% available features for this model
flist=DatumDisplay(m,features(m));
allRFnames={flist.Display};
% the rfs we currently have for this model
LFeats= get(m,'features');
rfno = ud.rfno;
if rfno>length(LFeats)
   rfno=length(LFeats);
end

if rfno>0
    Nind= strmatch(lower(LFeats(rfno).Display),lower(allRFnames),'exact');
else
    Nind=1;
end
if isempty(Nind), Nind=1; end;
top= max(1,Nind-5);

%% put possible rfnames into listbox
set(ud.resplist,'string',allRFnames,'value',Nind,'listboxtop',top)
if rfno>0
    set(ud.resplist,'enable','on')
else
    set(ud.resplist,'enable','off')
end
% change default addition to listeditor
%% change the list of RFs shown in the listeditor
names = RespFeatName(m);
ud.listEd.itemlist = names;
ud.listEd.NewItemTemplate = allRFnames{end};


% CLEAR THE LISTEDITOR OF OLD RFS??

if rfno>0 && ~isempty(findstr(flist(Nind).Function,'Value'));
    % a value is used in this rf
   Value= get(m,'values');
   Value= num2cell(Value(rfno,:));
   set(ud.value(:),{'string'},Value(:));
   
   set(ud.crdRF,'currentcard',2);
else
   % no value used for this rf
   set(ud.value(:),'string',0);
   set(ud.crdRF,'currentcard',1);
end

return


%=================================================
%   subfunction i_classchng
%=================================================
function i_classchng(h,EventData,udh)
ud=get(udh,'userdata');
clsval=get(ud.modellist,'value');
m=ud.pointer.info;

if strcmp(ud.lmgroups{clsval},lmgroup(m))
    return
end

% now allows cell expansion
if isa(ud.classfuncs{clsval},'cell')
    newm = feval(ud.classfuncs{clsval}{:});
else
    newm = feval(ud.classfuncs{clsval});
end

% set up covariance model and datumtype from old selection
newm = covmodel(newm,covmodel(m));
if isempty(covmodel(m));
    set(newm,'fitalg','ols');
else
    set(newm,'fitalg','gls');
end
newm = set(newm,'datumtype',DatumType(m));
% copy across old model structure - pick up old ytrans settings
newm = copymodel(m,newm);
if ~supportTBS(newm);
    % class doesn't support TBS
    set(newm,'TBS',0);
    set(ud.transbs,'enable','off','value',0);
elseif get(ud.transpop,'value')>1
    % transform defined
    set(ud.transbs,'enable','on','value',isTBS(newm));
else
    % no transform defined
    set(ud.transbs,'enable','off','value',0);
end

ud.pointer.info=newm;

% create appropriate layout for model options
if ~ud.optsdone(clsval)
    % create and attach layout
    lyt=gui_localmodopts(newm,'layout',ud.figh,ud.pointer);
    attach(ud.crd,lyt,clsval);
    set(lyt,'packstatus','on');
    ud.optsdone(clsval)=1;
else
    % update
    lyt=getcard(ud.crd,clsval);
    lyt=lyt{1};
    lyt=gui_localmodopts(newm,'layout',lyt,ud.pointer);
end
% show correct card
set(ud.crd,'currentcard',clsval);

%% NOTE: RF tab will get set up for this model by i_tabcallback

set(udh,'userdata',ud);
return



%=================================================
%   subfunction i_transchng
%=================================================
function i_transchng(h,EventData,udh)
ud=get(udh,'userdata');
TNo=get(ud.transpop,'value');
m=ud.pointer.info;

% check an actual change is made
oldTstr=char(get(m,'ytrans'));
if strcmp(oldTstr,ud.transfrms(TNo))
    return
end

% Transform
ValidT=0;
switch TNo
case 1
    % No Transform
    ValidT=1;
    Tstr='';
case length(ud.transfrms)
    % Other Transform
    Tstr= get(ud.transedt,'string');
    try 
        symT= sym(Tstr);
        slist= findsym(symT);
        if ~isempty(slist)  & isempty(findstr(slist,','))
            finv=char(finverse(symT));
            if ~isempty(finv) & isempty(strmatch('RootOf',finv))
                ValidT= 1 ;
            end
        end
    catch
        % Invalid Transform
        Tstr= char(get(m,'ytrans'));
        set(ud.transedt,'string',Tstr);
    end
otherwise
    ValidT=1;
    Tstr= ud.transfrms{TNo};
end

if ValidT 
    set(m,'ytrans',Tstr);
    ud.pointer.info=m;
end   

if TNo==length(ud.transfrms)
    % set edit box on
    set(ud.transedt,'visible','on');
else
    set(ud.transedt,'visible','off');
end
if TNo>1 & supportTBS(m)
    % transform defined
    set(ud.transbs,'enable','on','value',isTBS(m));
else
    % no transform defined
    set(ud.transbs,'enable','off','value',0);
end

return



%=================================================
%   subfunction i_covarchng
%=================================================
function i_covarchng(h,EventData,udh)
ud=get(udh,'userdata');
m=ud.pointer.info;
% covariance models
c=  gls_wlist(covmodel(m),get(ud.covarpop,'value'));
m= covmodel(m,c);

if isempty(c);
    set(m,'fitalg','ols');
else
    set(m,'fitalg','gls');
end
ud.pointer.info=m;
return



%=================================================
%   subfunction i_transbs
%=================================================
function i_transbs(h,EventData,udh)
ud=get(udh,'userdata');

m=ud.pointer.info;
set(m,'tbs',get(ud.transbs,'value'));
ud.pointer.info=m;
return



%=================================================
%   subfunction i_corrchng
%=================================================
function i_corrchng(h,EventData,udh)
ud=get(udh,'userdata');
m =ud.pointer.info;
% correlation models
c=  gls_clist(covmodel(m),get(ud.corrpop,'value'),ud.Ts);
m=  covmodel(m,c);

if isempty(c);
    set(m,'fitalg','ols');
else
    set(m,'fitalg','gls');
end


ud.pointer.info=m;
return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                            THE RF CALLBACKS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%=================================================
%   subfunction i_changerf
%=================================================
function i_changerf(h,EventData,udh)
%% callback from the listbox of all rfs available

% swap to new response feature type
ud=get(udh,'userdata');
i_change(ud.pointer.info,ud);

return


%=================================================
%   subfunction i_changevals
%=================================================
function i_changevals(h,EventData,udh)
%% callback from the edit box that takes a value for e.g. f'(x)

% swap to new response feature type
ud=get(udh,'userdata');
i_change(ud.pointer.info,ud);

return


%=================================================
%   subfunction i_change
%=================================================
function i_change(lm,ud)
%% any RF changes come to this function to change the rfs of the model

listEd = ud.listEd;

% current number of RFs
RFno = listEd.SelectedItem;

%% index in the list we have chosen
Type= get(ud.resplist,'value');

% get values 
vals= get(ud.value,{'string'});
vals= sprintf('%10s ',vals{:});
Value= str2num(vals);

% check values 
if isempty(Value) | size(Value,2)>nfactors(lm)
   % reset ui values and exit
   p=xregpointer(lm);
   i_setvalues(ud,p,RFno);
   freeptr(p);
   return
end

Limits= [-Inf;Inf]; 
lm= EditFeat(lm,RFno,Value,Type,Limits);
ud.pointer.info=lm;

%% change the RF shown in the editbox above
names = RespFeatName(lm);
%% change the list of RFs shown in the listeditor
listEd.itemlist = names;

%% reconstruct message
i_reconstructOK([],[],ud,lm);
i_selectFcn([],[],ud.udh)


%=================================================
%   subfunction i_tabcallback
%=================================================
function i_tabcallback(src,null,udh)

ud = get(udh,'userdata');

if get(src,'currentcard')==1 & get(ud.transpop,'value')~=length(get(ud.transpop,'string'))
    % card sets everything vis on, so turn of userdefined transform edit
    set(ud.transedt,'visible','off');
elseif get(src,'currentcard')==2
    % update rf tab if we are about to see it
    i_setvaluesRF(ud,ud.pointer);
    i_selectFcn([],[],udh);
    i_reconstructOK([],[],ud,ud.pointer.info);
end

%=================================================
%   subfunction i_addRF
%=================================================
function i_addRF(src,null,udh)
%% add new RF - the default RF added to the model

ud = get(udh,'userdata');
set(ud.resplist,'enable','on')
%% listeditor adds new string into middle - we want it a the end
% this just chanegs around the strings in the listeditor
le = ud.listEd;
val = le.selecteditem;
vec=le.value;
addPos=find(val==vec);
vec(end+1)=vec(addPos);vec(addPos)=[];
le.value = vec;

% now add the new RF to the model
m = ud.pointer.info;
%% index in the list we have chosen
% get values 
vals= get(ud.value,{'string'});
vals= sprintf('%10s ',vals{:});
Value= str2num(vals);
Type= length(get(ud.resplist,'string'));
Limits= [-Inf;Inf]; 

%% add new RF onto end of the current RFs
m = AddFeat(m,Value,Type,Limits);
ud.pointer.info = m;

%% put the nice diplay names in the listeditor
le.itemlist = RespFeatName(m);

i_reconstructOK([],[],ud,m);
i_selectFcn([],[],udh);
return

%=================================================
%   subfunction i_deleteRF
%=================================================
function i_deleteRF(src,null,udh)
%% delete RF currently selected in listEditor
ud = get(udh,'userdata');
m = ud.pointer.info;

RFno = ud.listEd.SelectedItem;

%% NOTE: listeditor index changes before this fcn call
%% IF we just deleted the last RF its index will be RFno+1
curNames = RespFeatName(m);
newNames = ud.listEd.itemlist;
if RFno==0
    set(ud.resplist,'enable','off')    
end


if RFno==0 || ~strcmp(curNames{end},newNames{end}) % last item deleted
    RFno = RFno+1;
end

m = DelFeat(m,RFno);
ud.pointer.info = m;
i_reconstructOK([],[],ud,m);
i_selectFcn([],[],udh)
return


%=================================================
%   subfunction i_defaultRF
%=================================================
function i_defaultRF(src,null,udh)
%% return to default RFs

ud = get(udh,'userdata');

%% get model
m = ud.pointer.info;
% reset to default RFs
m = SetFeat(m,'default');
ud.pointer.info=m;

% update the RF tab to show this
i_setvaluesRF(ud,ud.pointer);
i_selectFcn([],[],udh)
i_reconstructOK([],[],ud,m);
return


%=================================================
%   subfunction i_reconstructOK
%=================================================
function i_reconstructOK(src,null,ud,m)
%% sets the string to say whether or not there RFs allow TS construction
if nargin<4
    m = ud.pointer.info;
end

if ~isempty(SelectRF(m))
    %cannot reconstruct
    set(ud.reconstruct,'string','Twostage reconstruction possible: YES');
else
    set(ud.reconstruct,'string','Twostage reconstruction possible: NO');
end


%=================================================
%   subfunction i_selectFcn
%=================================================
function i_selectFcn(src,null,udh)
%% 

ud = get(udh,'userdata');
m = ud.pointer.info;
%% indices of current RFs
RfInds = get(m,'feat.index');
ind = ud.listEd.SelectedItem;
% listbox to right rf
if ~isempty(RfInds) && ind>0
    set(ud.resplist,'value',RfInds(ind))
end

% name above listbox 
names=RespFeatName(m);
% value edit boxes
flist=DatumDisplay(m,features(m));
if ~isempty(RfInds) && ind>0 && ~isempty(findstr(flist(RfInds(ind)).Function,'Value'));
    % a value is used in this rf
     [v,s]=GetFeat(m,ind);
     set(ud.crdRF,'currentcard',2);
     
    set(ud.value(:),{'string'},cellstr(num2str(v(:))));

else
   % no value used for this rf
    set(ud.value(:),'string',0);
    set(ud.crdRF,'currentcard',1);
end

return


%=================================================
%   subfunction i_ListReorderFcn
%=================================================
function i_ListReorderFcn(src,null,udh)

ud = get(udh,'userdata');
m = ud.pointer.info;
le= ud.listEd;

%% the full list of available RFs as in the rhs list
allRFs=DatumDisplay(m,features(m));
allRFs={allRFs.Display};

myRFs=RespFeatName(m);
%% list of strings in listeditor (post change)
curlist = le.itemList(le.value);
Value=[];
for i = 1:length(myRFs)
    Value(i)=strcmp(myRFs{i},curlist{i});
end

%% indices of the two RFs that have changed around
ind=find(~Value);

% find 'Type' indices of there RFs in allRFs
[v1,s1]=GetFeat(m,ind(1));
t1=strmatch([s1.Display],allRFs,'exact');
[v2,s2]=GetFeat(m,ind(2));
t2=strmatch([s2.Display],allRFs,'exact');

Limits= [-Inf;Inf]; 
m= EditFeat(m,ind(1),v2,t2,Limits);
m= EditFeat(m,ind(2),v1,t1,Limits);
ud.pointer.info = m;

%% change the RF shown in the editbox above
names = RespFeatName(m);
%% change the list of RFs shown in the listeditor
le.itemlist = names;
le.value = [1:length(names)];
%% reconstruct message
i_reconstructOK([],[],ud,m);
i_selectFcn([],[],udh)

return
