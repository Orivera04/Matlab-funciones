function varargout= GlobalReg(m,Action,varargin)
% xreglinear/GLOBALREG model browser display for xreglinear global and one-stage regression
%
% varargout= GlobalReg(m,Action,varargin)
%   where m isa xreglinear

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.5 $  $Date: 2004/02/09 07:49:00 $



switch lower(Action)
   % Compulsory Actions (from mv_GlobalReg)
case 'create'
   varargout{1}= i_Create(varargin{:},m);
case 'view'
   i_View(varargin{:});
case 'show'
   varargout{1}= i_Show(varargin{:});
case 'hide'
   i_Hide(varargin{:});
case 'subfigure'
   % If you want to open any other figures from this view you should make the 
   % callback to: [View.mfile,'SubFigure',varargin]
   % This keeps a track of all figures you open and will close 
   % the figures automatically as part of 'hide'. It calls 
   %       GlobalReg(model,Action,hFig,p)
   % to perform the model specific tasks
   varargout{1}=i_SubFigure(varargin{:});
   
   % xreglinear specific Actions
case 'reset'
   i_Reset;
case 'reduce'
   i_ReduceModel;
case 'globalmenus'
   % model dpt menus
   varargout{1}= [];
end

% xreglinear specific create
function View= i_Create(hFig,TabObj,View,m);

% All objects must be attached to TabObj
% Use View structure to store any 'view' information (handles etc.)

% obsolete




function i_View(hFig,View,p);

% xreglinear view

OK= p.status;
m= p.model;

if OK
   
   % update subfigures
   % this should probably go in mv_GlobalReg (i_View) but I haven't 
   % worked out a protocol for doing this. You can use this code as a template
   % for other models
   
	
   if ~isempty(gcbf)
      % update only required if callback
		hcf= double(gcbf);
		cfigs= [mvf('stepwisefig');mvf('mvBoxCox');mvf('mvPEVView');mvf('DOEtool')];
      for i=1:length(cfigs);
         ch= double(cfigs(i));
         if ishandle(ch) & ch ~= hcf & strcmp(get(ch,'visible'),'on')
            % update already performed if ch==gcbf
            switch get(ch,'tag')
            case 'stepwisefig'
               mv_stepwise('update',ch);
				case 'DOEtool'
					des= des_linearmod(m,Design(p.mdevtestplan));
					chH= mv_doeanalysis('create',des);
				case 'mvPEVView'
					des= des_linearmod(m,Design(p.mdevtestplan));
					mv_PEVView('update',ch,[],[],des, BoundaryModel( p.mdevtestplan ) );
            end
         end
      end
		figure(hcf)
	end  % if ~isempty(gcbf)
end % if OK  


function View= i_Show(hFig,View,p);
% does nothing


function i_Hide(hFig,View,p);

% clean up model store
p.cleanup;

% open subfigures
function chH= i_SubFigure(Action,hFig,p);

if nargin<2
	mbH= MBrowser;
   hFig=gcbf;
   p= mbH.CurrentNode;
end

chH=[];
switch lower(Action)
case 'stepwise'
   chH= mv_stepwise('create',p,0.3);
case 'transform'
   chH= mv_boxcox('create',p);
end


% reduce number of terms in model to enable interaction
function i_ReduceModel

hFig= gcbf;
p= get(MBrowser,'currentNode');
m= p.model;
m= reducetofull(m,[],2);
p.model(m);
p.fitmodel;
p.show(hFig);
p.view(hFig);
   
