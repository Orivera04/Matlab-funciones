function varargout=validate_local(action,varargin)
%VALIDATE_LOCAL Validation tool for local models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.8.2.4 $  $Date: 2004/02/09 08:02:16 $


% ----------------------------------------
% 	Beginning of the switchyard
% ----------------------------------------
switch lower(action)
case 'create'
   % setup the GUI
   varargout{1}= i_create(varargin{:});
case 'select'
   % callback for selecting the lognos to look at.
   varargout{1}= i_Select(varargin{:});
case 'close'
   i_Close(varargin{:});
end

%----------------------------------------------------
% SUBFUNCTION i_create
%----------------------------------------------------
function fig= i_create(p,selrf,ModelList,ParFig)

oldmdev= p.info;

% call mv_ValidationTool to create figure
[TSModels,ColHead,Table,SortKey,CalcPRESS]= i_ValidStats(ParFig,p,selrf);

if isempty(TSModels)
   errordlg('There is not enough data available to support twostage models','Model Verification','errordlg')
   fig=[];
   return
end


% call mv_ValidationTool to create figure
% pass in filename 'validate_local'
% p is pointer to an mdev_local object
% TSModels = two-stage models; will be more than one if comparing reconstructions using different combinations of rfs
% ParFig is the parent figure, needed to get hold of userdata
% 6 is the number of displays to be created (sweeps, dialUp, rmse, rf, residuals, responseSurfaces)
fig= mv_ValidationTool('create',mfilename,p,TSModels,ParFig,6);
if isempty(fig)
   pointer(oldmdev);
   return
end
mv_ValidationTool('setmessage','Creating validation views for local model...');
set(fig,'visible','on');drawnow;



%---------------Set Up Plots---------------------------%

x= p.getdata('FIT');
NumSweeps= size(x{1},3);

[View{1}, Lyt]= ValidateSweeps('create',fig,NumSweeps,~CalcPRESS);
mv_ValidationTool('attachlayout', fig,Lyt, 1);
% update waitbar
mv_ValidationTool('setwaitbar','value',.11);drawnow;

[View{2}, Lyt]= mv_DialUp('create',fig,TSModels{1});
mv_ValidationTool('attachlayout', fig,Lyt, 2);
% update waitbar
mv_ValidationTool('setwaitbar','value',.39);drawnow;

[View{3}, Lyt]= validate_rf('create',fig,CalcPRESS);
mv_ValidationTool('attachlayout', fig,Lyt, 3);
% update waitbar
mv_ValidationTool('setwaitbar','value',.41);drawnow;

[View{4}, Lyt]= validate_RMSE('create',fig,CalcPRESS);
mv_ValidationTool('attachlayout', fig,Lyt, 4);
% update waitbar
mv_ValidationTool('setwaitbar','value',.45);drawnow;

[View{5}, Lyt]= validate_residuals('create',fig,'FIT');
mv_ValidationTool('attachlayout', fig,Lyt, 5);
% update waitbar
mv_ValidationTool('setwaitbar','value',.51);drawnow;

[View{6}, Lyt]=validate_rstool('create',fig,TSModels{1});
mv_ValidationTool('attachlayout', fig,Lyt, 6);
% update waitbar
mv_ValidationTool('setwaitbar','value',.78);drawnow;

% create the stats in the listview control at the base of the figure
mv_ValidationTool('StatsTable',fig,ModelList,ColHead,Table,SortKey);

mv_ValidationTool('add',fig,View)
% update waitbar
mv_ValidationTool('setwaitbar','value',1);drawnow;

mv_ValidationTool('setcreatemessage',0);
mv_ValidationTool('view',fig,1)
mv_ValidationTool('setwaitbar','value',0);

%----------------------------------------------------
% SUBFUNCTION i_ValidStats
%----------------------------------------------------
function [TSModels,ch,Table,SortKey,CalcPRESS]= i_ValidStats(hFig,p,selrf)

% change mouse pointer to watch for calculations
% it may take a while ... 
% getting quicker

ptr= get(hFig,'pointer');
set(hFig,'pointer','watch');

p.history;
p.twostage(selrf);
TSModels= p.twostage;
CalcPRESS= 1;
ch= p.colhead;
for i=1:length(TSModels)
   CalcPRESS= CalcPRESS & islinear(TSModels{i});
end
if CalcPRESS
   SortKey=3;
else
   SortKey=2;
end
BMIndex=[];
Table=[];
if ~isempty(TSModels)
   [BMIndex,Table]= validate(p.info,hFig);
end
set(hFig,'pointer',ptr);

%----------------------------------------------------
% SUBFUNCTION i_Select
%----------------------------------------------------
function [ModelInfo]= i_Select(Models,ModNo,p)

ModelNos= {ModNo};
m= Models(ModNo);

ModelInfo= {ModelNos,p,m,0};

%----------------------------------------------------
% SUBFUNCTION i_Close
%----------------------------------------------------
function i_Close(hFig,p,BMIndex)

[mdev,msg]= BestModel(p.info,BMIndex);
p.CompressStats;


if ~isempty(msg)
    hFig= msgbox(msg,...
        'Model Selection','modal');
    uiwait(hFig);
end

mbH= MBrowser;
hFig= p.mledialog('Calculate the maximum likelihood estimate for the two-stage model');
uiwait(hFig);
mbH.doDrawIcons;

