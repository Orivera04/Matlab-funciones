function varargout=Validate_MLE(action,varargin);
% VALIDATE_MLE  validation tool for MLE models
% 
%  GUI for validating twostage models from response level
%  i.e. for different local models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.2 $  $Date: 2004/02/09 08:01:54 $



% ---------------------------------------------------------------------------------------
% 												Beginning of the switchyard
% ---------------------------------------------------------------------------------------
switch lower(action)
case 'create'
   % setup the GUI
   [varargout{1}]=i_create(varargin{:});
case 'select'
   [varargout{1:nargout}]= i_Select(varargin{:});
case 'close'
   i_Close(varargin{:});
end

% ---------------------------------------------------------------------------------------
% 													function create
% ---------------------------------------------------------------------------------------
function fig= i_create(p,ParFig);

View={};
ModelList= {'Univariate','MLE'};
[Models,ColHead,s,SortKey]= i_Models(p,ParFig);

pbest= p;
fig= mv_ValidationTool('create',mfilename,pbest,Models,ParFig,6);
if isempty(fig)
   return
end
set(fig,'Name',['MLE Model Selection for ',p.fullname])
mv_ValidationTool('setmessage','Creating validation views for MLE model...');
set(fig,'visible','on');drawnow;

mv_ValidationTool('StatsTable',fig,ModelList,ColHead,s,SortKey)
mv_ValidationTool('setmessage','Creating validation views for MLE model...');
mv_ValidationTool('setwaitbar','value',.02);drawnow;

% Set Up Plots
VMap= p.getdata('Y');
NumSweeps= size(VMap,3);

[View{1}, Lyt] = ValidateSweeps('create',fig,NumSweeps,1);
mv_ValidationTool('attachlayout', fig,Lyt, 1);
%% update waitbar
mv_ValidationTool('setwaitbar','value',.11);drawnow;

[View{2}, Lyt] = mv_DialUp('create',fig,Models{1});
mv_ValidationTool('attachlayout', fig,Lyt, 2);
%% update waitbar
mv_ValidationTool('setwaitbar','value',.39);drawnow;

[View{3}, Lyt] = validate_rf('create',fig,0);
mv_ValidationTool('attachlayout', fig,Lyt, 3);
%% update waitbar
mv_ValidationTool('setwaitbar','value',.41);drawnow;

[View{4}, Lyt] = validate_RMSE('create',fig,0);
mv_ValidationTool('attachlayout', fig,Lyt, 4);
%% update waitbar
mv_ValidationTool('setwaitbar','value',.45);drawnow;

[View{5}, Lyt] = validate_residuals('create',fig,'FIT');
mv_ValidationTool('attachlayout', fig,Lyt, 5);
%% update waitbar
mv_ValidationTool('setwaitbar','value',.51);drawnow;

[View{6}, Lyt] =validate_rstool('create',fig,Models{1});
mv_ValidationTool('attachlayout', fig,Lyt, 6);
%% update waitbar
mv_ValidationTool('setwaitbar','value',.78);drawnow;

mv_ValidationTool('add',fig,View)
%% update waitbar
mv_ValidationTool('setwaitbar','value',1);drawnow;

mv_ValidationTool('setcreatemessage',0);
mv_ValidationTool('view',fig,1)
mv_ValidationTool('setwaitbar','value',0);



function [Models,ch,s,SortKey]= i_Models(p,hFig);

%pbest= p.bestmdev;

ch= p.colhead;
p.history;
[s,Models]= mle_validate(p.info,hFig);

% Initialise the univariate model
p.InitStore(p.BMIndex);

% sort on last column (logL)
SortKey= size(s,2);


function [ModelInfo]= i_Select(Models,ModNo,p)

% ModelNos= p.BMIndex');
% p= p.children(ModNo);
m= Models(ModNo);

ModelInfo= {{ModNo},p,m,1};

function i_Close(hFig,p,BMIndex)


[mdev,msg]= mle_best(p.info,BMIndex==2);

doDrawIcons(MBrowser);
p.makemlerf;

if ~isempty(msg)
    hFig= msgbox(msg,...
        'Model Selection','modal');
    uiwait(hFig);
end
