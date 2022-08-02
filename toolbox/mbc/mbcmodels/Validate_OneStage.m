function varargout=Validate_OneStage(action,varargin)
%VALIDATE_ONESTAGE Validate the global model
%
%  VALIDATE_ONESTAGE('create', pmdev, fig) validates the global model, and
%  plots out the results. It is called from mv_globalreg.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.5 $  $Date: 2004/04/04 03:30:38 $

% ---------------------------------------------------------------------------------------
% 												Beginning of the switchyard
% ---------------------------------------------------------------------------------------
switch lower(action)
case 'create'
   % setup the GUI
   varargout{1}=i_create(varargin{:});
case 'select'
   % select the model(s)
   varargout{1}= i_Select(varargin{:});
case 'close'
   % close function
   i_Close(varargin{:});
end

% ---------------------------------------------------------------------------------------
% 													function create
% ---------------------------------------------------------------------------------------
function fig=i_create(p,ParFig)


View={};

% Put all relevant info into the userdata for the draw routine...

if isempty(p.children)
   ModelList={p.name};
else
   ModelList=p.children('name');
end
ModelList= ModelList(:);

[Models,ColHead,s,SortKey]= i_Models(ParFig,p);

fig= mv_ValidationTool('create',mfilename,p,Models,ParFig,4);
if isempty(fig)
   return
end
mv_ValidationTool('setmessage','Creating validation views for model...');
set(fig,'visible','on');drawnow('expose');

mv_ValidationTool('StatsTable',fig,ModelList,ColHead,s,SortKey);
mv_ValidationTool('setmessage','Creating validation views for model...');
mv_ValidationTool('setwaitbar','value',.03);

ptr= get(fig,'pointer');
set(fig,'pointer','watch');

% now start creating and adding views to the validationTool

% do some Obs/Pred plot
[View{1}, Lyt] =validate_prediction('create',fig);
mv_ValidationTool('attachlayout', fig,Lyt, 1);
% update waitbar
mv_ValidationTool('setwaitbar','value',.06);

[View{2}, Lyt] = validate_residuals('create',fig,'FIT');
mv_ValidationTool('attachlayout', fig,Lyt, 2);
% update waitbar
mv_ValidationTool('setwaitbar','value',.13); 

[View{3}, Lyt] =mv_DialUp('create',fig,Models{1});
mv_ValidationTool('attachlayout', fig,Lyt, 3);
% update waitbar
mv_ValidationTool('setwaitbar','value',.53); 

[View{4}, Lyt] =validate_rstool('create',fig,Models{1});
mv_ValidationTool('attachlayout', fig,Lyt, 4);
% update waitbar
mv_ValidationTool('setwaitbar','value',.81); 

mv_ValidationTool('add',fig,View)
% update waitbar
mv_ValidationTool('setwaitbar','value',1);

mv_ValidationTool('setcreatemessage',0);
mv_ValidationTool('view',fig,1)
% update waitbar
mv_ValidationTool('setwaitbar','value',0); 

set(fig,'pointer',ptr);

% ------------------------------------------------------------------------------
% 							function i_Models
% ------------------------------------------------------------------------------
function [Models,ColHead,S,SortKey]= i_Models(hFig,p)

ptr= get(hFig,'pointer');
set(hFig,'pointer','watch');
mbH= MBrowser;
ValID= mbH.addStatusMsg('Calculating Validation Statistics');
drawnow
SortKey=4;
if isempty(p.children)
   ColHead= p.colhead;
   Models={p.model};
   X= {p.getdata('X')};
   Y= {p.getdata('Y')};
   S= p.statistics;
else
   p.children('InitStore');
   Models=p.children('BestModel');
   X=p.children('getdata','X');
   Y=p.children('getdata','Y');
   
   [S,ColHead]= childstats(p.info);
   if SortKey>size(S,2)
      SortKey= size(S,2);
   end
end
if p.numChildren>0
   names= p.children('name');
else
   names= {p.name};
end
yi= yinfo(Models{1});
for i=1:length(Models);
   Models{i}= InitModel(Models{i},X{i},Y{i},[],0);
   yi.Name= names{i};
   Models{i}= yinfo(Models{i},yi);
end
mbH.removeStatusMsg(ValID);
set(hFig,'pointer',ptr);

% ---------------------------------------------------------------------------------------
% 													function i_Select
% ---------------------------------------------------------------------------------------
function [ModelInfo]= i_Select(Models,ModNo,p)

ModelNos= ModNo;
if ~isempty(p.children)
   p= p.children(ModNo);
end
m= Models(ModNo);

ModelInfo= {ModelNos,p,m};

% ---------------------------------------------------------------------------------------
% 													function i_Close
% ---------------------------------------------------------------------------------------
function i_Close(hFig,p,BMIndex)

ch= p.children;
m= ch(BMIndex).model;
mp= p.model;

mbH= MBrowser;

if ~isempty(strmatch(name(mp),p.name)) && ~strcmp(name(mp),name(m))
	% name of current node is the name of the model AND new model has a different name
	% update name of node
   
	p.name(name(m));
	mbH.treeview('label');
end

p.BestModel(ch(BMIndex));
p.InitModel;

% force a redraw of current view
delete(hFig)
RedrawNode(mbH);
