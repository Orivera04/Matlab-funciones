function varargout=Validate_Indpt(action,varargin)
% VALIDATE_INDPT validation tool for twostage models
% 
%  GUI for validating twostage models from response level
%  i.e. for different local models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.11.2.5 $  $Date: 2004/04/04 03:30:37 $


% ---------------------------------------------------------------------------------------
% 	Beginning of the switchyard
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
%   subfunction i_create
% ---------------------------------------------------------------------------------------
function fig= i_create(p,hFig,m)

%% p is pointer to current node on tree
%% hFig is the modelBrowser figure
%% m is the model we are going to display

MBh = MBrowser;
View = MBh.GetViewData;

fig=[];

%% get the candidate validation data sets from the project pointer
%% this returns an array of pointers to ssfs
allPtrs = MBh.RootNode.dataptrs;

%% throw out the unsuitable data (one/two stage)
numStages = numstages(p.mdevtestplan);

for i=1:length(allPtrs)
   d = allPtrs(i).info;
   isOneStage(i) = size(d,1)==size(d,3);
end

if numStages==1
   allPtrs = allPtrs(isOneStage);
end

yi = yinfo(m);

%% get the X and Y data used in fitting
[X,Y]= getdata(p.info,'FIT');

SWEEPCHOOSEROPTS=[true true true];
switch p.guid
case 'global'
   Yname = {yi.Name};
   %% the names we need data for (must be upper for sweepset find)
   Xg=X{end};
   factor_names= unique([get(Xg,'name'); Yname]);
otherwise
   if p.hasBest
      Yname = get(Y,'name');
      Xloc= X{1};
      Xg= X{2};
      %% the names we need data for (must be upper for sweepset find)
      factor_names= unique([get(Xloc,'name'); get(Xg,'name'); Yname]);
   else
      %% local node with no twostage model    
      Yname = get(Y,'name');
      Xloc= X{1};
      Xg= X{2};
      %% the names we need data for (must be upper for sweepset find)
      factor_names= unique([get(Xloc,'name'); Yname]);
      SWEEPCHOOSEROPTS=[true false false];
   end
end

%% the GUI for the user to choose which validation data to use
%% inside is a "waitfor" and execution pauses until OK or CANCEL is pressed
[ValData,ok]=gui_sweepchooser(allPtrs,'figure',...
   'filterlogs',testnum(Xg),...
   'factornames',factor_names,...
   'availableoptions',SWEEPCHOOSEROPTS);

%% return if no data/sweeps chosen (or if not OK)
if ~ok | (ok==3 & isempty(ValData))
   return
end


%%------------ CREATING THE VALIDATION TOOL FOR THIS DATA SET ----------------------

View={}; isTS= isa(m,'xregtwostage'); ModelList= {p.name};

switch ok %% no data (ok=1), fit data (ok=2), other data (ok=3)
   
case 1 %% no data
   %% make a validation tool to put the views in.
   fig= mv_ValidationTool('create',mfilename,p,{m},hFig,2);
   if isempty(fig),   return;   end;
   set(fig,'name',['Model Evaluation for ',p.name],...
      'CloseRequestFcn',{@i_Close,fig});
   uih = findobj(fig,'type','uimenu','label','&Close');
   set(uih,'CallBack',{@i_Close,fig});
   mv_ValidationTool('setmessage','Creating views for model evaluation...');
   set(fig,'visible','on');drawnow;
   
   %% put stuff into the listview at the bottom of the figure    %%%%SORT OUT EMPTY STATS%%%%
   ColHead=[];   s=[];   SortKey= 1;
   mv_ValidationTool('StatsTable',fig,ModelList,ColHead,s,SortKey)
   mv_ValidationTool('setmessage','Creating views for model evaluation...');
   %% update waitbar
   mv_ValidationTool('setwaitbar','value',.01);drawnow;
   
   [View{1}, Lyt]= mv_DialUp('create',fig,m);
   mv_ValidationTool('attachlayout', fig,Lyt, 1);
   %% update waitbar
   mv_ValidationTool('setwaitbar','value',.48);drawnow;
   
   [View{2}, Lyt]=validate_rstool('create',fig,m,'NONE');
   mv_ValidationTool('attachlayout', fig,Lyt, 2);
   %% update waitbar
   mv_ValidationTool('setwaitbar','value',.77);drawnow;
   
case 3 %% validation data
   %% make a validation tool to put the views in.
   fig= mv_ValidationTool('create',mfilename,p,{m},hFig,3+isTS);
   if isempty(fig)
      return
   end
   set(fig,'name',['Model Evaluation for ',p.name],...
      'CloseRequestFcn',{@i_Close,fig});
   uih = findobj(fig,'type','uimenu','label','&Close');
   set(uih,'CallBack',{@i_Close,fig});
   mv_ValidationTool('setmessage','Creating views for model evaluation...');
   set(fig,'visible','on');drawnow;
   
   %% only keep the sweeps we need if we're at the local node
   if strcmp(p.guid,'local') & ~isTS
       MBView = MBh.GetViewData;
       sweepPos = MBView.SweepPos;
       ValData= ValData(:,:,sweepPos);
   end

   %% always record the validation data in the form 
   %% X = {Xloc, Xglob}
   %% Y = Y
   %% create sweepset with only input variables included
   ValXglob= ValData(:,get(Xg,'name'),:);
   
   if isTS
      ValXloc= ValData(:,get(Xloc,'name'),:);
      ValX = {ValXloc,smean(ValXglob)};
   else
      ValX = {ValXglob};
   end
   %% create sweepset with only output variable included
   ValY = ValData(:,Yname,:);
   
   %% set the validation field of modeldev to hold these data
   p.valdata(ValX,ValY);
   
   [ColHead,s,SortKey]= i_valStats(p,m);
   mv_ValidationTool('StatsTable',fig,ModelList,ColHead,s,SortKey)
   mv_ValidationTool('setmessage','Creating views for model evaluation...');
   mv_ValidationTool('setwaitbar','value',.05);drawnow;
   
   %% create the views
   if isTS
      % Set Up Plots
      NumSweeps= size(ValXloc,3);
      [View{1}, Lyt] = IndptSweeps('create',fig,NumSweeps,1);
      mv_ValidationTool('attachlayout', fig,Lyt, 1);
      mv_ValidationTool('setwaitbar','value',.11);drawnow;
   end
   
   [View{1+isTS}, Lyt]= validate_residuals('create',fig,'VAL');
   mv_ValidationTool('attachlayout', fig,Lyt, 1+isTS);
   %% update waitbar
   mv_ValidationTool('setwaitbar','value',.18);drawnow;
   
   [View{2+isTS}, Lyt]= mv_DialUp('create',fig,m);
   mv_ValidationTool('attachlayout', fig,Lyt, 2+isTS);
   %% update waitbar
   mv_ValidationTool('setwaitbar','value',.52);drawnow;
   
   [View{3+isTS}, Lyt]=validate_rstool('create',fig,m,'VAL');
   mv_ValidationTool('attachlayout', fig,Lyt, 3+isTS);
   mv_ValidationTool('setwaitbar','value',.82);drawnow;
   
   
case 2 %% fit data == compare
   
   ViewIndex=p.guid;
   if strcmp(ViewIndex,'local') && p.hasBest
      ViewIndex = 'twostage';
   end
   
   %% make a validation tool to put the views in.
   isLoc = strcmp('local',ViewIndex);
   fig= mv_ValidationTool('create',mfilename,p,{m},hFig,4-isLoc);
   if isempty(fig), return;   end;
   set(fig,'name',['Model Evaluation for ',p.name],...
      'CloseRequestFcn',{@i_Close,fig});
   uih = findobj(fig,'type','uimenu','label','&Close');
   set(uih,'CallBack',{@i_Close,fig});
   mv_ValidationTool('setmessage','Creating views for model evaluation...');
   set(fig,'visible','on');drawnow;
   
   switch ViewIndex
   case 'twostage'
      [OK,ColHead,s,SortKey,CalcPRESS]= i_fitStats(p,m);
      mv_ValidationTool('StatsTable',fig,ModelList,ColHead,s,SortKey);
      mv_ValidationTool('setmessage','Creating views for model evaluation...');
      mv_ValidationTool('setwaitbar','value',.05);drawnow;
      
      % Set Up Plots
      VMap= p.getdata;
      NumSweeps= size(VMap,3);
      %% never allow calculation using PRESS
      pressDisable = 1;
      [View{1}, Lyt] = ValidateSweeps('create',fig,NumSweeps,pressDisable);
      mv_ValidationTool('attachlayout', fig,Lyt, 1);
      %% update waitbar
      mv_ValidationTool('setwaitbar','value',.12);drawnow;
      
      [View{2}, Lyt] = mv_DialUp('create',fig,m);
      mv_ValidationTool('attachlayout', fig,Lyt, 2);
      %% update waitbar
      mv_ValidationTool('setwaitbar','value',.45);drawnow;
      
      [View{3}, Lyt] = validate_residuals('create',fig,'FIT');
      mv_ValidationTool('attachlayout', fig,Lyt, 3);
      mv_ValidationTool('setwaitbar','value',.52);drawnow;
      
      [View{4}, Lyt] =validate_rstool('create',fig,m,'FIT');
      mv_ValidationTool('attachlayout', fig,Lyt, 4);
      mv_ValidationTool('setwaitbar','value',.84);drawnow;
      
   case 'local' %% no twostage - ****CURRENTLY DISABLED****
      [OK, ColHead,s,SortKey]= i_fitStats(p,m);
      mv_ValidationTool('StatsTable',fig,ModelList,ColHead,s,SortKey)
      mv_ValidationTool('setmessage','Creating views for model evaluation...');
      mv_ValidationTool('setwaitbar','value',.05);drawnow;
      
      [View{1}, Lyt] = validate_residuals('create',fig,'FIT');
      mv_ValidationTool('attachlayout', fig,Lyt, 1);
      mv_ValidationTool('setwaitbar','value',.15);drawnow;
      
      [View{2}, Lyt] =mv_DialUp('create',fig,m);
      mv_ValidationTool('attachlayout', fig,Lyt, 2);
      mv_ValidationTool('setwaitbar','value',.52);drawnow;
      
      [View{3}, Lyt] =validate_rstool('create',fig,m,'NONE');
      mv_ValidationTool('attachlayout', fig,Lyt, 3);
      mv_ValidationTool('setwaitbar','value',.82);drawnow;
      
   case 'global'
      [OK, ColHead,s,SortKey]= i_fitStats(p,m);
      m= InitModel(m,X{end},Y,[],0);
      yi.Name= p.name;    m= yinfo(m,yi);
      
      mv_ValidationTool('StatsTable',fig,ModelList,ColHead,s,SortKey);
      mv_ValidationTool('setmessage','Creating views for model evaluation...');
      mv_ValidationTool('setwaitbar','value',.03);drawnow;
      
      [View{1}, Lyt] =validate_prediction('create',fig);
      mv_ValidationTool('attachlayout', fig,Lyt, 1);
      mv_ValidationTool('setwaitbar','value',.06);drawnow;
      
      [View{2}, Lyt] = validate_residuals('create',fig,'FIT');
      mv_ValidationTool('attachlayout', fig,Lyt, 2);
      %% update waitbar
      mv_ValidationTool('setwaitbar','value',.15);drawnow;
      
      [View{3}, Lyt] =mv_DialUp('create',fig,m);
      mv_ValidationTool('attachlayout', fig,Lyt, 3);
      %% update waitbar
      mv_ValidationTool('setwaitbar','value',.52);drawnow;
      
      [View{4}, Lyt] =validate_rstool('create',fig,m,'FIT');
      mv_ValidationTool('attachlayout', fig,Lyt, 4);
      mv_ValidationTool('setwaitbar','value',.83);drawnow;
   end
end

mv_ValidationTool('add',fig,View)
%% update waitbar
mv_ValidationTool('setwaitbar','value',1);drawnow;

mv_ValidationTool('setcreatemessage',0);
mv_ValidationTool('view',fig,1)
%% update waitbar
mv_ValidationTool('setwaitbar','value',0);

% don't use the standard close dialog
set(fig,'CloseRequestFcn',get(0,'DefaultFigureCloseRequestFcn'));


% ---------------------------------------------------------------------------------------
%   subfunction i_valStats
% ---------------------------------------------------------------------------------------
function [ColHead,s,SortKey]= i_valStats(p,m);

SortKey= 1;
ColHead= {'Fit RMSE','RMSE'};

[X,Y]= valdata(p.info);
st= p.statistics;
ch= p.colhead;
pos= strcmp(ch,'RMSE');
if length(X)==1
   X=X{1};
end
if isa(m,'xregtwostage')
   RMSE= st(2);
else
   RMSE= st(pos);
end

s= [RMSE, sqrt( sum( (double(Y)-m(X)).^2) / size(Y,1) )]; 


% ---------------------------------------------------------------------------------------
% 													function i_fitStats
% ---------------------------------------------------------------------------------------
function [OK,ColHead,s,SortKey,CalcPRESS]= i_fitStats(p,m);

ColHead = p.colhead;
s= p.statistics;
OK= all(isfinite(s(:,2)));
if ~OK
   return
end
SortKey= 2;
CalcPRESS= islinear(m);

% ---------------------------------------------------------------------------------------
%   subfunction i_Select
% ---------------------------------------------------------------------------------------
function [ModelInfo]= i_Select(Models,ModNo,p)

ModelNos= {1};
m= Models(ModNo);
if isa(m{1},'xregtwostage') & ismle(m{1})
   % make sure mle model is used from mdev_local/sweep_plot
   flag=2;
else
   flag=0;
end

ModelInfo= {ModelNos,p,m,flag};

%----------------------------------------------------
% SUBFUNCTION i_Close
%----------------------------------------------------
function i_Close(src,event,hFig)

%% close the figure
%% remember this size as a preference
%% return focus to the MBrowser
if nargin <3, hFig= mvf('ValidationTool'); end;

%% set this figure to front
figure(hFig(1))

if ishandle(hFig)
   delete(hFig)
end
