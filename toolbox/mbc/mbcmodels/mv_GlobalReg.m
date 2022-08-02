function varargout= mv_GlobalReg(Action,varargin)
% MV_GLOBALREG callbacks for global and one stage models

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.2.5 $  $Date: 2004/04/04 03:30:44 $

hFig= mvf;
if ~isempty(hFig)
   PR=xregGui.PointerRepository;
   ptrID=PR.stackSetPointer(hFig,'watch');
end

switch lower(Action)
case 'subfigure'
   i_SubFigure(varargin{:});
case 'comments'
   i_Comments
case 'validate'
   i_SubFigure('validate')
case 'modelsetup'
   i_modelsetup;
case 'reset'
   i_Reset
case 'print'
   i_Print(varargin{:});
end
if ~isempty(hFig)
   PR.stackRemovePointer(hFig,ptrID);
end



%----------------------------------------------------------------------
%  subfunction i_Comments
%----------------------------------------------------------------------
function i_Comments

mbh=MBrowser;
p = mbh.CurrentNode;
m= p.BestModel;
m= comments(m,get(gcbo,'string'));
p.model(m);


%----------------------------------------------------------------------
%  subfunction i_SubFigure
%----------------------------------------------------------------------
function i_SubFigure(Action);
% opens subfigures

mbH= MBrowser;
hFig= double(mbH.Figure);

p= mbH.CurrentNode;
View= mbH.GetViewData;

switch lower(Action)
case 'displaymodel'
   chH= details(p.model,'view',p.fullname);
case 'validate'
   if ~isempty(p.children)
      pbest= p.children('bestmdev');
      pbest=[pbest{:}];
      if any(pbest==0)
         unvalmdev=p.children(find(pbest==0),'name');
         h= errordlg(str2mat('You must select a best model for all submodels ',...
				'before selecting a best model for this model',...
            'The following sub-models do not have a best model:',...
            unvalmdev{:}),...
            'Model Selection Error','modal');
			uiwait(h);
         return
      end
   end   
   chH=Validate_OneStage('create',p,hFig);
otherwise
   % Make SubFigure (model dependent)
   set(mbH.Figure,'pointer','watch');
   drawnow
   chH= GlobalReg(p.model,'SubFigure',Action,hFig,p);
   set(mbH.Figure,'pointer',get(0,'defaultFigurePointer'));
   drawnow
end

% update list of subfigures
if ~isempty(chH) 
   mbH.RegisterSubFigure(chH);
end



%----------------------------------------------------------------------
%  subfunction i_Reset
%----------------------------------------------------------------------
% reset model to base model
function i_Reset;

mbH= MBrowser;
p= mbH.CurrentNode;
if mbH.SelectNode(xregpointer,1)
	p.ResetModel;
	mbH.SelectNode(p,1);
end

%---------------------------------------------------------
% SUBFUNCTION i_Print
%---------------------------------------------------------
function i_Print(hFig,View,p)

print(p.info,hFig);

%---------------------------------------------------------
% SUBFUNCTION i_plotsweep
%---------------------------------------------------------
function i_plotsweep(src,null,m)

seltype=get(mvf,'SelectionType');

switch seltype
case 'open'
    diagnosticPlots(m,'plotsweep',src,[]);
end
