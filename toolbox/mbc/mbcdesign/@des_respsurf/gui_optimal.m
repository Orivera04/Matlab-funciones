function [dout,ok]=gui_optimal(d,action,varargin)
%GUI_OPTIMAL  Gui for creating an optimal design
%
%  D=GUI_OPTIMAL(D) creates a gui for creating an optimal design
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.9.2.3 $  $Date: 2004/02/09 07:03:39 $



if nargin<2
    action='create';
end

switch lower(action)
    case 'create'
        [dout,ok]= i_createfig(d);
end
return




function [d,ok]=i_createfig(d)

sc=get(0,'screensize');
fig=xregfigure('name','Optimal Design',...
    'visible','off',...
    'position',[(sc(3)-385)*.5  (sc(4)-510)*.5  385 530],...
    'closerequestfcn','set(gcbf,''tag'',''cancel'');',...
    'resize','off');

saved_c=constraints(d);
ptr=xregGui.RunTimePointer(d);
lyt=i_createlyt(fig,ptr,saved_c);
set(lyt,'visible','on');

okbtn=uicontrol('parent',fig,...
    'style','pushbutton',...
    'string','OK',...
    'callback','set(gcbf,''tag'',''ok'');',...
    'interruptible','on');
cancelbtn=uicontrol('parent',fig,...
    'style','pushbutton',...
    'string','Cancel',...
    'callback','set(gcbf,''tag'',''cancel'');');
helpbtn=mv_helpbutton(fig,'xreg_desOptimal');

biglyt=xreggridbaglayout(fig,'dimension',[2 4],...
    'rowsizes',[-1 25],...
    'colsizes',[-1 65 65 65],...
    'gapx',7,...
    'gapy',10,...
    'border',[10 10 10 10],...
    'packstatus','off',...
    'mergeblock',{[1 1],[1 4]},...
    'elements',{lyt,[],[],okbtn,[],cancelbtn,[],helpbtn});

fig.LayoutManager=biglyt;
set(biglyt,'packstatus','on');

set(fig,'visible','on');
drawnow;
set(fig,'windowstyle','modal');

loop=1;
while loop
    d2=ptr.info;
    saved_c=constraints(d2);
    d2=constraints(d2,[],0);
    ptr.info=d2;
    waitfor(fig,'tag'); % block and wait for GUI to return
    tg=get(fig,'tag');
    if strcmp(tg,'ok')
        % attempt to finalise the dialog
        % push constraints in first to ensure initial design is correct
        d2=ptr.info;
        d2=constraints(d2,saved_c,0);
        d2=updatestores(d2);
        ptr.info=d2;
        pre_optim_d=d2;  % save a copy for reverting to
        msg=i_finalise(lyt);
        if ~isempty(msg)
            h=errordlg(msg,'Error','modal');
            waitfor(h);
            % loop back into modal dialog
            set(fig,'tag','');
        else
            d2=ptr.info;
            ok=1;
            loop=0;
        end
    else
        loop=0;
        ok=0;
    end
end
delete(fig);


if ok
    try
        % invoke optimisation with a dialog
        [d2,ok]=optimisedialog(d2);
    catch
        h=errordlg('Optimization failed.  Check that the initial design is not rank-deficient');
        ok=0;
    end
    % return d2 whatever - this keeps settings if they press OK, then Cancel
    if ok
        d=d2;
    else
        % revert to a copy made before the design was reinitialised, but after design optim
        % settings are made
        d=pre_optim_d;
        ok=1;  % make sure this is saved
    end
end
delete(ptr);
return



function lyt=i_createlyt(fig,ptr,opt_con)
if nargin<3
    opt_con=des_constraints;
end

udptr=xregGui.RunTimePointer;

ud.pointer=ptr;
ud.figure=fig;
des=ptr.info;

txt(1)=xreguicontrol('parent',fig,'visible','off',...
    'style','text',...
    'string','Optimality criteria:',...
    'enable','inactive',...
    'horizontalalignment','left');
ud.optpop=xreguicontrol('parent',fig,...
    'visible','off',...
    'style','popupmenu',...
    'backgroundcolor','w',...
    'string',{'D-Optimal','V-Optimal','A-Optimal'},...
    'callback',{@i_critchng,udptr});

ud.reset=gui_reset(des,'layout',fig,ptr);
ud.cand=gui_candspace(des,'layout',fig,ptr,'callback',{@i_candchange,udptr});
ud.alg=gui_optimset(des,'layout',fig,ptr);

% candidate set preview buttons
txt(2)=xreguicontrol('parent',fig,'visible','off',...
    'style','text',...
    'string','Display a maximum of',...
    'enable','inactive',...
    'horizontalalignment','left',...
    'visible','off');
txt(3)=xreguicontrol('parent',fig,'visible','off',...
    'style','text',...
    'string','points.',...
    'enable','inactive',...
    'horizontalalignment','left',...
    'visible','off');
ud.Npoints=xregGui.clickedit('parent',fig,...
    'visible','off',...
    'min',0,...
    'rule','int',...
    'clickincrement',50,...
    'dragincrement',10,...
    'value',2500,...
    'callback',{@i_NPmaxchange,udptr});
sc=xregGui.SystemColors;
ud.view(1)=uicontrol('parent',fig,...
    'visible','off',...
    'style','togglebutton',...
    'cdata',replacecolor(xregresload('1dgraph.bmp','bmp'),[0 255 0],double(sc.CTRL_BACK)),...
    'callback',{@i_vieweronoff,udptr,1},...
    'deletefcn',{@i_layoutdel,udptr},...
    'tooltip','1D projection');
ud.view(2)=xreguicontrol('parent',fig,...
    'visible','off',...
    'style','togglebutton',...
    'cdata',replacecolor(xregresload('2dgraph.bmp','bmp'),[0 255 0],double(sc.CTRL_BACK)),...
    'callback',{@i_vieweronoff,udptr,2},...
    'tooltip','2D projection');
ud.view(3)=xreguicontrol('parent',fig,...
    'visible','off',...
    'style','togglebutton',...
    'cdata',replacecolor(xregresload('3dgraph.bmp','bmp'),[0 255 0],double(sc.CTRL_BACK)),...
    'callback',{@i_vieweronoff,udptr,3},...
    'tooltip','3D projection');
ud.view(4)=xreguicontrol('parent',fig,...
    'visible','off',...
    'style','togglebutton',...
    'cdata',replacecolor(xregresload('4dgraph.bmp','bmp'),[0 255 0],double(sc.CTRL_BACK)),...
    'callback',{@i_vieweronoff,udptr,4},...
    'tooltip','4D projection');

ud.candviewfigs=[0 0 0 0];

% constraints information
txt(4)=xreguicontrol('parent',fig,'visible','off',...
    'style','text',...
    'enable','inactive',...
    'horizontalalignment','left',...
    'visible','off');
NCons=length(opt_con);
if NCons==1
    set(txt(4),'string',sprintf('%d constraint will be applied to this candidate set.',NCons));
else
    set(txt(4),'string',sprintf('%d constraints will be applied to this candidate set.',NCons));
end

grd = xreggridbaglayout(fig,'dimension',[5 9],...
    'packstatus','off',...
    'rowsizes',[2 3 15 2 3],...
    'colsizes',[25 25 25 25 15 110 60 5 30],...
    'mergeblock',{[1 5],[1 1]},...
    'mergeblock',{[1 5],[2 2]},...
    'mergeblock',{[1 5],[3 3]},...
    'mergeblock',{[1 5],[4 4]},...
    'mergeblock',{[2 4],[7 7]},...
    'elements',{ud.view(1),ud.view(2),ud.view(3),ud.view(4),[],[],[],[],[];...
    [],[],[],[],[],[],ud.Npoints,[],[];...
    [],[],[],[],[],txt(2),[],[],txt(3);...
    [],[],[],[],[],[],[],[],[];...
    [],[],[],[],[],[],[],[],[]});
frm = xregframetitlelayout(fig,'title','Display',...
    'visible','off',...
    'center',grd,...
    'innerborder',[15 10 10 10]);
candlyt = xreggridlayout(fig,'correctalg','on',...
    'dimension',[3 1],...
    'elements',{ud.cand,frm,txt(4)},...
    'gapy',10,...
    'rowsizes',[-1 56 15]);
tblyt = xregtablayout2(fig,'numcards',3,...
    'packstatus','off',...
    'visible','off',...
    'innerborder',[10 10 10 10],...
    'tablabels',{'Initial Design','Candidate Set','Algorithm'});
attach(tblyt,ud.reset,1);
attach(tblyt,candlyt,2);
attach(tblyt,ud.alg,3);
lyt = xreggridbaglayout(fig,'dimension',[5 3],...
    'colratios',[0 2 1],...
    'colsizes',[90 -1 -1],...
    'rowsizes',[3 15 2 10 -1],...
    'gapx',10,...
    'mergeblock',{[1 3],[2 2]},...
    'mergeblock',{[5 5],[1 3]},...
    'elements',{[],txt(1),[],[],tblyt,ud.optpop},...
    'userdata',udptr);
udptr.info = ud;
i_setvalues(udptr);
return


function i_setvalues(ptr)
ud=ptr.info;
p=ud.pointer;
optset=getoptimiser(p.info);
val=find(strcmp(lower(optset),{'d-optimal','v-optimal','a-optimal'}));
set(ud.optpop,'value',val)
return


function i_critchng(src,evt,ptr)
ud=ptr.info;
val=get(ud.optpop,'value');
str=get(ud.optpop,'string');
str=lower(str{val});
ud.pointer.info = setoptimiser(ud.pointer.info,str);
return


function i_candchange(src,evt,ptr)
ud=ptr.info;
% affects the info display on alg page
gui_optimset(ud.pointer.info,'layout',ud.alg,ud.pointer);
% need to update open viewers
for n=1:length(ud.candviewfigs)
    if ud.candviewfigs(n)
        set(ud.figure,'pointer','watch');
        previewcand(ud.pointer.info,n,get(ud.Npoints,'value'),'update',ud.candviewfigs(n));
        set(ud.figure,'pointer','arrow');
    end
end
return


function msg=i_finalise(lyt)
ptr=get(lyt,'userdata');
ud=ptr.info;
% finalise reset gui
msg=gui_reset(ud.pointer.info,'finalise',ud.reset);
if ~msg
    msg=['Unable to initialize design.  Check that you have not over-constrained the candidate set',...
        ' or specified a candidate set with insufficient points to support the model.'];
else
    msg='';
end
return


function i_vieweronoff(src,evt,ptr,N)
ud=ptr.info;
if ud.candviewfigs(N)
    %close figure
    delete(ud.candviewfigs(N));
    ud.candviewfigs(N)=0;
else
    %create figure
    set(ud.figure,'pointer','watch');
    ud.candviewfigs(N)=previewcand(ud.pointer.info,N,get(ud.Npoints,'value'));
    set(ud.figure,'pointer','arrow');
    % attach listener for figure deletion.
    set(ud.candviewfigs(N),'deletefcn',{@i_delfig,ptr,N});
end
ptr.info=ud;
return


function i_delfig(src,evt,ptr,N)
ud=ptr.info;
if ~isBeingDestroyed(ud.figure)
    ud.candviewfigs(N)=0;
    set(ud.view(N),'value',0);
    ptr.info=ud;
end
return


function i_layoutdel(src,evt,ptr)
ud=ptr.info;
% close all open viewers
for n=1:length(ud.candviewfigs)
    if ud.candviewfigs(n)
        delete(ud.candviewfigs(n));
    end
end
return

function i_NPmaxchange(src,evt,ptr)
ud=ptr.info;
% need to update open viewers
for n=1:length(ud.candviewfigs)
    if ud.candviewfigs(n)
        set(ud.figure,'pointer','watch');
        previewcand(ud.pointer.info,n,get(ud.Npoints,'value'),'update',ud.candviewfigs(n));
        set(ud.figure,'pointer','arrow');
    end
end
return