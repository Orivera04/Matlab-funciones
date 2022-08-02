function [lyt,tblyt,View] = creategui(mdev,info)
%CREATEGUI

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.9.4.5 $  $Date: 2004/04/12 23:34:54 $

hFig=info.Figure;
p= address(mdev);

% callbacks are here for the moment
mfile= 'mv_LocalReg';

View.SweepPos=1;
View.Update=0;

% note that current min pane size is 675x402

% since this takes a while - give people a waitbar to look at
wb = xregGui.waitdlg('title', 'Creating Local Model View', 'parent', mvf);

% ------------------------------------------------------ 
% make the view-specific toolbar
% ------------------------------------------------------ 
% make the view-specific toolbar
hToolbar = xregGui.uitoolbar('parent', hFig,...
    'ResourceLocation', xregrespath);

[tblyt, buttons] = xregtoolbar(hToolbar, {'uipush';'uipush';'uipush';'uipush';'uipush'},...
    {'imageFile'}, {'viewCube.bmp';'refresh.bmp';'MLE.bmp';'sigmahat.bmp';'data.bmp'},...
    {'Tooltipstring'}, {'View Model Definition';'Update Fit';'Calculate MLE';'RMSE Plots';'View Local Fit Data'},...
    {'clickedcallback'}, {'local_regstats(''viewmodel'')';@i_updateFit;@i_CalcMLE;'mv_LocalReg(''RMSEPlot'')';@i_viewLocalData},...
    {'tag'},{'viewmodel';'update';'mle';'errorplot';'viewdata'},...
    'transparentcolor', [0 255 0]);
View.toolbarBtns = buttons;

% ------------------------------------------------------ 
% Create UI objects
% ------------------------------------------------------
% update waitbar
wb.Waitbar.value = 0.2;

View.Reg = local_regstats('create',hFig);

% update waitbar
wb.Waitbar.value = 0.45;

View.Notes= View.Reg.Notes;
View.Color= View.Reg.Color;
set(View.Notes,'callback',[mfile,'(''Notes'')']);
set(View.Color,'callback',[mfile,'(''Color'')']);

% Sweep selector controls
SelectBtn = xreguicontrol('parent',hFig,...
    'style','push',...
    'units','pixels',...
    'string','Select Test...',...
    'tooltipstring','Select test from list',...
    'Tag','SelectBtn',...
    'visible','off',...
    'callback',[mfile, '(''SweepChange'',1,2,''SelectBtn'')']);
View.SweepClick = xregGui.clickedit(hFig,...
    'visible','off',...
    'rule','list',...
    'style','leftright',...
    'fontsize',get(hFig,'defaultuicontrolfontsize'),...
    'dragging','off',...
    'callback',[mfile, '(''SweepChange'',1,2,''SweepClick'')']);
seltext = xreguicontrol(hFig,...
    'visible','off',...
    'style','text',...
    'fontweight','demi',...
    'horizontalalignment','left',...
    'string','Test:');

View.mdlString= axestext(hFig,...
    'visible','off',...
    'fontsize',10,...
    'clipping','on',...
    'verticalalignment','middle');

View.transString= axestext(hFig,...
    'visible','off',...
    'fontsize',10,...
    'clipping','on',...
    'verticalalignment','middle',...
    'horizontalalignment','right');


% ------------------------------------------------------
% Diagnostic Plots for card 1
% ------------------------------------------------------

[f,dPlots,View]= diagnosticPlots(mdev_local,'create',...
    hFig,View,'mdev_local',1);
% border between dPlots and the edge of the tab
set(dPlots,'border',[5 5 5 5]);

% update waitbar
wb.Waitbar.value = 0.65;

% --------------------------------------------------------------------
% Create the subplots for the Monitor Plots on Page 2
% --------------------------------------------------------------------
pr=address(p.mdevtestplan);
MPlyt=mv_MonitorPlots('create',hFig,pr,[],View.OutlierLine);
set(MPlyt,'visible','off');
View.MonitorGridLyt= MPlyt;

% update waitbar
wb.Waitbar.value = 0.8;

% ------------------------------------------------------ 
% Layout set up
% ------------------------------------------------------

% Page 1
% sweep selector
g=xreggridbaglayout(hFig,'dimension',[5 3],...
    'rowsizes',[3 2 15 3 2],'colsizes',[30 60 85],...
    'gapx',5,'mergeblock',{[1 5],[3 3]},'mergeblock',{[2 4],[2 2]},...
    'elements',{[],[],seltext,[],[],[],View.SweepClick,[],[],[],SelectBtn},...
    'border',[5 5 5 5]);
scrollFrame = xregpanellayout(hFig,...
    'center',g,...
    'innerborder',[0 0 0 0]);

% model string for inside the panel layout
View.allModelText = xreggridlayout(hFig,...
    'visible','off',...
    'dimension',[1,2],...
    'gapy',20,...
    'correctalg','on',...
    'colsizes',[-1, 1],...
    'elements',{View.mdlString,View.transString});
viewModelFrame = xregpanellayout(hFig,...
    'center',View.allModelText,...
    'innerborder',[5 5 10 5]);

% tabs for Sweep Plots, Monitor Plots and MLE
cardLyt = xregtablayout2(hFig,...
    'visible','off',...
    'numcards',2,...
    'drawonselect','on',...
    'tablabels',{'Model','Data'},...
    'callback',[mfile, '(''TabCallback'',%CARD%)'],...
    'packstatus','off');
attach(cardLyt,dPlots,1);
attach(cardLyt,View.MonitorGridLyt,2);
View.ChildTab= cardLyt;


% main snapsplit layout left and right

% put together [test selector, diagnosticplots, model name panel]
gleft=xreggridbaglayout(hFig,'dimension',[2 2],...
    'rowsizes',[37 -1],'colsizes',[197 -1],...
    'mergeblock',{[2 2],[1 2]},...
    'gapy',5,...
    'gapx',10,...
    'elements',{scrollFrame,cardLyt,viewModelFrame});
gright = xreggridlayout(hFig,...
    'visible','off',...
    'dimension',[3,1],...
    'gapy',8,...
    'correctalg','on',...
    'rowsizes',[-1, 120, 80],...
    'elements',{View.Reg.diagnostic,View.Reg.summaryLyt,View.Reg.notes});

mainLyt = xregsnapsplitlayout(hFig,...
    'visible','off',...
    'callback',[mfile, '(''StringSpace'')'],...
    'orientation','lr',...
    'split',[0.75, 0.25],...
    'style','toright',...
    'minwidth',[450, 200],...
    'left',gleft,...
    'right',gright,...
    'leftinnerborder',[0 5 0 0],...
    'rightinnerborder',[0 0 0 5],...
    'border',[5 5 5 5]);

% --------------------------------------------------------------------
% Create menus
% --------------------------------------------------------------------

% View Menu
mbH=MBrowser;
mns=mbH.CreateMenu(guid(mdev),3);
set(mns,{'label'},{'&Model';'&View';'&Outliers'});

% Model Menu
Labels={'&Set Up...'
    '&Fit Local...'
    '&Update Fit'
    'Calculate &MLE...'
    '&Evaluate...'
    'Se&lect...'
    '&Assign Best'};

CallBacks= {@i_Setup
    'mv_LocalReg(''FitOptions'')'
    @i_updateFit
    @i_CalcMLE
    @i_Evaluate
    @i_SelectModel
    @i_AssignBest};
hf= zeros(size(Labels));
for i=1:length(Labels)
    hf(i)= uimenu(mns(1),...
        'label',Labels{i},...
        'Callback',CallBacks{i});
end
set(hf(1),'accelerator','M');
set(hf(5),'accelerator','E');
set(hf(6),'separator','on');
View.menus.model= hf;

% Outlier 
View.menus.tools=mns(3);
Labels= {'Select &Multiple Outliers',...
        '&Clear Outliers',...
        '&Remove Outliers',...
        'Restore Removed &Data',...
        'Co&py Outliers From...',...
        '&Selection Criteria',...
        'Remove &All Data'};
CallBacks= {'diagnosticPlots(modeldev,''multiselect'')',...
        'diagnosticPlots(mdev_local,''CancelOutliers'',mvf)',...
        'diagnosticPlots(mdev_local,''ApplyOutliers'',mvf)',...
        'diagnosticPlots(mdev_local,''RestoreOutliers'',mvf)',...
        'CopyOutliers(modeldev);',...
        'diagnosticPlots(modeldev,''outliersselect'',mvf)',...
        'mv_LocalReg(''badSweep'',mvf)'};
Accel={'','','A','Z','','',''};
Tags={'outlier','outlier','outlier','outlier','outlier','outlier','BadTest'};


for i=1:length(Labels)
    hf(i)= uimenu(View.menus.tools,...
        'label',Labels{i},...
        'Callback',CallBacks{i},...
        'Accelerator',Accel{i},...
        'tag',Tags{i});
end

% view menu
View.menus.view=mns(2);
Labels= {'&Model Definition',...
        '&Data Plots...',...
        '&RMSE Plots',...
        '&Local Fit Data',...
        'Resp&onse Data',...
        'R&ecord Numbers',...
        '&Next Test','&Previous Test','&Select Test...'};
CallBacks= {'local_regstats(''viewmodel'')',...
        @i_DataPlots,...
        'mv_LocalReg(''RMSEPlot'')',...
        @i_viewLocalData,...
        @i_viewResponseData,...
        'diagnosticPlots(mdev_local,''testnum'',gcbf,gca);',...
        'mv_LocalReg(''sweepchange'',[],[],''increment'')',...
        'mv_LocalReg(''sweepchange'',[],[],''decrement'')',...
        'mv_LocalReg(''sweepchange'',[],[],''SelectBtn'')'};
Accel={'V','','','','','','F','B',''};
Tags={'','','','','','testnum','ForwardMenu','BackwardMenu','SelectMenu'};
for i=1:length(Labels)
    hf(i)= uimenu(View.menus.view,...
        'label',Labels{i},...
        'Callback',CallBacks{i},...
        'Tag',Tags{i},...
        'Accelerator',Accel{i});
end
set(hf(6),'separator','on');

% final waitbar value then delete
wb.Waitbar.value = 1;
delete(wb);
lyt = mainLyt;

return


% ------------------------------------------------------
% subfunction   i_updateFit
% ------------------------------------------------------
function i_updateFit(src,event)

mbh=MBrowser;
p = mbh.CurrentNode;
View = mbh.GetViewData;

if View.Update
    UpdateLinks(p.modeldev,View.Update,mbh);
    View.Update = 0;
    mbh.SetViewData(View);
end


% Local Model callbacks

% ------------------------------------------------------
% subfunction   i_Setup
% ------------------------------------------------------
function i_Setup(h,evt)

SetupModel(MBrowser);

% ------------------------------------------------------
% subfunction   i_Evaluate
% ------------------------------------------------------
function i_Evaluate(h,evt)

Evaluate(MBrowser);

% ------------------------------------------------------
% subfunction   i_CalcMLE
% ------------------------------------------------------
function i_CalcMLE(h,evt)

mbH= MBrowser;
View= mbH.GetViewData;
set(mbH.Figure,'pointer','watch');
drawnow
p= get(mbH,'currentnode');
if View.Update
    mdev=p.UpdateLinks(View.Update,mbH);
    View.Update= 0;
    mbH.SetViewData(View);
end

TS= p.BestModel;
if isempty(TS)
    % check that all response feature models have a best model
    pbest= p.children('bestmdev');
    pbest=[pbest{:}];
    if any(pbest==0)
        unvalmdev=p.children(find(pbest==0),'name');
        errordlg(str2mat('You must select a best model for ',...
            'all sub-models before creating a two-stage model. ',...
            'The following sub-models do not have a best model:',...
            unvalmdev{:}),...
            'Error','modal');
        set(mbH.Figure,'pointer',get(0,'DefaultFigurePointer'));
        return
    end
    selrf= SelectRF(p.model);
    if ~isempty(selrf)
        TSModels= p.twostage(selrf);
        if ~isempty(TSModels)
            BMInd= p.validate; 
            if ~isempty(BMInd)
                % select best model
                p.BestModel(BMInd);
                p.mledialog('Calculate MLE for global covariances');
            else
                xregerror('MLE Error','No two-stage model available. Lack of degrees of freedom is the most likely cause.');
            end
        else
            xregerror('MLE Error','No two-stage model available. Lack of degrees of freedom is the most likely cause.');
        end
    else
        xregerror('MLE Error','No two-stage model available. Insufficient response features to reconstruct two-stage model.');
    end
else
    p.mledialog('Calculate MLE for global covariances');
end
set(mbH.Figure,'pointer',get(0,'DefaultFigurePointer'));



% ------------------------------------------------------
% subfunction   i_SelectModel
% ------------------------------------------------------
function i_SelectModel(h,evt)
Validate(MBrowser);


% ------------------------------------------------------
% subfunction   i_DataPlots
% ------------------------------------------------------
function i_DataPlots(h,evt)
mbH= MBrowser;
View= mbH.GetViewData;

if get(View.ChildTab,'currentcard')~=2 
    set(View.ChildTab,'currentcard',2);
    drawnow('expose');
end	
mv_LocalReg('monitordlg',mbH.Figure);

%----------------------------------------------------------------------
%  function i_viewData
%----------------------------------------------------------------------
function i_viewLocalData(src, event)
h = MBrowser;
md = info(h.CurrentNode);
% Set pointer to be a watch
set(h.Figure, 'pointer', 'watch');
% Get the data to send to the editor
fullData = getdata(md, 'ALLDATA');
[X, Y] = getdata(md);
predictedYLocal = set(Y, 'name', 'predictedY_local');
% Do local prediction
allModels = LocalModel(md, ':');
% Loop through the local models and produce the localfit data
for i = 1:length(allModels)
    predictedYLocal{i} = allModels{i}(X{i});
end
% Concatenate the data
ss = [fullData predictedYLocal];
% Get the two stage model
TS = BestModel(md);
% Is it empty
if ~isempty(TS)    
    predictedYTwostage = set(Y, 'name', 'predictedY_twostage');
    % Get the global fit data
    Xfit = getdata(md, 'FIT');
    % Fit the twostage model
    predictedYTwostage(:,1) = TS(Xfit);
    % Concatenate
    ss = [ss predictedYTwostage];
end
% Open data edit facility
f = xregdataedit('create', 'CloseClickedFcn', []);
% Register as a subfigure
h.RegisterSubFigure(f);
% Send the modelling data to the data editor in read-only mode
f.DataMessageService.setDataObject(ss);
f.DataMessageService.isReadOnly = true;
% Set pointer to be the default
set(h.Figure, 'pointer', 'arrow');

%----------------------------------------------------------------------
%  function i_viewData
%----------------------------------------------------------------------
function i_viewResponseData(src, event)
h = MBrowser;
md = info(h.CurrentNode);
% Set pointer to be a watch
set(h.Figure,'pointer','watch');
% Get the data to send to the editor
responseData = info(md.RFData);
XFit = getdata(md, 'FIT');
globalData = XFit{end};
% Concatenate the data
ss = [responseData globalData];
% Open data edit facility
f = xregdataedit('create', 'CloseClickedFcn', []);
% Register as a subfigure
h.RegisterSubFigure(f);
% Send the modelling data to the data editor
f.DataMessageService.setDataObject(ss);
f.DataMessageService.isReadOnly = true;
% Set pointer to be the default
set(h.Figure, 'pointer', 'arrow');

%----------------------------------------------------------------------
%
%----------------------------------------------------------------------
function i_AssignBest(h,evt)

mbh = MBrowser;
mdev= info(mbh.CurrentNode);
st= children(mdev,'status');
if status(mdev) && any([st{:}])
    p= Parent(mdev);
    p.BestModel(address(mdev));
    if p.childindex==1 && get(model(mdev),'datumtype')
        Lp= address(mdev);
        prf= Lp.children;
        pdatum= p.datumlink;
        if pdatum~= prf(1)
            p.AssignData('Data',prf(1));
            TP= p.mdevtestplan;
            
            pr= children(TP);
            
            % update datum links
            Lp.UpdateLinks(1);
            
            if length(pr)>1
                msgbox('The Datum Model has changed. All responses using datum links should be updated',...
                    'Datum Model','modal');
            end
        end
    end
    
else
    xregerror('Best Model Error','MLE Model needs updating');
end
