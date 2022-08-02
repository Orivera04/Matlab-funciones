function varargout=Validate_TwoStage(action,varargin);
%VALIDATE_TWOSTAGE Validation tool for twostage models
% 
%  GUI for validating twostage models from response level i.e. for
%  different local models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.7.2.5 $  $Date: 2004/04/04 03:30:39 $


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
[OK,Models,ColHead,s,SortKey,CalcPRESS]= i_Models(p);
if ~OK
   errordlg('You must validate all local models before validating the response model',...
      'Model Selection Error','modal');
   fig= [];
   return
end

ModelList= p.children('name');

mbH= MBrowser;

fig= mv_ValidationTool('create',mfilename,p,Models,ParFig,4);
if isempty(fig)
   return
end
mv_ValidationTool('setmessage','Creating validation views for two-stage model...');
set(fig,'visible','on');drawnow;

mv_ValidationTool('StatsTable',fig,ModelList,ColHead,s,SortKey);
mv_ValidationTool('setmessage','Creating validation views for two-stage model...');
mv_ValidationTool('setwaitbar','value',.03);drawnow;

% Set Up Plots
VMap= p.getdata('Y');
NumSweeps= size(VMap,3);
[View{1}, Lyt] = ValidateSweeps('create',fig,NumSweeps,~CalcPRESS);
mv_ValidationTool('attachlayout', fig,Lyt, 1);
% update waitbar
mv_ValidationTool('setwaitbar','value',.13);drawnow;

[View{2}, Lyt] = mv_DialUp('create',fig,Models{1});
mv_ValidationTool('attachlayout', fig,Lyt, 2);
% update waitbar
mv_ValidationTool('setwaitbar','value',.47);drawnow; 

[View{3}, Lyt] = validate_residuals('create',fig,'FIT');
mv_ValidationTool('attachlayout', fig,Lyt, 3);
mv_ValidationTool('setwaitbar','value',.54);drawnow;

[View{4}, Lyt] =validate_rstool('create',fig,Models{1});
mv_ValidationTool('attachlayout', fig,Lyt, 4);
% update waitbar
mv_ValidationTool('setwaitbar','value',.84);drawnow;

mv_ValidationTool('add',fig,View)
% update waitbar
mv_ValidationTool('setwaitbar','value',1);drawnow;

mv_ValidationTool('setcreatemessage',0);
mv_ValidationTool('view',fig,1)
mv_ValidationTool('setwaitbar','value',0);

% ---------------------------------------------------------------------------------------
% 													function i_Models
% ---------------------------------------------------------------------------------------
function [OK,Models,ColHead,s,SortKey,CalcPRESS]= i_Models(p);

ColHead=[];
s=[];
SortKey=[];
CalcPRESS=[];
Models=[];
if isempty(p.children)
   OK=0;
else
   [s,ColHead]= childstats(p.info);
   OK= all(isfinite(s(:,2)));
   if ~OK
      return
   end
   p.children('InitStore');
   Models = p.children('BestModel');
end
SortKey= 2;

CalcPRESS= 1;
for i=1:length(Models)
   CalcPRESS= CalcPRESS & islinear(Models{i}) & ~ismle(Models{i});
end


% ---------------------------------------------------------------------------------------
% 													function i_Select
% ---------------------------------------------------------------------------------------
function [ModelInfo]= i_Select(Models,ModNo,p)

ModelNos= p.children(ModNo,'BMIndex');
p= p.children(ModNo);
m= Models(ModNo);

ModelInfo= {ModelNos,p,m,0};


% -----------------------------------------------------------------------
%                         function i_Close
% -----------------------------------------------------------------------
function i_Close(hFig,p,BMno)

ch= p.children;
p.BestModel(ch(BMno));
p.modelinfo(1);

ModNo= ch(BMno).UniIndex;

s= ch(BMno).statistics;
p.statistics( s );


ud= get(hFig,'userdata');

mbH= MBrowser;

if p.childindex==1 & get(ch(1).model,'datumtype')
   Lp= ch(BMno);
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
if p==mbH.CurrentNode
	mbH.ShowNode;
end
