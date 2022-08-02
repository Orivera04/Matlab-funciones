function ud = draw(d,ax,Enable,T)
%DRAW Draw hierarchy diagram editor
%
%  ud = draw(d,ax,Enable)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.6 $  $Date: 2004/04/12 23:34:31 $

if nargin==1
    ax=gca;
end
if nargin<=2
    Enable= 1;
end

delete(allchild(ax));
set(ax,'defaultRectangleBusyAction','cancel');
hFig= get(ax,'parent');

% context menu for model blocks
uc_model = findobj(hFig,'type','uicontextmenu','tag','xregtpdiag');
if isempty(uc_model)
    uc_model = uicontextmenu('parent',hFig,'tag','xregtpdiag');
    str = {'&Set Up Model...', 'Design &Experiment', 'View &Design Data', 'View &Model', 'Summary Statistics'};
    cb = {@i_SetupModel, @i_Design, @i_ViewDesign, @i_ViewModel, @i_SummaryStats};
    for n = 1:length(str)
        u(n) = uimenu('Parent',uc_model,...
            'Label',str{n},...
            'CallBack',cb{n});
    end
else
    u= get(uc_model,'children');
    u= u(end:-1:1);
end
if IsMatched(T)
    set(u(3),'enable','on');
else
    set(u(3),'enable','off');
end

uc_inports = findobj(hFig,'type','uicontextmenu','tag','xregtpinports');
if isempty(uc_inports)
    uc_inports = uicontextmenu('parent',hFig,'tag','xregtpinports');
    uimenu('parent', uc_inports, 'label', '&Set Up Inputs...', 'Callback', @i_Inputs);
end

uc_outport = findobj(hFig,'type','uicontextmenu','tag','xregtpoutport');
if isempty(uc_outport)
    uc_outport = uicontextmenu('parent',hFig,'tag','xregtpoutport');
    uimenu('parent', uc_outport, 'label', '&New Response Model...', 'Callback', @i_ResponseContext);
end

ud.Menu= u;

ud.Enable= Enable;

N= length(d);
D= DesignDev2Cell(d);

ht= (diff(get(ax,'ylim'))/(N+1));
wid= diff(get(ax,'xlim'));

xp= 0.9-0.1/N;
ip= 0.05; % 0.35-0.1/N;

% colors for blockdiagram
Colors.BackGround= [1 1 1];
Colors.Port     = [240 150 150]/255;  % in and out ports
Colors.Model    = [120 180 220]/255;  % model block
Colors.Selected  = [220 220 170]/255; % blocks when selected

ud.Colors= Colors;
% border
h= rectangle('parent',ax,...
    'facecolor',Colors.BackGround,...
    'edgecolor',[0 0 0],...
    'position',[(ip+0.15)*wid ht*.2  0.8*wid ht*(N+0.3)]);

if N==2
    ud.StageNames= {'Local','Global'};
else
    ud.StageNames= {''};
end

for i=N:-1:1

    xp= xp-0.2;
    % ip= ip-0.1;
    Stage= N-i+1;

    m= getModel(D{Stage});

    % inports for defining Stage Input Factors
    ud.pBorder(Stage)= line('parent',ax,...
        'color','w',...
        'xdata',wid*[ip ip ip+0.1 ip+0.1 ip],...
        'ydata',ht*[(i-0.15)  i+0.15 i+0.15 i-0.15 i-0.15]);
    ud.hInput(Stage)= rectangle('parent',ax,...
        'facecolor',Colors.Port,...
        'buttondownfcn',{@i_Inputs,Stage},...
        'UIContextMenu', uc_inports, ...
        'position',[ip*wid ht*(i-0.15)  0.1*wid ht*.3],...
        'UserData',Stage,...
        'curvature',[0.75 0.75]);

    % Stage Label on inport
    text('parent',ax,...
        'position',[(ip+.05)*wid ht*i],...
        'HorizontalAlignment','Center',...
        'hittest','off',...
        'string',int2str(Stage));
    if ~isempty(ud.StageNames{Stage})
        lab= sprintf('%s\nInputs',ud.StageNames{Stage});
    else
        lab= 'Inputs';
    end
    text('parent',ax,...
        'pos',[(ip+.05)*wid ht*(i+0.18)],...
        'VerticalAlignment','Bottom',...
        'HorizontalAlignment','Center',...
        'hittest','off',...
        'string',lab);

    % line joining inputs to model block
    line('parent',ax,...
        'linewidth',3,...
        'xdata',[(ip+0.1) xp]*wid,...
        'ydata',[ht*i ht*i]);
    h= drawarrow(ax,[xp*wid,ht*i 0.02*wid 0.05*ht],0);

    % model block

    lab= [ud.StageNames{Stage}, ' Model'];

    text('parent',ax,...
        'pos',[(xp+0.1)*wid ht*(i+0.26)],...
        'VerticalAlignment','Bottom',...
        'HorizontalAlignment','Center',...
        'hittest','off',...
        'string',lab);

    ud.hStage(Stage)= rectangle('parent',ax,...
        'buttondownfcn',{@i_Select,Stage},...
        'facecolor',Colors.Model,...
        'UserData',Stage,...
        'uicontextmenu',uc_model,...
        'position',[xp*wid  ht*(i-0.25)  0.2*wid ht*.5]);
    ud.hBorder(Stage)= line('parent',ax,...
        'color','k',...
        'xdata',wid*[xp xp xp+0.2 xp+0.2 xp],...
        'ydata',ht*[(i-0.25)  i+0.25 i+0.25 i-0.25 i-0.25]);

    % input labels
    str= InputLabels(m);
    ud.InpLabels(Stage) = text('parent',ax,...
        'interpreter','none',...
        'FontSize',8,...
        'pos',[(ip+0.16)*wid ht*(i-0.05)],...
        'hittest','off',...
        'VerticalAlignment','Top',...
        'clipping','on',...
        'string',sprintf('%s\n',str{:}));


    % model name
    ud.hModel(Stage)= text('parent',ax,...
        'string',name(m),...
        'hittest','off',...
        'HorizontalAlignment','center',...
        'VerticalAlignment','middle',...
        'interpreter','none',...
        'position',[(xp+0.1)*wid  ht*i]);

    if Stage~=1
        % join stages for higher levels
        line('parent',ax,...
            'linewidth',3,...
            'xdata',[xp+0.2 xp+0.3 xp+0.3]*wid,...
            'ydata',[ht*i ht*i ht*(i+0.75)]);
        h= drawarrow(ax,[(xp+0.3)*wid,ht*(i+0.75),0.05*ht 0.02*wid],1);
    else
        % level 1 has a normal output
        line('parent',ax,...
            'linewidth',3,...
            'xdata',[xp+0.2 ip+1]*wid,...
            'ydata',[ht*i ht*i]);
        h= drawarrow(ax,[(ip+1)*wid,ht*(i),0.02*wid 0.05*ht],0);

        % response outport
        ud.pBorder(N+1)= line('parent',ax,...
            'color','w',...
            'xdata',wid*[ip+1 ip+1 ip+1.1 ip+1.1 ip+1],...
            'ydata',ht*[(i-0.15)  i+0.15 i+0.15 i-0.15 i-0.15]);
        ud.Models= rectangle('parent',ax,...
            'buttondownFcn',@i_ResponseClick,...
            'UIContextMenu', uc_outport, ...
            'facecolor',Colors.Port,...
            'position',[(ip+1)*wid , ht*(i-0.15) , 0.1*wid , ht*.3],...
            'curvature',[0.75 0.75]);
        text('parent',ax,...
            'position',[(ip+1.05)*wid , ht*(i)],...
            'VerticalAlignment','Middle',...
            'HorizontalAlignment','Center',...
            'hittest','off',...
            'string',int2str(Stage));

        % responese labels
        str= ResponseLabels(T);
        ud.Responses= text('parent',ax,...
            'position',[(ip+0.94)*wid , ht*(i-0.27)],...
            'interpreter','none',...
            'VerticalAlignment','Top',...
            'HorizontalAlignment','Right',...
            'hittest','off',...
            'clipping','on',...
            'string',sprintf('%s\n',str{:}));
        text('parent',ax,...
            'position',[(ip+1.05)*wid , ht*(i+0.18)],...
            'interpreter','none',...
            'VerticalAlignment','Bottom',...
            'HorizontalAlignment','Center',...
            'hittest','off',...
            'string','Responses');
    end
end

% select outer stage input port


set(ax,'xlim',[0 wid*(ip+1.15)]);
if N==1
    set(ax,'ylim',[0 ht*(2+0.7)]-ht/2);
else
    set(ax,'ylim',[0 ht*(N+0.75)]);
end
set(ax,'ylim',[0 ht*(N+0.75)]);
yht= get(ax,'ylim');

if IsMatched(T) || hasRespModels(T)
    set(ud.pBorder(end),'selected','on');
else
    m= getModel(d);
    s= get(m,'symbols');
    if length(s)==1 && ismember(s{1},{'L1','G1','X1'})
        set(ud.pBorder(N),'selected','on');
    else
        set(ud.hBorder(N),'selected','on');
    end
end


ud.msg= text('parent',ax,...
    'position',[0.02*wid , yht(2)-ht*0.025],...
    'VerticalAlignment','Top',...
    'HorizontalAlignment','left',...
    'hittest','off',...
    'string',i_Message(ud,address(T)));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   drawarrow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function h= drawarrow(ax,pos,up)

s= pos(3:4);
pos= pos(1:2);
if up
    s= s([2 1]);
    xp= [pos(1)-s(1) pos(1)+s(1) pos(1) pos(1)-s(1)];
    yp= [pos(2)-s(2) pos(2)-s(2) pos(2) pos(2)-s(2)];
else
    xp= [pos(1)-s(1) pos(1)-s(1) pos(1) pos(1)-s(1)];
    yp= [pos(2)-s(2) pos(2)+s(2) pos(2) pos(2)-s(2)];
end

h= patch('parent',ax,'xdata',xp,'ydata',yp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   i_GetDesignDev
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function d= i_GetDesignDev(Stage)

% store in base workspace for now
p= get(MBrowser,'CurrentNode');

d= p.designdev;
if nargin
    d= DesignDev2Cell(d);
    d= d{Stage};
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   i_PutDesignDev
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_PutDesignDev(ds,Stage)

% store in base workspace for now

p= get(MBrowser,'CurrentNode');
d= p.designdev;

d= DesignDev2Cell(d);
d{Stage}=ds;
d= Cell2DesignDev(d);

p.designdev(d);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   i_FindDOE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [hDOE,hAutoMatch]= i_FindDOE

hDOE       = findobj(allchild(0),'flat','tag','DOEeditor','visible','on');
hAutoMatch = findobj(allchild(0),'flat','tag','dataEditor','visible','on');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   i_Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_Inputs(h,EventData,Stage)

if nargin<3
    Stage = get(gco, 'Userdata');
end
mbH= MBrowser;
p= get(mbH,'CurrentNode');
View= mbH.GetViewData;

if ~any(strcmp(get(View.hHSM.pBorder,'selected'),'on'))
    i_HighLight(Stage)
end
set(View.hHSM.pBorder,'Selected','off')
set(View.hHSM.hBorder,'selected','off');


set(View.hHSM.pBorder(Stage),'Selected','on')
set(View.hHSM.msg,'string',i_Message(View.hHSM,p));

p.EnableMenus(View);


if nargin==3 && ~strcmp(get(gcbf,'selectiontype'),'open')
    return
end


[hDOE,hAutoMatch]= i_FindDOE;

ReadOnly= p.IsMatched || ~isempty(hDOE) || ~isempty(hAutoMatch);


d= i_GetDesignDev(Stage);
m= getModel(d);

% factor gui
xregm= copymodel(m,xregmodel('nfactors',nfactors(m)));


% selected color for port
set(View.hHSM.hInput(Stage),'facecolor',View.hHSM.Colors.Selected);

set(mbH.Figure,'pointer','watch');

if ~isempty(View.hHSM.StageNames{Stage})
    Title= sprintf('%s Input Factor Setup',View.hHSM.StageNames{Stage});
else
    Title= 'Input Factor Set Up';
end
[xregm,OK]= gui_InputSetup2(xregm,'figure',~ReadOnly,Title);
set(mbH.Figure,'pointer',get(0,'DefaultFigurePointer'));

% normal color for port
set(View.hHSM.hInput(Stage),'facecolor',View.hHSM.Colors.Port);


if OK
    if nfactors(m)==nfactors(xregm);
        m= copymodel(xregm,m);
    else
        DDev= p.designdev;
        defm=	xregcubic( ones(1,nfactors(xregm))*2);
        if Stage< length(DDev)
            defm= localsurface(defm);
        end
        m= copymodel(xregm,defm);
        set(View.hHSM.hModel(Stage),'string',name(m))
    end
    d= UpdateModels(d,m);
    set( View.hHSM.InpLabels(Stage),'string',InputLabels(m));
    i_PutDesignDev(d,Stage);
    p.DisplaySizes(View);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   i_Design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_Design(h,EventData,Stage)
mbH= MBrowser;
p= get(mbH,'CurrentNode');
View= mbH.GetViewData;
if nargin<3
    Stage= get(gco,'userdata');
end
d= i_GetDesignDev(Stage);

if ~any(strcmp(get(View.hHSM.hBorder,'selected'),'on'))
    i_HighLight(Stage)
end


[hDOE,hAutoMatch]= i_FindDOE;
if ~isempty(hAutoMatch)
    xregerror('Error','The design editor cannot be used while the data selection figure is open');
    return
end



if isempty(hDOE)
    % create a design editor
    D= i_GetDesignDev;
    NStages= length(D);
    hDOE=xregdesigneditor;
    xregdesigneditor(hDOE,'loadtree',d.DesignTree,'closefcn',{@i_DEclose,Stage},...
        'numberofstages',NStages,'currentstage',Stage);
else
    hDOE_Stage=xregdesigneditor(hDOE,'getcurrentstage',[]);
    if hDOE_Stage~=Stage
        % switch design editor's design stage
        i_DEclose(hDOE,[],hDOE_Stage);
        D= i_GetDesignDev;
        NStages= length(D);
        hDOE=xregdesigneditor;
        xregdesigneditor(hDOE,'loadtree',d.DesignTree,'closefcn',{@i_DEclose,Stage},...
            'numberofstages',NStages,'currentstage',Stage);
    else
        % push figure to foreground
        figure(hDOE);
    end
end

if length(p.designdev)>1
    set(hDOE,'Name',['Design Editor - [',p.name,  ' (',View.hHSM.StageNames{Stage},')]']);
else
    set(hDOE,'Name',['Design Editor - [',p.name,']']);
end
RegisterSubFigure(mbH,double(hDOE));
return



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   i_DEClose
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_DEclose(hDOE,evt,Stage)

mbH= MBrowser;
View= mbH.GetViewData;

d= i_GetDesignDev(Stage);

% grab a copy of the design tree
dtree=xregdesigneditor(hDOE,'savetree',[]);

OldTree= d.DesignTree;
OldDes= factorsettings(getdesign(d));
NewDes= factorsettings(dtree.designs{dtree.chosen});

if OldTree.chosen ~= dtree.chosen || size(OldDes,1)~=size(NewDes,1) || any(OldDes(:)~=NewDes(:))
    % make best design model the default
    m = model(dtree.designs{dtree.chosen});
    dtree.designs{1}= model(dtree.designs{1},m);

    % display name of model
    set(View.hHSM.hModel(Stage),'string',name(m))
end

d.DesignTree= dtree;
i_PutDesignDev(d,Stage);

return


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   i_SetupModel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_SetupModel(h,EventData,Stage)

D= i_GetDesignDev;
if nargin<3
    Stage= get(gco,'userdata');
end

[hDOE,hAutoMatch]= i_FindDOE;
if ~isempty(hDOE) || ~isempty(hAutoMatch)
    xregerror('Error','The model cannot be setup while the design editor or the data selection figure is open');
    return
end
mbH= MBrowser;
View= mbH.GetViewData;
if ~any(strcmp(get(View.hHSM.hBorder,'selected'),'on'))
    i_HighLight(Stage)
end

d= subsref(D,substruct('()',{Stage}));
m= getModel(d);

set(View.hHSM.hStage(Stage),'facecolor',View.hHSM.Colors.Selected);
drawnow('expose');
% setup gui
if Stage>1
    [m,OK]= gui_ModelSetup(m,'criteria','global');
else
    [m,OK]= gui_ModelSetup(m);
end
set(View.hHSM.hStage(Stage),'facecolor',View.hHSM.Colors.Model);
set(View.hHSM.hModel(Stage),'string',name(m))
if OK
    d= setmodel(d,m);
    i_PutDesignDev(d,Stage);
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_ViewDesign
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_ViewDesign(h,evt,Stage)

if nargin<3
    Stage= get(gco,'userdata');
end

mbH= MBrowser;
p= get(mbH,'CurrentNode');
View= mbH.GetViewData;

D= i_GetDesignDev;
NStages= length(D);
d= i_GetDesignDev(Stage);

dtree= d.DesignTree;
if dtree.chosen
    if Stage < NStages

        if p.IsMatched
            % get the data
            X= p.getdata('X',0);
            X=X{Stage};

            des= dtree.designs{dtree.chosen};
            m= model(des);
            dtree.designs= dtree.designs(1);
            tn= testnum(X);
            for i= 1:size(X,3)
                des= reinit(des,code(m,X{i}));
                des= name(des,sprintf('Test %2d',tn(i)));
                dtree.designs=[dtree.designs,{des}];
            end

            dtree.parents=[0,ones(1,size(X,3))];
            d.DesignTree= dtree;
        end
    else
        if p.IsMatched
            X= p.getdata('X',0);
            if iscell(X)
                X=X{end};
            end
            des= dtree.designs{dtree.chosen};
            m= model(des);
            des= reinit(des,code(m,double(X)));
            des= name(des,'Selected Data');
            dtree.designs=[dtree.designs(1),{des}];
            dtree.parents= [0,1];
        end
    end
    dtree.chosen=1;

    hDOE=xregdesigneditor;
    xregdesigneditor(hDOE,'lockgui',1,'loadtree',dtree,'closefcn','',...
        'numberofstages',NStages,'currentstage',Stage);

    if length(p.designdev)>1
        set(hDOE,'Name',['Design Editor - [',p.name,  ' (',View.hHSM.StageNames{Stage},')]']);
    else
        set(hDOE,'Name',['Design Editor - [',p.name,']']);
    end

    RegisterSubFigure(MBrowser,double(hDOE));

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_ViewModel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_ViewModel(h,evt,Stage)

if nargin<3
    Stage= get(gco,'userdata');
end


mbH= MBrowser;
p= get(mbH,'CurrentNode');
View= mbH.GetViewData;
if ~any(strcmp(get(View.hHSM.hBorder,'selected'),'on'))
    i_HighLight(Stage)
end

d= i_GetDesignDev(Stage);

hFig= view(getModel(d));

if length(p.designdev)>1
    set(hFig,'Name',['Default ' View.hHSM.StageNames{Stage} ' Model']);
else
    set(hFig,'Name','Default Model');
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_Select
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_Select(h,EventData,Stage)
mbH= MBrowser;
if strcmp(get(gcbf,'selectiontype'),'open')
    set(mbH.Figure,'pointer','watch');
    drawnow('expose');
    i_SetupModel(h,EventData,Stage);
    drawnow('expose');
    set(mbH.Figure,'pointer',get(0,'DefaultFigurePointer'));
else
    % this is a single click - just need to highlight the block
    i_HighLight( Stage );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% i_HightLight
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_HighLight( Stage )
% Highlights (selects) the block associated with the given Stage

mbH= MBrowser;
p = get(mbH,'CurrentNode');
View = mbH.GetViewData;

% all items are cyan
set(View.hHSM.hBorder,'selected','off');
set(View.hHSM.pBorder,'selected','off');
set(View.hHSM.hBorder(Stage),'selected','on');
set(View.hHSM.msg,'string',i_Message(View.hHSM,p));

if Stage == p.numstages
    set(View.hHSM.Menu(end),'enable','on');
else
    set(View.hHSM.Menu(end),'enable','off');
end

p.EnableMenus(View);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Functions to handle clicking/context menu on response outport
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function i_ResponseClick(h,EventData)
% Collect clicks on the response outport
mbH= MBrowser;
View= mbH.GetViewData;
if strcmp(get(mbH.Figure,'selectiontype'),'open')
    i_NewResponse(mbH,View);
else
    p= get(mbH,'CurrentNode');

    set(View.hHSM.pBorder,'Selected','off')
    set(View.hHSM.hBorder,'selected','off');

    set(View.hHSM.pBorder(end),'Selected','on')
    set(View.hHSM.msg,'string',i_Message(View.hHSM,p));
    p.EnableMenus(View);
end


function i_ResponseContext(h, EventData)
% Collect callback from context menu
mbH = MBrowser;
View = mbH.GetViewData;
i_NewResponse(mbH, View);


function i_NewResponse(mbH, View)
% Create a new response model
set(mbH.Figure,'pointer','watch');
set(View.hHSM.Models,'facecolor',View.hHSM.Colors.Selected);
drawnow('expose');
mbH.NewNode;
if ishandle(View.hHSM.Models)
    set(View.hHSM.Models,'facecolor',View.hHSM.Colors.Port);
end
set(mbH.Figure,'pointer',get(0,'defaultFigurePointer'));



function i_SelectNext(obj,src)

mbH= MBrowser;
p= get(mbH,'CurrentNode');
T= p.info;
View= mbH.GetViewData;
ud= View.hHSM;

selPort  = find(strcmp(get(ud.pBorder,'Selected'),'on'));
selModel = find(strcmp(get(ud.hBorder,'Selected'),'on'));

% display a status bar message as well ?
if ~isempty(selPort) && selPort<length(ud.pBorder) || ~isempty(selModel)
    if ~isempty(selPort)
        % select model
        set(ud.hBorder(selPort),'Selected','on')
        set(ud.pBorder(selPort),'Selected','off')
        set(ud.msg,'string','Setup model and design experiment');
    elseif selModel>1
        set(ud.pBorder(selModel-1),'Selected','on')
        set(ud.hBorder(selModel),'Selected','off')
        set(ud.msg,'string','Setup input factors');
    else
        % select output port
        set(ud.pBorder(end),'Selected','on')
        set(ud.hBorder(selModel),'Selected','off')
        if IsMatched(T)
            set(ud.msg,'string','Build new response model');
        else
            set(ud.msg,'string','Select data and build new response model');
        end
    end
end



function Msg= i_Message(ud,p)
selPort  = find(strcmp(get(ud.pBorder,'Selected'),'on'));
selModel = find(strcmp(get(ud.hBorder,'Selected'),'on'));

Msg= '';
% display a status bar message as well ?
if ~isempty(selPort)
    if selPort<length(ud.pBorder)
        % inport
        sname= ud.StageNames{selPort};
        if ~isempty(sname)
            sname= [sname,' '];
        end
        Msg    = sprintf('Set up %sinput factors',lower(sname));
        NextMsg=  sprintf('%sModel',sname);
    else
        % outport
        NextMsg= '';
        if p.IsMatched
            Msg= 'Build new response model';
        else
            Msg= 'Select data and build new response model';
        end
    end
elseif ~isempty(selModel)
    % model
    sname= ud.StageNames{selModel};
    if ~isempty(sname)
        sname= [sname,' '];
    end
    Msg=  sprintf('Set up %smodel and design experiment',lower(sname));
    if selModel>1
        NextMsg    = sprintf('%s Inputs',ud.StageNames{selModel-1});
    else
        % select output port
        NextMsg= 'Responses';
    end
end

Msg= sprintf('{\\bfCurrent selection       :} %s',Msg);
if ~isempty(NextMsg);
    Msg= sprintf('%s\n{\\bfSuggested next block:} %s',Msg,NextMsg);
end


function i_SummaryStats(src,evt)

D= i_GetDesignDev;
if nargin<3
    Stage= get(gco,'userdata');
end

[hDOE,hAutoMatch]= i_FindDOE;
if ~isempty(hDOE) || ~isempty(hAutoMatch)
    xregerror('Error','The model statistics cannot be defined while the design editor or the data selection figure is open');
    return
end
mbH= MBrowser;
View= mbH.GetViewData;
if ~any(strcmp(get(View.hHSM.hBorder,'selected'),'on'))
    i_HighLight(Stage)
end

d= subsref(D,substruct('()',{Stage}));
m= getModel(d);

set(View.hHSM.hStage(Stage),'facecolor',View.hHSM.Colors.Selected);
% setup gui
[m,OK]= gui_SummaryStats(m);
set(View.hHSM.hStage(Stage),'facecolor',View.hHSM.Colors.Model);

set(View.hHSM.hModel(Stage),'string',name(m))

if OK
    d= setmodel(d,m);
    i_PutDesignDev(d,Stage);
end
