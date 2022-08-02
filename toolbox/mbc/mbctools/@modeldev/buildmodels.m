function OK= buildmodels(mdev,mlist,Criteria)
%BUILDMODELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.4.5 $  $Date: 2004/04/04 03:31:47 $

p= address(mdev);

% Check whether running with model browser
mbh=MBrowser;
if mbh.GUIExists
    pSelected= get(mbh,'currentnode');
    GUIMode= p==pSelected;
    CurrentStatus= mbh.GUILocked;
else
    GUIMode= false;
    CurrentStatus= false;
end

m= model(mdev);
s= statistics(mdev);
nobs= s(1);

OK=false;
if nargin<2
    [mlist,OK]=xreg_modeltemplates('create',m,nobs);
else
    OK= true;
end

if nargin<3
    % default selection criteria
    Criteria= 'RMSE';
end

if ~CurrentStatus && OK

    if GUIMode
        mbh.GUILocked= true;
        OldPtr= get(mbh.Figure,'pointer');
        set(mbh.Figure,'pointer','watch');
        % create waitbar
        hWB= xregGui.waitdlg('parent',mbh.Figure);
        set(hWB.waitbar,'min',1,'max',length(mlist)+1);
        % deselect current node
        mbh.SelectNode(xregpointer,1);
    end
    try
        inc=1;
        N= length(mlist);
        [X,Y]= FitData(mdev);
        Y= double(Y);
        for i = 1:N;
            mi= mlist{i};
            lam= get(mi,'boxcox');
            fopt= get(mi,'fitalg');
            mi = copymodel(m,mi);

            % Make sure selection criteria is present
            if ~ismember(Criteria, StatsList(mi))
                mi= addSummaryStats(mi,Criteria );
            end

            set(mi,'fitalg',fopt);

            % reset after copy model as rbf/reset requires this
            mi= reset(mi);
            % deal wirh box cox transform (this gets removed by copymodel!)
            if lam~=1
                set(mi,'boxcox',{lam,Y})
            else
                set(mi,'ytrans','');
            end

            % build new child
            pch= modeldev(mi,p);

            if GUIMode
                hWB.message= ['Building Model for ',name(mi),'...'];
                hWB.waitbar.value= i;
            end

            try
                % fit it
                OK=fitmodel(pch.info);
                pch.name(name(mi));
                % clean up any temporary store in models
                pch.cleanup;
                if GUIMode
                    % add it to mbrowser tree
                    mbh.treeview(pch,'add');
                end
            catch
                % model fit crashed so delete ???
                pch.delete;
            end
            inc=inc+1;
        end
        chstatus= p.children('status');
        chstatus=[chstatus{:}];
        % choose best model based on PRESS RMSE if possible otherwise RMSE
        if any(chstatus)
            [S,Chead]= childstats(info(p));
            ind= find(strcmp(Criteria,Chead));
            if isempty(ind)
                % use RMSE by default
                Criteria= 'RMSE';
                ind= find(strcmp(Criteria,Chead));
            end

            sbOK= true;
            if GUIMode
                [ind,sbOK]= i_SelectCriteria(Chead,ind);
            end

            if sbOK
                % determine whether to minimize or maximize selection criteria
                [List,Width,SummStatsType,MinIsBest]= StatsList(mi);
                if MinIsBest(strcmp(Chead{ind},List))
                    [sm,BestInd]=min(S(:,ind));
                else
                    [sm,BestInd]=max(S(:,ind));
                end
                % select best model
                p.BestModel(p.children(BestInd));
            end


            % turn status back to 0 after bestmodel
            % bestmodel normally requires status to be 1 or 2
            p.children(chstatus==0,'status',0);
        end
    end

    if GUIMode
        % redraw current node
        mbh.SelectNode(address(mdev),1);
        hWB.waitbar.value= length(mlist)+1;
        delete(hWB);
        set(mbh.Figure,'pointer',OldPtr);

        % unlock model browser
        mbh.GUILocked= false;
    end
end



function [ind,OK] = i_SelectCriteria(List,Default)
hFig= xregdialog('Name','Model Selection',...
    'position',[10 10 250 110],...
    'resize','off');
xregcenterfigure(hFig)

h= cell(1,2);
h{1,1}= uicontrol('parent',hFig,...
    'style','text',...
    'HorizontalAlignment','left',...
    'string','Selection Criteria');
h{1,2}= uicontrol('parent',hFig,...
    'style','popupmenu',...
    'Backgroundcolor','w',...
    'HorizontalAlignment','left',...
    'value',Default,...
    'string',List);

hGrid= xreggridlayout(hFig,...
    'dimension',[1 2],...
    'elements',h(:)',...
    'rowsizes',20*ones(size(h,1)),...
    'colsizes',[130 130],...
    'correctalg','on',...
    'border',[10 10 10 15],...
    'gapy',5,...
    'gapx',10);

okbtn=uicontrol('style','pushbutton',...
    'parent',hFig,...
    'string','OK',...
    'position',[0 0 65 25],...
    'callback','set(gcbf,''tag'',''ok'', ''visible'', ''off'');');
cancbtn=uicontrol('style','pushbutton',...
    'parent',hFig,...
    'string','Cancel',...
    'position',[0 0 65 25],...
    'callback','set(gcbf,''visible'',''off'');');
flw=xregflowlayout(hFig,'orientation','right/center',...
    'gap',7,'elements',{cancbtn,okbtn},'border',[0 0 -7 0]);
brd=xregborderlayout(hFig,'center',hGrid,'south',flw,'container',double(hFig),...
    'innerborder',[10 45 10 10],'packstatus','on');

hFig.LayoutManager= brd;

hFig.showDialog(okbtn);

if strcmp(get(hFig,'tag'),'ok')
    ind= get(h{2},'value');
    OK= 1;
else
    ind= Default;
    OK= 0;
end
delete(hFig)
