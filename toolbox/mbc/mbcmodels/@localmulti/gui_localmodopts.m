function [m,ok]=gui_localmodopts(m,action,fig,p);
% GUI_LOCALMODOPTS  Local model options dialog
%
%   [M,OK]=GUI_LOCALMODOPTS(M) creates a modal dialog for setting up
%   options specific to the current local model class.  This function is
%   the default, creating a simple 'No options available dialog'.  Overload
%   it in local  models which have additional options such as spline order.
%
%   LYT=GUI_LOCALMODOPTS(M,'layout',FIG,P) creates and returns a layout in
%   figure FIG, based around altering the model in the pointer P.  This
%   interface must be supported by overloaded methods.  FIG may also be an
%   existing layout object in which case the layout is updated with fresh
%   information from the  model in P.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.6.4 $  $Date: 2004/04/04 03:29:40 $

if nargin<2
    action='figure';
end

switch lower(action)
case 'figure'
    [m,ok]=i_createfig(m);
case 'layout'
    m=i_createlyt(fig,p);
case 'mdlchng'
    i_mdlchng(fig); 
end




function [mout,ok]=i_createfig(m)

scsz=get(0,'screensize');
figh=figure('menubar','none',...
    'toolbar','none',...
    'numbertitle','off',...
    'name','Local Model Options',...
    'doublebuffer','on',...
    'renderer','zbuffer',...
    'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
    'position',[scsz(3).*0.5-125 scsz(4).*0.5-45 250 85],...
    'visible','off',...
    'color',get(0,'defaultuicontrolbackgroundcolor'),...
    'tag','LocalOpts',...
    'resize','off');

p=pointer(m);
lyt=i_createlyt(figh,p);

% ok and cancel buttons
okbtn = xreguicontrol('parent',figh,...
    'string','OK',...
    'visible','off',...
    'style','pushbutton',...
    'callback','set(gcbf,''tag'',''ok'');',...
    'position',[0 0 65 25]);
cancbtn = xreguicontrol('parent',figh,...
    'string','Cancel',...
    'visible','off',...
    'style','pushbutton',...
    'callback','set(gcbf,''tag'',''cancel'');',...
    'position',[0 0 65 25]);
flw=xregflowlayout(figh,'orientation','right/center',...
    'elements',{cancbtn,okbtn},...
    'border',[0 10 0 10]);
brd=xregborderlayout(figh,'center',lyt,'south',flw,...
    'innerborder',[10 45 10 10],...
    'container',figh,...
    'packstatus','on');

set(figh,'visible','on');
drawnow;
set(figh,'windowstyle','modal');

waitfor(figh,'tag');
tg=get(figh,'tag');
switch lower(tg)
case 'ok'
    mout=p.info
    ok=1;
case 'cancel'
    mout=m;
    ok=0;
end
freeptr(p);
delete(figh);
return



function lyt=i_createlyt(figh,p)

if ~isa(figh,'xregcontainer')
    ud.pointer=p;
    ud.figh=figh;
    
    
    text(1)=xreguicontrol('parent',figh,...
        'style','text',...
        'visible','off',...
        'string','Selection criteria:',...
        'horizontalalignment','left');
    text(2)=xreguicontrol('parent',figh,...
        'style','text',...
        'visible','off',...
        'string','Edit models:',...
        'horizontalalignment','left');
    text(3)=xreguicontrol('parent',figh,...
        'style','text',...
        'visible','off',...
        'string','Select model template:',...
        'horizontalalignment','left');
    
    
    ud.modelSelect=xreguicontrol('parent',figh,...
        'style','popupmenu',...
        'visible','off',...
        'backgroundcolor','w',...
        'interruptible','off');
     
    ud.modelsEdit=xreguicontrol('parent',figh,...
        'style','push',...
        'visible','off',...
        'string','Edit...',...
        'interruptible','off');
     ud.modelSetup=xreguicontrol('parent',figh,...
        'style','push',...
        'visible','off',...
        'string','Template...',...
        'interruptible','off');
    ud.modelString= axestext(figh,...
        'visible','off',...
        'fontsize',10,...
        'clipping','on',...
        'verticalalignment','middle');
    

    % data
    udh= ud.modelSetup;
    
    % callbacks
    set(ud.modelSelect,'callback',{@i_SelectCriteria,udh});
    set(ud.modelSetup,'callback',{@i_mdlchng,udh});
    set(ud.modelsEdit,'callback',{@i_mdlsEdit,udh});
    % note: below (in the ELSE) we find the handle to the button (holds userdata)
    % as the *last* element in the gblayout. Think if you change this
    lyt=xreggridbaglayout(figh,...
        'dimension',[5,3],...
        'rowsizes',[17, 20, -1, 25 25],...
        'colsizes',[10, -1, 80],...
        'mergeblock',{[1 1],[1,3]},...
        'mergeblock',{[2 2],[2,3]},...
        'mergeblock',{[4 4],[1,3]},...
        'mergeblock',{[5 5],[1,3]},...
        'elements',{...
            [],[],[],[],[],...
            [],[],text(1),text(2),text(3),...
            [],[],ud.modelSelect,ud.modelsEdit,ud.modelSetup});
    set(ud.modelSetup,'userdata',ud);
else %% get the userdata from the handle of the button
    el = get(figh,'elements');
    ud=get(el{end},'userdata');
    ud.pointer=p;
    set(el{end},'userdata',ud);
    lyt=figh;
end
i_setvalues(ud,p);
return



function i_setvalues(ud,p)


m=p.info;
xi= xinfo(m);
m= xinfo(m,xi);
yi= yinfo(m);
m= yinfo(m,yi);


p.info= m;
[s,sel]= childstats(m);
pos= find(strcmp(sel,m.Select));
set(ud.modelSelect,'string',sel,'value',pos);
set(ud.modelString,'string',str_func(m,1));

return


function i_mdlchng(h,EventData,udh)

ud=get(udh,'userdata');
m=ud.pointer.info;


[mlist,OK]=xreg_modeltemplates('create',m,100);

if OK
    
    Tgt= gettarget(m);
    g= repmat({''},nfactors(m),1);
    N= length(mlist);
    for i = 1:N;
        mi= mlist{i};
        % reset after copy model as rbf/reset requires this
        mlist{i}= reset(mi);
        
    end	

   % make xregmulti have the right number of models
   nmdls= get(m,'nmodels');
   for i=1:length(mlist)-nmdls
      m=add(m,mi);
   end
   for i=1:nmdls-length(mlist)
      m=remove(m,1);
   end
      
   [s,sel]= childstats(m);
   pos= find(strcmp(sel,m.Select));
   if isempty(pos)
      m.Select= 'RMSE';
      pos= find(strcmp(sel,m.Select));
   end
   set(ud.modelSelect,'string',sel,'value',pos);

   set(m,'allmodels',mlist);

   % m= completecopymodel(m);
   
   ud.pointer.info= m;
end

set(ud.modelString,'string',str_func(m,1));

return





function i_mdlsEdit(h,EventData,udh)

ud=get(udh,'userdata');
m=ud.pointer.info;

[m,ok] = gui_globalmodsetup(m, 'figure', 'AllowWeightEditing', false);
if ok
    m= completecopymodel(m);
    % check that the selection criteria is still valid
    [s,sel]= childstats(m);
    pos= find(strcmp(sel,m.Select));
    if isempty(pos)
        m.Select= 'RMSE';
        pos= find(strcmp(sel,m.Select));
    end
    set(ud.modelSelect,'string',sel,'value',pos);
    
    
    
    ud.pointer.info= m; 
    set(ud.modelString,'string',str_func(m,1));
    
    
end


function i_SelectCriteria(h,EventData,udh)

ud=get(udh,'userdata');
m=ud.pointer.info;

props= get(ud.modelSelect,{'string','value'});
m.Select= props{1}{props{2}};
ud.pointer.info= m; 

   
