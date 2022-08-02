function varargout= GlobalReg(m,action,varargin)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.5.2.4 $  $Date: 2004/04/04 03:30:11 $
switch lower(action)
case 'create'
    varargout{1}=i_create(varargin{:},m);
case 'update'
    i_updatemodel;
case 'view'
    i_View(varargin{:});
case 'show'
    varargout{1}= i_show(varargin{:});
case 'hide'
    i_hide(varargin{:});
case 'subfigure'
    varargout{1}= i_SubFigure(varargin{:});
case 'globalmenus'
    % model dpt menus
    varargout{1}= [];
end


% -----------------------------------------
% function i_create
% -----------------------------------------
function View= i_create(fParent,TabObj,View,m);

return


% -----------------------------------------
% function i_show
% -----------------------------------------
function View= i_show(hFig,View,p);


% -----------------------------------------
% function i_View
% -----------------------------------------
function i_View(hFig,View,p);


% -----------------------------------------
% function i_hide
% -----------------------------------------
function i_hide(hFig,View,p);
%hide(View.UniTab);

% -----------------------------------------------
% function i_SUBFIGURE
% -----------------------------------------------
% open subfigures
function chH= i_SubFigure(Action,hFig,p);

mbH= MBrowser;
if nargin<2
    hFig=gcbf;
    p= get(mbH,'CurrentNode');
end


chH=[];
switch lower(Action)
case 'transform'
    chH= mv_boxcox('create',p);
case 'fitmodel'
    p.fitmodel;
    % after we have done the complicated fit including the non-linear parameters
    % change to a simple fit
    m = p.model;
    set(m,'fitalg','leastsq'); 
    p.model(m);
    ViewNode(mbH);
case 'fitopts'
    m = p.model;
    [X,Y] = getdata(p.info);
    [x,y] = checkdata(m,X,Y);
    [m,ok]=gui_globalmodsetup(p.model,'figure',x);
    if ok
        p.model(m);
    end
case 'viewcenters'
    scr = get(0,'screensize');
    fsize= [scr(3)*0.35 scr(4)*0.6];
   
    fHudd= xregdialog('Visible','off',...
        'Name','View Centers',...
        'Renderer','zbuffer');
    
    fH = double(fHudd);
    xregcenterfigure(fH, fsize, mvf);
    
    m=p.model;
    nf =get(m,'nfactors');
    % THE GRAPH
    if nf >3
        gr=mvgraph4d(fH,'Visible','off');
        set(gr,'factorselection','exclusive');
    elseif nf ==3
        gr=mvgraph3d(fH,'Visible','off');
        set(gr,'factorselection','exclusive');
    elseif nf ==2   
        gr=mvgraph2d(fH,'Visible','off');
        set(gr,'factorselection','exclusive');
    else
        gr=mvgraph1d(fH,'Visible','off');
    end   
    centers = invcode(m,get(m,'centers'));
    
    set(gr,'data',centers(Terms(m),:));
    set(gr,'factors',get(m,'symbol'));
    
    ncenters = size(centers(Terms(m),:),1);

    % THE TABLE
    tb = xregtable(fH,...
        'Visible','off',...
        'position',[0 0 100 70],...
        'redrawmode','basic',...
        'frame.visible','off',...
        'frame.vborder',[0,0],...
        'frame.hborder',[0,0],...
        'DefaultCellType','uiemuedit0',...
        'rows.number',ncenters+1,...
        'cols.number',nf+1,...
        'rows.fixed',1,...
        'cols.fixed',1);

    tb.redraw;

    set(tb,...
        'cells.rowselection',[1,1],...
        'cells.colselection',[1,1],...
        'cells.string','--',...
        'cells.rowselection',[1,1],...
        'cells.colselection',[2,nf+1],...
        'cells.string',get(m,'symbol'),...
        'cells.rowselection',[2,ncenters+1],...
        'cells.colselection',[1,1],...
        'cells.value',1:ncenters,...
        'cells.rowselection',[2,ncenters+1],...
        'cells.colselection',[2,nf+1],...
        'cells.value',centers(Terms(m),:),...
        'cells.backgroundcolor',[1 1 1]);

    set(tb,'enable','inactive');
    
    panel = xregpanellayout(fH,'center',tb,'packstatus','off','innerborder',[0 0 0 0]);
        
    % THE BUTTON
    closebutton = xreguicontrol(fH,...
        'String','Close',...
        'Callback',{@i_centers_close, fH});
    helpbutton = mv_helpbutton(fH,'xreg_rbfViewCentres');
    buttonGrd = xreggridlayout(fH,...
       'dimension',[1,3],...
       'elements',{[],closebutton,helpbutton},...
       'correctalg','on',...
       'colsizes',[-1,65,65],...
       'gapx',7);
    
    % THE GRIDBAGLAYOUT   
    b = xreggridlayout(fH,...
        'dimension', [3,1],...
        'correctalg','on',...
        'rowsizes',[-1,-1,25],...
        'gapy',10,...
        'border',[20,10,20,20],...
        'packstatus','off',...
        'elements',{gr, panel, buttonGrd});
    
       
    fHudd.layoutmanager=b;
    
    set(b,'packstatus','on');
    set(tb,'redrawmode','normal');
    tb.redraw;
    set(b,'Visible','on');
    fHudd.showDialog(closebutton);
    delete(fHudd);
    
case 'prune'
    %m = p.model; % get the model
    %chH= mv_ncenter_selector('create',p);
    rbfpruneH = xregMdlGui.rbfprune(p);
    chH = double(rbfpruneH.figure);
case 'stepwise'
    chH= mv_stepwise('create',p,0.3);
end

function i_centers_close(src, evt, fH);
close(fH);
